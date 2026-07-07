import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/results/result_model.dart';
import '../../../domain/repositories/results/result_repository.dart';

class FirestoreResultRepository implements ResultRepository {
  FirestoreResultRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'results';
  static const String _pendingStatus = 'pending';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<ResultModel> createResult({
    required String sdkId,
    required String testerId,
    String? summary,
  }) async {
    final normalizedSdkId = sdkId.trim();
    final normalizedTesterId = testerId.trim();
    final normalizedSummary = summary?.trim();

    if (normalizedSdkId.isEmpty) {
      throw ArgumentError('SDK ID is required.');
    }
    if (normalizedTesterId.isEmpty) {
      throw ArgumentError('Tester ID is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final resultId = _generateResultId();
      final docRef = _firestore.collection(_collection).doc(resultId);
      final now = DateTime.now().toUtc();

      final result = ResultModel(
        resultId: resultId,
        sdkId: normalizedSdkId,
        testerId: normalizedTesterId,
        primaryColor: _defaultPrimaryColor,
        status: _pendingStatus,
        summary: (normalizedSummary == null || normalizedSummary.isEmpty)
            ? null
            : normalizedSummary,
        description: null,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (snapshot.exists) {
            throw StateError('Result ID collision detected.');
          }
          transaction.set(docRef, result.toMap());
        });

        return result;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create result after multiple attempts.');
  }

  @override
  Future<ResultModel?> getResultById(String resultId) async {
    final normalizedId = resultId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Result ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return ResultModel.fromMap(data);
  }

  @override
  Future<ResultModel> updateResult({
    required String resultId,
    String? summary,
  }) async {
    final normalizedId = resultId.trim();
    final normalizedSummary = summary?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Result ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedResult = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Result not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Result data is unavailable.');
      }

      final currentResult = ResultModel.fromMap(data);
      final editedResult = currentResult.copyWith(
        summary: normalizedSummary,
        clearSummary: normalizedSummary == null || normalizedSummary.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedResult.toMap());
      return editedResult;
    });

    return updatedResult;
  }

  @override
  Future<ResultModel> archiveResult({
    required String resultId,
  }) async {
    final normalizedId = resultId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Result ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedResult = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Result not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Result data is unavailable.');
      }

      final currentResult = ResultModel.fromMap(data);
      if (currentResult.status == _archivedStatus) {
        throw StateError('Result is already archived.');
      }
      if (currentResult.status != _pendingStatus) {
        throw StateError('Only pending results can be archived.');
      }

      final updatedResult = currentResult.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updatedResult.toMap());
      return updatedResult;
    });

    return archivedResult;
  }

  @override
  Future<ResultModel> updateResultGeneralSettings({
    required String resultId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = resultId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Result ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedResult = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Result not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Result data is unavailable.');
      }

      final currentResult = ResultModel.fromMap(data);
      final editedResult = currentResult.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedResult.toMap());
      return editedResult;
    });

    return updatedResult;
  }

  String _generateResultId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'result_${ts}_$suffix';
  }
}
