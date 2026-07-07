import '../../utils/markdown_report_builder.dart';

class BetaFeedbackReport {
  BetaFeedbackReport({
    required this.appId,
    required this.appName,
    required this.campaignId,
    required this.campaignName,
    required this.userId,
    required this.reportVersion,
    this.feedbackText,
    this.checklistResponses = const <String, bool>{},
    this.deviceTechnicalData = const <String, dynamic>{},
    this.uxEvaluationScore,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? markdownReport,
  })  : createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc(),
        markdownReport = markdownReport ??
            MarkdownReportBuilder.build(
              appName: appName,
              campaignName: campaignName,
              userId: userId,
              reportVersion: reportVersion,
              feedbackText: feedbackText,
              checklistResponses: checklistResponses,
              deviceTechnicalData: deviceTechnicalData,
              uxEvaluationScore: uxEvaluationScore,
            );

  final String appId;
  final String appName;
  final String campaignId;
  final String campaignName;
  final String userId;
  final String reportVersion;
  final String? feedbackText;
  final Map<String, bool> checklistResponses;
  final Map<String, dynamic> deviceTechnicalData;
  final int? uxEvaluationScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String markdownReport;

  String get reportKey => '${campaignId}_$userId';

  BetaFeedbackReport copyWith({
    String? feedbackText,
    Map<String, bool>? checklistResponses,
    Map<String, dynamic>? deviceTechnicalData,
    int? uxEvaluationScore,
    DateTime? updatedAt,
  }) {
    return BetaFeedbackReport(
      appId: appId,
      appName: appName,
      campaignId: campaignId,
      campaignName: campaignName,
      userId: userId,
      reportVersion: reportVersion,
      feedbackText: feedbackText ?? this.feedbackText,
      checklistResponses: checklistResponses ?? this.checklistResponses,
      deviceTechnicalData: deviceTechnicalData ?? this.deviceTechnicalData,
      uxEvaluationScore: uxEvaluationScore ?? this.uxEvaluationScore,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appId': appId,
      'appName': appName,
      'campaignId': campaignId,
      'campaignName': campaignName,
      'userId': userId,
      'reportVersion': reportVersion,
      'feedbackText': feedbackText,
      'checklistResponses': checklistResponses,
      'deviceTechnicalData': deviceTechnicalData,
      'uxEvaluationScore': uxEvaluationScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'markdownReport': markdownReport,
      'reportKey': reportKey,
    };
  }

  factory BetaFeedbackReport.fromMap(Map<String, dynamic> map) {
    return BetaFeedbackReport(
      appId: map['appId'] as String? ?? '',
      appName: map['appName'] as String? ?? '',
      campaignId: map['campaignId'] as String? ?? '',
      campaignName: map['campaignName'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      reportVersion: map['reportVersion'] as String? ?? 'v1',
      feedbackText: map['feedbackText'] as String?,
      checklistResponses:
          (map['checklistResponses'] as Map<String, dynamic>? ?? <String, dynamic>{})
              .map((key, value) => MapEntry(key, value as bool)),
      deviceTechnicalData:
          map['deviceTechnicalData'] as Map<String, dynamic>? ?? <String, dynamic>{},
      uxEvaluationScore: map['uxEvaluationScore'] as int?,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '')?.toUtc(),
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '')?.toUtc(),
      markdownReport: map['markdownReport'] as String?,
    );
  }
}