import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/test_steps/test_step_model.dart';
import '../../../domain/repositories/test_steps/test_step_repository.dart';

class FirestoreTestStepRepository implements TestStepRepository {
  FirestoreTestStepRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'test_steps';
  static const String _pendingStatus = 'pending';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<TestStepModel> createTestStep({
    required String checklistId,
    required String title,
    String? description,
  }) async {
    final normalizedChecklistId = checklistId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedChecklistId.isEmpty) {
      throw ArgumentError('Checklist ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Test step title is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final testStepId = _generateTestStepId();
      final docRef = _firestore.collection(_collection).doc(testStepId);
      final now = DateTime.now().toUtc();

      final testStep = TestStepModel(
        testStepId: testStepId,
        checklistId: normalizedChecklistId,
        title: normalizedTitle,
        description: (normalizedDescription == null || normalizedDescription.isEmpty)
            ? null
            : normalizedDescription,
        primaryColor: _defaultPrimaryColor,
        status: _pendingStatus,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (snapshot.exists) {
            throw StateError('Test step ID collision detected.');
          }
          transaction.set(docRef, testStep.toMap());
        });

        return testStep;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create test step after multiple attempts.');
  }

  @override
  Future<TestStepModel?> getTestStepById(String testStepId) async {
    final normalizedId = testStepId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Test step ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return TestStepModel.fromMap(data);
  }

  @override
  Future<TestStepModel> updateTestStep({
    required String testStepId,
    required String title,
    String? description,
  }) async {
    final normalizedId = testStepId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Test step ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Test step title is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedTestStep = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Test step not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Test step data is unavailable.');
      }

      final currentTestStep = TestStepModel.fromMap(data);
      final editedTestStep = currentTestStep.copyWith(
        title: normalizedTitle,
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedTestStep.toMap());
      return editedTestStep;
    });

    return updatedTestStep;
  }

  @override
  Future<TestStepModel> archiveTestStep({
    required String testStepId,
  }) async {
    final normalizedId = testStepId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Test step ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedTestStep = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Test step not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Test step data is unavailable.');
      }

      final currentTestStep = TestStepModel.fromMap(data);
      if (currentTestStep.status == _archivedStatus) {
        throw StateError('Test step is already archived.');
      }
      if (currentTestStep.status != _pendingStatus) {
        throw StateError('Only pending test steps can be archived.');
      }

      final updatedTestStep = currentTestStep.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updatedTestStep.toMap());
      return updatedTestStep;
    });

    return archivedTestStep;
  }

  @override
  Future<TestStepModel> updateTestStepGeneralSettings({
    required String testStepId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = testStepId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Test step ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedTestStep = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Test step not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Test step data is unavailable.');
      }

      final currentTestStep = TestStepModel.fromMap(data);
      final editedTestStep = currentTestStep.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedTestStep.toMap());
      return editedTestStep;
    });

    return updatedTestStep;
  }

  String _generateTestStepId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'test_step_${ts}_$suffix';
  }
}
