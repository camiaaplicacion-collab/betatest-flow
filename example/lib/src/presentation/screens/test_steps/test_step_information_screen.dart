import 'package:flutter/material.dart';

import '../../../domain/models/test_steps/test_step_model.dart';
import '../../controllers/test_steps/test_step_information_controller.dart';

class TestStepInformationScreen extends StatefulWidget {
  const TestStepInformationScreen({
    super.key,
    required this.controller,
  });

  final TestStepInformationController controller;

  @override
  State<TestStepInformationScreen> createState() =>
      _TestStepInformationScreenState();
}

class _TestStepInformationScreenState extends State<TestStepInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testStepIdController = TextEditingController();

  TestStepModel? _testStep;
  bool _isLoading = false;

  @override
  void dispose() {
    _testStepIdController.dispose();
    super.dispose();
  }

  Future<void> _loadTestStep() async {
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
        const SnackBar(content: Text('No fue posible consultar el Paso de prueba.')),
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
    final testStep = _testStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del Paso de prueba'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H6.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta identidad y estado de un Paso de prueba en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
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
                      onPressed: _isLoading ? null : _loadTestStep,
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
              if (testStep != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Titulo', value: testStep.title),
                    _ReadOnlyField(
                      label: 'Descripcion',
                      value: testStep.description ?? 'Sin descripcion',
                    ),
                    _ReadOnlyField(
                      label: 'testStepId',
                      value: testStep.testStepId,
                    ),
                    _ReadOnlyField(
                      label: 'checklistId',
                      value: testStep.checklistId,
                    ),
                    _ReadOnlyField(label: 'status', value: testStep.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: testStep.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: testStep.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(testStep.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${testStep.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
