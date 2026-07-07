import 'package:flutter/material.dart';

import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../controllers/sdk_configurations/create_sdk_configuration_controller.dart';

class CreateSDKConfigurationScreen extends StatefulWidget {
  const CreateSDKConfigurationScreen({
    super.key,
    required this.controller,
  });

  final CreateSDKConfigurationController controller;

  @override
  State<CreateSDKConfigurationScreen> createState() =>
      _CreateSDKConfigurationScreenState();
}

class _CreateSDKConfigurationScreenState
    extends State<CreateSDKConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _betaIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  SDKConfigurationModel? _createdSDKConfiguration;

  @override
  void dispose() {
    _betaIdController.dispose();
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
      final sdkConfiguration = await widget.controller.createSDKConfiguration(
        betaId: _betaIdController.text,
        name: _nameController.text,
        description: _descriptionController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdSDKConfiguration = sdkConfiguration;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuracion SDK creada correctamente.')),
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
        const SnackBar(content: Text('No fue posible crear la Configuracion SDK.')),
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
      appBar: AppBar(title: const Text('Crear Configuracion SDK')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H8.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crea una Configuracion SDK asociada obligatoriamente a una Beta.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'name obligatorio';
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
                        labelText: 'description (opcional)',
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
                            : const Text('Crear Configuracion SDK'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdSDKConfiguration != null)
                _CreatedSDKConfigurationCard(
                  sdkConfiguration: _createdSDKConfiguration!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedSDKConfigurationCard extends StatelessWidget {
  const _CreatedSDKConfigurationCard({required this.sdkConfiguration});

  final SDKConfigurationModel sdkConfiguration;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuracion SDK creada',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('sdkId: ${sdkConfiguration.sdkId}'),
            Text('betaId: ${sdkConfiguration.betaId}'),
            Text('name: ${sdkConfiguration.name}'),
            Text('description: ${sdkConfiguration.description ?? '-'}'),
            Text('status: ${sdkConfiguration.status}'),
            Text('createdAt: ${sdkConfiguration.createdAt.toIso8601String()}'),
            Text('updatedAt: ${sdkConfiguration.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
