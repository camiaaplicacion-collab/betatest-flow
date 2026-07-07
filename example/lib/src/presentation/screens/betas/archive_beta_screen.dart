import 'package:flutter/material.dart';

import '../../../domain/models/betas/beta_model.dart';
import '../../controllers/betas/archive_beta_controller.dart';

class ArchiveBetaScreen extends StatefulWidget {
  const ArchiveBetaScreen({
    super.key,
    required this.controller,
  });

  final ArchiveBetaController controller;

  @override
  State<ArchiveBetaScreen> createState() => _ArchiveBetaScreenState();
}

class _ArchiveBetaScreenState extends State<ArchiveBetaScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _betaIdController = TextEditingController();

  BetaModel? _beta;
  bool _isLoading = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _betaIdController.dispose();
    super.dispose();
  }

  Future<void> _loadBeta() async {
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
        const SnackBar(content: Text('No fue posible cargar la Beta.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _archiveBeta() async {
    final beta = _beta;
    if (beta == null || _isLoading || _isArchiving) {
      return;
    }

    if (beta.status == 'archived') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La Beta ya esta archivada.')),
      );
      return;
    }

    final canArchive = beta.status == 'draft' || beta.status == 'active';
    if (!canArchive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solo Betas draft o active pueden archivarse.')),
      );
      return;
    }

    final shouldArchive = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar archivado'),
          content: const Text(
            'Esta accion cambiara el status de la Beta a archived. '
            'No se eliminara el historial ni la asociacion con la App.\n\n'
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
      final updated = await widget.controller.archiveBeta(betaId: beta.betaId);

      if (!mounted) {
        return;
      }

      setState(() {
        _beta = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Beta archivada correctamente.')),
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
        const SnackBar(content: Text('No fue posible archivar la Beta.')),
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
    final beta = _beta;

    return Scaffold(
      appBar: AppBar(title: const Text('Archivar Beta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H3.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga una Beta y confirma su archivado logico.'),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
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
                      onPressed: _isLoading || _isArchiving ? null : _loadBeta,
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
              if (beta != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'betaId', value: beta.betaId),
                    _ReadOnlyField(label: 'appId', value: beta.appId),
                    _ReadOnlyField(label: 'name', value: beta.name),
                    _ReadOnlyField(label: 'description', value: beta.description ?? '-'),
                    _ReadOnlyField(label: 'status', value: beta.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: beta.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: beta.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            beta.status != 'archived' && !_isLoading && !_isArchiving
                                ? _archiveBeta
                                : null,
                        child: _isArchiving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Archivar Beta'),
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
