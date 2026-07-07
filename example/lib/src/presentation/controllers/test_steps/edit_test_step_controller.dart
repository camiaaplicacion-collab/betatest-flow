import '../../../domain/models/test_steps/test_step_model.dart';
import '../../../domain/repositories/test_steps/test_step_repository.dart';

class EditTestStepController {
  EditTestStepController({
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

  Future<TestStepModel> updateTestStep({
    required String testStepId,
    required String title,
    String? description,
  }) {
    final normalizedId = testStepId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El testStepId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El titulo del Paso de prueba es obligatorio.');
    }

    return _testStepRepository.updateTestStep(
      testStepId: normalizedId,
      title: normalizedTitle,
      description: normalizedDescription,
    );
  }
}
