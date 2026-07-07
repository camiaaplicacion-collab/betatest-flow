import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../../domain/repositories/sdk_configurations/sdk_configuration_repository.dart';

class ArchiveSDKConfigurationController {
  ArchiveSDKConfigurationController({
    required SDKConfigurationRepository sdkConfigurationRepository,
  }) : _sdkConfigurationRepository = sdkConfigurationRepository;

  final SDKConfigurationRepository _sdkConfigurationRepository;

  Future<SDKConfigurationModel?> loadSDKConfiguration(String sdkId) {
    final normalizedId = sdkId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El sdkId es obligatorio.');
    }

    return _sdkConfigurationRepository.getSDKConfigurationById(normalizedId);
  }

  Future<SDKConfigurationModel> archiveSDKConfiguration({
    required String sdkId,
  }) {
    final normalizedId = sdkId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El sdkId es obligatorio.');
    }

    return _sdkConfigurationRepository.archiveSDKConfiguration(sdkId: normalizedId);
  }
}
