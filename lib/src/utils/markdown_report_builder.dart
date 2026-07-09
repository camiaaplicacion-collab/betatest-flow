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
    String? screenName,
    String? reproducibility,
    String? usageImpact,
    String? publishRecommendation,
    String? uxDetails,
    String? interfaceEvaluation,
    String? colorEvaluation,
    String? usabilityEvaluation,
    int? uxEvaluationScore,
  }) {
    final checklist = checklistResponses.entries
        .map((entry) => '- [${entry.value ? 'x' : ' '}] ${entry.key}')
        .join('\n');

    final technicalData = deviceTechnicalData.entries
        .map((entry) => '- ${entry.key}: ${entry.value}')
        .join('\n');

    final advancedLines = <String>[
      if (_hasValue(screenName)) '- Pantalla: ${screenName!.trim()}',
      if (_hasValue(reproducibility))
        '- Repetibilidad: ${reproducibility!.trim()}',
      if (_hasValue(usageImpact)) '- Impacto de uso: ${usageImpact!.trim()}',
      if (_hasValue(publishRecommendation))
        '- Recomendacion de publicacion: ${publishRecommendation!.trim()}',
      if (_hasValue(uxDetails)) '- Detalles UX: ${uxDetails!.trim()}',
      if (_hasValue(interfaceEvaluation))
        '- Evaluacion de interfaz: ${interfaceEvaluation!.trim()}',
      if (_hasValue(colorEvaluation))
        '- Evaluacion de colores: ${colorEvaluation!.trim()}',
      if (_hasValue(usabilityEvaluation))
        '- Facilidad de uso: ${usabilityEvaluation!.trim()}',
    ];

    final advancedSection = advancedLines.isEmpty
        ? ''
        : '\n\n## Campos avanzados\n${advancedLines.join('\n')}';

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
${technicalData.isEmpty ? '- No technical data attached.' : technicalData}$advancedSection
''';
  }

  static bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}