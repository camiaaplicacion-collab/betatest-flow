import '../../../domain/models/apps/app_model.dart';
import '../../../domain/repositories/apps/app_repository.dart';

class AppGeneralSettingsController {
  AppGeneralSettingsController({
    required AppRepository appRepository,
  }) : _appRepository = appRepository;

  final AppRepository _appRepository;

  Future<AppModel?> loadApp(String appId) {
    final normalizedId = appId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El appId es obligatorio.');
    }

    return _appRepository.getAppById(normalizedId);
  }

  Future<AppModel> updateAppGeneralSettings({
    required String appId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = appId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El appId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _appRepository.updateAppGeneralSettings(
      appId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
