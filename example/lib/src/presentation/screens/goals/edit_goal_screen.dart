import 'package:flutter/material.dart';

import '../../../domain/models/goals/goal_model.dart';
import '../../controllers/goals/edit_goal_controller.dart';

class EditGoalScreen extends StatefulWidget {
  const EditGoalScreen({
    super.key,
    required this.controller,
  });

  final EditGoalController controller;

  @override
  State<EditGoalScreen> createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final _goalIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  GoalModel? _goal;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _goalIdController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadGoal() async {
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
      final goal = await widget.controller.loadGoal(_goalIdController.text);

      if (!mounted) {
        return;
      }

      if (goal == null) {
        setState(() {
          _goal = null;
          _titleController.clear();
          _descriptionController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal no encontrado.')),
        );
        return;
      }

      setState(() {
        _goal = goal;
        _titleController.text = goal.title;
        _descriptionController.text = goal.description ?? '';
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

  Future<void> _saveChanges() async {
    final goal = _goal;
    if (goal == null || _isLoading || _isSaving) {
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
      final updated = await widget.controller.updateGoal(
        goalId: goal.goalId,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _goal = updated;
        _titleController.text = updated.title;
        _descriptionController.text = updated.description ?? '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal actualizado correctamente.')),
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
        const SnackBar(content: Text('No fue posible actualizar el Goal.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Goal')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H4.2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga un Goal existente y actualiza titulo y descripcion.'),
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
                      onPressed: _isLoading || _isSaving ? null : _loadGoal,
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
              if (_goal != null)
                Form(
                  key: _editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Titulo del Goal',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'Titulo obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Descripcion',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyField(label: 'goalId', value: _goal!.goalId),
                      _ReadOnlyField(label: 'betaId', value: _goal!.betaId),
                      _ReadOnlyField(label: 'status', value: _goal!.status),
                      _ReadOnlyField(
                        label: 'createdAt',
                        value: _goal!.createdAt.toIso8601String(),
                      ),
                      _ReadOnlyField(
                        label: 'updatedAt',
                        value: _goal!.updatedAt.toIso8601String(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving || _isLoading ? null : _saveChanges,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Guardar cambios'),
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
