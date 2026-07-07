import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../../domain/repositories/correction_prompts/correction_prompt_repository.dart';

class CorrectionPromptGeneralSettingsController {
  CorrectionPromptGeneralSettingsController({
    required CorrectionPromptRepository correctionPromptRepository,
  }) : _correctionPromptRepository = correctionPromptRepository;

  final CorrectionPromptRepository _correctionPromptRepository;

  Future<CorrectionPromptModel?> loadCorrectionPrompt(String correctionPromptId) {
    final normalizedId = correctionPromptId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El correctionPromptId es obligatorio.');
    }

    return _correctionPromptRepository.getCorrectionPromptById(normalizedId);
  }

  Future<CorrectionPromptModel> updateCorrectionPromptGeneralSettings({
    required String correctionPromptId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = correctionPromptId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El correctionPromptId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _correctionPromptRepository.updateCorrectionPromptGeneralSettings(
      correctionPromptId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
