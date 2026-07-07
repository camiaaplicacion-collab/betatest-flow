import 'package:flutter/material.dart';

import '../../../domain/models/goals/goal_model.dart';
import '../../controllers/goals/goal_information_controller.dart';

class GoalInformationScreen extends StatefulWidget {
  const GoalInformationScreen({
    super.key,
    required this.controller,
  });

  final GoalInformationController controller;

  @override
  State<GoalInformationScreen> createState() => _GoalInformationScreenState();
}

class _GoalInformationScreenState extends State<GoalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _goalIdController = TextEditingController();

  GoalModel? _goal;
  bool _isLoading = false;

  @override
  void dispose() {
    _goalIdController.dispose();
    super.dispose();
  }

  Future<void> _loadGoal() async {
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
        const SnackBar(content: Text('No fue posible consultar el Goal.')),
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
    final goal = _goal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del Goal'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H4.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Consulta identidad y estado de un Goal en modo solo lectura.'),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
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
                      onPressed: _isLoading ? null : _loadGoal,
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
              if (goal != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Titulo', value: goal.title),
                    _ReadOnlyField(
                      label: 'Descripcion',
                      value: goal.description ?? 'Sin descripcion',
                    ),
                    _ReadOnlyField(label: 'goalId', value: goal.goalId),
                    _ReadOnlyField(label: 'betaId', value: goal.betaId),
                    _ReadOnlyField(label: 'status', value: goal.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: goal.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: goal.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(goal.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${goal.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
                        ),
                      ],
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
