import '../../models/sdk_configurations/sdk_configuration_model.dart';

abstract class SDKConfigurationRepository {
  Future<SDKConfigurationModel> createSDKConfiguration({
    required String betaId,
    required String name,
    String? description,
  });

  Future<SDKConfigurationModel?> getSDKConfigurationById(String sdkId);

  Future<SDKConfigurationModel> updateSDKConfiguration({
    required String sdkId,
    required String name,
    String? description,
  });

  Future<SDKConfigurationModel> archiveSDKConfiguration({
    required String sdkId,
  });

  Future<SDKConfigurationModel> updateSDKConfigurationGeneralSettings({
    required String sdkId,
    String? description,
    required int primaryColor,
  });
}
