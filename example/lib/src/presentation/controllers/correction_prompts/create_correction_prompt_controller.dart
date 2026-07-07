import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../../domain/repositories/correction_prompts/correction_prompt_repository.dart';
import '../../../domain/repositories/reports/report_repository.dart';

class CreateCorrectionPromptController {
  CreateCorrectionPromptController({
    required CorrectionPromptRepository correctionPromptRepository,
    required ReportRepository reportRepository,
  })  : _correctionPromptRepository = correctionPromptRepository,
        _reportRepository = reportRepository;

  final CorrectionPromptRepository _correctionPromptRepository;
  final ReportRepository _reportRepository;

  Future<CorrectionPromptModel> createCorrectionPrompt({
    required String reportId,
    required String title,
    required String prompt,
  }) async {
    final normalizedReportId = reportId.trim();
    final normalizedTitle = title.trim();
    final normalizedPrompt = prompt.trim();

    if (normalizedReportId.isEmpty) {
      throw ArgumentError('El reportId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El title es obligatorio.');
    }
    if (normalizedPrompt.isEmpty) {
      throw ArgumentError('El prompt es obligatorio.');
    }

    final report = await _reportRepository.getReportById(normalizedReportId);
    if (report == null) {
      throw StateError('No existe un Reporte con ese reportId.');
    }

    return _correctionPromptRepository.createCorrectionPrompt(
      reportId: normalizedReportId,
      title: normalizedTitle,
      prompt: normalizedPrompt,
    );
  }
}
