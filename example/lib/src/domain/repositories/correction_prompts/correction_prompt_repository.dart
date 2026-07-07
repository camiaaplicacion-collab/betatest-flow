import '../../models/correction_prompts/correction_prompt_model.dart';

abstract class CorrectionPromptRepository {
  Future<CorrectionPromptModel> createCorrectionPrompt({
    required String reportId,
    required String title,
    required String prompt,
  });

  Future<CorrectionPromptModel?> getCorrectionPromptById(String correctionPromptId);

  Future<CorrectionPromptModel> updateCorrectionPrompt({
    required String correctionPromptId,
    required String title,
    required String prompt,
  });

  Future<CorrectionPromptModel> archiveCorrectionPrompt({
    required String correctionPromptId,
  });

  Future<CorrectionPromptModel> updateCorrectionPromptGeneralSettings({
    required String correctionPromptId,
    String? description,
    required int primaryColor,
  });
}
