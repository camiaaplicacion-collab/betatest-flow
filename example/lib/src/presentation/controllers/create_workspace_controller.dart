import '../../domain/models/workspace.dart';
import '../../domain/repositories/workspace_repository.dart';

class CreateWorkspaceController {
  CreateWorkspaceController({
    required WorkspaceRepository repository,
  }) : _repository = repository;

  final WorkspaceRepository _repository;

  Future<Workspace> createWorkspace({
    required String name,
    required String ownerUserId,
    required String ownerEmail,
  }) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError('El nombre del Workspace es obligatorio.');
    }

    return _repository.createWorkspace(
      name: normalizedName,
      ownerUserId: ownerUserId,
      ownerEmail: ownerEmail,
    );
  }
}
