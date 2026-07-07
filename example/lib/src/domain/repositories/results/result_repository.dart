import '../../models/results/result_model.dart';

abstract class ResultRepository {
  Future<ResultModel> createResult({
    required String sdkId,
    required String testerId,
    String? summary,
  });

  Future<ResultModel?> getResultById(String resultId);

  Future<ResultModel> updateResult({
    required String resultId,
    String? summary,
  });

  Future<ResultModel> archiveResult({
    required String resultId,
  });

  Future<ResultModel> updateResultGeneralSettings({
    required String resultId,
    String? description,
    required int primaryColor,
  });
}
