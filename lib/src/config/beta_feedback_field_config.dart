class BetaFeedbackFieldConfig {
  const BetaFeedbackFieldConfig({
    this.showScreenName = false,
    this.showReproducibility = false,
    this.showUsageImpact = false,
    this.showPublishRecommendation = false,
    this.showUxDetails = false,
    this.showInterfaceEvaluation = false,
    this.showColorEvaluation = false,
    this.showUsabilityEvaluation = false,
  });

  final bool showScreenName;
  final bool showReproducibility;
  final bool showUsageImpact;
  final bool showPublishRecommendation;
  final bool showUxDetails;
  final bool showInterfaceEvaluation;
  final bool showColorEvaluation;
  final bool showUsabilityEvaluation;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'showScreenName': showScreenName,
      'showReproducibility': showReproducibility,
      'showUsageImpact': showUsageImpact,
      'showPublishRecommendation': showPublishRecommendation,
      'showUxDetails': showUxDetails,
      'showInterfaceEvaluation': showInterfaceEvaluation,
      'showColorEvaluation': showColorEvaluation,
      'showUsabilityEvaluation': showUsabilityEvaluation,
    };
  }

  factory BetaFeedbackFieldConfig.fromMap(Map<String, dynamic> map) {
    return BetaFeedbackFieldConfig(
      showScreenName: map['showScreenName'] as bool? ?? false,
      showReproducibility: map['showReproducibility'] as bool? ?? false,
      showUsageImpact: map['showUsageImpact'] as bool? ?? false,
      showPublishRecommendation: map['showPublishRecommendation'] as bool? ?? false,
      showUxDetails: map['showUxDetails'] as bool? ?? false,
      showInterfaceEvaluation: map['showInterfaceEvaluation'] as bool? ?? false,
      showColorEvaluation: map['showColorEvaluation'] as bool? ?? false,
      showUsabilityEvaluation: map['showUsabilityEvaluation'] as bool? ?? false,
    );
  }
}
