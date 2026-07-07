import '../../models/betas/beta_model.dart';

abstract class BetaRepository {
  Future<BetaModel> createBeta({
    required String appId,
    required String name,
    String? description,
  });

  Future<BetaModel?> getBetaById(String betaId);

  Future<BetaModel> updateBeta({
    required String betaId,
    required String name,
    String? description,
  });

  Future<BetaModel> updateBetaGeneralSettings({
    required String betaId,
    String? description,
    required int primaryColor,
  });

  Future<BetaModel> archiveBeta({
    required String betaId,
  });
}
