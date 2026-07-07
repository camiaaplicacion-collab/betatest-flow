import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/workspace.dart';
import '../../domain/repositories/workspace_repository.dart';

class FirestoreWorkspaceRepository implements WorkspaceRepository {
  FirestoreWorkspaceRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'workspaces';
  static const String _activeStatus = 'active';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<Workspace> createWorkspace({
    required String name,
    required String ownerUserId,
    required String ownerEmail,
  }) async {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError('Workspace name is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final workspaceId = _generateWorkspaceId();
      final docRef = _firestore.collection(_collection).doc(workspaceId);
      final now = DateTime.now().toUtc();

      final workspace = Workspace(
        workspaceId: workspaceId,
        name: normalizedName,
        ownerUserId: ownerUserId,
        ownerEmail: ownerEmail,
        description: null,
        primaryColor: _defaultPrimaryColor,
        createdAt: now,
        updatedAt: now,
        status: _activeStatus,
      );

      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (snapshot.exists) {
            throw StateError('Workspace ID collision detected.');
          }
          transaction.set(docRef, workspace.toMap());
        });

        return workspace;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create workspace after multiple attempts.');
  }

  @override
  Future<Workspace?> getWorkspaceById(String workspaceId) async {
    final normalizedId = workspaceId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Workspace ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return Workspace.fromMap(data);
  }

  @override
  Future<Workspace> updateWorkspaceName({
    required String workspaceId,
    required String name,
  }) async {
    final normalizedId = workspaceId.trim();
    final normalizedName = name.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Workspace ID is required.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('Workspace name is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedWorkspace = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Workspace not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Workspace data is unavailable.');
      }

      final currentWorkspace = Workspace.fromMap(data);
      final editedWorkspace = currentWorkspace.copyWith(
        name: normalizedName,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedWorkspace.toMap());
      return editedWorkspace;
    });

    return updatedWorkspace;
  }

  @override
  Future<Workspace> archiveWorkspace({
    required String workspaceId,
  }) async {
    final normalizedId = workspaceId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Workspace ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedWorkspace = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Workspace not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Workspace data is unavailable.');
      }

      final currentWorkspace = Workspace.fromMap(data);
      if (currentWorkspace.status != _activeStatus) {
        throw StateError('Only active workspaces can be archived.');
      }

      final updatedWorkspace = currentWorkspace.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updatedWorkspace.toMap());
      return updatedWorkspace;
    });

    return archivedWorkspace;
  }

  @override
  Future<Workspace> updateWorkspaceGeneralSettings({
    required String workspaceId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = workspaceId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Workspace ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final normalizedDescription = description?.trim();
    final safeDescription = (normalizedDescription == null || normalizedDescription.isEmpty)
        ? null
        : normalizedDescription;

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedWorkspace = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Workspace not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Workspace data is unavailable.');
      }

      final currentWorkspace = Workspace.fromMap(data);
      final editedWorkspace = currentWorkspace.copyWith(
        description: safeDescription,
        clearDescription: safeDescription == null,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedWorkspace.toMap());
      return editedWorkspace;
    });

    return updatedWorkspace;
  }

  String _generateWorkspaceId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'ws_${ts}_$suffix';
  }
}
