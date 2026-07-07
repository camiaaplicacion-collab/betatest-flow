import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../../domain/repositories/correction_prompts/correction_prompt_repository.dart';

class CorrectionPromptInformationController {
  CorrectionPromptInformationController({
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
}
