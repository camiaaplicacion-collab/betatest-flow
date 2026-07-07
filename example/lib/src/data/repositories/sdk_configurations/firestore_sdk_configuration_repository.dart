import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../../domain/repositories/sdk_configurations/sdk_configuration_repository.dart';

class FirestoreSDKConfigurationRepository implements SDKConfigurationRepository {
  FirestoreSDKConfigurationRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'sdk_configurations';
  static const String _activeStatus = 'active';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<SDKConfigurationModel> createSDKConfiguration({
    required String betaId,
    required String name,
    String? description,
  }) async {
    final normalizedBetaId = betaId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedBetaId.isEmpty) {
      throw ArgumentError('Beta ID is required.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('SDK configuration name is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final sdkId = _generateSDKId();
      final docRef = _firestore.collection(_collection).doc(sdkId);
      final now = DateTime.now().toUtc();

      final sdkConfiguration = SDKConfigurationModel(
        sdkId: sdkId,
        betaId: normalizedBetaId,
        name: normalizedName,
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
            throw StateError('SDK ID collision detected.');
          }
          transaction.set(docRef, sdkConfiguration.toMap());
        });

        return sdkConfiguration;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create SDK configuration after multiple attempts.');
  }

  @override
  Future<SDKConfigurationModel?> getSDKConfigurationById(String sdkId) async {
    final normalizedId = sdkId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('SDK ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return SDKConfigurationModel.fromMap(data);
  }

  @override
  Future<SDKConfigurationModel> updateSDKConfiguration({
    required String sdkId,
    required String name,
    String? description,
  }) async {
    final normalizedId = sdkId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('SDK ID is required.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('SDK configuration name is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedSDKConfiguration = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('SDK configuration not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('SDK configuration data is unavailable.');
      }

      final currentSDKConfiguration = SDKConfigurationModel.fromMap(data);
      final editedSDKConfiguration = currentSDKConfiguration.copyWith(
        name: normalizedName,
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedSDKConfiguration.toMap());
      return editedSDKConfiguration;
    });

    return updatedSDKConfiguration;
  }

  @override
  Future<SDKConfigurationModel> archiveSDKConfiguration({
    required String sdkId,
  }) async {
    final normalizedId = sdkId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('SDK ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedSDKConfiguration = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('SDK configuration not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('SDK configuration data is unavailable.');
      }

      final currentSDKConfiguration = SDKConfigurationModel.fromMap(data);
      if (currentSDKConfiguration.status == _archivedStatus) {
        throw StateError('SDK configuration is already archived.');
      }
      if (currentSDKConfiguration.status != _activeStatus) {
        throw StateError('Only active SDK configurations can be archived.');
      }

      final updatedSDKConfiguration = currentSDKConfiguration.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updatedSDKConfiguration.toMap());
      return updatedSDKConfiguration;
    });

    return archivedSDKConfiguration;
  }

  @override
  Future<SDKConfigurationModel> updateSDKConfigurationGeneralSettings({
    required String sdkId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = sdkId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('SDK ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedSDKConfiguration = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('SDK configuration not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('SDK configuration data is unavailable.');
      }

      final currentSDKConfiguration = SDKConfigurationModel.fromMap(data);
      final editedSDKConfiguration = currentSDKConfiguration.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedSDKConfiguration.toMap());
      return editedSDKConfiguration;
    });

    return updatedSDKConfiguration;
  }

  String _generateSDKId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'sdk_${ts}_$suffix';
  }
}
