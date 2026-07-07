import '../../models/checklists/checklist_model.dart';

abstract class ChecklistRepository {
  Future<ChecklistModel> createChecklist({
    required String goalId,
    required String title,
    String? description,
  });

  Future<ChecklistModel?> getChecklistById(String checklistId);

  Future<ChecklistModel> updateChecklist({
    required String checklistId,
    required String title,
    String? description,
  });

  Future<ChecklistModel> archiveChecklist({
    required String checklistId,
  });

  Future<ChecklistModel> updateChecklistGeneralSettings({
    required String checklistId,
    String? description,
    required int primaryColor,
  });
}