import '../../../domain/models/betas/beta_model.dart';
import '../../../domain/repositories/betas/beta_repository.dart';

class BetaGeneralSettingsController {
  BetaGeneralSettingsController({
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

  Future<BetaModel> updateBetaGeneralSettings({
    required String betaId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = betaId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El betaId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _betaRepository.updateBetaGeneralSettings(
      betaId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
