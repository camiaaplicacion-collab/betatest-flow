import 'package:flutter/material.dart';

import '../../../domain/models/goals/goal_model.dart';
import '../../controllers/goals/archive_goal_controller.dart';

class ArchiveGoalScreen extends StatefulWidget {
  const ArchiveGoalScreen({
    super.key,
    required this.controller,
  });

  final ArchiveGoalController controller;

  @override
  State<ArchiveGoalScreen> createState() => _ArchiveGoalScreenState();
}

class _ArchiveGoalScreenState extends State<ArchiveGoalScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _goalIdController = TextEditingController();

  GoalModel? _goal;
  bool _isLoading = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _goalIdController.dispose();
    super.dispose();
  }

  Future<void> _loadGoal() async {
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
      final goal = await widget.controller.loadGoal(_goalIdController.text);

      if (!mounted) {
        return;
      }

      if (goal == null) {
        setState(() {
          _goal = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal no encontrado.')),
        );
        return;
      }

      setState(() {
        _goal = goal;
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
        const SnackBar(content: Text('No fue posible cargar el Goal.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _archiveGoal() async {
    final goal = _goal;
    if (goal == null || _isLoading || _isArchiving) {
      return;
    }

    if (goal.status != 'active') {
      final message = goal.status == 'archived'
          ? 'El Goal ya esta archivado.'
          : 'Solo Goals activos pueden archivarse.';
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
            'Esta accion cambiara el status del Goal a archived. '
            'No se eliminara el historial ni la asociacion con la Beta.\n\n'
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
      final updated = await widget.controller.archiveGoal(goalId: goal.goalId);

      if (!mounted) {
        return;
      }

      setState(() {
        _goal = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal archivado correctamente.')),
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
        const SnackBar(content: Text('No fue posible archivar el Goal.')),
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
    final goal = _goal;

    return Scaffold(
      appBar: AppBar(title: const Text('Archivar Goal')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H4.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga un Goal y confirma su archivado logico.'),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _goalIdController,
                        decoration: const InputDecoration(
                          labelText: 'goalId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'goalId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading || _isArchiving ? null : _loadGoal,
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
              if (goal != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'goalId', value: goal.goalId),
                    _ReadOnlyField(label: 'betaId', value: goal.betaId),
                    _ReadOnlyField(label: 'title', value: goal.title),
                    _ReadOnlyField(label: 'description', value: goal.description ?? '-'),
                    _ReadOnlyField(label: 'status', value: goal.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: goal.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: goal.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            goal.status == 'active' && !_isLoading && !_isArchiving
                                ? _archiveGoal
                                : null,
                        child: _isArchiving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Archivar Goal'),
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
