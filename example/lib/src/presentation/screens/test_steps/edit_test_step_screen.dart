import 'package:flutter/material.dart';

import '../../../domain/models/test_steps/test_step_model.dart';
import '../../controllers/test_steps/edit_test_step_controller.dart';

class EditTestStepScreen extends StatefulWidget {
  const EditTestStepScreen({
    super.key,
    required this.controller,
  });

  final EditTestStepController controller;

  @override
  State<EditTestStepScreen> createState() => _EditTestStepScreenState();
}

class _EditTestStepScreenState extends State<EditTestStepScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final _testStepIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TestStepModel? _testStep;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _testStepIdController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTestStep() async {
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
      final testStep = await widget.controller.loadTestStep(_testStepIdController.text);

      if (!mounted) {
        return;
      }

      if (testStep == null) {
        setState(() {
          _testStep = null;
          _titleController.clear();
          _descriptionController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paso de prueba no encontrado.')),
        );
        return;
      }

      setState(() {
        _testStep = testStep;
        _titleController.text = testStep.title;
        _descriptionController.text = testStep.description ?? '';
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
        const SnackBar(content: Text('No fue posible cargar el Paso de prueba.')),
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
    final testStep = _testStep;
    if (testStep == null || _isLoading || _isSaving) {
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
      final updated = await widget.controller.updateTestStep(
        testStepId: testStep.testStepId,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _testStep = updated;
        _titleController.text = updated.title;
        _descriptionController.text = updated.description ?? '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paso de prueba actualizado correctamente.')),
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
        const SnackBar(content: Text('No fue posible actualizar el Paso de prueba.')),
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
      appBar: AppBar(title: const Text('Editar Paso de prueba')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H6.2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga un Paso de prueba existente y actualiza titulo y descripcion.'),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _testStepIdController,
                        decoration: const InputDecoration(
                          labelText: 'testStepId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'testStepId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading || _isSaving ? null : _loadTestStep,
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
              if (_testStep != null)
                Form(
                  key: _editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          labelText: 'Descripcion',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyField(label: 'testStepId', value: _testStep!.testStepId),
                      _ReadOnlyField(label: 'checklistId', value: _testStep!.checklistId),
                      _ReadOnlyField(label: 'status', value: _testStep!.status),
                      _ReadOnlyField(
                        label: 'createdAt',
                        value: _testStep!.createdAt.toIso8601String(),
                      ),
                      _ReadOnlyField(
                        label: 'updatedAt',
                        value: _testStep!.updatedAt.toIso8601String(),
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
