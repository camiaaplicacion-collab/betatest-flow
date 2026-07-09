class BetaReleaseDecision {
  const BetaReleaseDecision({
    required this.status,
    required this.title,
    required this.rationale,
    this.blockingReasons = const <String>[],
    this.conditionsToGoLive = const <String>[],
  });

  final String status;
  final String title;
  final String rationale;
  final List<String> blockingReasons;
  final List<String> conditionsToGoLive;
}
