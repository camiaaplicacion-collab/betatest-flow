import 'package:flutter/material.dart';

import '../../../domain/models/test_steps/test_step_model.dart';
import '../../controllers/test_steps/create_test_step_controller.dart';

class CreateTestStepScreen extends StatefulWidget {
  const CreateTestStepScreen({
    super.key,
    required this.controller,
  });

  final CreateTestStepController controller;

  @override
  State<CreateTestStepScreen> createState() => _CreateTestStepScreenState();
}

class _CreateTestStepScreenState extends State<CreateTestStepScreen> {
  final _formKey = GlobalKey<FormState>();
  final _checklistIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  TestStepModel? _createdTestStep;

  @override
  void dispose() {
    _checklistIdController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
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
      final testStep = await widget.controller.createTestStep(
        checklistId: _checklistIdController.text,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdTestStep = testStep;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paso de prueba creado correctamente.')),
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
        const SnackBar(content: Text('No fue posible crear el Paso de prueba.')),
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
      appBar: AppBar(title: const Text('Crear Paso de prueba')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H6.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crea un Paso de prueba asociado obligatoriamente a una Lista de pruebas.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titulo del Paso de prueba',
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
                        labelText: 'Descripcion (opcional)',
                        border: OutlineInputBorder(),
                      ),
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
                            : const Text('Crear Paso de prueba'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdTestStep != null)
                _CreatedTestStepCard(testStep: _createdTestStep!),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedTestStepCard extends StatelessWidget {
  const _CreatedTestStepCard({required this.testStep});

  final TestStepModel testStep;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paso de prueba creado',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('testStepId: ${testStep.testStepId}'),
            Text('checklistId: ${testStep.checklistId}'),
            Text('title: ${testStep.title}'),
            Text('description: ${testStep.description ?? '-'}'),
            Text('status: ${testStep.status}'),
            Text('createdAt: ${testStep.createdAt.toIso8601String()}'),
            Text('updatedAt: ${testStep.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
