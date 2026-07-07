import '../../../domain/models/goals/goal_model.dart';
import '../../../domain/repositories/goals/goal_repository.dart';

class GoalInformationController {
  GoalInformationController({
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
}
