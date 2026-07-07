import '../../models/goals/goal_model.dart';

abstract class GoalRepository {
  Future<GoalModel> createGoal({
    required String betaId,
    required String title,
    String? description,
  });

  Future<GoalModel?> getGoalById(String goalId);

  Future<GoalModel> updateGoal({
    required String goalId,
    required String title,
    String? description,
  });

  Future<GoalModel> updateGoalGeneralSettings({
    required String goalId,
    String? description,
    required int primaryColor,
  });

  Future<GoalModel> archiveGoal({
    required String goalId,
  });
}
