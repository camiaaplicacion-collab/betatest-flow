import '../../../domain/models/testers/tester_model.dart';
import '../../../domain/repositories/testers/tester_repository.dart';

class EditTesterController {
  EditTesterController({
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

  Future<TesterModel> updateTester({
    required String testerId,
    required String displayName,
    required String email,
  }) {
    final normalizedId = testerId.trim();
    final normalizedDisplayName = displayName.trim();
    final normalizedEmail = email.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El testerId es obligatorio.');
    }
    if (normalizedDisplayName.isEmpty) {
      throw ArgumentError('El displayName es obligatorio.');
    }
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('El email es obligatorio.');
    }

    return _testerRepository.updateTester(
      testerId: normalizedId,
      displayName: normalizedDisplayName,
      email: normalizedEmail,
    );
  }
}
