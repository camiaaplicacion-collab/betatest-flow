import '../../models/reports/report_model.dart';

abstract class ReportRepository {
  Future<ReportModel> createReport({
    required String resultId,
    required String title,
    String? summary,
  });

  Future<ReportModel?> getReportById(String reportId);

  Future<ReportModel> updateReport({
    required String reportId,
    required String title,
    String? summary,
  });

  Future<ReportModel> archiveReport({
    required String reportId,
  });

  Future<ReportModel> updateReportGeneralSettings({
    required String reportId,
    String? description,
    required int primaryColor,
  });
}
