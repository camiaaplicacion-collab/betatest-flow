class MarkdownReportBuilder {
  const MarkdownReportBuilder._();

  static String build({
    required String appName,
    required String campaignName,
    required String userId,
    required String reportVersion,
    required Map<String, bool> checklistResponses,
    required Map<String, dynamic> deviceTechnicalData,
    String? feedbackText,
    int? uxEvaluationScore,
  }) {
    final checklist = checklistResponses.entries
        .map((entry) => '- [${entry.value ? 'x' : ' '}] ${entry.key}')
        .join('\n');

    final technicalData = deviceTechnicalData.entries
        .map((entry) => '- ${entry.key}: ${entry.value}')
        .join('\n');

    return '''# Beta Feedback Report

## Metadata
- App: $appName
- Campaign: $campaignName
- User: $userId
- Report version: $reportVersion

## Feedback
${feedbackText ?? 'No textual feedback provided.'}

## UX Evaluation
${uxEvaluationScore?.toString() ?? 'Not provided'}

## Checklist
${checklist.isEmpty ? '- No checklist responses.' : checklist}

## Datos tecnicos
${technicalData.isEmpty ? '- No technical data attached.' : technicalData}
''';
  }
}