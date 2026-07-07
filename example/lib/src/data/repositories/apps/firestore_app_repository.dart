import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/apps/app_model.dart';
import '../../../domain/repositories/apps/app_repository.dart';

class FirestoreAppRepository implements AppRepository {
  FirestoreAppRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'apps';
  static const String _activeStatus = 'active';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<AppModel> createApp({
    required String workspaceId,
    required String name,
    String? description,
  }) async {
    final normalizedWorkspaceId = workspaceId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedWorkspaceId.isEmpty) {
      throw ArgumentError('Workspace ID is required.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('App name is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final appId = _generateAppId();
      final docRef = _firestore.collection(_collection).doc(appId);
      final now = DateTime.now().toUtc();

      final app = AppModel(
        appId: appId,
        workspaceId: normalizedWorkspaceId,
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
            throw StateError('App ID collision detected.');
          }
          transaction.set(docRef, app.toMap());
        });

        return app;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create app after multiple attempts.');
  }

  @override
  Future<AppModel?> getAppById(String appId) async {
    final normalizedId = appId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('App ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return AppModel.fromMap(data);
  }

  @override
  Future<AppModel> updateApp({
    required String appId,
    required String name,
    String? description,
  }) async {
    final normalizedId = appId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('App ID is required.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('App name is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedApp = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('App not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('App data is unavailable.');
      }

      final currentApp = AppModel.fromMap(data);
      final editedApp = currentApp.copyWith(
        name: normalizedName,
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedApp.toMap());
      return editedApp;
    });

    return updatedApp;
  }

  @override
  Future<AppModel> updateAppGeneralSettings({
    required String appId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = appId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('App ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedApp = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('App not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('App data is unavailable.');
      }

      final currentApp = AppModel.fromMap(data);
      final editedApp = currentApp.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedApp.toMap());
      return editedApp;
    });

    return updatedApp;
  }

  @override
  Future<AppModel> archiveApp({
    required String appId,
  }) async {
    final normalizedId = appId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('App ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedApp = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('App not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('App data is unavailable.');
      }

      final currentApp = AppModel.fromMap(data);
      if (currentApp.status != _activeStatus) {
        throw StateError('Only active apps can be archived.');
      }

      final updated = currentApp.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updated.toMap());
      return updated;
    });

    return archivedApp;
  }

  String _generateAppId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'app_${ts}_$suffix';
  }
}
