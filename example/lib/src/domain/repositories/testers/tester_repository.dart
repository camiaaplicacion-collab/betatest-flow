import '../../models/testers/tester_model.dart';

abstract class TesterRepository {
  Future<TesterModel> createTester({
    required String betaId,
    required String displayName,
    required String email,
  });

  Future<TesterModel?> getTesterById(String testerId);

  Future<TesterModel> updateTester({
    required String testerId,
    required String displayName,
    required String email,
  });

  Future<TesterModel> archiveTester({
    required String testerId,
  });

  Future<TesterModel> updateTesterGeneralSettings({
    required String testerId,
    required String email,
    required int primaryColor,
  });
}
