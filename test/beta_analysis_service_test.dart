import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:betatest_flow/src/domain/services/beta_analysis_service.dart';

void main() {
  group('BetaAnalysisService', () {
    test('computes required distributions from simple normalized reports', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'alta',
          'result': 'no_funciono',
          'screenName': 'HomeScreen',
          'reproducibility': 'Si',
          'usageImpact': 'Afecta mucho',
          'publishRecommendation': 'No todavia',
          'interfaceEvaluation': 'Confusa',
          'colorEvaluation': 'Mejorables',
          'usabilityEvaluation': 'Dificil',
        },
        <String, dynamic>{
          'severity': 'media',
          'result': 'funciono_a_medias',
          'screenName': 'HomeScreen',
          'reproducibility': 'A veces',
          'usageImpact': 'Afecta un poco',
          'publishRecommendation': 'Si, con ajustes menores',
          'interfaceEvaluation': 'Clara',
          'colorEvaluation': 'Correctos',
          'usabilityEvaluation': 'Facil',
        },
        <String, dynamic>{
          'severity': 'baja',
          'result': 'funciono',
          'screenName': 'AuthScreen',
          'reproducibility': 'Si',
          'usageImpact': 'No afecta',
          'publishRecommendation': 'Si',
          'interfaceEvaluation': 'Muy clara',
          'colorEvaluation': 'Buenos',
          'usabilityEvaluation': 'Muy facil',
        },
      ];

      final result = service.analyze(reports);

      expect(result.totalReports, 3);
      expect(result.releaseDecision.status, 'GO_WITH_CONDITIONS');
      expect(result.confidenceScore.overallScore, 65);
      expect(result.confidenceScore.label, 'Confianza media');
      expect(result.metricsSnapshot.severityDistribution.counts, <String, int>{
        'alta': 1,
        'media': 1,
        'baja': 1,
      });
      expect(result.actionPlan, isNotEmpty);
      expect(result.actionPlan.first.priority, 1);
      expect(result.actionPlan.first.title, contains('severidad alta'));
      expect(result.metricsSnapshot.resultDistribution.counts, <String, int>{
        'no_funciono': 1,
        'funciono_a_medias': 1,
        'funciono': 1,
      });
      expect(result.metricsSnapshot.screenNameDistribution.counts, <String, int>{
        'HomeScreen': 2,
        'AuthScreen': 1,
      });
      expect(
        result.metricsSnapshot.reproducibilityDistribution.counts,
        <String, int>{'Si': 2, 'A veces': 1},
      );
      expect(result.metricsSnapshot.usageImpactDistribution.counts, <String, int>{
        'Afecta mucho': 1,
        'Afecta un poco': 1,
        'No afecta': 1,
      });
      expect(
        result.metricsSnapshot.publishRecommendationDistribution.counts,
        <String, int>{
          'No todavia': 1,
          'Si, con ajustes menores': 1,
          'Si': 1,
        },
      );
      expect(
        result.metricsSnapshot.interfaceEvaluationDistribution.counts,
        <String, int>{'Confusa': 1, 'Clara': 1, 'Muy clara': 1},
      );
      expect(result.metricsSnapshot.colorEvaluationDistribution.counts, <String, int>{
        'Mejorables': 1,
        'Correctos': 1,
        'Buenos': 1,
      });
      expect(result.metricsSnapshot.usabilityEvaluationDistribution.counts, <String, int>{
        'Dificil': 1,
        'Facil': 1,
        'Muy facil': 1,
      });
    });

    test('loads fixture demo and computes expected key distributions', () {
      const service = BetaAnalysisService();
      final file = File('example/data/sample_beta_reports.json');
      final decoded = jsonDecode(file.readAsStringSync()) as List<dynamic>;
      final reports = decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false);

      final result = service.analyze(reports);

      expect(result.totalReports, 3);
      expect(result.releaseDecision.status, 'GO_WITH_CONDITIONS');
      expect(result.confidenceScore.overallScore, 65);
      expect(result.actionPlan, isNotEmpty);
      expect(result.metricsSnapshot.severityDistribution.counts['alta'], 1);
      expect(result.metricsSnapshot.resultDistribution.counts['no_funciono'], 1);
      expect(result.metricsSnapshot.screenNameDistribution.counts['PublishAlertScreen'], 1);
      expect(result.metricsSnapshot.reproducibilityDistribution.counts['Si'], 2);
      expect(result.metricsSnapshot.publishRecommendationDistribution.counts['Si'], 1);
    });

    test('ignores null and blank values in distributions', () {
      const service = BetaAnalysisService();
      final reports = <Map<String, dynamic>>[
        <String, dynamic>{'severity': '  ', 'result': null, 'screenName': ''},
        <String, dynamic>{'severity': 'alta', 'result': 'no_funciono', 'screenName': 'Home'},
      ];

      final result = service.analyze(reports);

      expect(result.totalReports, 2);
      expect(result.releaseDecision.status, 'GO_WITH_CONDITIONS');
      expect(result.confidenceScore.overallScore, 85);
      expect(result.actionPlan, isNotEmpty);
      expect(result.metricsSnapshot.severityDistribution.counts, <String, int>{'alta': 1});
      expect(result.metricsSnapshot.resultDistribution.counts, <String, int>{'no_funciono': 1});
      expect(result.metricsSnapshot.screenNameDistribution.counts, <String, int>{'Home': 1});
    });

    test('returns NO_GO when critical severity is present', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'critica',
          'publishRecommendation': 'Si',
          'usageImpact': 'No afecta',
        },
      ];

      final result = service.analyze(reports);

      expect(result.releaseDecision.status, 'NO_GO');
      expect(result.releaseDecision.title, 'NO-GO');
      expect(result.releaseDecision.blockingReasons, isNotEmpty);
      expect(result.confidenceScore.overallScore, 70);
    });

    test('returns NO_GO when publish recommendation is No', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'media',
          'publishRecommendation': 'No',
          'usageImpact': 'Afecta un poco',
        },
      ];

      final result = service.analyze(reports);

      expect(result.releaseDecision.status, 'NO_GO');
      expect(result.releaseDecision.title, 'NO-GO');
      expect(result.confidenceScore.overallScore, 80);
    });

    test('returns GO when there are no relevant blockers', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'media',
          'publishRecommendation': 'Si',
          'usageImpact': 'No afecta',
        },
        <String, dynamic>{
          'severity': 'baja',
          'publishRecommendation': 'Si',
          'usageImpact': 'Afecta un poco',
        },
      ];

      final result = service.analyze(reports);

      expect(result.releaseDecision.status, 'GO');
      expect(result.releaseDecision.title, 'GO');
      expect(result.releaseDecision.blockingReasons, isEmpty);
      expect(result.releaseDecision.conditionsToGoLive, isEmpty);
      expect(result.confidenceScore.overallScore, 100);
      expect(result.confidenceScore.label, 'Alta confianza');
      expect(result.confidenceScore.penalties, isEmpty);
      expect(result.confidenceScore.strengths, isNotEmpty);
      expect(result.actionPlan, isNotEmpty);
    });

    test('confidence score clamps at 0 with heavy penalties', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'critica',
          'usageImpact': 'Afecta mucho',
          'publishRecommendation': 'No',
          'result': 'no_funciono',
        },
        <String, dynamic>{
          'severity': 'critica',
          'usageImpact': 'Me haria dejar de usarla',
          'publishRecommendation': 'No',
          'result': 'no_funciono',
        },
        <String, dynamic>{
          'severity': 'alta',
          'usageImpact': 'Afecta mucho',
          'publishRecommendation': 'No todavia',
          'result': 'no_funciono',
        },
      ];

      final result = service.analyze(reports);

      expect(result.confidenceScore.overallScore, 0);
      expect(result.confidenceScore.label, 'Baja confianza');
      expect(result.confidenceScore.penalties, isNotEmpty);
    });

    test('confidence score reports strengths for positive majority', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'baja',
          'result': 'funciono',
          'publishRecommendation': 'Si',
          'usageImpact': 'No afecta',
        },
        <String, dynamic>{
          'severity': 'media',
          'result': 'funciono_bien',
          'publishRecommendation': 'Si',
          'usageImpact': 'Afecta un poco',
        },
        <String, dynamic>{
          'severity': 'media',
          'result': 'funciono_a_medias',
          'publishRecommendation': 'Si, con ajustes menores',
          'usageImpact': 'Afecta un poco',
        },
      ];

      final result = service.analyze(reports);

      expect(result.confidenceScore.overallScore, 100);
      expect(result.confidenceScore.strengths, isNotEmpty);
      expect(
        result.confidenceScore.strengths.first,
        contains('Mayoria de resultados positivos'),
      );
    });
    test('builds prioritized action plan from critical/high/impact/screen/ux signals', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'critica',
          'result': 'no_funciono',
          'screenName': 'PublishAlertScreen',
          'usageImpact': 'Afecta mucho',
          'publishRecommendation': 'No',
          'uxDetails': 'No queda claro si el envio sigue en progreso.',
        },
        <String, dynamic>{
          'severity': 'alta',
          'result': 'funciono_a_medias',
          'screenName': 'PublishAlertScreen',
          'usageImpact': 'Me haria dejar de usarla',
          'publishRecommendation': 'No todavia',
          'uxDetails': '',
        },
      ];

      final result = service.analyze(reports);

      expect(result.actionPlan.length, greaterThanOrEqualTo(6));
      expect(result.actionPlan.first.priority, 1);
      expect(result.actionPlan.first.title, 'Contener severidad critica');

      final titles = result.actionPlan.map((item) => item.title).toList(growable: false);
      expect(titles, contains('Reducir severidad alta en flujo principal'));
      expect(titles, contains('Estabilizar pantalla mas reportada'));
      expect(titles, contains('Mitigar impacto fuerte de uso'));
      expect(titles, contains('Cerrar brechas para decision de publicacion'));
      expect(titles, contains('Atender observacion UX destacada'));
    });

    test('builds fallback action plan when no risk signals are present', () {
      const service = BetaAnalysisService();

      final reports = <Map<String, dynamic>>[
        <String, dynamic>{
          'severity': 'baja',
          'result': 'funciono',
          'screenName': '',
          'usageImpact': 'No afecta',
          'publishRecommendation': 'Si',
          'uxDetails': '',
        },
      ];

      final result = service.analyze(reports);

      expect(result.actionPlan.length, 1);
      expect(result.actionPlan.first.priority, 1);
      expect(result.actionPlan.first.title, 'Mantener estabilidad y monitoreo');
    });
  });
}
