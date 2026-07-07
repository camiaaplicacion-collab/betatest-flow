import '../../../domain/models/results/result_model.dart';
import '../../../domain/repositories/results/result_repository.dart';

class ArchiveResultController {
  ArchiveResultController({
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

  Future<ResultModel> archiveResult({
    required String resultId,
  }) {
    final normalizedId = resultId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El resultId es obligatorio.');
    }

    return _resultRepository.archiveResult(resultId: normalizedId);
  }
}
