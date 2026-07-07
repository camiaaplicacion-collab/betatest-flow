import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/checklists/checklist_model.dart';
import '../../../domain/repositories/checklists/checklist_repository.dart';

class FirestoreChecklistRepository implements ChecklistRepository {
  FirestoreChecklistRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'checklists';
  static const String _activeStatus = 'active';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<ChecklistModel> createChecklist({
    required String goalId,
    required String title,
    String? description,
  }) async {
    final normalizedGoalId = goalId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedGoalId.isEmpty) {
      throw ArgumentError('Goal ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Checklist title is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final checklistId = _generateChecklistId();
      final docRef = _firestore.collection(_collection).doc(checklistId);
      final now = DateTime.now().toUtc();

      final checklist = ChecklistModel(
        checklistId: checklistId,
        goalId: normalizedGoalId,
        title: normalizedTitle,
        description: (normalizedDescription == null || normalizedDescription.isEmpty)
            ? null
            : normalizedDescription,
        primaryColor: _defaultPrimaryColor,
        status: _activeStatus,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (snapshot.exists) {
            throw StateError('Checklist ID collision detected.');
          }
          transaction.set(docRef, checklist.toMap());
        });

        return checklist;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create checklist after multiple attempts.');
  }

  @override
  Future<ChecklistModel?> getChecklistById(String checklistId) async {
    final normalizedId = checklistId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Checklist ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return ChecklistModel.fromMap(data);
  }

  @override
  Future<ChecklistModel> updateChecklist({
    required String checklistId,
    required String title,
    String? description,
  }) async {
    final normalizedId = checklistId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Checklist ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Checklist title is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedChecklist = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Checklist not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Checklist data is unavailable.');
      }

      final currentChecklist = ChecklistModel.fromMap(data);
      final editedChecklist = currentChecklist.copyWith(
        title: normalizedTitle,
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedChecklist.toMap());
      return editedChecklist;
    });

    return updatedChecklist;
  }

  @override
  Future<ChecklistModel> archiveChecklist({
    required String checklistId,
  }) async {
    final normalizedId = checklistId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Checklist ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedChecklist = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Checklist not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Checklist data is unavailable.');
      }

      final currentChecklist = ChecklistModel.fromMap(data);
      if (currentChecklist.status == _archivedStatus) {
        throw StateError('Checklist is already archived.');
      }
      if (currentChecklist.status != _activeStatus) {
        throw StateError('Only active checklists can be archived.');
      }

      final updatedChecklist = currentChecklist.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updatedChecklist.toMap());
      return updatedChecklist;
    });

    return archivedChecklist;
  }

  @override
  Future<ChecklistModel> updateChecklistGeneralSettings({
    required String checklistId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = checklistId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Checklist ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedChecklist = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Checklist not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Checklist data is unavailable.');
      }

      final currentChecklist = ChecklistModel.fromMap(data);
      final editedChecklist = currentChecklist.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedChecklist.toMap());
      return editedChecklist;
    });

    return updatedChecklist;
  }

  String _generateChecklistId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'checklist_${ts}_$suffix';
  }
}