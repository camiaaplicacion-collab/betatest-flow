import 'package:flutter/material.dart';

import '../../domain/models/workspace.dart';
import '../controllers/edit_workspace_controller.dart';

class EditWorkspaceScreen extends StatefulWidget {
  const EditWorkspaceScreen({
    super.key,
    required this.controller,
  });

  final EditWorkspaceController controller;

  @override
  State<EditWorkspaceScreen> createState() => _EditWorkspaceScreenState();
}

class _EditWorkspaceScreenState extends State<EditWorkspaceScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  final _workspaceIdController = TextEditingController();
  final _nameController = TextEditingController();

  Workspace? _workspace;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _workspaceIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspace() async {
    if (_isLoading || _isSaving) {
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
      final workspace =
          await widget.controller.loadWorkspace(_workspaceIdController.text);

      if (!mounted) {
        return;
      }

      if (workspace == null) {
        setState(() {
          _workspace = null;
          _nameController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace no encontrado.')),
        );
        return;
      }

      setState(() {
        _workspace = workspace;
        _nameController.text = workspace.name;
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
        const SnackBar(content: Text('No fue posible cargar el Workspace.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_workspace == null || _isLoading || _isSaving || _isArchiving) {
      return;
    }

    final valid = _editFormKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = await widget.controller.updateWorkspaceName(
        workspaceId: _workspace!.workspaceId,
        name: _nameController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _workspace = updated;
        _nameController.text = updated.name;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace actualizado correctamente.')),
      );
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
        const SnackBar(content: Text('No fue posible actualizar el Workspace.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _archiveWorkspace() async {
    final workspace = _workspace;
    if (workspace == null || _isLoading || _isSaving || _isArchiving) {
      return;
    }

    if (workspace.status != 'active') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solo Workspaces activos pueden archivarse.')),
      );
      return;
    }

    final shouldArchive = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Archivar Workspace'),
          content: const Text(
            '¿Confirmas que deseas archivar este Workspace? Esta accion no elimina su historial.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
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
      final archived = await widget.controller.archiveWorkspace(
        workspaceId: workspace.workspaceId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _workspace = archived;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace archivado correctamente.')),
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
        const SnackBar(content: Text('No fue posible archivar el Workspace.')),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Workspace'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H1.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Carga un Workspace existente, edita su nombre y permite archivarlo.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _workspaceIdController,
                        decoration: const InputDecoration(
                          labelText: 'workspaceId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final normalized = (value ?? '').trim();
                          if (normalized.isEmpty) {
                            return 'workspaceId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading || _isSaving ? null : _loadWorkspace,
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
              if (_workspace != null)
                Form(
                  key: _editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Workspace',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final normalized = (value ?? '').trim();
                          if (normalized.isEmpty) {
                            return 'Nombre obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyField(
                        label: 'workspaceId',
                        value: _workspace!.workspaceId,
                      ),
                      _ReadOnlyField(
                        label: 'ownerUserId',
                        value: _workspace!.ownerUserId,
                      ),
                      _ReadOnlyField(
                        label: 'ownerEmail',
                        value: _workspace!.ownerEmail,
                      ),
                      _ReadOnlyField(
                        label: 'createdAt',
                        value: _workspace!.createdAt.toIso8601String(),
                      ),
                      _ReadOnlyField(
                        label: 'status',
                        value: _workspace!.status,
                      ),
                      _ReadOnlyField(
                        label: 'updatedAt',
                        value: _workspace!.updatedAt.toIso8601String(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSaving || _isLoading || _isArchiving
                                  ? null
                                  : _saveChanges,
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Guardar cambios'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isSaving || _isLoading || _isArchiving
                                  ? null
                                  : _archiveWorkspace,
                              child: _isArchiving
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Archivar Workspace'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
