import '../../../domain/models/apps/app_model.dart';
import '../../../domain/repositories/apps/app_repository.dart';

class ArchiveAppController {
  ArchiveAppController({
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

  Future<AppModel> archiveApp({
    required String appId,
  }) {
    final normalizedId = appId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El appId es obligatorio.');
    }

    return _appRepository.archiveApp(appId: normalizedId);
  }
}
