import 'package:flutter/material.dart';

import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../controllers/sdk_configurations/sdk_configuration_information_controller.dart';

class SDKConfigurationInformationScreen extends StatefulWidget {
  const SDKConfigurationInformationScreen({
    super.key,
    required this.controller,
  });

  final SDKConfigurationInformationController controller;

  @override
  State<SDKConfigurationInformationScreen> createState() =>
      _SDKConfigurationInformationScreenState();
}

class _SDKConfigurationInformationScreenState
    extends State<SDKConfigurationInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sdkIdController = TextEditingController();

  SDKConfigurationModel? _sdkConfiguration;
  bool _isLoading = false;

  @override
  void dispose() {
    _sdkIdController.dispose();
    super.dispose();
  }

  Future<void> _loadSDKConfiguration() async {
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
      final sdkConfiguration =
          await widget.controller.loadSDKConfiguration(_sdkIdController.text);

      if (!mounted) {
        return;
      }

      if (sdkConfiguration == null) {
        setState(() {
          _sdkConfiguration = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configuracion SDK no encontrada.')),
        );
        return;
      }

      setState(() {
        _sdkConfiguration = sdkConfiguration;
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
        const SnackBar(
          content: Text('No fue posible consultar la Configuracion SDK.'),
        ),
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
    final sdkConfiguration = _sdkConfiguration;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del SDK'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H8.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta toda la informacion de una Configuracion SDK en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _sdkIdController,
                        decoration: const InputDecoration(
                          labelText: 'sdkId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'sdkId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loadSDKConfiguration,
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
              if (sdkConfiguration != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Nombre', value: sdkConfiguration.name),
                    _ReadOnlyField(
                      label: 'Descripcion',
                      value: sdkConfiguration.description ?? '',
                    ),
                    _ReadOnlyField(label: 'sdkId', value: sdkConfiguration.sdkId),
                    _ReadOnlyField(label: 'betaId', value: sdkConfiguration.betaId),
                    _ReadOnlyField(label: 'status', value: sdkConfiguration.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: sdkConfiguration.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: sdkConfiguration.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(sdkConfiguration.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${sdkConfiguration.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
