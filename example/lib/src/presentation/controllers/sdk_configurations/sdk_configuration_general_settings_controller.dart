import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../../domain/repositories/sdk_configurations/sdk_configuration_repository.dart';

class SDKConfigurationGeneralSettingsController {
  SDKConfigurationGeneralSettingsController({
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

  Future<SDKConfigurationModel> updateSDKConfigurationGeneralSettings({
    required String sdkId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = sdkId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El sdkId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _sdkConfigurationRepository.updateSDKConfigurationGeneralSettings(
      sdkId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
