import '../../../domain/models/test_steps/test_step_model.dart';
import '../../../domain/repositories/checklists/checklist_repository.dart';
import '../../../domain/repositories/test_steps/test_step_repository.dart';

class CreateTestStepController {
  CreateTestStepController({
    required TestStepRepository testStepRepository,
    required ChecklistRepository checklistRepository,
  })  : _testStepRepository = testStepRepository,
        _checklistRepository = checklistRepository;

  final TestStepRepository _testStepRepository;
  final ChecklistRepository _checklistRepository;

  Future<TestStepModel> createTestStep({
    required String checklistId,
    required String title,
    String? description,
  }) async {
    final normalizedChecklistId = checklistId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedChecklistId.isEmpty) {
      throw ArgumentError('El checklistId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El titulo del Paso de prueba es obligatorio.');
    }

    final checklist = await _checklistRepository.getChecklistById(normalizedChecklistId);
    if (checklist == null) {
      throw StateError('No existe una Lista de pruebas con ese checklistId.');
    }

    return _testStepRepository.createTestStep(
      checklistId: normalizedChecklistId,
      title: normalizedTitle,
      description: normalizedDescription,
    );
  }
}
