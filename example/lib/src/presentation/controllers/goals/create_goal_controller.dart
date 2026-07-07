import '../../../domain/models/goals/goal_model.dart';
import '../../../domain/repositories/betas/beta_repository.dart';
import '../../../domain/repositories/goals/goal_repository.dart';

class CreateGoalController {
  CreateGoalController({
    required GoalRepository goalRepository,
    required BetaRepository betaRepository,
  })  : _goalRepository = goalRepository,
        _betaRepository = betaRepository;

  final GoalRepository _goalRepository;
  final BetaRepository _betaRepository;

  Future<GoalModel> createGoal({
    required String betaId,
    required String title,
    String? description,
  }) async {
    final normalizedBetaId = betaId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedBetaId.isEmpty) {
      throw ArgumentError('El betaId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El titulo del Goal es obligatorio.');
    }

    final beta = await _betaRepository.getBetaById(normalizedBetaId);
    if (beta == null) {
      throw StateError('No existe una Beta con ese betaId.');
    }

    return _goalRepository.createGoal(
      betaId: normalizedBetaId,
      title: normalizedTitle,
      description: normalizedDescription,
    );
  }
}
