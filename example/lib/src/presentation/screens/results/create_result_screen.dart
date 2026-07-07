import 'package:flutter/material.dart';

import '../../../domain/models/results/result_model.dart';
import '../../controllers/results/create_result_controller.dart';

class CreateResultScreen extends StatefulWidget {
  const CreateResultScreen({
    super.key,
    required this.controller,
  });

  final CreateResultController controller;

  @override
  State<CreateResultScreen> createState() => _CreateResultScreenState();
}

class _CreateResultScreenState extends State<CreateResultScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sdkIdController = TextEditingController();
  final _testerIdController = TextEditingController();
  final _summaryController = TextEditingController();

  bool _isSubmitting = false;
  ResultModel? _createdResult;

  @override
  void dispose() {
    _sdkIdController.dispose();
    _testerIdController.dispose();
    _summaryController.dispose();
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
      final result = await widget.controller.createResult(
        sdkId: _sdkIdController.text,
        testerId: _testerIdController.text,
        summary: _summaryController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdResult = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resultado creado correctamente.')),
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
        const SnackBar(content: Text('No fue posible crear el Resultado.')),
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
      appBar: AppBar(title: const Text('Crear Resultado')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H9.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crea un Resultado asociado obligatoriamente a un SDK y un Tester.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _sdkIdController,
                      decoration: const InputDecoration(
                        labelText: 'sdkId',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'sdkId obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _testerIdController,
                      decoration: const InputDecoration(
                        labelText: 'testerId',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'testerId obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _summaryController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'summary (opcional)',
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
                            : const Text('Crear Resultado'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdResult != null)
                _CreatedResultCard(result: _createdResult!),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedResultCard extends StatelessWidget {
  const _CreatedResultCard({required this.result});

  final ResultModel result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultado creado',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('resultId: ${result.resultId}'),
            Text('sdkId: ${result.sdkId}'),
            Text('testerId: ${result.testerId}'),
            Text('status: ${result.status}'),
            Text('summary: ${result.summary ?? '-'}'),
            Text('createdAt: ${result.createdAt.toIso8601String()}'),
            Text('updatedAt: ${result.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
