import '../models/beta_feedback_report.dart';
import 'device_info_service.dart';

class BetaFeedbackReportPreparationService {
  BetaFeedbackReportPreparationService({
    DeviceInfoService? deviceInfoService,
  }) : _deviceInfoService = deviceInfoService ?? DeviceInfoService();

  static const String _unknown = 'unknown';

  final DeviceInfoService _deviceInfoService;

  Future<BetaFeedbackReport> prepare(BetaFeedbackReport report) async {
    final collectedTechnicalData = await _deviceInfoService.collectTechnicalData();
    final mergedTechnicalData = _mergeTechnicalData(
      existing: report.deviceTechnicalData,
      collected: collectedTechnicalData,
    );

    return report.copyWith(
      deviceTechnicalData: mergedTechnicalData,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> _mergeTechnicalData({
    required Map<String, dynamic> existing,
    required Map<String, dynamic> collected,
  }) {
    final merged = <String, dynamic>{
      ...collected,
    };

    for (final entry in existing.entries) {
      if (!_isMissingValue(entry.value)) {
        merged[entry.key] = entry.value;
      } else {
        merged.putIfAbsent(entry.key, () => entry.value);
      }
    }

    return merged;
  }

  bool _isMissingValue(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized.isEmpty || normalized == _unknown;
    }
    return false;
  }
}