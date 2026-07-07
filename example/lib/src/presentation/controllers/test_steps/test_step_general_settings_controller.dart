import '../../../domain/models/test_steps/test_step_model.dart';
import '../../../domain/repositories/test_steps/test_step_repository.dart';

class TestStepGeneralSettingsController {
  TestStepGeneralSettingsController({
    required TestStepRepository testStepRepository,
  }) : _testStepRepository = testStepRepository;

  final TestStepRepository _testStepRepository;

  Future<TestStepModel?> loadTestStep(String testStepId) {
    final normalizedId = testStepId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El testStepId es obligatorio.');
    }

    return _testStepRepository.getTestStepById(normalizedId);
  }

  Future<TestStepModel> updateTestStepGeneralSettings({
    required String testStepId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = testStepId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El testStepId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _testStepRepository.updateTestStepGeneralSettings(
      testStepId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
