import 'package:flutter/material.dart';

import '../../../domain/models/sdk_configurations/sdk_configuration_model.dart';
import '../../controllers/sdk_configurations/archive_sdk_configuration_controller.dart';

class ArchiveSDKConfigurationScreen extends StatefulWidget {
  const ArchiveSDKConfigurationScreen({
    super.key,
    required this.controller,
  });

  final ArchiveSDKConfigurationController controller;

  @override
  State<ArchiveSDKConfigurationScreen> createState() =>
      _ArchiveSDKConfigurationScreenState();
}

class _ArchiveSDKConfigurationScreenState
    extends State<ArchiveSDKConfigurationScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _sdkIdController = TextEditingController();

  SDKConfigurationModel? _sdkConfiguration;
  bool _isLoading = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _sdkIdController.dispose();
    super.dispose();
  }

  Future<void> _loadSDKConfiguration() async {
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
        const SnackBar(content: Text('No fue posible cargar la Configuracion SDK.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _archiveSDKConfiguration() async {
    final sdkConfiguration = _sdkConfiguration;
    if (sdkConfiguration == null || _isLoading || _isArchiving) {
      return;
    }

    if (sdkConfiguration.status != 'active') {
      final message = sdkConfiguration.status == 'archived'
          ? 'La Configuracion SDK ya esta archivada.'
          : 'Solo Configuraciones SDK active pueden archivarse.';
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
            'Esta accion cambiara el status de la Configuracion SDK a archived. '
            'No se eliminara el historial ni la asociacion con la Beta.\n\n'
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
      final updated = await widget.controller.archiveSDKConfiguration(
        sdkId: sdkConfiguration.sdkId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _sdkConfiguration = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuracion SDK archivada correctamente.')),
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
        const SnackBar(content: Text('No fue posible archivar la Configuracion SDK.')),
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
    final sdkConfiguration = _sdkConfiguration;

    return Scaffold(
      appBar: AppBar(title: const Text('Archivar Configuracion SDK')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H8.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga una Configuracion SDK y confirma su archivado logico.'),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
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
                      onPressed: _isLoading || _isArchiving
                          ? null
                          : _loadSDKConfiguration,
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
              if (sdkConfiguration != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'sdkId', value: sdkConfiguration.sdkId),
                    _ReadOnlyField(label: 'betaId', value: sdkConfiguration.betaId),
                    _ReadOnlyField(label: 'name', value: sdkConfiguration.name),
                    _ReadOnlyField(
                      label: 'description',
                      value: sdkConfiguration.description ?? '-',
                    ),
                    _ReadOnlyField(label: 'status', value: sdkConfiguration.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: sdkConfiguration.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: sdkConfiguration.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            sdkConfiguration.status == 'active' &&
                                !_isLoading &&
                                !_isArchiving
                            ? _archiveSDKConfiguration
                            : null,
                        child: _isArchiving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Archivar Configuracion SDK'),
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
