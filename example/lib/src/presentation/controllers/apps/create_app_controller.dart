import '../../../domain/models/apps/app_model.dart';
import '../../../domain/repositories/apps/app_repository.dart';
import '../../../domain/repositories/workspace_repository.dart';

class CreateAppController {
  CreateAppController({
    required AppRepository appRepository,
    required WorkspaceRepository workspaceRepository,
  })  : _appRepository = appRepository,
        _workspaceRepository = workspaceRepository;

  final AppRepository _appRepository;
  final WorkspaceRepository _workspaceRepository;

  Future<AppModel> createApp({
    required String workspaceId,
    required String name,
    String? description,
  }) async {
    final normalizedWorkspaceId = workspaceId.trim();
    final normalizedName = name.trim();
    final normalizedDescription = description?.trim();

    if (normalizedWorkspaceId.isEmpty) {
      throw ArgumentError('El workspaceId es obligatorio.');
    }
    if (normalizedName.isEmpty) {
      throw ArgumentError('El nombre de la App es obligatorio.');
    }

    final workspace = await _workspaceRepository.getWorkspaceById(normalizedWorkspaceId);
    if (workspace == null) {
      throw StateError('No existe un Workspace con ese workspaceId.');
    }

    return _appRepository.createApp(
      workspaceId: normalizedWorkspaceId,
      name: normalizedName,
      description: normalizedDescription,
    );
  }
}
