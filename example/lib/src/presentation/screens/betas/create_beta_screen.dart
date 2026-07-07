import 'package:flutter/material.dart';

import '../../../domain/models/betas/beta_model.dart';
import '../../controllers/betas/create_beta_controller.dart';

class CreateBetaScreen extends StatefulWidget {
  const CreateBetaScreen({
    super.key,
    required this.controller,
  });

  final CreateBetaController controller;

  @override
  State<CreateBetaScreen> createState() => _CreateBetaScreenState();
}

class _CreateBetaScreenState extends State<CreateBetaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _appIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  BetaModel? _createdBeta;

  @override
  void dispose() {
    _appIdController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
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
      final beta = await widget.controller.createBeta(
        appId: _appIdController.text,
        name: _nameController.text,
        description: _descriptionController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdBeta = beta;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beta creada correctamente.')),
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
        const SnackBar(content: Text('No fue posible crear la Beta.')),
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
      appBar: AppBar(title: const Text('Crear Beta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H3.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Registra una nueva Beta asociada a una App.'),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _appIdController,
                      decoration: const InputDecoration(
                        labelText: 'appId',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'appId obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Beta',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Nombre obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Descripcion (opcional)',
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
                            : const Text('Crear Beta'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdBeta != null) _CreatedBetaCard(beta: _createdBeta!),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedBetaCard extends StatelessWidget {
  const _CreatedBetaCard({required this.beta});

  final BetaModel beta;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Beta creada',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('betaId: ${beta.betaId}'),
            Text('appId: ${beta.appId}'),
            Text('name: ${beta.name}'),
            Text('description: ${beta.description ?? '-'}'),
            Text('status: ${beta.status}'),
            Text('createdAt: ${beta.createdAt.toIso8601String()}'),
            Text('updatedAt: ${beta.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
