import 'beta_metrics_snapshot.dart';
import 'beta_confidence_score.dart';
import 'beta_release_decision.dart';
import 'action_plan_item.dart';

class BetaAnalysisResult {
  const BetaAnalysisResult({
    required this.totalReports,
    required this.metricsSnapshot,
    required this.releaseDecision,
    required this.confidenceScore,
    required this.actionPlan,
  });

  final int totalReports;
  final BetaMetricsSnapshot metricsSnapshot;
  final BetaReleaseDecision releaseDecision;
  final BetaConfidenceScore confidenceScore;
  final List<ActionPlanItem> actionPlan;
}
