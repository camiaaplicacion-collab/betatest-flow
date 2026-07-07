import 'package:flutter/material.dart';

import '../../domain/models/workspace.dart';
import '../controllers/create_workspace_controller.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({
    super.key,
    required this.controller,
    required this.ownerUserId,
    required this.ownerEmail,
  });

  final CreateWorkspaceController controller;
  final String ownerUserId;
  final String ownerEmail;

  @override
  State<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isSubmitting = false;
  Workspace? _createdWorkspace;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final workspace = await widget.controller.createWorkspace(
        name: _nameController.text,
        ownerUserId: widget.ownerUserId,
        ownerEmail: widget.ownerEmail,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdWorkspace = workspace;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace creado correctamente.')),
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
        const SnackBar(content: Text('No fue posible crear el Workspace.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Workspace'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H1.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Crea tu primer Workspace.'),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Workspace',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final normalized = (value ?? '').trim();
                        if (normalized.isEmpty) {
                          return 'Nombre obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Crear Workspace'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdWorkspace != null)
                _WorkspaceInfoCard(workspace: _createdWorkspace!),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspaceInfoCard extends StatelessWidget {
  const _WorkspaceInfoCard({
    required this.workspace,
  });

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
              'Workspace creado',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('workspaceId: ${workspace.workspaceId}'),
            Text('name: ${workspace.name}'),
            Text('ownerUserId: ${workspace.ownerUserId}'),
            Text('ownerEmail: ${workspace.ownerEmail}'),
            Text('status: ${workspace.status}'),
            Text('createdAt: ${workspace.createdAt.toIso8601String()}'),
            Text('updatedAt: ${workspace.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
