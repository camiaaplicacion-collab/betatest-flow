import '../../../domain/models/results/result_model.dart';
import '../../../domain/repositories/results/result_repository.dart';
import '../../../domain/repositories/sdk_configurations/sdk_configuration_repository.dart';
import '../../../domain/repositories/testers/tester_repository.dart';

class CreateResultController {
  CreateResultController({
    required ResultRepository resultRepository,
    required SDKConfigurationRepository sdkConfigurationRepository,
    required TesterRepository testerRepository,
  })  : _resultRepository = resultRepository,
        _sdkConfigurationRepository = sdkConfigurationRepository,
        _testerRepository = testerRepository;

  final ResultRepository _resultRepository;
  final SDKConfigurationRepository _sdkConfigurationRepository;
  final TesterRepository _testerRepository;

  Future<ResultModel> createResult({
    required String sdkId,
    required String testerId,
    String? summary,
  }) async {
    final normalizedSdkId = sdkId.trim();
    final normalizedTesterId = testerId.trim();
    final normalizedSummary = summary?.trim();

    if (normalizedSdkId.isEmpty) {
      throw ArgumentError('El sdkId es obligatorio.');
    }
    if (normalizedTesterId.isEmpty) {
      throw ArgumentError('El testerId es obligatorio.');
    }

    final sdkConfiguration =
        await _sdkConfigurationRepository.getSDKConfigurationById(normalizedSdkId);
    if (sdkConfiguration == null) {
      throw StateError('No existe una Configuracion SDK con ese sdkId.');
    }

    final tester = await _testerRepository.getTesterById(normalizedTesterId);
    if (tester == null) {
      throw StateError('No existe un Tester con ese testerId.');
    }

    return _resultRepository.createResult(
      sdkId: normalizedSdkId,
      testerId: normalizedTesterId,
      summary: normalizedSummary,
    );
  }
}
