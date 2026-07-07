import 'package:flutter/material.dart';

import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../controllers/correction_prompts/edit_correction_prompt_controller.dart';

class EditCorrectionPromptScreen extends StatefulWidget {
  const EditCorrectionPromptScreen({
    super.key,
    required this.controller,
  });

  final EditCorrectionPromptController controller;

  @override
  State<EditCorrectionPromptScreen> createState() =>
      _EditCorrectionPromptScreenState();
}

class _EditCorrectionPromptScreenState extends State<EditCorrectionPromptScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final _correctionPromptIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _promptController = TextEditingController();

  CorrectionPromptModel? _correctionPrompt;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _correctionPromptIdController.dispose();
    _titleController.dispose();
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _loadCorrectionPrompt() async {
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
      final correctionPrompt =
          await widget.controller.loadCorrectionPrompt(_correctionPromptIdController.text);

      if (!mounted) {
        return;
      }

      if (correctionPrompt == null) {
        setState(() {
          _correctionPrompt = null;
          _titleController.clear();
          _promptController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prompt de Correccion no encontrado.')),
        );
        return;
      }

      setState(() {
        _correctionPrompt = correctionPrompt;
        _titleController.text = correctionPrompt.title;
        _promptController.text = correctionPrompt.prompt;
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
        const SnackBar(content: Text('No fue posible cargar el Prompt de Correccion.')),
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
    final correctionPrompt = _correctionPrompt;
    if (correctionPrompt == null || _isLoading || _isSaving) {
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
      final updated = await widget.controller.updateCorrectionPrompt(
        correctionPromptId: correctionPrompt.correctionPromptId,
        title: _titleController.text,
        prompt: _promptController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _correctionPrompt = updated;
        _titleController.text = updated.title;
        _promptController.text = updated.prompt;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prompt de Correccion actualizado correctamente.')),
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
        const SnackBar(content: Text('No fue posible actualizar el Prompt de Correccion.')),
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
    final correctionPrompt = _correctionPrompt;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Prompt de Correccion')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H11.2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Carga un Prompt de Correccion existente y actualiza title y prompt.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _correctionPromptIdController,
                        decoration: const InputDecoration(
                          labelText: 'correctionPromptId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'correctionPromptId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading || _isSaving ? null : _loadCorrectionPrompt,
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
              if (correctionPrompt != null)
                Form(
                  key: _editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 12),
                      _ReadOnlyField(
                        label: 'correctionPromptId',
                        value: correctionPrompt.correctionPromptId,
                      ),
                      _ReadOnlyField(label: 'reportId', value: correctionPrompt.reportId),
                      _ReadOnlyField(label: 'status', value: correctionPrompt.status),
                      _ReadOnlyField(
                        label: 'createdAt',
                        value: correctionPrompt.createdAt.toIso8601String(),
                      ),
                      _ReadOnlyField(
                        label: 'updatedAt',
                        value: correctionPrompt.updatedAt.toIso8601String(),
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
