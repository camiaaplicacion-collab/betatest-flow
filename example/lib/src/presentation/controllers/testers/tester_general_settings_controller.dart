import '../../../domain/models/testers/tester_model.dart';
import '../../../domain/repositories/testers/tester_repository.dart';

class TesterGeneralSettingsController {
  TesterGeneralSettingsController({
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

  Future<TesterModel> updateTesterGeneralSettings({
    required String testerId,
    required String email,
    required int primaryColor,
  }) {
    final normalizedId = testerId.trim();
    final normalizedEmail = email.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El testerId es obligatorio.');
    }
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('El email es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    return _testerRepository.updateTesterGeneralSettings(
      testerId: normalizedId,
      email: normalizedEmail,
      primaryColor: primaryColor,
    );
  }
}
