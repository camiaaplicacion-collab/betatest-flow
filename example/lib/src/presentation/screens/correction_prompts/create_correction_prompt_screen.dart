import 'package:flutter/material.dart';

import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../controllers/correction_prompts/create_correction_prompt_controller.dart';

class CreateCorrectionPromptScreen extends StatefulWidget {
  const CreateCorrectionPromptScreen({
    super.key,
    required this.controller,
  });

  final CreateCorrectionPromptController controller;

  @override
  State<CreateCorrectionPromptScreen> createState() =>
      _CreateCorrectionPromptScreenState();
}

class _CreateCorrectionPromptScreenState
    extends State<CreateCorrectionPromptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reportIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _promptController = TextEditingController();

  bool _isSubmitting = false;
  CorrectionPromptModel? _createdCorrectionPrompt;

  @override
  void dispose() {
    _reportIdController.dispose();
    _titleController.dispose();
    _promptController.dispose();
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
      final correctionPrompt = await widget.controller.createCorrectionPrompt(
        reportId: _reportIdController.text,
        title: _titleController.text,
        prompt: _promptController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdCorrectionPrompt = correctionPrompt;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prompt de Correccion creado correctamente.')),
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
        const SnackBar(
          content: Text('No fue posible crear el Prompt de Correccion.'),
        ),
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
      appBar: AppBar(title: const Text('Crear Prompt de Correccion')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H11.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crea un Prompt de Correccion asociado obligatoriamente a un Reporte.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _reportIdController,
                      decoration: const InputDecoration(
                        labelText: 'reportId',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'reportId obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'title obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _promptController,
                      minLines: 4,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'prompt',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'prompt obligatorio';
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
                            : const Text('Crear Prompt de Correccion'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdCorrectionPrompt != null)
                _CreatedCorrectionPromptCard(
                  correctionPrompt: _createdCorrectionPrompt!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedCorrectionPromptCard extends StatelessWidget {
  const _CreatedCorrectionPromptCard({required this.correctionPrompt});

  final CorrectionPromptModel correctionPrompt;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Prompt de Correccion creado',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('correctionPromptId: ${correctionPrompt.correctionPromptId}'),
            Text('reportId: ${correctionPrompt.reportId}'),
            Text('title: ${correctionPrompt.title}'),
            Text('prompt: ${correctionPrompt.prompt}'),
            Text('status: ${correctionPrompt.status}'),
            Text('createdAt: ${correctionPrompt.createdAt.toIso8601String()}'),
            Text('updatedAt: ${correctionPrompt.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
