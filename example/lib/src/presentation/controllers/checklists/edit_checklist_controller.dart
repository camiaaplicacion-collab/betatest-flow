import '../../../domain/models/checklists/checklist_model.dart';
import '../../../domain/repositories/checklists/checklist_repository.dart';

class EditChecklistController {
  EditChecklistController({
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

  Future<ChecklistModel> updateChecklist({
    required String checklistId,
    required String title,
    String? description,
  }) {
    final normalizedId = checklistId.trim();
    final normalizedTitle = title.trim();
    final normalizedDescription = description?.trim();

    if (normalizedId.isEmpty) {
      throw ArgumentError('El checklistId es obligatorio.');
    }
    if (normalizedTitle.isEmpty) {
      throw ArgumentError('El titulo de la Lista de pruebas es obligatorio.');
    }

    return _checklistRepository.updateChecklist(
      checklistId: normalizedId,
      title: normalizedTitle,
      description: normalizedDescription,
    );
  }
}
