import '../models/beta_analysis_result.dart';
import '../models/action_plan_item.dart';
import '../models/beta_confidence_score.dart';
import '../models/beta_metrics_snapshot.dart';
import '../models/beta_release_decision.dart';
import '../models/distribution_metric.dart';

class BetaAnalysisService {
  const BetaAnalysisService();

  BetaAnalysisResult analyze(List<Map<String, dynamic>> reports) {
    final metricsSnapshot = BetaMetricsSnapshot(
      severityDistribution: _distributionFor(reports, 'severity'),
      resultDistribution: _distributionFor(reports, 'result'),
      screenNameDistribution: _distributionFor(reports, 'screenName'),
      reproducibilityDistribution: _distributionFor(reports, 'reproducibility'),
      usageImpactDistribution: _distributionFor(reports, 'usageImpact'),
      publishRecommendationDistribution: _distributionFor(
        reports,
        'publishRecommendation',
      ),
      interfaceEvaluationDistribution: _distributionFor(
        reports,
        'interfaceEvaluation',
      ),
      colorEvaluationDistribution: _distributionFor(reports, 'colorEvaluation'),
      usabilityEvaluationDistribution: _distributionFor(
        reports,
        'usabilityEvaluation',
      ),
    );

    return BetaAnalysisResult(
      totalReports: reports.length,
      metricsSnapshot: metricsSnapshot,
      releaseDecision: _buildReleaseDecision(reports),
      confidenceScore: _buildConfidenceScore(metricsSnapshot),
      actionPlan: _buildActionPlan(reports, metricsSnapshot),
    );
  }

  List<ActionPlanItem> _buildActionPlan(
    List<Map<String, dynamic>> reports,
    BetaMetricsSnapshot snapshot,
  ) {
    final plan = <ActionPlanItem>[];
    var nextPriority = 1;

    void addItem({
      required String title,
      required String rationale,
      required String suggestedAction,
      required String validation,
    }) {
      plan.add(
        ActionPlanItem(
          priority: nextPriority,
          title: title,
          rationale: rationale,
          suggestedAction: suggestedAction,
          validation: validation,
        ),
      );
      nextPriority += 1;
    }

    final criticalCount = snapshot.severityDistribution.counts['critica'] ?? 0;
    if (criticalCount > 0) {
      addItem(
        title: 'Contener severidad critica',
        rationale:
            'Se detectaron $criticalCount reportes criticos con riesgo de bloqueo de release.',
        suggestedAction:
            'Corregir primero fallos criticos y preparar hotfix en ramas de alta prioridad.',
        validation:
            'Reproducir cada caso critico y confirmar estado resuelto en una corrida beta corta.',
      );
    }

    final highCount = snapshot.severityDistribution.counts['alta'] ?? 0;
    if (highCount > 0) {
      addItem(
        title: 'Reducir severidad alta en flujo principal',
        rationale:
            'Hay $highCount reportes de severidad alta que afectan estabilidad funcional.',
        suggestedAction:
            'Priorizar fixes en rutas de uso frecuentes y reforzar manejo de error/reintento.',
        validation:
            'Ejecutar smoke suite de flujos principales y verificar ausencia de regresiones.',
      );
    }

    final topScreen = _topEntry(snapshot.screenNameDistribution.counts);
    if (topScreen != null) {
      addItem(
        title: 'Estabilizar pantalla mas reportada',
        rationale:
            'La pantalla ${topScreen.key} concentra ${topScreen.value} reportes y merece foco temprano.',
        suggestedAction:
            'Auditar eventos, estados y errores en ${topScreen.key} para reducir friccion.',
        validation:
            'Correr pruebas manuales guiadas en ${topScreen.key} con al menos 3 escenarios reales.',
      );
    }

    final strongImpactCount =
        (snapshot.usageImpactDistribution.counts['Afecta mucho'] ?? 0) +
        (snapshot.usageImpactDistribution.counts['Me haria dejar de usarla'] ?? 0);
    if (strongImpactCount > 0) {
      addItem(
        title: 'Mitigar impacto fuerte de uso',
        rationale:
            '$strongImpactCount reportes indican impacto alto en continuidad de uso.',
        suggestedAction:
            'Resolver bloqueos UX/flujo y mejorar feedback visual en operaciones de alto riesgo.',
        validation:
            'Comparar antes/despues con testers beta y confirmar mejora percibida del flujo.',
      );
    }

    final publishNoCount = snapshot.publishRecommendationDistribution.counts['No'] ?? 0;
    final publishNotYetCount =
        snapshot.publishRecommendationDistribution.counts['No todavia'] ?? 0;
    if (publishNoCount > 0 || publishNotYetCount > 0) {
      addItem(
        title: 'Cerrar brechas para decision de publicacion',
        rationale:
            'Hay señales de freno de release (No: $publishNoCount, No todavia: $publishNotYetCount).',
        suggestedAction:
            'Convertir recomendaciones de no-publicacion en checklist de fixes con responsables y ETA.',
        validation:
            'Repetir export beta y verificar descenso de recomendaciones negativas.',
      );
    }

    final uxObservation = _firstNonEmptyValue(reports, 'uxDetails');
    if (uxObservation != null) {
      addItem(
        title: 'Atender observacion UX destacada',
        rationale: uxObservation,
        suggestedAction:
            'Aplicar ajuste UX puntual y documentar criterio de diseno para consistencia futura.',
        validation:
            'Validar con test cualitativo rapido que la mejora UX sea entendible para usuarios.',
      );
    }

    if (plan.isEmpty) {
      addItem(
        title: 'Mantener estabilidad y monitoreo',
        rationale: 'No se detectaron riesgos significativos en los indicadores clave.',
        suggestedAction:
            'Ejecutar regresion corta y mantener monitoreo activo en primeros dias post-release.',
        validation:
            'Confirmar que no aparezcan nuevos reportes de alta severidad tras la publicacion.',
      );
    }

    return plan;
  }

  MapEntry<String, int>? _topEntry(Map<String, int> counts) {
    if (counts.isEmpty) {
      return null;
    }

    final sorted = counts.entries.toList(growable: false)
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first;
  }

  String? _firstNonEmptyValue(
    List<Map<String, dynamic>> reports,
    String field,
  ) {
    for (final report in reports) {
      final value = report[field]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  BetaConfidenceScore _buildConfidenceScore(BetaMetricsSnapshot snapshot) {
    final penalties = <String>[];
    final strengths = <String>[];

    final criticalCount = snapshot.severityDistribution.counts['critica'] ?? 0;
    final highCount = snapshot.severityDistribution.counts['alta'] ?? 0;
    final strongImpactCount =
        (snapshot.usageImpactDistribution.counts['Afecta mucho'] ?? 0) +
        (snapshot.usageImpactDistribution.counts['Me haria dejar de usarla'] ?? 0);
    final publishNoCount =
        (snapshot.publishRecommendationDistribution.counts['No'] ?? 0);
    final publishNotYetCount =
        (snapshot.publishRecommendationDistribution.counts['No todavia'] ?? 0);

    var overallScore = 100;
    overallScore -= criticalCount * 30;
    overallScore -= highCount * 15;
    overallScore -= strongImpactCount * 10;
    overallScore -= publishNoCount * 20;
    overallScore -= publishNotYetCount * 10;

    if (criticalCount > 0) {
      penalties.add('Severidad critica: -${criticalCount * 30}');
    }
    if (highCount > 0) {
      penalties.add('Severidad alta: -${highCount * 15}');
    }
    if (strongImpactCount > 0) {
      penalties.add('Impacto fuerte en uso: -${strongImpactCount * 10}');
    }
    if (publishNoCount > 0) {
      penalties.add('Recomendacion de no publicar: -${publishNoCount * 20}');
    }
    if (publishNotYetCount > 0) {
      penalties.add('Recomendacion de no publicar todavia: -${publishNotYetCount * 10}');
    }

    final positiveResults =
        (snapshot.resultDistribution.counts['funciono'] ?? 0) +
        (snapshot.resultDistribution.counts['funciono_bien'] ?? 0);
    final totalResults = snapshot.resultDistribution.counts.values
        .fold<int>(0, (sum, value) => sum + value);

    if (totalResults > 0 && positiveResults > totalResults / 2) {
      strengths.add('Mayoria de resultados positivos en pruebas beta.');
    }
    if (criticalCount == 0) {
      strengths.add('Sin reportes de severidad critica.');
    }

    final stabilityScore =
        _clampScore(100 - (criticalCount * 35) - (highCount * 20));
    final usabilityScore =
        _clampScore(100 - (strongImpactCount * 20) - (publishNoCount * 15));
    final releaseReadinessScore = _clampScore(
      100 -
          (criticalCount * 30) -
          (highCount * 10) -
          (publishNoCount * 20) -
          (publishNotYetCount * 12),
    );

    overallScore = _clampScore(overallScore);

    return BetaConfidenceScore(
      overallScore: overallScore,
      label: _scoreLabel(overallScore),
      stabilityScore: stabilityScore,
      usabilityScore: usabilityScore,
      releaseReadinessScore: releaseReadinessScore,
      penalties: penalties,
      strengths: strengths,
    );
  }

  int _clampScore(int score) {
    if (score < 0) {
      return 0;
    }
    if (score > 100) {
      return 100;
    }
    return score;
  }

  String _scoreLabel(int score) {
    if (score >= 80) {
      return 'Alta confianza';
    }
    if (score >= 60) {
      return 'Confianza media';
    }
    return 'Baja confianza';
  }

  BetaReleaseDecision _buildReleaseDecision(List<Map<String, dynamic>> reports) {
    final hasCriticalSeverity = _hasValue(reports, 'severity', 'critica');
    final hasPublishNo = _hasValue(reports, 'publishRecommendation', 'No');

    if (hasCriticalSeverity || hasPublishNo) {
      return const BetaReleaseDecision(
        status: 'NO_GO',
        title: 'NO-GO',
        rationale: 'Se detectaron bloqueadores de release que requieren correccion previa.',
        blockingReasons: <String>[
          'Hay reportes con severidad critica o recomendacion explicita de no publicar.',
        ],
      );
    }

    final hasHighSeverity = _hasValue(reports, 'severity', 'alta');
    final hasStrongImpact =
        _hasValue(reports, 'usageImpact', 'Afecta mucho') ||
        _hasValue(reports, 'usageImpact', 'Me haria dejar de usarla');
    final hasPublishNotYet = _hasValue(
      reports,
      'publishRecommendation',
      'No todavia',
    );

    if (hasHighSeverity || hasStrongImpact || hasPublishNotYet) {
      return const BetaReleaseDecision(
        status: 'GO_WITH_CONDITIONS',
        title: 'GO CON CONDICIONES',
        rationale:
            'Existen riesgos relevantes; se puede avanzar solo con mitigaciones y validacion adicional.',
        conditionsToGoLive: <String>[
          'Corregir incidencias de severidad alta o impacto fuerte.',
          'Revalidar con una corrida beta corta antes de publicar.',
        ],
      );
    }

    return const BetaReleaseDecision(
      status: 'GO',
      title: 'GO',
      rationale: 'No se detectaron bloqueadores relevantes para publicacion.',
    );
  }

  bool _hasValue(
    List<Map<String, dynamic>> reports,
    String field,
    String expected,
  ) {
    final expectedLower = expected.trim().toLowerCase();
    for (final report in reports) {
      final value = report[field]?.toString().trim().toLowerCase() ?? '';
      if (value == expectedLower) {
        return true;
      }
    }
    return false;
  }

  DistributionMetric _distributionFor(
    List<Map<String, dynamic>> reports,
    String field,
  ) {
    final counts = <String, int>{};
    for (final report in reports) {
      final value = report[field]?.toString().trim() ?? '';
      if (value.isEmpty) {
        continue;
      }
      counts[value] = (counts[value] ?? 0) + 1;
    }

    return DistributionMetric(field: field, counts: counts);
  }
}
