import 'package:flutter/material.dart';

import '../../../domain/models/test_steps/test_step_model.dart';
import '../../controllers/test_steps/archive_test_step_controller.dart';

class ArchiveTestStepScreen extends StatefulWidget {
  const ArchiveTestStepScreen({
    super.key,
    required this.controller,
  });

  final ArchiveTestStepController controller;

  @override
  State<ArchiveTestStepScreen> createState() => _ArchiveTestStepScreenState();
}

class _ArchiveTestStepScreenState extends State<ArchiveTestStepScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _testStepIdController = TextEditingController();

  TestStepModel? _testStep;
  bool _isLoading = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _testStepIdController.dispose();
    super.dispose();
  }

  Future<void> _loadTestStep() async {
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
      final testStep = await widget.controller.loadTestStep(_testStepIdController.text);

      if (!mounted) {
        return;
      }

      if (testStep == null) {
        setState(() {
          _testStep = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paso de prueba no encontrado.')),
        );
        return;
      }

      setState(() {
        _testStep = testStep;
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

  Future<void> _archiveTestStep() async {
    final testStep = _testStep;
    if (testStep == null || _isLoading || _isArchiving) {
      return;
    }

    if (testStep.status != 'pending') {
      final message = testStep.status == 'archived'
          ? 'El Paso de prueba ya esta archivado.'
          : 'Solo Pasos de prueba pending pueden archivarse.';
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
            'Esta accion cambiara el status del Paso de prueba a archived. '
            'No se eliminara el historial ni la asociacion con la Lista de pruebas.\n\n'
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
      final updated = await widget.controller.archiveTestStep(
        testStepId: testStep.testStepId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _testStep = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paso de prueba archivado correctamente.')),
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
        const SnackBar(content: Text('No fue posible archivar el Paso de prueba.')),
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
    final testStep = _testStep;

    return Scaffold(
      appBar: AppBar(title: const Text('Archivar Paso de prueba')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H6.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga un Paso de prueba y confirma su archivado logico.'),
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
                      onPressed: _isLoading || _isArchiving ? null : _loadTestStep,
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
              if (testStep != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'testStepId', value: testStep.testStepId),
                    _ReadOnlyField(label: 'checklistId', value: testStep.checklistId),
                    _ReadOnlyField(label: 'title', value: testStep.title),
                    _ReadOnlyField(label: 'description', value: testStep.description ?? '-'),
                    _ReadOnlyField(label: 'status', value: testStep.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: testStep.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: testStep.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            testStep.status == 'pending' && !_isLoading && !_isArchiving
                                ? _archiveTestStep
                                : null,
                        child: _isArchiving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Archivar Paso de prueba'),
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
