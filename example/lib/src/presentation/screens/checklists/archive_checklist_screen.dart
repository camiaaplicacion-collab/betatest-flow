import 'package:flutter/material.dart';

import '../../../domain/models/checklists/checklist_model.dart';
import '../../controllers/checklists/archive_checklist_controller.dart';

class ArchiveChecklistScreen extends StatefulWidget {
  const ArchiveChecklistScreen({
    super.key,
    required this.controller,
  });

  final ArchiveChecklistController controller;

  @override
  State<ArchiveChecklistScreen> createState() => _ArchiveChecklistScreenState();
}

class _ArchiveChecklistScreenState extends State<ArchiveChecklistScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _checklistIdController = TextEditingController();

  ChecklistModel? _checklist;
  bool _isLoading = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _checklistIdController.dispose();
    super.dispose();
  }

  Future<void> _loadChecklist() async {
    if (_isLoading || _isArchiving) {
      return;
    }

    final valid = _loadFormKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final checklist = await widget.controller.loadChecklist(_checklistIdController.text);

      if (!mounted) {
        return;
      }

      if (checklist == null) {
        setState(() {
          _checklist = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lista de pruebas no encontrada.')),
        );
        return;
      }

      setState(() {
        _checklist = checklist;
      });
    } on ArgumentError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No fue posible cargar la Lista de pruebas.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _archiveChecklist() async {
    final checklist = _checklist;
    if (checklist == null || _isLoading || _isArchiving) {
      return;
    }

    if (checklist.status != 'active') {
      final message = checklist.status == 'archived'
          ? 'La Lista de pruebas ya esta archivada.'
          : 'Solo Listas de pruebas activas pueden archivarse.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    final shouldArchive = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar archivado'),
          content: const Text(
            'Esta accion cambiara el status de la Lista de pruebas a archived. '
            'No se eliminara el historial ni la asociacion con el Goal.\n\n'
            'Deseas continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Archivar'),
            ),
          ],
        );
      },
    );

    if (shouldArchive != true) {
      return;
    }

    setState(() {
      _isArchiving = true;
    });

    try {
      final updated = await widget.controller.archiveChecklist(
        checklistId: checklist.checklistId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _checklist = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lista de pruebas archivada correctamente.')),
      );
    } on ArgumentError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message.toString())),
      );
    } on StateError catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No fue posible archivar la Lista de pruebas.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isArchiving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final checklist = _checklist;

    return Scaffold(
      appBar: AppBar(title: const Text('Archivar Lista de pruebas')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H5.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga una Lista de pruebas y confirma su archivado logico.'),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _checklistIdController,
                        decoration: const InputDecoration(
                          labelText: 'checklistId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'checklistId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading || _isArchiving ? null : _loadChecklist,
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Cargar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (checklist != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'checklistId', value: checklist.checklistId),
                    _ReadOnlyField(label: 'goalId', value: checklist.goalId),
                    _ReadOnlyField(label: 'title', value: checklist.title),
                    _ReadOnlyField(
                      label: 'description',
                      value: checklist.description ?? '-',
                    ),
                    _ReadOnlyField(label: 'status', value: checklist.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: checklist.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: checklist.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            checklist.status == 'active' && !_isLoading && !_isArchiving
                                ? _archiveChecklist
                                : null,
                        child: _isArchiving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Archivar Lista de pruebas'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text('$label: $value'),
    );
  }
}
