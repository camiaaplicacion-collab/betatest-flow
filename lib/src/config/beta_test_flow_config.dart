import 'package:flutter/material.dart';

import 'beta_feedback_field_config.dart';
import '../domain/models/beta_checklist_item.dart';

class BetaTestFlowConfig {
  const BetaTestFlowConfig({
    required this.appId,
    required this.appName,
    required this.campaignId,
    required this.campaignName,
    required this.checklistItems,
    required this.reportVersion,
    this.firebaseCollection = 'beta_reports',
    this.primaryColor,
    this.enableUxEvaluation = false,
    this.fieldConfig = const BetaFeedbackFieldConfig(),
  });

  final String appId;
  final String appName;
  final String campaignId;
  final String campaignName;
  final List<BetaChecklistItem> checklistItems;
  final String firebaseCollection;
  final Color? primaryColor;
  final bool enableUxEvaluation;
  final BetaFeedbackFieldConfig fieldConfig;
  final String reportVersion;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appId': appId,
      'appName': appName,
      'campaignId': campaignId,
      'campaignName': campaignName,
      'checklistItems': checklistItems.map((item) => item.toMap()).toList(),
      'firebaseCollection': firebaseCollection,
      'primaryColor': primaryColor?.toARGB32(),
      'enableUxEvaluation': enableUxEvaluation,
      'fieldConfig': fieldConfig.toMap(),
      'reportVersion': reportVersion,
    };
  }

  factory BetaTestFlowConfig.fromMap(Map<String, dynamic> map) {
    return BetaTestFlowConfig(
      appId: map['appId'] as String? ?? '',
      appName: map['appName'] as String? ?? '',
      campaignId: map['campaignId'] as String? ?? '',
      campaignName: map['campaignName'] as String? ?? '',
      checklistItems: (map['checklistItems'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => BetaChecklistItem.fromMap(item as Map<String, dynamic>))
          .toList(growable: false),
      firebaseCollection: map['firebaseCollection'] as String? ?? 'beta_reports',
      primaryColor: map['primaryColor'] == null
          ? null
          : Color(map['primaryColor'] as int),
      enableUxEvaluation: map['enableUxEvaluation'] as bool? ?? false,
      fieldConfig: _resolveFieldConfig(map['fieldConfig']),
      reportVersion: map['reportVersion'] as String? ?? 'v1',
    );
  }

  static BetaFeedbackFieldConfig _resolveFieldConfig(dynamic rawValue) {
    if (rawValue is Map<String, dynamic>) {
      return BetaFeedbackFieldConfig.fromMap(rawValue);
    }
    if (rawValue is Map) {
      return BetaFeedbackFieldConfig.fromMap(
        rawValue.map((key, value) => MapEntry('$key', value)),
      );
    }
    return const BetaFeedbackFieldConfig();
  }
}