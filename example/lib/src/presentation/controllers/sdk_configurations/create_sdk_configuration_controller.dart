import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../../domain/repositories/betas/beta_repository.dart';
import '../../../domain/repositories/sdk_configurations/sdk_configuration_repository.dart';

class CreateSDKConfigurationController {
  CreateSDKConfigurationController({
    required SDKConfigurationRepository sdkConfigurationRepository,
    required BetaRepository betaRepository,
  })  : _sdkConfigurationRepository = sdkConfigurationRepository,
        _betaRepository = betaRepository;

  final SDKConfigurationRepository _sdkConfigurationRepository;
  final BetaRepository _betaRepository;

  Future<SDKConfigurationModel> createSDKConfiguration({
    required String betaId,
    required String name,
    String? description,
  }) async {
    final normalizedBetaId = betaId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedBetaId.isEmpty) {
      throw ArgumentError('El betaId es obligatorio.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('El name es obligatorio.');
    }

    final beta = await _betaRepository.getBetaById(normalizedBetaId);
    if (beta == null) {
      throw StateError('No existe una Beta con ese betaId.');
    }

    return _sdkConfigurationRepository.createSDKConfiguration(
      betaId: normalizedBetaId,
      name: normalizedName,
      description: normalizedDescription,
    );
  }
}
