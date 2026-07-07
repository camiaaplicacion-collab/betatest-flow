import '../../models/test_steps/test_step_model.dart';

abstract class TestStepRepository {
  Future<TestStepModel> createTestStep({
    required String checklistId,
    required String title,
    String? description,
  });

  Future<TestStepModel?> getTestStepById(String testStepId);

  Future<TestStepModel> updateTestStep({
    required String testStepId,
    required String title,
    String? description,
  });

  Future<TestStepModel> archiveTestStep({
    required String testStepId,
  });

  Future<TestStepModel> updateTestStepGeneralSettings({
    required String testStepId,
    String? description,
    required int primaryColor,
  });
}
