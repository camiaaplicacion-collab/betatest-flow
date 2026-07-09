class DistributionMetric {
  const DistributionMetric({
    required this.field,
    required this.counts,
  });

  final String field;
  final Map<String, int> counts;
}
