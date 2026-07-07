import 'package:flutter/material.dart';

import '../../../domain/models/correction_prompts/correction_prompt_model.dart';
import '../../controllers/correction_prompts/correction_prompt_information_controller.dart';

class CorrectionPromptInformationScreen extends StatefulWidget {
  const CorrectionPromptInformationScreen({
    super.key,
    required this.controller,
  });

  final CorrectionPromptInformationController controller;

  @override
  State<CorrectionPromptInformationScreen> createState() =>
      _CorrectionPromptInformationScreenState();
}

class _CorrectionPromptInformationScreenState
    extends State<CorrectionPromptInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correctionPromptIdController = TextEditingController();

  CorrectionPromptModel? _correctionPrompt;
  bool _isLoading = false;

  @override
  void dispose() {
    _correctionPromptIdController.dispose();
    super.dispose();
  }

  Future<void> _loadCorrectionPrompt() async {
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
        const SnackBar(content: Text('No fue posible consultar el Prompt de Correccion.')),
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
    final correctionPrompt = _correctionPrompt;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del Prompt de Correccion'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H11.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta toda la informacion de un Prompt de Correccion en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
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
                      onPressed: _isLoading ? null : _loadCorrectionPrompt,
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
              if (correctionPrompt != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Title', value: correctionPrompt.title),
                    _ReadOnlyField(label: 'Prompt', value: correctionPrompt.prompt),
                    _ReadOnlyField(
                      label: 'Description',
                      value: correctionPrompt.description ?? '',
                    ),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(correctionPrompt.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${correctionPrompt.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
