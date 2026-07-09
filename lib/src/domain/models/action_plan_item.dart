class ActionPlanItem {
  const ActionPlanItem({
    required this.priority,
    required this.title,
    required this.rationale,
    required this.suggestedAction,
    required this.validation,
  });

  final int priority;
  final String title;
  final String rationale;
  final String suggestedAction;
  final String validation;
}
