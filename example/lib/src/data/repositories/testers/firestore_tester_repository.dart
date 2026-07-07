import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/testers/tester_model.dart';
import '../../../domain/repositories/testers/tester_repository.dart';

class FirestoreTesterRepository implements TesterRepository {
  FirestoreTesterRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'testers';
  static const String _invitedStatus = 'invited';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<TesterModel> createTester({
    required String betaId,
    required String displayName,
    required String email,
  }) async {
    final normalizedBetaId = betaId.trim();
    final normalizedDisplayName = displayName.trim();
    final normalizedEmail = email.trim();

    if (normalizedBetaId.isEmpty) {
      throw ArgumentError('Beta ID is required.');
    }
    if (normalizedDisplayName.isEmpty) {
      throw ArgumentError('Display name is required.');
    }
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('Email is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final testerId = _generateTesterId();
      final docRef = _firestore.collection(_collection).doc(testerId);
      final now = DateTime.now().toUtc();

      final tester = TesterModel(
        testerId: testerId,
        betaId: normalizedBetaId,
        displayName: normalizedDisplayName,
        email: normalizedEmail,
        primaryColor: _defaultPrimaryColor,
        status: _invitedStatus,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (snapshot.exists) {
            throw StateError('Tester ID collision detected.');
          }
          transaction.set(docRef, tester.toMap());
        });

        return tester;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create tester after multiple attempts.');
  }

  @override
  Future<TesterModel?> getTesterById(String testerId) async {
    final normalizedId = testerId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Tester ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return TesterModel.fromMap(data);
  }

  @override
  Future<TesterModel> updateTester({
    required String testerId,
    required String displayName,
    required String email,
  }) async {
    final normalizedId = testerId.trim();
    final normalizedDisplayName = displayName.trim();
    final normalizedEmail = email.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Tester ID is required.');
    }
    if (normalizedDisplayName.isEmpty) {
      throw ArgumentError('Display name is required.');
    }
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('Email is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedTester = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Tester not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Tester data is unavailable.');
      }

      final currentTester = TesterModel.fromMap(data);
      final editedTester = currentTester.copyWith(
        displayName: normalizedDisplayName,
        email: normalizedEmail,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedTester.toMap());
      return editedTester;
    });

    return updatedTester;
  }

  @override
  Future<TesterModel> archiveTester({
    required String testerId,
  }) async {
    final normalizedId = testerId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Tester ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedTester = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Tester not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Tester data is unavailable.');
      }

      final currentTester = TesterModel.fromMap(data);
      if (currentTester.status == _archivedStatus) {
        throw StateError('Tester is already archived.');
      }
      if (currentTester.status != _invitedStatus) {
        throw StateError('Only invited testers can be archived.');
      }

      final updated = currentTester.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updated.toMap());
      return updated;
    });

    return archivedTester;
  }

  @override
  Future<TesterModel> updateTesterGeneralSettings({
    required String testerId,
    required String email,
    required int primaryColor,
  }) async {
    final normalizedId = testerId.trim();
    final normalizedEmail = email.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Tester ID is required.');
    }
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('Email is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedTester = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Tester not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Tester data is unavailable.');
      }

      final currentTester = TesterModel.fromMap(data);
      final editedTester = currentTester.copyWith(
        email: normalizedEmail,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedTester.toMap());
      return editedTester;
    });

    return updatedTester;
  }

  String _generateTesterId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'tester_${ts}_$suffix';
  }
}
