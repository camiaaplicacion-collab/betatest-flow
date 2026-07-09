import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:betatest_flow/betatest_flow.dart';

void main() {
  test('builds config with expected defaults', () {
    const config = BetaTestFlowConfig(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      checklistItems: <BetaChecklistItem>[],
      reportVersion: 'v1',
    );

    expect(config.firebaseCollection, 'beta_reports');
    expect(config.enableUxEvaluation, false);
    expect(config.fieldConfig.showScreenName, false);
    expect(config.fieldConfig.showReproducibility, false);
    expect(config.fieldConfig.showUsageImpact, false);
    expect(config.fieldConfig.showPublishRecommendation, false);
    expect(config.fieldConfig.showUxDetails, false);
    expect(config.fieldConfig.showInterfaceEvaluation, false);
    expect(config.fieldConfig.showColorEvaluation, false);
    expect(config.fieldConfig.showUsabilityEvaluation, false);
  });

  test('builds BetaFeedbackFieldConfig with safe defaults', () {
    const fieldConfig = BetaFeedbackFieldConfig();

    expect(fieldConfig.showScreenName, false);
    expect(fieldConfig.showReproducibility, false);
    expect(fieldConfig.showUsageImpact, false);
    expect(fieldConfig.showPublishRecommendation, false);
    expect(fieldConfig.showUxDetails, false);
    expect(fieldConfig.showInterfaceEvaluation, false);
    expect(fieldConfig.showColorEvaluation, false);
    expect(fieldConfig.showUsabilityEvaluation, false);
  });

  test('builds config with custom fieldConfig', () {
    const fieldConfig = BetaFeedbackFieldConfig(
      showScreenName: true,
      showReproducibility: true,
      showUsageImpact: true,
      showPublishRecommendation: true,
      showUxDetails: true,
      showInterfaceEvaluation: true,
      showColorEvaluation: true,
      showUsabilityEvaluation: true,
    );

    const config = BetaTestFlowConfig(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      checklistItems: <BetaChecklistItem>[],
      reportVersion: 'v1',
      fieldConfig: fieldConfig,
    );

    expect(config.fieldConfig.showScreenName, true);
    expect(config.fieldConfig.showReproducibility, true);
    expect(config.fieldConfig.showUsageImpact, true);
    expect(config.fieldConfig.showPublishRecommendation, true);
    expect(config.fieldConfig.showUxDetails, true);
    expect(config.fieldConfig.showInterfaceEvaluation, true);
    expect(config.fieldConfig.showColorEvaluation, true);
    expect(config.fieldConfig.showUsabilityEvaluation, true);
  });

  test('BetaFeedbackReport supports optional advanced fields', () {
    final report = BetaFeedbackReport(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      userId: 'user-1',
      reportVersion: 'v1',
      feedbackText: 'Comentario principal',
      screenName: 'HomeScreen',
      reproducibility: 'A veces',
      usageImpact: 'Afecta un poco',
      publishRecommendation: 'Si, con ajustes menores',
      uxDetails: 'Detalle UX',
      interfaceEvaluation: 'Muy clara',
      colorEvaluation: 'Correctos',
      usabilityEvaluation: 'Muy facil',
      checklistResponses: const <String, bool>{'login': true},
      deviceTechnicalData: const <String, dynamic>{},
    );

    final map = report.toMap();
    expect(map['screenName'], 'HomeScreen');
    expect(map['reproducibility'], 'A veces');
    expect(map['usageImpact'], 'Afecta un poco');
    expect(map['publishRecommendation'], 'Si, con ajustes menores');
    expect(map['uxDetails'], 'Detalle UX');
    expect(map['interfaceEvaluation'], 'Muy clara');
    expect(map['colorEvaluation'], 'Correctos');
    expect(map['usabilityEvaluation'], 'Muy facil');

    final restored = BetaFeedbackReport.fromMap(map);
    expect(restored.screenName, 'HomeScreen');
    expect(restored.reproducibility, 'A veces');
    expect(restored.usageImpact, 'Afecta un poco');
    expect(restored.publishRecommendation, 'Si, con ajustes menores');
    expect(restored.uxDetails, 'Detalle UX');
    expect(restored.interfaceEvaluation, 'Muy clara');
    expect(restored.colorEvaluation, 'Correctos');
    expect(restored.usabilityEvaluation, 'Muy facil');
  });

  test('BetaFeedbackReport fromMap keeps backward compatibility', () {
    final report = BetaFeedbackReport.fromMap(<String, dynamic>{
      'appId': 'app',
      'appName': 'App',
      'campaignId': 'campaign',
      'campaignName': 'Campaign',
      'userId': 'user-1',
      'reportVersion': 'v1',
      'feedbackText': 'Comentario principal',
      'checklistResponses': <String, dynamic>{'login': true},
      'deviceTechnicalData': <String, dynamic>{},
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    expect(report.screenName, isNull);
    expect(report.reproducibility, isNull);
    expect(report.usageImpact, isNull);
    expect(report.publishRecommendation, isNull);
    expect(report.uxDetails, isNull);
    expect(report.interfaceEvaluation, isNull);
    expect(report.colorEvaluation, isNull);
    expect(report.usabilityEvaluation, isNull);
  });

  test('markdown includes advanced fields only when present', () {
    final report = BetaFeedbackReport(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      userId: 'user-1',
      reportVersion: 'v1',
      feedbackText: 'Comentario principal',
      screenName: 'HomeScreen',
      reproducibility: 'A veces',
      usageImpact: 'Afecta un poco',
      publishRecommendation: 'Si, con ajustes menores',
      uxDetails: 'Detalle UX',
      interfaceEvaluation: 'Muy clara',
      colorEvaluation: 'Correctos',
      usabilityEvaluation: 'Muy facil',
      checklistResponses: const <String, bool>{'login': true},
      deviceTechnicalData: const <String, dynamic>{'platform': 'web'},
    );

    expect(report.markdownReport, contains('## Campos avanzados'));
    expect(report.markdownReport, contains('- Pantalla: HomeScreen'));
    expect(report.markdownReport, contains('- Repetibilidad: A veces'));
    expect(report.markdownReport, contains('- Impacto de uso: Afecta un poco'));
    expect(
      report.markdownReport,
      contains('- Recomendacion de publicacion: Si, con ajustes menores'),
    );
    expect(report.markdownReport, contains('- Detalles UX: Detalle UX'));
    expect(report.markdownReport, contains('- Evaluacion de interfaz: Muy clara'));
    expect(report.markdownReport, contains('- Evaluacion de colores: Correctos'));
    expect(report.markdownReport, contains('- Facilidad de uso: Muy facil'));
    expect(report.markdownReport, contains('Comentario principal'));
  });

  test('markdown keeps compatibility when advanced fields are empty', () {
    final report = BetaFeedbackReport(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      userId: 'user-1',
      reportVersion: 'v1',
      feedbackText: 'Comentario legacy',
      checklistResponses: const <String, bool>{'login': false},
      deviceTechnicalData: const <String, dynamic>{},
    );

    expect(report.markdownReport, isNot(contains('## Campos avanzados')));
    expect(report.markdownReport, contains('Comentario legacy'));
  });

  testWidgets('loads draft fields without mixing main comment and screenName', (
    WidgetTester tester,
  ) async {
    const config = BetaTestFlowConfig(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      checklistItems: <BetaChecklistItem>[
        BetaChecklistItem(id: 'login', title: 'Login'),
      ],
      reportVersion: 'v1',
      fieldConfig: BetaFeedbackFieldConfig(
        showScreenName: true,
        showReproducibility: true,
        showUsageImpact: true,
        showPublishRecommendation: true,
        showUxDetails: true,
        showInterfaceEvaluation: true,
        showColorEvaluation: true,
        showUsabilityEvaluation: true,
      ),
    );

    final payload = <String, dynamic>{
      'generalResult': 'funciono_bien',
      'severity': 'media',
      'steps': 'Paso 1',
      'suggestion': 'Sugerencia 1',
      'screenName': 'HomeScreen',
      'reproducibility': 'A veces',
      'usageImpact': 'Afecta un poco',
      'publishRecommendation': 'Si, con ajustes menores',
      'uxDetails': 'Detalle UX',
      'interfaceEvaluation': 'Muy clara',
      'colorEvaluation': 'Correctos',
      'usabilityEvaluation': 'Muy facil',
      'email': 'tester@example.com',
    };

    final draft = BetaFeedbackReport(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      userId: 'user-1',
      reportVersion: 'v1',
      feedbackText: 'Comentario principal real\n[btf_form_v1]${jsonEncode(payload)}',
      checklistResponses: const <String, bool>{'login': true},
      deviceTechnicalData: const <String, dynamic>{},
    );

    final repository = _FakeBetaFeedbackRepository(draft);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BetaFeedbackSheet(
            config: config,
            repository: repository,
            userId: 'user-1',
            email: 'tester@example.com',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final commentField = find.byType(TextFormField).at(0);
    final stepsField = find.byType(TextFormField).at(1);
    final suggestionField = find.byType(TextFormField).at(2);
    final screenField = find.byType(TextFormField).at(3);
    final uxField = find.byType(TextFormField).at(4);

    expect(tester.widget<TextFormField>(commentField).controller?.text, 'Comentario principal real');
    expect(tester.widget<TextFormField>(screenField).controller?.text, 'HomeScreen');
    expect(tester.widget<TextFormField>(stepsField).controller?.text, 'Paso 1');
    expect(tester.widget<TextFormField>(suggestionField).controller?.text, 'Sugerencia 1');
    expect(tester.widget<TextFormField>(uxField).controller?.text, 'Detalle UX');

    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'A veces')).selected,
      true,
    );
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Afecta un poco'))
          .selected,
      true,
    );
    expect(
      tester
          .widget<ChoiceChip>(
            find.widgetWithText(ChoiceChip, 'Si, con ajustes menores'),
          )
          .selected,
      true,
    );
        expect(
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Muy clara')).selected,
          true,
        );
        expect(
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Correctos')).selected,
          true,
        );
        expect(
          tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Muy facil')).selected,
          true,
        );
  });

  testWidgets('shows inline error and recovers when submit fails', (
    WidgetTester tester,
  ) async {
    const config = BetaTestFlowConfig(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      checklistItems: <BetaChecklistItem>[
        BetaChecklistItem(id: 'login', title: 'Login'),
      ],
      reportVersion: 'v1',
      fieldConfig: BetaFeedbackFieldConfig(
        showScreenName: true,
        showReproducibility: true,
        showUsageImpact: true,
        showPublishRecommendation: true,
        showUxDetails: true,
        showInterfaceEvaluation: true,
        showColorEvaluation: true,
        showUsabilityEvaluation: true,
      ),
    );

    final repository = _FakeSubmitFailureRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BetaFeedbackSheet(
            config: config,
            repository: repository,
            userId: 'user-1',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.enterText(
      find.byType(TextFormField).first,
      'Comentario para envio',
    );

    final submitButtonFinder = find.widgetWithText(ElevatedButton, 'Enviar reporte');
    await tester.ensureVisible(submitButtonFinder);
    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle();

    expect(
      find.text('No se pudo enviar el reporte. Intenta nuevamente.'),
      findsOneWidget,
    );
    expect(find.text('Feedback beta'), findsOneWidget);

    final submitButton = tester.widget<ElevatedButton>(
      submitButtonFinder,
    );
    expect(submitButton.onPressed, isNotNull);
    expect(repository.submitCalls, 1);
    expect(repository.deleteDraftCalls, 0);
  });
}

class _FakeBetaFeedbackRepository implements BetaFeedbackRepository {
  _FakeBetaFeedbackRepository(this._draft);

  final BetaFeedbackReport? _draft;

  @override
  Future<void> saveDraft(BetaFeedbackReport draft) async {}

  @override
  Future<BetaFeedbackReport?> getDraft({
    required String appId,
    required String userId,
    required String campaignId,
  }) async {
    return _draft;
  }

  @override
  Future<void> deleteDraft({
    required String appId,
    required String userId,
    required String campaignId,
  }) async {}

  @override
  Future<void> submitReport(BetaFeedbackReport report) async {}

  @override
  Future<BetaFeedbackReport?> getSubmittedReport({
    required String userId,
    required String campaignId,
  }) async {
    return null;
  }

  @override
  String buildReportKey({
    required String userId,
    required String campaignId,
  }) {
    return '${campaignId}_$userId';
  }
}

class _FakeSubmitFailureRepository implements BetaFeedbackRepository {
  int submitCalls = 0;
  int deleteDraftCalls = 0;

  @override
  Future<void> saveDraft(BetaFeedbackReport draft) async {}

  @override
  Future<BetaFeedbackReport?> getDraft({
    required String appId,
    required String userId,
    required String campaignId,
  }) async {
    return null;
  }

  @override
  Future<void> deleteDraft({
    required String appId,
    required String userId,
    required String campaignId,
  }) async {
    deleteDraftCalls++;
  }

  @override
  Future<void> submitReport(BetaFeedbackReport report) async {
    submitCalls++;
    throw StateError('submit failed');
  }

  @override
  Future<BetaFeedbackReport?> getSubmittedReport({
    required String userId,
    required String campaignId,
  }) async {
    return null;
  }

  @override
  String buildReportKey({
    required String userId,
    required String campaignId,
  }) {
    return '${campaignId}_$userId';
  }
}
