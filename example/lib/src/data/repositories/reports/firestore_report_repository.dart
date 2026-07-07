import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/reports/report_model.dart';
import '../../../domain/repositories/reports/report_repository.dart';

class FirestoreReportRepository implements ReportRepository {
  FirestoreReportRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'reports';
  static const String _draftStatus = 'draft';
  static const String _archivedStatus = 'archived';
  static const int _defaultPrimaryColor = 0xFF0F766E;

  final FirebaseFirestore _firestore;
  final Random _random = Random();

  @override
  Future<ReportModel> createReport({
    required String resultId,
    required String title,
    String? summary,
  }) async {
    final normalizedResultId = resultId.trim();
    final normalizedTitle = title.trim();
    final normalizedSummary = summary?.trim();

    if (normalizedResultId.isEmpty) {
      throw ArgumentError('Result ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Title is required.');
    }

    const maxAttempts = 5;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final reportId = _generateReportId();
      final docRef = _firestore.collection(_collection).doc(reportId);
      final now = DateTime.now().toUtc();

      final report = ReportModel(
        reportId: reportId,
        resultId: normalizedResultId,
        title: normalizedTitle,
        primaryColor: _defaultPrimaryColor,
        status: _draftStatus,
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
            throw StateError('Report ID collision detected.');
          }
          transaction.set(docRef, report.toMap());
        });

        return report;
      } on StateError {
        if (attempt == maxAttempts - 1) {
          rethrow;
        }
      }
    }

    throw StateError('Unable to create report after multiple attempts.');
  }

  @override
  Future<ReportModel?> getReportById(String reportId) async {
    final normalizedId = reportId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Report ID is required.');
    }

    final snapshot = await _firestore.collection(_collection).doc(normalizedId).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return ReportModel.fromMap(data);
  }

  @override
  Future<ReportModel> updateReport({
    required String reportId,
    required String title,
    String? summary,
  }) async {
    final normalizedId = reportId.trim();
    final normalizedTitle = title.trim();
    final normalizedSummary = summary?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Report ID is required.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('Title is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedReport = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Report not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Report data is unavailable.');
      }

      final currentReport = ReportModel.fromMap(data);
      final editedReport = currentReport.copyWith(
        title: normalizedTitle,
        summary: normalizedSummary,
        clearSummary: normalizedSummary == null || normalizedSummary.isEmpty,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedReport.toMap());
      return editedReport;
    });

    return updatedReport;
  }

  @override
  Future<ReportModel> archiveReport({
    required String reportId,
  }) async {
    final normalizedId = reportId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('Report ID is required.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final archivedReport = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Report not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Report data is unavailable.');
      }

      final currentReport = ReportModel.fromMap(data);
      if (currentReport.status == _archivedStatus) {
        throw StateError('Report is already archived.');
      }
      if (currentReport.status != _draftStatus) {
        throw StateError('Only draft reports can be archived.');
      }

      final updatedReport = currentReport.copyWith(
        status: _archivedStatus,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, updatedReport.toMap());
      return updatedReport;
    });

    return archivedReport;
  }

  @override
  Future<ReportModel> updateReportGeneralSettings({
    required String reportId,
    String? description,
    required int primaryColor,
  }) async {
    final normalizedId = reportId.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('Report ID is required.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('Primary color is invalid.');
    }

    final docRef = _firestore.collection(_collection).doc(normalizedId);

    final updatedReport = await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw StateError('Report not found.');
      }

      final data = snapshot.data();
      if (data == null) {
        throw StateError('Report data is unavailable.');
      }

      final currentReport = ReportModel.fromMap(data);
      final editedReport = currentReport.copyWith(
        description: normalizedDescription,
        clearDescription: normalizedDescription == null || normalizedDescription.isEmpty,
        primaryColor: primaryColor,
        updatedAt: DateTime.now().toUtc(),
      );

      transaction.set(docRef, editedReport.toMap());
      return editedReport;
    });

    return updatedReport;
  }

  String _generateReportId() {
    final ts = DateTime.now().toUtc().microsecondsSinceEpoch;
    final suffix = _random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return 'report_${ts}_$suffix';
  }
}
