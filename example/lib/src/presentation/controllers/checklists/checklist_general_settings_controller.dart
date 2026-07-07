import '../../../domain/models/checklists/checklist_model.dart';
import '../../../domain/repositories/checklists/checklist_repository.dart';

class ChecklistGeneralSettingsController {
  ChecklistGeneralSettingsController({
    required ChecklistRepository checklistRepository,
  }) : _checklistRepository = checklistRepository;

  final ChecklistRepository _checklistRepository;

  Future<ChecklistModel?> loadChecklist(String checklistId) {
    final normalizedId = checklistId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El checklistId es obligatorio.');
    }

    return _checklistRepository.getChecklistById(normalizedId);
  }

  Future<ChecklistModel> updateChecklistGeneralSettings({
    required String checklistId,
    String? description,
    required int primaryColor,
  }) {
    final normalizedId = checklistId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El checklistId es obligatorio.');
    }
    if (primaryColor < 0 || primaryColor > 0xFFFFFFFF) {
      throw ArgumentError('El color principal es invalido.');
    }

    final normalizedDescription = description?.trim();

    return _checklistRepository.updateChecklistGeneralSettings(
      checklistId: normalizedId,
      description: normalizedDescription,
      primaryColor: primaryColor,
    );
  }
}
