import 'package:flutter/material.dart';

import '../../domain/models/workspace.dart';
import '../controllers/edit_workspace_controller.dart';

class WorkspaceInformationScreen extends StatefulWidget {
  const WorkspaceInformationScreen({
    super.key,
    required this.controller,
  });

  final EditWorkspaceController controller;

  @override
  State<WorkspaceInformationScreen> createState() =>
      _WorkspaceInformationScreenState();
}

class _WorkspaceInformationScreenState extends State<WorkspaceInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workspaceIdController = TextEditingController();

  Workspace? _workspace;
  bool _isLoading = false;

  @override
  void dispose() {
    _workspaceIdController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspace() async {
    if (_isLoading) {
      return;
    }

    final valid = _formKey.currentState?.validate() ?? false;
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
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace no encontrado.')),
        );
        return;
      }

      setState(() {
        _workspace = workspace;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del Workspace'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H1.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta la identidad y el estado del Workspace en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
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
                      onPressed: _isLoading ? null : _loadWorkspace,
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Consultar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_workspace != null)
                _WorkspaceReadOnlyCard(workspace: _workspace!),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspaceReadOnlyCard extends StatelessWidget {
  const _WorkspaceReadOnlyCard({required this.workspace});

  final Workspace workspace;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Datos del Workspace',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _ReadOnlyField(label: 'Nombre', value: workspace.name),
            _ReadOnlyField(
              label: 'Descripcion',
              value: workspace.description ?? '-',
            ),
            _ReadOnlyField(label: 'Workspace ID', value: workspace.workspaceId),
            _ReadOnlyField(label: 'Estado', value: workspace.status),
            _ReadOnlyField(
              label: 'Fecha de creacion',
              value: workspace.createdAt.toIso8601String(),
            ),
            _ReadOnlyField(
              label: 'Ultima actualizacion',
              value: workspace.updatedAt.toIso8601String(),
            ),
            _ReadOnlyField(
              label: 'Color principal',
              value: _toHex(workspace.primaryColor),
            ),
            _ReadOnlyField(label: 'Owner', value: workspace.ownerEmail),
          ],
        ),
      ),
    );
  }

  String _toHex(int value) {
    return '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
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
