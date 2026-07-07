import '../../../domain/models/reports/report_model.dart';
import '../../../domain/repositories/reports/report_repository.dart';
import '../../../domain/repositories/results/result_repository.dart';

class CreateReportController {
  CreateReportController({
    required ReportRepository reportRepository,
    required ResultRepository resultRepository,
  })  : _reportRepository = reportRepository,
        _resultRepository = resultRepository;

  final ReportRepository _reportRepository;
  final ResultRepository _resultRepository;

  Future<ReportModel> createReport({
    required String resultId,
    required String title,
    String? summary,
  }) async {
    final normalizedResultId = resultId.trim();
    final normalizedTitle = title.trim();
    final normalizedSummary = summary?.trim();

    if (normalizedResultId.isEmpty) {
      throw ArgumentError('El resultId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El title es obligatorio.');
    }

    final result = await _resultRepository.getResultById(normalizedResultId);
    if (result == null) {
      throw StateError('No existe un Resultado con ese resultId.');
    }

    return _reportRepository.createReport(
      resultId: normalizedResultId,
      title: normalizedTitle,
      summary: normalizedSummary,
    );
  }
}
