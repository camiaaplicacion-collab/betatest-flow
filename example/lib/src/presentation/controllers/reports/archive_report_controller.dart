import '../../../domain/models/reports/report_model.dart';
import '../../../domain/repositories/reports/report_repository.dart';

class ArchiveReportController {
  ArchiveReportController({
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

  Future<ReportModel> archiveReport({
    required String reportId,
  }) {
    final normalizedId = reportId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El reportId es obligatorio.');
    }

    return _reportRepository.archiveReport(reportId: normalizedId);
  }
}
