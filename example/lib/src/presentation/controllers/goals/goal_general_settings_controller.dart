import '../../../domain/models/goals/goal_model.dart';
import '../../../domain/repositories/goals/goal_repository.dart';

class GoalGeneralSettingsController {
  GoalGeneralSettingsController({
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

  Future<GoalModel> updateGoalGeneralSettings({
    required String goalId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = goalId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El goalId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _goalRepository.updateGoalGeneralSettings(
      goalId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
