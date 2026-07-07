import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../../domain/repositories/correction_prompts/correction_prompt_repository.dart';

class EditCorrectionPromptController {
  EditCorrectionPromptController({
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

  Future<CorrectionPromptModel> updateCorrectionPrompt({
    required String correctionPromptId,
    required String title,
    required String prompt,
  }) {
    final normalizedId = correctionPromptId.trim();
    final normalizedTitle = title.trim();
    final normalizedPrompt = prompt.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El correctionPromptId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El title es obligatorio.');
    }
    if (normalizedPrompt.isEmpty) {
      throw ArgumentError('El prompt es obligatorio.');
    }

    return _correctionPromptRepository.updateCorrectionPrompt(
      correctionPromptId: normalizedId,
      title: normalizedTitle,
      prompt: normalizedPrompt,
    );
  }
}
