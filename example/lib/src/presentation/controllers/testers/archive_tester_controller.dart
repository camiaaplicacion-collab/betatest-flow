import '../../../domain/models/testers/tester_model.dart';
import '../../../domain/repositories/testers/tester_repository.dart';

class ArchiveTesterController {
  ArchiveTesterController({
    required TesterRepository testerRepository,
  }) : _testerRepository = testerRepository;

  final TesterRepository _testerRepository;

  Future<TesterModel?> loadTester(String testerId) {
    final normalizedId = testerId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El testerId es obligatorio.');
    }

    return _testerRepository.getTesterById(normalizedId);
  }

  Future<TesterModel> archiveTester({
    required String testerId,
  }) {
    final normalizedId = testerId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El testerId es obligatorio.');
    }

    return _testerRepository.archiveTester(testerId: normalizedId);
  }
}
