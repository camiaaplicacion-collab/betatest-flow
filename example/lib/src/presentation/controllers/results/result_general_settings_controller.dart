import '../../../domain/models/results/result_model.dart';
import '../../../domain/repositories/results/result_repository.dart';

class ResultGeneralSettingsController {
  ResultGeneralSettingsController({
    required ResultRepository resultRepository,
  }) : _resultRepository = resultRepository;

  final ResultRepository _resultRepository;

  Future<ResultModel?> loadResult(String resultId) {
    final normalizedId = resultId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El resultId es obligatorio.');
    }

    return _resultRepository.getResultById(normalizedId);
  }

  Future<ResultModel> updateResultGeneralSettings({
    required String resultId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = resultId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El resultId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _resultRepository.updateResultGeneralSettings(
      resultId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
