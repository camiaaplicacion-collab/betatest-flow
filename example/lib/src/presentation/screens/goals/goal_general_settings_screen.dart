import 'package:flutter/material.dart';

import '../../../domain/models/goals/goal_model.dart';
import '../../controllers/goals/goal_general_settings_controller.dart';

class GoalGeneralSettingsScreen extends StatefulWidget {
  const GoalGeneralSettingsScreen({
    super.key,
    required this.controller,
  });

  final GoalGeneralSettingsController controller;

  @override
  State<GoalGeneralSettingsScreen> createState() => _GoalGeneralSettingsScreenState();
}

class _GoalGeneralSettingsScreenState extends State<GoalGeneralSettingsScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _settingsFormKey = GlobalKey<FormState>();
  final _goalIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  GoalModel? _goal;
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
    _goalIdController.dispose();
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
          _descriptionController.clear();
          _selectedColor = _palette.first.value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal no encontrado.')),
        );
        return;
      }

      setState(() {
        _goal = goal;
        _descriptionController.text = goal.description ?? '';
        _selectedColor = _resolveColor(goal.primaryColor);
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

  Future<void> _saveGeneralSettings() async {
    final goal = _goal;
    if (goal == null || _isLoading || _isSaving) {
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
      final updated = await widget.controller.updateGoalGeneralSettings(
        goalId: goal.goalId,
        description: _descriptionController.text,
        primaryColor: _selectedColor,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _goal = updated;
        _descriptionController.text = updated.description ?? '';
        _selectedColor = _resolveColor(updated.primaryColor);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuracion general del Goal actualizada correctamente.'),
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
          content: Text('No fue posible guardar la configuracion general del Goal.'),
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
        title: const Text('Configuracion General del Goal'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H4.4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualiza y administra la configuracion basica del Goal.',
              ),
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
                          final normalized = (value ?? '').trim();
                          if (normalized.isEmpty) {
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
                  key: _settingsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReadOnlyField(label: 'Titulo actual', value: _goal!.title),
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
