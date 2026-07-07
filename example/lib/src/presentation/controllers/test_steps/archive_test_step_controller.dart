import '../../../domain/models/test_steps/test_step_model.dart';
import '../../../domain/repositories/test_steps/test_step_repository.dart';

class ArchiveTestStepController {
  ArchiveTestStepController({
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

  Future<TestStepModel> archiveTestStep({
    required String testStepId,
  }) {
    final normalizedId = testStepId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El testStepId es obligatorio.');
    }

    return _testStepRepository.archiveTestStep(testStepId: normalizedId);
  }
}
