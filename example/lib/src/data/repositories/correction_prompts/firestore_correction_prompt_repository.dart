import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../../domain/repositories/correction_prompts/correction_prompt_repository.dart';

class FirestoreCorrectionPromptRepository implements CorrectionPromptRepository {
  FirestoreCorrectionPromptRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'correction_prompts';
  static const String _draftStatus = 'draft';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<CorrectionPromptModel> createCorrectionPrompt({
    required String reportId,
    required String title,
    required String prompt,
  }) async {
    final normalizedReportId = reportId.trim();
    final normalizedTitle = title.trim();
    final normalizedPrompt = prompt.trim();

    if (normalizedReportId.isEmpty) {
      throw ArgumentError('Report ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Title is required.');
    }
    if (normalizedPrompt.isEmpty) {
      throw ArgumentError('Prompt is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final correctionPromptId = _generateCorrectionPromptId();
      final docRef = _firestore.collection(_collection).doc(correctionPromptId);
      final now = DateTime.now().toUtc();

      final correctionPrompt = CorrectionPromptModel(
        correctionPromptId: correctionPromptId,
        reportId: normalizedReportId,
        title: normalizedTitle,
        prompt: normalizedPrompt,
        description: null,
        primaryColor: _defaultPrimaryColor,
        status: _draftStatus,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await _firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);
          if (snapshot.exists) {
            throw StateError('Correction Prompt ID collision detected.');
          }
          transaction.set(docRef, correctionPrompt.toMap());
        });

        return correctionPrompt;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create correction prompt after multiple attempts.');
  }

  @override
  Future<CorrectionPromptModel?> getCorrectionPromptById(String correctionPromptId) async {
    final normalizedId = correctionPromptId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Correction Prompt ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return CorrectionPromptModel.fromMap(data);
  }

  @override
  Future<CorrectionPromptModel> updateCorrectionPrompt({
    required String correctionPromptId,
    required String title,
    required String prompt,
  }) async {
    final normalizedId = correctionPromptId.trim();
    final normalizedTitle = title.trim();
    final normalizedPrompt = prompt.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Correction Prompt ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Title is required.');
    }
    if (normalizedPrompt.isEmpty) {
      throw ArgumentError('Prompt is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedCorrectionPrompt = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Correction Prompt not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Correction Prompt data is unavailable.');
      }

      final currentCorrectionPrompt = CorrectionPromptModel.fromMap(data);
      final editedCorrectionPrompt = currentCorrectionPrompt.copyWith(
        title: normalizedTitle,
        prompt: normalizedPrompt,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedCorrectionPrompt.toMap());
      return editedCorrectionPrompt;
    });

    return updatedCorrectionPrompt;
  }

  @override
  Future<CorrectionPromptModel> archiveCorrectionPrompt({
    required String correctionPromptId,
  }) async {
    final normalizedId = correctionPromptId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Correction Prompt ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedCorrectionPrompt = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Correction Prompt not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Correction Prompt data is unavailable.');
      }

      final currentCorrectionPrompt = CorrectionPromptModel.fromMap(data);
      if (currentCorrectionPrompt.status == _archivedStatus) {
        throw StateError('Correction Prompt is already archived.');
      }
      if (currentCorrectionPrompt.status != _draftStatus) {
        throw StateError('Only draft correction prompts can be archived.');
      }

      final updatedCorrectionPrompt = currentCorrectionPrompt.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updatedCorrectionPrompt.toMap());
      return updatedCorrectionPrompt;
    });

    return archivedCorrectionPrompt;
  }

  @override
  Future<CorrectionPromptModel> updateCorrectionPromptGeneralSettings({
    required String correctionPromptId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = correctionPromptId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Correction Prompt ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedCorrectionPrompt = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Correction Prompt not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Correction Prompt data is unavailable.');
      }

      final currentCorrectionPrompt = CorrectionPromptModel.fromMap(data);
      final editedCorrectionPrompt = currentCorrectionPrompt.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedCorrectionPrompt.toMap());
      return editedCorrectionPrompt;
    });

    return updatedCorrectionPrompt;
  }

  String _generateCorrectionPromptId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'correction_prompt_${ts}_$suffix';
  }
}
