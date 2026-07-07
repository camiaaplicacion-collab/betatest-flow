import 'package:flutter/material.dart';

import '../../../domain/models/testers/tester_model.dart';
import '../../controllers/testers/tester_information_controller.dart';

class TesterInformationScreen extends StatefulWidget {
  const TesterInformationScreen({
    super.key,
    required this.controller,
  });

  final TesterInformationController controller;

  @override
  State<TesterInformationScreen> createState() => _TesterInformationScreenState();
}

class _TesterInformationScreenState extends State<TesterInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _testerIdController = TextEditingController();

  TesterModel? _tester;
  bool _isLoading = false;

  @override
  void dispose() {
    _testerIdController.dispose();
    super.dispose();
  }

  Future<void> _loadTester() async {
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
      final tester = await widget.controller.loadTester(_testerIdController.text);

      if (!mounted) {
        return;
      }

      if (tester == null) {
        setState(() {
          _tester = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tester no encontrado.')),
        );
        return;
      }

      setState(() {
        _tester = tester;
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
        const SnackBar(content: Text('No fue posible consultar el Tester.')),
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
    final tester = _tester;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del Tester'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H7.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta identidad y estado de un Tester en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loadTester,
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
              if (tester != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Nombre', value: tester.displayName),
                    _ReadOnlyField(label: 'Email', value: tester.email),
                    _ReadOnlyField(label: 'testerId', value: tester.testerId),
                    _ReadOnlyField(label: 'betaId', value: tester.betaId),
                    _ReadOnlyField(label: 'status', value: tester.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: tester.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: tester.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(tester.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${tester.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
