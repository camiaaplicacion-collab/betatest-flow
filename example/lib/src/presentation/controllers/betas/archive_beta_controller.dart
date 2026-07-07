import '../../../domain/models/betas/beta_model.dart';
import '../../../domain/repositories/betas/beta_repository.dart';

class ArchiveBetaController {
  ArchiveBetaController({
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

  Future<BetaModel> archiveBeta({
    required String betaId,
  }) {
    final normalizedId = betaId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El betaId es obligatorio.');
    }

    return _betaRepository.archiveBeta(betaId: normalizedId);
  }
}
