import '../../../domain/models/reports/report_model.dart';
import '../../../domain/repositories/reports/report_repository.dart';

class ReportGeneralSettingsController {
  ReportGeneralSettingsController({
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

  Future<ReportModel> updateReportGeneralSettings({
    required String reportId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = reportId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El reportId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _reportRepository.updateReportGeneralSettings(
      reportId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
