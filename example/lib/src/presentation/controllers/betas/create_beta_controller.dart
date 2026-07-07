import '../../../domain/models/betas/beta_model.dart';
import '../../../domain/repositories/apps/app_repository.dart';
import '../../../domain/repositories/betas/beta_repository.dart';

class CreateBetaController {
  CreateBetaController({
    required BetaRepository betaRepository,
    required AppRepository appRepository,
  })  : _betaRepository = betaRepository,
        _appRepository = appRepository;

  final BetaRepository _betaRepository;
  final AppRepository _appRepository;

  Future<BetaModel> createBeta({
    required String appId,
    required String name,
    String? description,
  }) async {
    final normalizedAppId = appId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedAppId.isEmpty) {
      throw ArgumentError('El appId es obligatorio.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('El nombre de la Beta es obligatorio.');
    }

    final app = await _appRepository.getAppById(normalizedAppId);
    if (app == null) {
      throw StateError('No existe una App con ese appId.');
    }

    return _betaRepository.createBeta(
      appId: normalizedAppId,
      name: normalizedName,
      description: normalizedDescription,
    );
  }
}
