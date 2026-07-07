import 'package:flutter/material.dart';

import '../../../domain/models/results/result_model.dart';
import '../../controllers/results/edit_result_controller.dart';

class EditResultScreen extends StatefulWidget {
  const EditResultScreen({
    super.key,
    required this.controller,
  });

  final EditResultController controller;

  @override
  State<EditResultScreen> createState() => _EditResultScreenState();
}

class _EditResultScreenState extends State<EditResultScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final _resultIdController = TextEditingController();
  final _summaryController = TextEditingController();

  ResultModel? _result;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _resultIdController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _loadResult() async {
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
      final result = await widget.controller.loadResult(_resultIdController.text);

      if (!mounted) {
        return;
      }

      if (result == null) {
        setState(() {
          _result = null;
          _summaryController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resultado no encontrado.')),
        );
        return;
      }

      setState(() {
        _result = result;
        _summaryController.text = result.summary ?? '';
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
        const SnackBar(content: Text('No fue posible cargar el Resultado.')),
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
    final result = _result;
    if (result == null || _isLoading || _isSaving) {
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
      final updated = await widget.controller.updateResult(
        resultId: result.resultId,
        summary: _summaryController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _result = updated;
        _summaryController.text = updated.summary ?? '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resultado actualizado correctamente.')),
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
        const SnackBar(content: Text('No fue posible actualizar el Resultado.')),
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
      appBar: AppBar(title: const Text('Editar Resultado')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H9.2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Carga un Resultado existente y actualiza solo summary.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _resultIdController,
                        decoration: const InputDecoration(
                          labelText: 'resultId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'resultId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading || _isSaving ? null : _loadResult,
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
              if (_result != null)
                Form(
                  key: _editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _summaryController,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'summary',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyField(label: 'resultId', value: _result!.resultId),
                      _ReadOnlyField(label: 'sdkId', value: _result!.sdkId),
                      _ReadOnlyField(label: 'testerId', value: _result!.testerId),
                      _ReadOnlyField(label: 'status', value: _result!.status),
                      _ReadOnlyField(
                        label: 'createdAt',
                        value: _result!.createdAt.toIso8601String(),
                      ),
                      _ReadOnlyField(
                        label: 'updatedAt',
                        value: _result!.updatedAt.toIso8601String(),
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
