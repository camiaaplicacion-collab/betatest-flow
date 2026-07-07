import 'package:flutter/material.dart';

import '../../../domain/models/betas/beta_model.dart';
import '../../controllers/betas/beta_information_controller.dart';

class BetaInformationScreen extends StatefulWidget {
  const BetaInformationScreen({
    super.key,
    required this.controller,
  });

  final BetaInformationController controller;

  @override
  State<BetaInformationScreen> createState() => _BetaInformationScreenState();
}

class _BetaInformationScreenState extends State<BetaInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _betaIdController = TextEditingController();

  BetaModel? _beta;
  bool _isLoading = false;

  @override
  void dispose() {
    _betaIdController.dispose();
    super.dispose();
  }

  Future<void> _loadBeta() async {
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
      final beta = await widget.controller.loadBeta(_betaIdController.text);

      if (!mounted) {
        return;
      }

      if (beta == null) {
        setState(() {
          _beta = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Beta no encontrada.')),
        );
        return;
      }

      setState(() {
        _beta = beta;
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
        const SnackBar(content: Text('No fue posible consultar la Beta.')),
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
    final beta = _beta;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion de la Beta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H3.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Consulta identidad y estado de una Beta en modo solo lectura.'),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _betaIdController,
                        decoration: const InputDecoration(
                          labelText: 'betaId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'betaId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loadBeta,
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
              if (beta != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Nombre', value: beta.name),
                    _ReadOnlyField(
                      label: 'Descripcion',
                      value: beta.description ?? 'Sin descripcion',
                    ),
                    _ReadOnlyField(label: 'betaId', value: beta.betaId),
                    _ReadOnlyField(label: 'appId', value: beta.appId),
                    _ReadOnlyField(label: 'status', value: beta.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: beta.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: beta.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(beta.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${beta.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
