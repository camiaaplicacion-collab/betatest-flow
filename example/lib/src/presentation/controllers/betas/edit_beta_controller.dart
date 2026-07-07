import '../../../domain/models/betas/beta_model.dart';
import '../../../domain/repositories/betas/beta_repository.dart';

class EditBetaController {
  EditBetaController({
    required BetaRepository betaRepository,
  }) : _betaRepository = betaRepository;

  final BetaRepository _betaRepository;

  Future<BetaModel?> loadBeta(String betaId) {
    final normalizedId = betaId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El betaId es obligatorio.');
    }

    return _betaRepository.getBetaById(normalizedId);
  }

  Future<BetaModel> updateBeta({
    required String betaId,
    required String name,
    String? description,
  }) {
    final normalizedId = betaId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El betaId es obligatorio.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('El nombre de la Beta es obligatorio.');
    }

    return _betaRepository.updateBeta(
      betaId: normalizedId,
      name: normalizedName,
      description: normalizedDescription,
    );
  }
}
