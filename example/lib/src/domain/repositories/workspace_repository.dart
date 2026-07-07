import '../models/workspace.dart';

abstract class WorkspaceRepository {
  Future<Workspace> createWorkspace({
    required String name,
    required String ownerUserId,
    required String ownerEmail,
  });

  Future<Workspace?> getWorkspaceById(String workspaceId);

  Future<Workspace> updateWorkspaceName({
    required String workspaceId,
    required String name,
  });

  Future<Workspace> archiveWorkspace({
    required String workspaceId,
  });

  Future<Workspace> updateWorkspaceGeneralSettings({
    required String workspaceId,
    String? description,
    required int primaryColor,
  });
}
