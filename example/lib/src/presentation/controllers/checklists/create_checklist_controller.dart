import '../../../domain/models/checklists/checklist_model.dart';
import '../../../domain/repositories/checklists/checklist_repository.dart';
import '../../../domain/repositories/goals/goal_repository.dart';

class CreateChecklistController {
  CreateChecklistController({
    required ChecklistRepository checklistRepository,
    required GoalRepository goalRepository,
  })  : _checklistRepository = checklistRepository,
        _goalRepository = goalRepository;

  final ChecklistRepository _checklistRepository;
  final GoalRepository _goalRepository;

  Future<ChecklistModel> createChecklist({
    required String goalId,
    required String title,
    String? description,
  }) async {
    final normalizedGoalId = goalId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedGoalId.isEmpty) {
      throw ArgumentError('El goalId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El titulo de la Lista de pruebas es obligatorio.');
    }

    final goal = await _goalRepository.getGoalById(normalizedGoalId);
    if (goal == null) {
      throw StateError('No existe un Goal con ese goalId.');
    }

    return _checklistRepository.createChecklist(
      goalId: normalizedGoalId,
      title: normalizedTitle,
      description: normalizedDescription,
    );
  }
}