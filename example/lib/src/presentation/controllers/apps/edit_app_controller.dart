import '../../../domain/models/apps/app_model.dart';
import '../../../domain/repositories/apps/app_repository.dart';

class EditAppController {
  EditAppController({
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

  Future<AppModel> updateApp({
    required String appId,
    required String name,
    String? description,
  }) {
    final normalizedId = appId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El appId es obligatorio.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('El nombre de la App es obligatorio.');
    }

    return _appRepository.updateApp(
      appId: normalizedId,
      name: normalizedName,
      description: normalizedDescription,
    );
  }
}
