import '../../domain/models/workspace.dart';
import '../../domain/repositories/workspace_repository.dart';

class EditWorkspaceController {
  EditWorkspaceController({
    required WorkspaceRepository repository,
  }) : _repository = repository;

  final WorkspaceRepository _repository;

  Future<Workspace?> loadWorkspace(String workspaceId) {
    final normalizedId = workspaceId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El workspaceId es obligatorio.');
    }

    return _repository.getWorkspaceById(normalizedId);
  }

  Future<Workspace> updateWorkspaceName({
    required String workspaceId,
    required String name,
  }) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError('El nombre del Workspace es obligatorio.');
    }

    return _repository.updateWorkspaceName(
      workspaceId: workspaceId,
      name: normalizedName,
    );
  }

  Future<Workspace> archiveWorkspace({
    required String workspaceId,
  }) {
    final normalizedId = workspaceId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El workspaceId es obligatorio.');
    }

    return _repository.archiveWorkspace(workspaceId: normalizedId);
  }

  Future<Workspace> updateWorkspaceGeneralSettings({
    required String workspaceId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = workspaceId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El workspaceId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _repository.updateWorkspaceGeneralSettings(
      workspaceId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
