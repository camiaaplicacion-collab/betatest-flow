import '../../../domain/models/goals/goal_model.dart';
import '../../../domain/repositories/goals/goal_repository.dart';

class EditGoalController {
  EditGoalController({
    required GoalRepository goalRepository,
  }) : _goalRepository = goalRepository;

  final GoalRepository _goalRepository;

  Future<GoalModel?> loadGoal(String goalId) {
    final normalizedId = goalId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El goalId es obligatorio.');
    }

    return _goalRepository.getGoalById(normalizedId);
  }

  Future<GoalModel> updateGoal({
    required String goalId,
    required String title,
    String? description,
  }) {
    final normalizedId = goalId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El goalId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El titulo del Goal es obligatorio.');
    }

    return _goalRepository.updateGoal(
      goalId: normalizedId,
      title: normalizedTitle,
      description: normalizedDescription,
    );
  }
}
