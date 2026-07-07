import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/betas/beta_model.dart';
import '../../../domain/repositories/betas/beta_repository.dart';

class FirestoreBetaRepository implements BetaRepository {
  FirestoreBetaRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'betas';
  static const String _draftStatus = 'draft';
  static const String _activeStatus = 'active';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<BetaModel> createBeta({
    required String appId,
    required String name,
    String? description,
  }) async {
    final normalizedAppId = appId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedAppId.isEmpty) {
      throw ArgumentError('App ID is required.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('Beta name is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final betaId = _generateBetaId();
      final docRef = _firestore.collection(_collection).doc(betaId);
      final now = DateTime.now().toUtc();

      final beta = BetaModel(
        betaId: betaId,
        appId: normalizedAppId,
        name: normalizedName,
        description: (normalizedDescription == null || normalizedDescription.isEmpty)
            ? null
            : normalizedDescription,
        primaryColor: _defaultPrimaryColor,
        status: _draftStatus,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (snapshot.exists) {
            throw StateError('Beta ID collision detected.');
          }
          transaction.set(docRef, beta.toMap());
        });

        return beta;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create beta after multiple attempts.');
  }

  @override
  Future<BetaModel?> getBetaById(String betaId) async {
    final normalizedId = betaId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Beta ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return BetaModel.fromMap(data);
  }

  @override
  Future<BetaModel> updateBeta({
    required String betaId,
    required String name,
    String? description,
  }) async {
    final normalizedId = betaId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Beta ID is required.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('Beta name is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedBeta = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Beta not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Beta data is unavailable.');
      }

      final currentBeta = BetaModel.fromMap(data);
      final editedBeta = currentBeta.copyWith(
        name: normalizedName,
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedBeta.toMap());
      return editedBeta;
    });

    return updatedBeta;
  }

  @override
  Future<BetaModel> updateBetaGeneralSettings({
    required String betaId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = betaId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Beta ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedBeta = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Beta not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Beta data is unavailable.');
      }

      final currentBeta = BetaModel.fromMap(data);
      final editedBeta = currentBeta.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedBeta.toMap());
      return editedBeta;
    });

    return updatedBeta;
  }

  @override
  Future<BetaModel> archiveBeta({
    required String betaId,
  }) async {
    final normalizedId = betaId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Beta ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedBeta = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Beta not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Beta data is unavailable.');
      }

      final currentBeta = BetaModel.fromMap(data);
      if (currentBeta.status == _archivedStatus) {
        throw StateError('Beta is already archived.');
      }
      final canArchive =
          currentBeta.status == _draftStatus || currentBeta.status == _activeStatus;
      if (!canArchive) {
        throw StateError('Only draft or active betas can be archived.');
      }

      final updated = currentBeta.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updated.toMap());
      return updated;
    });

    return archivedBeta;
  }

  String _generateBetaId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'beta_${ts}_$suffix';
  }
}
