import '../../models/apps/app_model.dart';

abstract class AppRepository {
  Future<AppModel> createApp({
    required String workspaceId,
    required String name,
    String? description,
  });

  Future<AppModel?> getAppById(String appId);

  Future<AppModel> updateApp({
    required String appId,
    required String name,
    String? description,
  });

  Future<AppModel> updateAppGeneralSettings({
    required String appId,
    String? description,
    required int primaryColor,
  });

  Future<AppModel> archiveApp({
    required String appId,
  });
}
