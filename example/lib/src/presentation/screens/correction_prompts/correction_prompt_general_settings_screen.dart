import 'package:flutter/material.dart';

import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../controllers/correction_prompts/correction_prompt_general_settings_controller.dart';

class CorrectionPromptGeneralSettingsScreen extends StatefulWidget {
  const CorrectionPromptGeneralSettingsScreen({
    super.key,
    required this.controller,
  });

  final CorrectionPromptGeneralSettingsController controller;

  @override
  State<CorrectionPromptGeneralSettingsScreen> createState() =>
      _CorrectionPromptGeneralSettingsScreenState();
}

class _CorrectionPromptGeneralSettingsScreenState
    extends State<CorrectionPromptGeneralSettingsScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _settingsFormKey = GlobalKey<FormState>();
  final _correctionPromptIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  CorrectionPromptModel? _correctionPrompt;
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
    _correctionPromptIdController.dispose();
    _descriptionController.dispose();
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
          _descriptionController.clear();
          _selectedColor = _palette.first.value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prompt de Correccion no encontrado.')),
        );
        return;
      }

      setState(() {
        _correctionPrompt = correctionPrompt;
        _descriptionController.text = correctionPrompt.description ?? '';
        _selectedColor = _resolveColor(correctionPrompt.primaryColor);
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

  Future<void> _saveGeneralSettings() async {
    final correctionPrompt = _correctionPrompt;
    if (correctionPrompt == null || _isLoading || _isSaving) {
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
      final updated = await widget.controller.updateCorrectionPromptGeneralSettings(
        correctionPromptId: correctionPrompt.correctionPromptId,
        description: _descriptionController.text,
        primaryColor: _selectedColor,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _correctionPrompt = updated;
        _descriptionController.text = updated.description ?? '';
        _selectedColor = _resolveColor(updated.primaryColor);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuracion general del Prompt de Correccion actualizada correctamente.'),
        ),
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
          content: Text('No fue posible guardar la configuracion general del Prompt de Correccion.'),
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
    final correctionPrompt = _correctionPrompt;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion General del Prompt de Correccion'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H11.4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualiza y administra la configuracion general del Prompt de Correccion.',
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
                  key: _settingsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReadOnlyField(label: 'title actual', value: correctionPrompt.title),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'description (opcional)',
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
                          onPressed: _isSaving || _isLoading ? null : _saveGeneralSettings,
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
