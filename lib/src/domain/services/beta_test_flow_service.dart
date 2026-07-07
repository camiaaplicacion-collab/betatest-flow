import '../../config/beta_test_flow_config.dart';

abstract class BetaTestFlowService {
  BetaTestFlowConfig get config;

  Future<void> initialize(BetaTestFlowConfig config);

  Future<void> openFeedbackEntryPoint();
}