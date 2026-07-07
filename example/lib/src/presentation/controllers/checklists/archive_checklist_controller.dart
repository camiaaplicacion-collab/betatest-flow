import '../../../domain/models/checklists/checklist_model.dart';
import '../../../domain/repositories/checklists/checklist_repository.dart';

class ArchiveChecklistController {
  ArchiveChecklistController({
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

  Future<ChecklistModel> archiveChecklist({
    required String checklistId,
  }) {
    final normalizedId = checklistId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError('El checklistId es obligatorio.');
    }

    return _checklistRepository.archiveChecklist(checklistId: normalizedId);
  }
}
