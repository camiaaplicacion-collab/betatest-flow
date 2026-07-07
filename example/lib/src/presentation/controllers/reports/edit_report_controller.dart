import '../../../domain/models/reports/report_model.dart';
import '../../../domain/repositories/reports/report_repository.dart';

class EditReportController {
  EditReportController({
    required ReportRepository reportRepository,
  }) : _reportRepository = reportRepository;

  final ReportRepository _reportRepository;

  Future<ReportModel?> loadReport(String reportId) {
    final normalizedId = reportId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El reportId es obligatorio.');
    }

    return _reportRepository.getReportById(normalizedId);
  }

  Future<ReportModel> updateReport({
    required String reportId,
    required String title,
    String? summary,
  }) {
    final normalizedId = reportId.trim();
    final normalizedTitle = title.trim();
    final normalizedSummary = summary?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El reportId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El title es obligatorio.');
    }

    return _reportRepository.updateReport(
      reportId: normalizedId,
      title: normalizedTitle,
      summary: normalizedSummary,
    );
  }
}
