import 'distribution_metric.dart';

class BetaMetricsSnapshot {
  const BetaMetricsSnapshot({
    required this.severityDistribution,
    required this.resultDistribution,
    required this.screenNameDistribution,
    required this.reproducibilityDistribution,
    required this.usageImpactDistribution,
    required this.publishRecommendationDistribution,
    required this.interfaceEvaluationDistribution,
    required this.colorEvaluationDistribution,
    required this.usabilityEvaluationDistribution,
  });

  final DistributionMetric severityDistribution;
  final DistributionMetric resultDistribution;
  final DistributionMetric screenNameDistribution;
  final DistributionMetric reproducibilityDistribution;
  final DistributionMetric usageImpactDistribution;
  final DistributionMetric publishRecommendationDistribution;
  final DistributionMetric interfaceEvaluationDistribution;
  final DistributionMetric colorEvaluationDistribution;
  final DistributionMetric usabilityEvaluationDistribution;
}
