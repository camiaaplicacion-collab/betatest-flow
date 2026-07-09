class BetaConfidenceScore {
  const BetaConfidenceScore({
    required this.overallScore,
    required this.label,
    required this.stabilityScore,
    required this.usabilityScore,
    required this.releaseReadinessScore,
    this.penalties = const <String>[],
    this.strengths = const <String>[],
  });

  final int overallScore;
  final String label;
  final int stabilityScore;
  final int usabilityScore;
  final int releaseReadinessScore;
  final List<String> penalties;
  final List<String> strengths;
}
