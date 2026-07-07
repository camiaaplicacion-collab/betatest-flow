import 'package:flutter/material.dart';

import '../../../domain/models/results/result_model.dart';
import '../../controllers/results/result_information_controller.dart';

class ResultInformationScreen extends StatefulWidget {
  const ResultInformationScreen({
    super.key,
    required this.controller,
  });

  final ResultInformationController controller;

  @override
  State<ResultInformationScreen> createState() => _ResultInformationScreenState();
}

class _ResultInformationScreenState extends State<ResultInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _resultIdController = TextEditingController();

  ResultModel? _result;
  bool _isLoading = false;

  @override
  void dispose() {
    _resultIdController.dispose();
    super.dispose();
  }

  Future<void> _loadResult() async {
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
      final result = await widget.controller.loadResult(_resultIdController.text);

      if (!mounted) {
        return;
      }

      if (result == null) {
        setState(() {
          _result = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resultado no encontrado.')),
        );
        return;
      }

      setState(() {
        _result = result;
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
        const SnackBar(content: Text('No fue posible consultar el Resultado.')),
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
    final result = _result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del Resultado'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H9.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta toda la informacion de un Resultado en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
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
                      onPressed: _isLoading ? null : _loadResult,
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
              if (result != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Summary', value: result.summary ?? ''),
                    _ReadOnlyField(
                      label: 'Description',
                      value: result.description ?? '',
                    ),
                    _ReadOnlyField(label: 'resultId', value: result.resultId),
                    _ReadOnlyField(label: 'sdkId', value: result.sdkId),
                    _ReadOnlyField(label: 'testerId', value: result.testerId),
                    _ReadOnlyField(label: 'status', value: result.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: result.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: result.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(result.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${result.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
