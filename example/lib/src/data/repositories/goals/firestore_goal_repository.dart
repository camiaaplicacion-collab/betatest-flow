import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/goals/goal_model.dart';
import '../../../domain/repositories/goals/goal_repository.dart';

class FirestoreGoalRepository implements GoalRepository {
  FirestoreGoalRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'goals';
  static const String _activeStatus = 'active';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<GoalModel> createGoal({
    required String betaId,
    required String title,
    String? description,
  }) async {
    final normalizedBetaId = betaId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedBetaId.isEmpty) {
      throw ArgumentError('Beta ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Goal title is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final goalId = _generateGoalId();
      final docRef = _firestore.collection(_collection).doc(goalId);
      final now = DateTime.now().toUtc();

      final goal = GoalModel(
        goalId: goalId,
        betaId: normalizedBetaId,
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
            throw StateError('Goal ID collision detected.');
          }
          transaction.set(docRef, goal.toMap());
        });

        return goal;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create goal after multiple attempts.');
  }

  @override
  Future<GoalModel?> getGoalById(String goalId) async {
    final normalizedId = goalId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Goal ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return GoalModel.fromMap(data);
  }

  @override
  Future<GoalModel> updateGoal({
    required String goalId,
    required String title,
    String? description,
  }) async {
    final normalizedId = goalId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Goal ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Goal title is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedGoal = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Goal not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Goal data is unavailable.');
      }

      final currentGoal = GoalModel.fromMap(data);
      final editedGoal = currentGoal.copyWith(
        title: normalizedTitle,
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedGoal.toMap());
      return editedGoal;
    });

    return updatedGoal;
  }

  @override
  Future<GoalModel> updateGoalGeneralSettings({
    required String goalId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = goalId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Goal ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedGoal = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Goal not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Goal data is unavailable.');
      }

      final currentGoal = GoalModel.fromMap(data);
      final editedGoal = currentGoal.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedGoal.toMap());
      return editedGoal;
    });

    return updatedGoal;
  }

  @override
  Future<GoalModel> archiveGoal({
    required String goalId,
  }) async {
    final normalizedId = goalId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Goal ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedGoal = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Goal not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Goal data is unavailable.');
      }

      final currentGoal = GoalModel.fromMap(data);
      if (currentGoal.status == _archivedStatus) {
        throw StateError('Goal is already archived.');
      }
      if (currentGoal.status != _activeStatus) {
        throw StateError('Only active goals can be archived.');
      }

      final updated = currentGoal.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updated.toMap());
      return updated;
    });

    return archivedGoal;
  }

  String _generateGoalId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'goal_${ts}_$suffix';
  }
}
