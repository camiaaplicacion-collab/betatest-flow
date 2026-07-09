import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/beta_test_flow_config.dart';
import '../../domain/models/beta_feedback_report.dart';
import '../../domain/repositories/beta_feedback_repository.dart';
import '../../domain/services/beta_feedback_report_preparation_service.dart';

class FirebaseBetaFeedbackRepository implements BetaFeedbackRepository {
  FirebaseBetaFeedbackRepository({
    required BetaTestFlowConfig config,
    FirebaseFirestore? firestore,
    Future<SharedPreferences> Function()? preferencesFactory,
    BetaFeedbackReportPreparationService? reportPreparationService,
    this.clearDraftOnSubmit = true,
  })  : _config = config,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _preferencesFactory = preferencesFactory ?? SharedPreferences.getInstance,
        _reportPreparationService =
            reportPreparationService ?? BetaFeedbackReportPreparationService();

  final BetaTestFlowConfig _config;
  final FirebaseFirestore _firestore;
  final Future<SharedPreferences> Function() _preferencesFactory;
  final BetaFeedbackReportPreparationService _reportPreparationService;
  final bool clearDraftOnSubmit;

  @override
  Future<void> saveDraft(BetaFeedbackReport draft) async {
    final preparedDraft = await _reportPreparationService.prepare(draft);
    final sharedPreferences = await _preferencesFactory();
    final key = _buildDraftKey(
      appId: preparedDraft.appId,
      campaignId: preparedDraft.campaignId,
      userId: preparedDraft.userId,
    );
    final payload = jsonEncode(preparedDraft.toMap());

    final success = await sharedPreferences.setString(key, payload);
    if (!success) {
      throw StateError('Unable to persist local draft for key: $key');
    }
  }

  @override
  Future<BetaFeedbackReport?> getDraft({
    required String appId,
    required String userId,
    required String campaignId,
  }) async {
    final sharedPreferences = await _preferencesFactory();
    final key = _buildDraftKey(
      appId: appId,
      campaignId: campaignId,
      userId: userId,
    );
    final rawDraft = sharedPreferences.getString(key);
    if (rawDraft == null || rawDraft.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(rawDraft);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid draft payload format.');
    }

    return BetaFeedbackReport.fromMap(decoded);
  }

  @override
  Future<void> deleteDraft({
    required String appId,
    required String userId,
    required String campaignId,
  }) async {
    final sharedPreferences = await _preferencesFactory();
    final key = _buildDraftKey(
      appId: appId,
      campaignId: campaignId,
      userId: userId,
    );

    final success = await sharedPreferences.remove(key);
    if (!success && sharedPreferences.containsKey(key)) {
      throw StateError('Unable to remove local draft for key: $key');
    }
  }

  @override
  Future<void> submitReport(BetaFeedbackReport report) async {
    final preparedReport = await _reportPreparationService.prepare(report);
    final document = _reportsCollection().doc(preparedReport.reportKey);
    final existingReport = await document.get();
    final existingMap = existingReport.data();

    final createdAt = _resolveCreatedAt(
      existingMap: existingMap,
      fallback: preparedReport.createdAt,
    );
    final updatedAt = DateTime.now().toUtc();

    final normalizedReport = BetaFeedbackReport(
      appId: preparedReport.appId,
      appName: preparedReport.appName,
      campaignId: preparedReport.campaignId,
      campaignName: preparedReport.campaignName,
      userId: preparedReport.userId,
      reportVersion: preparedReport.reportVersion,
      feedbackText: preparedReport.feedbackText,
      screenName: preparedReport.screenName,
      reproducibility: preparedReport.reproducibility,
      usageImpact: preparedReport.usageImpact,
      publishRecommendation: preparedReport.publishRecommendation,
      uxDetails: preparedReport.uxDetails,
      checklistResponses: preparedReport.checklistResponses,
      deviceTechnicalData: preparedReport.deviceTechnicalData,
      uxEvaluationScore: preparedReport.uxEvaluationScore,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    await document.set(normalizedReport.toMap(), SetOptions(merge: true));

    if (clearDraftOnSubmit) {
      await deleteDraft(
        appId: report.appId,
        campaignId: report.campaignId,
        userId: report.userId,
      );
    }
  }

  @override
  Future<BetaFeedbackReport?> getSubmittedReport({
    required String userId,
    required String campaignId,
  }) async {
    final reportKey = buildReportKey(userId: userId, campaignId: campaignId);
    final snapshot = await _reportsCollection().doc(reportKey).get();
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    return BetaFeedbackReport.fromMap(_normalizeFirestoreMap(data));
  }

  @override
  String buildReportKey({
    required String userId,
    required String campaignId,
  }) {
    return '${campaignId}_$userId';
  }

  CollectionReference<Map<String, dynamic>> _reportsCollection() {
    return _firestore.collection(_config.firebaseCollection);
  }

  DateTime _resolveCreatedAt({
    required Map<String, dynamic>? existingMap,
    required DateTime fallback,
  }) {
    if (existingMap == null) {
      return fallback;
    }

    final createdAtValue = existingMap['createdAt'];
    if (createdAtValue is Timestamp) {
      return createdAtValue.toDate().toUtc();
    }

    if (createdAtValue is String) {
      final parsed = DateTime.tryParse(createdAtValue);
      if (parsed != null) {
        return parsed.toUtc();
      }
    }

    return fallback;
  }

  Map<String, dynamic> _normalizeFirestoreMap(Map<String, dynamic> data) {
    final normalized = Map<String, dynamic>.from(data);

    if (normalized['createdAt'] is Timestamp) {
      normalized['createdAt'] =
          (normalized['createdAt'] as Timestamp).toDate().toUtc().toIso8601String();
    }
    if (normalized['updatedAt'] is Timestamp) {
      normalized['updatedAt'] =
          (normalized['updatedAt'] as Timestamp).toDate().toUtc().toIso8601String();
    }

    return normalized;
  }

  String _buildDraftKey({
    required String appId,
    required String campaignId,
    required String userId,
  }) {
    return 'betatest_flow_draft_${appId}_${campaignId}_$userId';
  }
}