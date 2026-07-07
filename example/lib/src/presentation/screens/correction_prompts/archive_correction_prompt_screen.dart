import 'package:flutter/material.dart';

import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../controllers/correction_prompts/archive_correction_prompt_controller.dart';

class ArchiveCorrectionPromptScreen extends StatefulWidget {
  const ArchiveCorrectionPromptScreen({
    super.key,
    required this.controller,
  });

  final ArchiveCorrectionPromptController controller;

  @override
  State<ArchiveCorrectionPromptScreen> createState() =>
      _ArchiveCorrectionPromptScreenState();
}

class _ArchiveCorrectionPromptScreenState
    extends State<ArchiveCorrectionPromptScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _correctionPromptIdController = TextEditingController();

  CorrectionPromptModel? _correctionPrompt;
  bool _isLoading = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _correctionPromptIdController.dispose();
    super.dispose();
  }

  Future<void> _loadCorrectionPrompt() async {
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
      final correctionPrompt =
          await widget.controller.loadCorrectionPrompt(_correctionPromptIdController.text);

      if (!mounted) {
        return;
      }

      if (correctionPrompt == null) {
        setState(() {
          _correctionPrompt = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prompt de Correccion no encontrado.')),
        );
        return;
      }

      setState(() {
        _correctionPrompt = correctionPrompt;
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

  Future<void> _archiveCorrectionPrompt() async {
    final correctionPrompt = _correctionPrompt;
    if (correctionPrompt == null || _isLoading || _isArchiving) {
      return;
    }

    if (correctionPrompt.status != 'draft') {
      final message = correctionPrompt.status == 'archived'
          ? 'El Prompt de Correccion ya esta archivado.'
          : 'Solo Prompts draft pueden archivarse.';
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
            'Esta accion cambiara el status del Prompt de Correccion a archived. '
            'No se eliminara el documento ni su asociacion con el Reporte.\n\n'
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
      final updated = await widget.controller.archiveCorrectionPrompt(
        correctionPromptId: correctionPrompt.correctionPromptId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _correctionPrompt = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prompt de Correccion archivado correctamente.')),
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
        const SnackBar(content: Text('No fue posible archivar el Prompt de Correccion.')),
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
    final correctionPrompt = _correctionPrompt;

    return Scaffold(
      appBar: AppBar(title: const Text('Archivar Prompt de Correccion')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H11.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga un Prompt de Correccion y confirma su archivado logico.'),
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
                      onPressed: _isLoading || _isArchiving ? null : _loadCorrectionPrompt,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(
                      label: 'correctionPromptId',
                      value: correctionPrompt.correctionPromptId,
                    ),
                    _ReadOnlyField(label: 'reportId', value: correctionPrompt.reportId),
                    _ReadOnlyField(label: 'title', value: correctionPrompt.title),
                    _ReadOnlyField(label: 'prompt', value: correctionPrompt.prompt),
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
                      child: FilledButton(
                        onPressed: correctionPrompt.status == 'draft' &&
                                !_isLoading &&
                                !_isArchiving
                            ? _archiveCorrectionPrompt
                            : null,
                        child: _isArchiving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Archivar Prompt de Correccion'),
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
