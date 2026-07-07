import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../../domain/repositories/sdk_configurations/sdk_configuration_repository.dart';

class EditSDKConfigurationController {
  EditSDKConfigurationController({
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

  Future<SDKConfigurationModel> updateSDKConfiguration({
    required String sdkId,
    required String name,
    String? description,
  }) {
    final normalizedId = sdkId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El sdkId es obligatorio.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('El name es obligatorio.');
    }

    return _sdkConfigurationRepository.updateSDKConfiguration(
      sdkId: normalizedId,
      name: normalizedName,
      description: normalizedDescription,
    );
  }
}
