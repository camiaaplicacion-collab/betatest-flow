import '../../../domain/models/testers/tester_model.dart';
import '../../../domain/repositories/betas/beta_repository.dart';
import '../../../domain/repositories/testers/tester_repository.dart';

class CreateTesterController {
  CreateTesterController({
    required TesterRepository testerRepository,
    required BetaRepository betaRepository,
  })  : _testerRepository = testerRepository,
        _betaRepository = betaRepository;

  final TesterRepository _testerRepository;
  final BetaRepository _betaRepository;

  Future<TesterModel> createTester({
    required String betaId,
    required String displayName,
    required String email,
  }) async {
    final normalizedBetaId = betaId.trim();
    final normalizedDisplayName = displayName.trim();
    final normalizedEmail = email.trim();

    if (normalizedBetaId.isEmpty) {
      throw ArgumentError('El betaId es obligatorio.');
    }
    if (normalizedDisplayName.isEmpty) {
      throw ArgumentError('El displayName es obligatorio.');
    }
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('El email es obligatorio.');
    }

    final beta = await _betaRepository.getBetaById(normalizedBetaId);
    if (beta == null) {
      throw StateError('No existe una Beta con ese betaId.');
    }

    return _testerRepository.createTester(
      betaId: normalizedBetaId,
      displayName: normalizedDisplayName,
      email: normalizedEmail,
    );
  }
}
