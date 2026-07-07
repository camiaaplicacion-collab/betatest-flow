import '../models/beta_feedback_report.dart';

abstract class BetaFeedbackRepository {
  Future<void> saveDraft(BetaFeedbackReport draft);

  Future<BetaFeedbackReport?> getDraft({
    required String appId,
    required String userId,
    required String campaignId,
  });

  Future<void> deleteDraft({
    required String appId,
    required String userId,
    required String campaignId,
  });

  Future<void> submitReport(BetaFeedbackReport report);

  Future<BetaFeedbackReport?> getSubmittedReport({
    required String userId,
    required String campaignId,
  });

  String buildReportKey({
    required String userId,
    required String campaignId,
  }) {
    return '${campaignId}_$userId';
  }
}