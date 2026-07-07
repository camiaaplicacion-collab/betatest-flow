import 'package:flutter/material.dart';

import '../../domain/models/workspace.dart';
import '../controllers/edit_workspace_controller.dart';

class WorkspaceGeneralSettingsScreen extends StatefulWidget {
  const WorkspaceGeneralSettingsScreen({
    super.key,
    required this.controller,
  });

  final EditWorkspaceController controller;

  @override
  State<WorkspaceGeneralSettingsScreen> createState() =>
      _WorkspaceGeneralSettingsScreenState();
}

class _WorkspaceGeneralSettingsScreenState
    extends State<WorkspaceGeneralSettingsScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _settingsFormKey = GlobalKey<FormState>();
  final _workspaceIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  Workspace? _workspace;
  bool _isLoading = false;
  bool _isSaving = false;
  int _selectedColor = _palette.first.value;

  static const List<_ColorOption> _palette = [
    _ColorOption(label: 'Teal', value: 0xFF0F766E),
    _ColorOption(label: 'Blue', value: 0xFF1D4ED8),
    _ColorOption(label: 'Green', value: 0xFF15803D),
    _ColorOption(label: 'Orange', value: 0xFFEA580C),
    _ColorOption(label: 'Red', value: 0xFFB91C1C),
  ];

  @override
  void dispose() {
    _workspaceIdController.dispose();
    _descriptionController.dispose();
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
          _descriptionController.clear();
          _selectedColor = _palette.first.value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace no encontrado.')),
        );
        return;
      }

      setState(() {
        _workspace = workspace;
        _descriptionController.text = workspace.description ?? '';
        _selectedColor = _resolveColor(workspace.primaryColor);
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

  Future<void> _saveGeneralSettings() async {
    final workspace = _workspace;
    if (workspace == null || _isLoading || _isSaving) {
      return;
    }

    final valid = _settingsFormKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = await widget.controller.updateWorkspaceGeneralSettings(
        workspaceId: workspace.workspaceId,
        description: _descriptionController.text,
        primaryColor: _selectedColor,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _workspace = updated;
        _descriptionController.text = updated.description ?? '';
        _selectedColor = _resolveColor(updated.primaryColor);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuracion general actualizada correctamente.'),
        ),
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
        const SnackBar(
          content: Text('No fue posible guardar la configuracion general.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  int _resolveColor(int colorValue) {
    if (_palette.any((item) => item.value == colorValue)) {
      return colorValue;
    }
    return _palette.first.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion General del Workspace'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H1.4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualiza y administra la configuracion basica del Workspace.',
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
                  key: _settingsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReadOnlyField(label: 'Nombre actual', value: _workspace!.name),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Descripcion (opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedColor,
                        decoration: const InputDecoration(
                          labelText: 'Color principal',
                          border: OutlineInputBorder(),
                        ),
                        items: _palette
                            .map(
                              (item) => DropdownMenuItem<int>(
                                value: item.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Color(item.value),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(item.label),
                                  ],
                                ),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: _isSaving
                            ? null
                            : (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedColor = value;
                                });
                              },
                        validator: (value) {
                          if (value == null) {
                            return 'Color obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyField(
                        label: 'workspaceId',
                        value: _workspace!.workspaceId,
                      ),
                      _ReadOnlyField(label: 'status', value: _workspace!.status),
                      _ReadOnlyField(
                        label: 'createdAt',
                        value: _workspace!.createdAt.toIso8601String(),
                      ),
                      _ReadOnlyField(
                        label: 'updatedAt',
                        value: _workspace!.updatedAt.toIso8601String(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isSaving || _isLoading ? null : _saveGeneralSettings,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Guardar configuracion general'),
                        ),
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

class _ColorOption {
  const _ColorOption({required this.label, required this.value});

  final String label;
  final int value;
}
