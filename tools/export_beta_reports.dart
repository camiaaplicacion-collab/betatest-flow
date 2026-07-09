import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:betatest_flow/src/domain/models/action_plan_item.dart';
import 'package:betatest_flow/src/domain/services/beta_analysis_service.dart';

Future<void> main(List<String> args) async {
  late final _ParsedArgs parsed;
  try {
    parsed = _parseArgs(args);
  } on ArgumentError catch (error) {
    stderr.writeln(error.message);
    _printUsage();
    exitCode = 64;
    return;
  }

  if (parsed.showHelp) {
    _printUsage();
    return;
  }

  final outDir = Directory(parsed.outDir);
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  final jsonPath = '${parsed.outDir}${Platform.pathSeparator}beta_reports.json';
  final csvPath = '${parsed.outDir}${Platform.pathSeparator}beta_reports.csv';
  final mdPath = '${parsed.outDir}${Platform.pathSeparator}beta_summary.md';

  if (parsed.inputJsonPath != null && parsed.inputJsonPath!.isNotEmpty) {
    final documents = await _loadReportsFromInputJson(
      parsed.inputJsonPath!,
      appIdFilter: parsed.appId,
      campaignIdFilter: parsed.campaignId,
    );

    await File(jsonPath).writeAsString(
      const JsonEncoder.withIndent('  ').convert(documents),
    );
    await File(csvPath).writeAsString(_toCsv(documents));
    await File(mdPath).writeAsString(_buildSummaryMarkdown(documents));

    stdout.writeln('Export completed (offline JSON mode).');
    stdout.writeln('- Input JSON: ${parsed.inputJsonPath}');
    stdout.writeln('- JSON: $jsonPath');
    stdout.writeln('- CSV: $csvPath');
    stdout.writeln('- MD:  $mdPath');
    stdout.writeln('Total reports: ${documents.length}');
    return;
  }

  final serviceAccountPath = parsed.serviceAccountPath ??
      Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'];
  if (serviceAccountPath == null || serviceAccountPath.isEmpty) {
    stderr.writeln(
      'Missing service account path. Use --service-account or GOOGLE_APPLICATION_CREDENTIALS.',
    );
    exitCode = 64;
    return;
  }

  final serviceFile = File(serviceAccountPath);
  if (!serviceFile.existsSync()) {
    stderr.writeln('Service account file not found: $serviceAccountPath');
    exitCode = 66;
    return;
  }

  final credentialsJson =
      jsonDecode(await serviceFile.readAsString()) as Map<String, dynamic>;
  final serviceAccount = ServiceAccountCredentials.fromJson(credentialsJson);
  final projectId = parsed.projectId ?? credentialsJson['project_id'] as String?;

  if (projectId == null || projectId.isEmpty) {
    stderr.writeln('Missing project id. Use --project-id or include project_id in credentials.');
    exitCode = 64;
    return;
  }

  final authClient = await clientViaServiceAccount(
    serviceAccount,
    const ['https://www.googleapis.com/auth/datastore'],
  );

  try {
    final documents = await _fetchAllReports(
      authClient,
      projectId: projectId,
      appIdFilter: parsed.appId,
      campaignIdFilter: parsed.campaignId,
    );

    await File(jsonPath).writeAsString(
      const JsonEncoder.withIndent('  ').convert(documents),
    );

    await File(csvPath).writeAsString(_toCsv(documents));
    await File(mdPath).writeAsString(_buildSummaryMarkdown(documents));

    stdout.writeln('Export completed.');
    stdout.writeln('- JSON: $jsonPath');
    stdout.writeln('- CSV: $csvPath');
    stdout.writeln('- MD:  $mdPath');
    stdout.writeln('Total reports: ${documents.length}');
  } finally {
    authClient.close();
  }
}

Future<List<Map<String, dynamic>>> _loadReportsFromInputJson(
  String inputJsonPath, {
  required String? appIdFilter,
  required String? campaignIdFilter,
}) async {
  final inputFile = File(inputJsonPath);
  if (!inputFile.existsSync()) {
    throw ArgumentError('Input JSON file not found: $inputJsonPath');
  }

  final raw = jsonDecode(await inputFile.readAsString());
  if (raw is! List) {
    throw ArgumentError('Input JSON must be an array of reports or Firestore documents.');
  }

  final reports = <Map<String, dynamic>>[];
  for (final item in raw) {
    if (item is! Map) {
      continue;
    }

    final map = item.map((key, value) => MapEntry('$key', value));
    final normalized = _isFirestoreDocumentShape(map)
        ? _normalizeDocument(map)
        : _normalizeInputReport(map);

    if (_matchesFilters(normalized, appIdFilter: appIdFilter, campaignIdFilter: campaignIdFilter)) {
      reports.add(normalized);
    }
  }

  return reports;
}

bool _isFirestoreDocumentShape(Map<String, dynamic> candidate) {
  return candidate.containsKey('fields') || candidate.containsKey('name');
}

Map<String, dynamic> _normalizeInputReport(Map<String, dynamic> input) {
  final checklist = (input['checklist'] as List<dynamic>? ?? const <dynamic>[])
      .map((value) => value.toString())
      .toList(growable: false);

  Map<String, dynamic> deviceData;
  final rawDeviceData = input['deviceTechnicalData'];
  if (rawDeviceData is Map) {
    deviceData = rawDeviceData.map((key, value) => MapEntry('$key', value));
  } else {
    deviceData = <String, dynamic>{};
  }

  return <String, dynamic>{
    'documentId': input['documentId']?.toString() ?? '',
    'appId': input['appId']?.toString() ?? '',
    'appName': input['appName']?.toString() ?? '',
    'campaignId': input['campaignId']?.toString() ?? '',
    'campaignName': input['campaignName']?.toString() ?? '',
    'userId': input['userId']?.toString() ?? '',
    'email': input['email']?.toString() ?? '',
    'checklist': checklist,
    'result': input['result']?.toString() ?? '',
    'severity': input['severity']?.toString() ?? '',
    'feedbackText': input['feedbackText']?.toString() ?? '',
    'screenName': input['screenName']?.toString() ?? '',
    'reproducibility': input['reproducibility']?.toString() ?? '',
    'usageImpact': input['usageImpact']?.toString() ?? '',
    'publishRecommendation': input['publishRecommendation']?.toString() ?? '',
    'uxDetails': input['uxDetails']?.toString() ?? '',
    'interfaceEvaluation': input['interfaceEvaluation']?.toString() ?? '',
    'colorEvaluation': input['colorEvaluation']?.toString() ?? '',
    'usabilityEvaluation': input['usabilityEvaluation']?.toString() ?? '',
    'stepsToReproduce': input['stepsToReproduce']?.toString() ?? '',
    'suggestion': input['suggestion']?.toString() ?? '',
    'rating': input['rating'],
    'wouldPublishToday': input['wouldPublishToday'],
    'deviceTechnicalData': deviceData,
    'markdownReport': input['markdownReport']?.toString() ?? '',
    'createdAt': input['createdAt']?.toString() ?? '',
    'updatedAt': input['updatedAt']?.toString() ?? '',
  };
}

Future<List<Map<String, dynamic>>> _fetchAllReports(
  AutoRefreshingAuthClient authClient, {
  required String projectId,
  String? appIdFilter,
  String? campaignIdFilter,
}) async {
  final reports = <Map<String, dynamic>>[];
  String? pageToken;

  do {
    final queryParameters = <String, String>{
      'pageSize': '500',
      if (pageToken != null && pageToken.isNotEmpty) 'pageToken': pageToken,
    };

    final uri = Uri.https(
      'firestore.googleapis.com',
      '/v1/projects/$projectId/databases/(default)/documents/beta_reports',
      queryParameters,
    );

    final response = await authClient.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Firestore request failed (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = (decoded['documents'] as List<dynamic>? ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();

    for (final doc in docs) {
      final normalized = _normalizeDocument(doc);
      if (_matchesFilters(normalized, appIdFilter: appIdFilter, campaignIdFilter: campaignIdFilter)) {
        reports.add(normalized);
      }
    }

    pageToken = decoded['nextPageToken'] as String?;
  } while (pageToken != null && pageToken.isNotEmpty);

  return reports;
}

bool _matchesFilters(
  Map<String, dynamic> report, {
  required String? appIdFilter,
  required String? campaignIdFilter,
}) {
  if (appIdFilter != null && appIdFilter.isNotEmpty && report['appId'] != appIdFilter) {
    return false;
  }

  if (campaignIdFilter != null &&
      campaignIdFilter.isNotEmpty &&
      report['campaignId'] != campaignIdFilter) {
    return false;
  }

  return true;
}

Map<String, dynamic> _normalizeDocument(Map<String, dynamic> document) {
  final fields = _decodeFields(document['fields'] as Map<String, dynamic>? ?? <String, dynamic>{});
  final parsedFeedback = _extractFeedbackPayload(fields['feedbackText'] as String?);

  final checklistResponses =
      (fields['checklistResponses'] as Map<String, dynamic>? ?? <String, dynamic>{})
          .map((key, value) => MapEntry(key, value == true));
  final checkedItems = checklistResponses.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList(growable: false);

  final feedbackText = parsedFeedback['mainComment'] as String? ??
      (fields['feedbackText'] as String? ?? '');

  return <String, dynamic>{
    'documentId': _documentId(document['name'] as String?),
    'appId': fields['appId'] as String? ?? '',
    'appName': fields['appName'] as String? ?? '',
    'campaignId': fields['campaignId'] as String? ?? '',
    'campaignName': fields['campaignName'] as String? ?? '',
    'userId': fields['userId'] as String? ?? '',
    'email': (parsedFeedback['email'] as String?) ?? (fields['email'] as String? ?? ''),
    'checklist': checkedItems,
    'result': (parsedFeedback['generalResult'] as String?) ?? (fields['result'] as String? ?? ''),
    'severity': (parsedFeedback['severity'] as String?) ?? (fields['severity'] as String? ?? ''),
    'feedbackText': feedbackText,
    'screenName': (fields['screenName'] as String?) ??
      (parsedFeedback['screenName']?.toString() ?? ''),
    'reproducibility': (fields['reproducibility'] as String?) ??
      (parsedFeedback['reproducibility']?.toString() ?? ''),
    'usageImpact': (fields['usageImpact'] as String?) ??
      (parsedFeedback['usageImpact']?.toString() ?? ''),
    'publishRecommendation':
      (fields['publishRecommendation'] as String?) ??
        (parsedFeedback['publishRecommendation']?.toString() ?? ''),
    'uxDetails': (fields['uxDetails'] as String?) ??
      (parsedFeedback['uxDetails']?.toString() ?? ''),
    'interfaceEvaluation':
      (fields['interfaceEvaluation'] as String?) ??
        (parsedFeedback['interfaceEvaluation']?.toString() ?? ''),
    'colorEvaluation': (fields['colorEvaluation'] as String?) ??
      (parsedFeedback['colorEvaluation']?.toString() ?? ''),
    'usabilityEvaluation':
      (fields['usabilityEvaluation'] as String?) ??
        (parsedFeedback['usabilityEvaluation']?.toString() ?? ''),
    'stepsToReproduce':
        (parsedFeedback['steps'] as String?) ?? (fields['stepsToReproduce'] as String? ?? ''),
    'suggestion': (parsedFeedback['suggestion'] as String?) ?? (fields['suggestion'] as String? ?? ''),
    'rating': (parsedFeedback['rating']) ?? fields['rating'],
    'wouldPublishToday':
        (parsedFeedback['wouldPublishToday']) ?? fields['wouldPublishToday'],
    'deviceTechnicalData':
        fields['deviceTechnicalData'] as Map<String, dynamic>? ?? <String, dynamic>{},
    'markdownReport': fields['markdownReport'] as String? ?? '',
    'createdAt': fields['createdAt']?.toString() ?? '',
    'updatedAt': fields['updatedAt']?.toString() ?? '',
  };
}

String _documentId(String? name) {
  if (name == null || name.isEmpty) {
    return '';
  }
  final parts = name.split('/');
  return parts.isEmpty ? '' : parts.last;
}

Map<String, dynamic> _decodeFields(Map<String, dynamic> fields) {
  final output = <String, dynamic>{};
  for (final entry in fields.entries) {
    output[entry.key] = _decodeFirestoreValue(entry.value as Map<String, dynamic>);
  }
  return output;
}

dynamic _decodeFirestoreValue(Map<String, dynamic> valueMap) {
  if (valueMap.containsKey('stringValue')) {
    return valueMap['stringValue'] as String;
  }
  if (valueMap.containsKey('integerValue')) {
    final raw = valueMap['integerValue'];
    if (raw is int) {
      return raw;
    }
    return int.tryParse(raw.toString());
  }
  if (valueMap.containsKey('doubleValue')) {
    final raw = valueMap['doubleValue'];
    if (raw is num) {
      return raw.toDouble();
    }
    return double.tryParse(raw.toString());
  }
  if (valueMap.containsKey('booleanValue')) {
    return valueMap['booleanValue'] as bool;
  }
  if (valueMap.containsKey('nullValue')) {
    return null;
  }
  if (valueMap.containsKey('timestampValue')) {
    return valueMap['timestampValue'] as String;
  }
  if (valueMap.containsKey('mapValue')) {
    final nestedFields = (valueMap['mapValue'] as Map<String, dynamic>)['fields']
            as Map<String, dynamic>? ??
        <String, dynamic>{};
    return _decodeFields(nestedFields);
  }
  if (valueMap.containsKey('arrayValue')) {
    final values = (valueMap['arrayValue'] as Map<String, dynamic>)['values'] as List<dynamic>? ??
        const <dynamic>[];
    return values
        .cast<Map<String, dynamic>>()
        .map(_decodeFirestoreValue)
        .toList(growable: false);
  }
  return null;
}

Map<String, dynamic> _extractFeedbackPayload(String? feedbackText) {
  if (feedbackText == null || feedbackText.isEmpty) {
    return <String, dynamic>{};
  }

  final markerIndex = feedbackText.lastIndexOf('[btf_form_v1]');
  if (markerIndex < 0) {
    return <String, dynamic>{
      'mainComment': feedbackText,
    };
  }

  final mainComment = feedbackText.substring(0, markerIndex).trim();
  final payloadRaw = feedbackText.substring(markerIndex + '[btf_form_v1]'.length).trim();

  if (payloadRaw.isEmpty) {
    return <String, dynamic>{
      'mainComment': mainComment,
    };
  }

  try {
    final decoded = jsonDecode(payloadRaw);
    if (decoded is Map<String, dynamic>) {
      return <String, dynamic>{
        ...decoded,
        'mainComment': mainComment,
      };
    }
    if (decoded is Map) {
      return <String, dynamic>{
        ...decoded.map((key, value) => MapEntry('$key', value)),
        'mainComment': mainComment,
      };
    }
  } catch (_) {
    return <String, dynamic>{
      'mainComment': mainComment,
    };
  }

  return <String, dynamic>{
    'mainComment': mainComment,
  };
}

String _toCsv(List<Map<String, dynamic>> reports) {
  const headers = <String>[
    'appId',
    'appName',
    'campaignId',
    'campaignName',
    'userId',
    'email',
    'checklist',
    'result',
    'severity',
    'feedbackText',
    'screenName',
    'reproducibility',
    'usageImpact',
    'publishRecommendation',
    'uxDetails',
    'interfaceEvaluation',
    'colorEvaluation',
    'usabilityEvaluation',
    'stepsToReproduce',
    'suggestion',
    'rating',
    'wouldPublishToday',
    'deviceTechnicalData',
    'markdownReport',
    'createdAt',
    'updatedAt',
  ];

  final buffer = StringBuffer();
  buffer.writeln(headers.join(','));

  for (final report in reports) {
    final row = headers.map((header) {
      final value = report[header];
      if (value is List || value is Map) {
        return _csvEscape(jsonEncode(value));
      }
      return _csvEscape(value?.toString() ?? '');
    }).join(',');
    buffer.writeln(row);
  }

  return buffer.toString();
}

String _csvEscape(String input) {
  final escaped = input.replaceAll('"', '""');
  return '"$escaped"';
}

String _buildSummaryMarkdown(List<Map<String, dynamic>> reports) {
  final analysis = const BetaAnalysisService().analyze(reports);
  final snapshot = analysis.metricsSnapshot;

  final severityCount = snapshot.severityDistribution.counts;
  final resultCount = snapshot.resultDistribution.counts;
  final screenCount = snapshot.screenNameDistribution.counts;
  final reproducibilityCount = snapshot.reproducibilityDistribution.counts;
  final usageImpactCount = snapshot.usageImpactDistribution.counts;
  final publishRecommendationCount =
      snapshot.publishRecommendationDistribution.counts;
  final interfaceEvaluationCount =
      snapshot.interfaceEvaluationDistribution.counts;
  final colorEvaluationCount = snapshot.colorEvaluationDistribution.counts;
  final usabilityEvaluationCount = snapshot.usabilityEvaluationDistribution.counts;
  final checklistCount = <String, int>{};
  final technicalCount = <String, int>{};
  final problemReports = <Map<String, dynamic>>[];
  final suggestions = <String>[];
  final uxObservations = <String>[];

  for (final report in reports) {
    final checklist = (report['checklist'] as List<dynamic>? ?? const <dynamic>[])
        .map((value) => value.toString())
        .toList(growable: false);
    for (final item in checklist) {
      checklistCount[item] = (checklistCount[item] ?? 0) + 1;
    }

    final suggestion = (report['suggestion'] ?? '').toString().trim();
    if (suggestion.isNotEmpty) {
      suggestions.add(suggestion);
    }

    final uxDetail = (report['uxDetails'] ?? '').toString().trim();
    if (uxDetail.isNotEmpty) {
      uxObservations.add(uxDetail);
    }

    final severity = (report['severity'] ?? '').toString();
    final result = (report['result'] ?? '').toString();
    if (severity == 'alta' || severity == 'critica' || result == 'no_funciono') {
      problemReports.add(report);
    }

    final deviceData = report['deviceTechnicalData'] as Map<String, dynamic>?;
    if (deviceData != null) {
      final platform = deviceData['platform']?.toString();
      if (platform != null && platform.isNotEmpty) {
        technicalCount['platform:$platform'] =
            (technicalCount['platform:$platform'] ?? 0) + 1;
      }

      final model = deviceData['deviceModel']?.toString();
      if (model != null && model.isNotEmpty && model != 'unknown') {
        technicalCount['model:$model'] = (technicalCount['model:$model'] ?? 0) + 1;
      }

      final osVersion = deviceData['osVersion']?.toString();
      if (osVersion != null && osVersion.isNotEmpty && osVersion != 'unknown') {
        technicalCount['os:$osVersion'] = (technicalCount['os:$osVersion'] ?? 0) + 1;
      }
    }
  }

  final sortedChecklist = _sortByValueDesc(checklistCount);
  final sortedTechnical = _sortByValueDesc(technicalCount);
  final sortedScreens = _sortByValueDesc(screenCount);
  final sortedReproducibility = _sortByValueDesc(reproducibilityCount);
  final sortedUsageImpact = _sortByValueDesc(usageImpactCount);
  final sortedPublishRecommendation = _sortByValueDesc(publishRecommendationCount);
  final sortedInterfaceEvaluation = _sortByValueDesc(interfaceEvaluationCount);
  final sortedColorEvaluation = _sortByValueDesc(colorEvaluationCount);
  final sortedUsabilityEvaluation = _sortByValueDesc(usabilityEvaluationCount);

  final prompt = _buildCorrectionPrompt(
    reports: reports,
    releaseDecisionTitle: analysis.releaseDecision.title,
    releaseDecisionRationale: analysis.releaseDecision.rationale,
    confidenceOverallScore: analysis.confidenceScore.overallScore,
    confidenceLabel: analysis.confidenceScore.label,
    confidenceStabilityScore: analysis.confidenceScore.stabilityScore,
    confidenceUsabilityScore: analysis.confidenceScore.usabilityScore,
    confidenceReleaseReadinessScore: analysis.confidenceScore.releaseReadinessScore,
    actionPlan: analysis.actionPlan,
    severityCount: severityCount,
    resultCount: resultCount,
    topChecklist: sortedChecklist.take(5).toList(growable: false),
    topScreens: sortedScreens.take(5).toList(growable: false),
    reproducibilitySummary: sortedReproducibility.take(5).toList(growable: false),
    usageImpactSummary: sortedUsageImpact.take(5).toList(growable: false),
    publishRecommendationSummary:
        sortedPublishRecommendation.take(5).toList(growable: false),
    interfaceEvaluationSummary:
        sortedInterfaceEvaluation.take(5).toList(growable: false),
    colorEvaluationSummary: sortedColorEvaluation.take(5).toList(growable: false),
    usabilityEvaluationSummary:
        sortedUsabilityEvaluation.take(5).toList(growable: false),
    topUxObservations: uxObservations.take(5).toList(growable: false),
    topProblems: problemReports.take(5).toList(growable: false),
    topSuggestions: suggestions.take(5).toList(growable: false),
  );

  final buffer = StringBuffer();
  buffer.writeln('# Resumen Beta');
  buffer.writeln();
  buffer.writeln('## Total de reportes');
  buffer.writeln('- ${analysis.totalReports}');
  buffer.writeln();

  buffer.writeln('## Por gravedad');
  if (severityCount.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in _sortByValueDesc(severityCount)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Por resultado');
  if (resultCount.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in _sortByValueDesc(resultCount)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Areas mas probadas');
  if (sortedChecklist.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedChecklist.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Problemas reportados');
  if (problemReports.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final report in problemReports.take(10)) {
      final userId = report['userId']?.toString() ?? '';
      final severity = report['severity']?.toString() ?? '';
      final result = report['result']?.toString() ?? '';
      final comment = (report['feedbackText']?.toString() ?? '').replaceAll('\n', ' ');
      final trimmed = comment.length > 140 ? '${comment.substring(0, 140)}...' : comment;
      buffer.writeln('- [$userId] ($severity / $result) $trimmed');
    }
  }
  buffer.writeln();

  buffer.writeln('## Sugerencias');
  if (suggestions.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final suggestion in suggestions.take(15)) {
      buffer.writeln('- $suggestion');
    }
  }
  buffer.writeln();

  buffer.writeln('## Pantallas mas reportadas');
  if (sortedScreens.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedScreens.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Repetibilidad');
  if (sortedReproducibility.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedReproducibility.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Impacto en uso');
  if (sortedUsageImpact.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedUsageImpact.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Recomendacion de publicacion');
  if (sortedPublishRecommendation.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedPublishRecommendation.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  final decision = analysis.releaseDecision;
  buffer.writeln('## Decision de publicacion');
  buffer.writeln('- Estado: ${decision.title}');
  buffer.writeln('- Razon: ${decision.rationale}');
  if (decision.blockingReasons.isNotEmpty) {
    buffer.writeln('- Bloqueadores:');
    for (final reason in decision.blockingReasons) {
      buffer.writeln('  - $reason');
    }
  }
  if (decision.conditionsToGoLive.isNotEmpty) {
    buffer.writeln('- Condiciones para publicar:');
    for (final condition in decision.conditionsToGoLive) {
      buffer.writeln('  - $condition');
    }
  }
  buffer.writeln();

  final score = analysis.confidenceScore;
  buffer.writeln('## Beta Confidence Score');
  buffer.writeln('- Overall: ${score.overallScore}/100 (${score.label})');
  buffer.writeln('- Stability: ${score.stabilityScore}/100');
  buffer.writeln('- Usability: ${score.usabilityScore}/100');
  buffer.writeln('- Release readiness: ${score.releaseReadinessScore}/100');
  if (score.penalties.isNotEmpty) {
    buffer.writeln('- Penalizaciones:');
    for (final penalty in score.penalties) {
      buffer.writeln('  - $penalty');
    }
  }
  if (score.strengths.isNotEmpty) {
    buffer.writeln('- Fortalezas:');
    for (final strength in score.strengths) {
      buffer.writeln('  - $strength');
    }
  }
  buffer.writeln();

  final actionPlan = analysis.actionPlan;
  buffer.writeln('## Plan de accion 48h');
  if (actionPlan.isEmpty) {
    buffer.writeln('- Sin acciones sugeridas');
  } else {
    for (final item in actionPlan) {
      buffer.writeln('- P${item.priority}: ${item.title}');
      buffer.writeln('  - Razon: ${_normalizeReportCountWording(item.rationale)}');
      buffer.writeln('  - Accion sugerida: ${item.suggestedAction}');
      buffer.writeln('  - Validacion: ${item.validation}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Evaluacion de interfaz');
  if (sortedInterfaceEvaluation.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedInterfaceEvaluation.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Evaluacion de colores');
  if (sortedColorEvaluation.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedColorEvaluation.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Facilidad de uso');
  if (sortedUsabilityEvaluation.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedUsabilityEvaluation.take(10)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Observaciones UX destacadas');
  if (uxObservations.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final detail in uxObservations.take(15)) {
      buffer.writeln('- $detail');
    }
  }
  buffer.writeln();

  buffer.writeln('## Datos tecnicos frecuentes');
  if (sortedTechnical.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final entry in sortedTechnical.take(15)) {
      buffer.writeln('- ${entry.key}: ${entry.value}');
    }
  }
  buffer.writeln();

  buffer.writeln('## Reportes individuales');
  if (reports.isEmpty) {
    buffer.writeln('- Sin datos');
  } else {
    for (final report in reports) {
      final userId = report['userId']?.toString() ?? '';
      final campaign = report['campaignId']?.toString() ?? '';
      final severity = report['severity']?.toString() ?? '';
      final result = report['result']?.toString() ?? '';
      final updatedAt = report['updatedAt']?.toString() ?? '';
      buffer.writeln('- userId: $userId | campaignId: $campaign | severity: $severity | result: $result | updatedAt: $updatedAt');
    }
  }
  buffer.writeln();

  buffer.writeln('## Prompt de Correccion');
  buffer.writeln('```text');
  buffer.writeln(prompt);
  buffer.writeln('```');

  return buffer.toString();
}

List<MapEntry<String, int>> _sortByValueDesc(Map<String, int> source) {
  final entries = source.entries.toList(growable: false)
    ..sort((a, b) => b.value.compareTo(a.value));
  return entries;
}

String _buildCorrectionPrompt({
  required List<Map<String, dynamic>> reports,
  required String releaseDecisionTitle,
  required String releaseDecisionRationale,
  required int confidenceOverallScore,
  required String confidenceLabel,
  required int confidenceStabilityScore,
  required int confidenceUsabilityScore,
  required int confidenceReleaseReadinessScore,
  required List<ActionPlanItem> actionPlan,
  required Map<String, int> severityCount,
  required Map<String, int> resultCount,
  required List<MapEntry<String, int>> topChecklist,
  required List<MapEntry<String, int>> topScreens,
  required List<MapEntry<String, int>> reproducibilitySummary,
  required List<MapEntry<String, int>> usageImpactSummary,
  required List<MapEntry<String, int>> publishRecommendationSummary,
  required List<MapEntry<String, int>> interfaceEvaluationSummary,
  required List<MapEntry<String, int>> colorEvaluationSummary,
  required List<MapEntry<String, int>> usabilityEvaluationSummary,
  required List<String> topUxObservations,
  required List<Map<String, dynamic>> topProblems,
  required List<String> topSuggestions,
}) {
  final severitySummary = severityCount.entries
      .map((entry) => '${entry.key}:${entry.value}')
      .join(', ');
  final resultSummary =
      resultCount.entries.map((entry) => '${entry.key}:${entry.value}').join(', ');
  final checklistSummary =
      topChecklist.map((entry) => '${entry.key}:${entry.value}').join(', ');
    final screensSummary =
      topScreens.map((entry) => '${entry.key}:${entry.value}').join(', ');
    final reproducibilityText = reproducibilitySummary
      .map((entry) => '${entry.key}:${entry.value}')
      .join(', ');
    final usageImpactText =
      usageImpactSummary.map((entry) => '${entry.key}:${entry.value}').join(', ');
    final publishRecommendationText = publishRecommendationSummary
      .map((entry) => '${entry.key}:${entry.value}')
      .join(', ');
    final interfaceEvaluationText = interfaceEvaluationSummary
      .map((entry) => '${entry.key}:${entry.value}')
      .join(', ');
    final colorEvaluationText = colorEvaluationSummary
      .map((entry) => '${entry.key}:${entry.value}')
      .join(', ');
    final usabilityEvaluationText = usabilityEvaluationSummary
      .map((entry) => '${entry.key}:${entry.value}')
      .join(', ');

  final topProblemsText = topProblems
      .map((report) {
        final user = report['userId']?.toString() ?? '';
        final severity = report['severity']?.toString() ?? '';
        final result = report['result']?.toString() ?? '';
        final feedback = report['feedbackText']?.toString().replaceAll('\n', ' ') ?? '';
        return '- user:$user severity:$severity result:$result issue:$feedback';
      })
      .join('\n');

  final suggestionsText = topSuggestions.map((item) => '- $item').join('\n');
  final uxObservationsText = topUxObservations.map((item) => '- $item').join('\n');
  final actionPlanText = actionPlan
      .map((item) {
        final priority = item.priority.toString();
        final title = item.title;
        final rationale = _normalizeReportCountWording(item.rationale);
        final suggestedAction = item.suggestedAction;
        final validation = item.validation;
        return '- P$priority | $title\n  razon: $rationale\n  accion: $suggestedAction\n  validacion: $validation';
      })
      .join('\n');

  return '''
Actua como un ingeniero senior corrigiendo una app Flutter basada en feedback beta real.

Contexto de reportes:
- Total reportes: ${reports.length}
- Severidad: $severitySummary
- Resultado: $resultSummary
- Areas mas probadas: $checklistSummary
- Pantallas reportadas: ${screensSummary.isEmpty ? 'Sin datos' : screensSummary}
- Repetibilidad: ${reproducibilityText.isEmpty ? 'Sin datos' : reproducibilityText}
- Impacto en uso: ${usageImpactText.isEmpty ? 'Sin datos' : usageImpactText}
- Recomendacion de publicacion: ${publishRecommendationText.isEmpty ? 'Sin datos' : publishRecommendationText}
- Evaluacion de interfaz: ${interfaceEvaluationText.isEmpty ? 'Sin datos' : interfaceEvaluationText}
- Evaluacion de colores: ${colorEvaluationText.isEmpty ? 'Sin datos' : colorEvaluationText}
- Facilidad de uso: ${usabilityEvaluationText.isEmpty ? 'Sin datos' : usabilityEvaluationText}
- Decision de publicacion: $releaseDecisionTitle
- Motivo de decision: $releaseDecisionRationale
- Beta Confidence Score: $confidenceOverallScore/100 ($confidenceLabel)
- Subscores: estabilidad=$confidenceStabilityScore, usabilidad=$confidenceUsabilityScore, release readiness=$confidenceReleaseReadinessScore

Plan de accion 48h (respetar prioridad):
${actionPlanText.isEmpty ? '- Sin plan disponible' : actionPlanText}

Problemas principales:
${topProblemsText.isEmpty ? '- Sin datos' : topProblemsText}

Sugerencias de usuarios:
${suggestionsText.isEmpty ? '- Sin datos' : suggestionsText}

Observaciones UX destacadas:
${uxObservationsText.isEmpty ? '- Sin datos' : uxObservationsText}

Restricciones obligatorias:
- No hacer refactor general.
- Corregir por prioridad del Plan de accion 48h.
- Mantener compatibilidad hacia atras.
- Ejecutar analyze y test al final de los cambios.

Formato esperado de respuesta:
1. Archivos modificados.
2. Causa.
3. Solucion.
4. Validacion (incluye analyze/test).
''';
}

String _normalizeReportCountWording(String text) {
  final genericSingularPattern = RegExp(r'\b1 reportes\b');
  return text.replaceAll(genericSingularPattern, '1 reporte');
}

class _ParsedArgs {
  const _ParsedArgs({
    required this.showHelp,
    required this.projectId,
    required this.serviceAccountPath,
    required this.inputJsonPath,
    required this.appId,
    required this.campaignId,
    required this.outDir,
  });

  final bool showHelp;
  final String? projectId;
  final String? serviceAccountPath;
  final String? inputJsonPath;
  final String? appId;
  final String? campaignId;
  final String outDir;
}

_ParsedArgs _parseArgs(List<String> args) {
  String? projectId;
  String? serviceAccountPath;
  String? inputJsonPath;
  String? appId;
  String? campaignId;
  var outDir = 'exports';
  var showHelp = false;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    switch (arg) {
      case '--help':
      case '-h':
        showHelp = true;
        break;
      case '--project-id':
        projectId = _nextValue(args, ++i, '--project-id');
        break;
      case '--service-account':
        serviceAccountPath = _nextValue(args, ++i, '--service-account');
        break;
      case '--input-json':
        inputJsonPath = _nextValue(args, ++i, '--input-json');
        break;
      case '--app-id':
        appId = _nextValue(args, ++i, '--app-id');
        break;
      case '--campaign-id':
        campaignId = _nextValue(args, ++i, '--campaign-id');
        break;
      case '--out-dir':
        outDir = _nextValue(args, ++i, '--out-dir') ?? outDir;
        break;
      default:
        stderr.writeln('Unknown argument: $arg');
        showHelp = true;
        break;
    }
  }

  return _ParsedArgs(
    showHelp: showHelp,
    projectId: projectId,
    serviceAccountPath: serviceAccountPath,
    inputJsonPath: inputJsonPath,
    appId: appId,
    campaignId: campaignId,
    outDir: outDir,
  );
}

String? _nextValue(List<String> args, int index, String name) {
  if (index >= args.length) {
    throw ArgumentError('Missing value for $name');
  }
  return args[index];
}

void _printUsage() {
  stdout.writeln('''
Export beta reports from Firestore to local files.

Usage:
  dart run tools/export_beta_reports.dart
    [--input-json /path/beta_reports.json]
    [--service-account /path/service-account.json]
    [--project-id your-firebase-project]
    [--app-id demo_app]
    [--campaign-id demo_beta_1]
    [--out-dir exports]

Notes:
  - If --input-json is provided, the export runs offline and does not connect to Firestore.
  - If --input-json is not provided, Firestore mode is used (requires credentials/project id).

Outputs:
  - beta_reports.json
  - beta_reports.csv
  - beta_summary.md
''');
}
