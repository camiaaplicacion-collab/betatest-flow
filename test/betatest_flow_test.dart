import 'package:flutter_test/flutter_test.dart';

import 'package:betatest_flow/betatest_flow.dart';

void main() {
  test('builds config with expected defaults', () {
    const config = BetaTestFlowConfig(
      appId: 'app',
      appName: 'App',
      campaignId: 'campaign',
      campaignName: 'Campaign',
      checklistItems: <BetaChecklistItem>[],
      reportVersion: 'v1',
    );

    expect(config.firebaseCollection, 'beta_reports');
    expect(config.enableUxEvaluation, false);
  });
}
