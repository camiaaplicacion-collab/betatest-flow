import 'package:flutter/material.dart';

import '../../../domain/models/testers/tester_model.dart';
import '../../controllers/testers/archive_tester_controller.dart';

class ArchiveTesterScreen extends StatefulWidget {
  const ArchiveTesterScreen({
    super.key,
    required this.controller,
  });

  final ArchiveTesterController controller;

  @override
  State<ArchiveTesterScreen> createState() => _ArchiveTesterScreenState();
}

class _ArchiveTesterScreenState extends State<ArchiveTesterScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _testerIdController = TextEditingController();

  TesterModel? _tester;
  bool _isLoading = false;
  bool _isArchiving = false;

  @override
  void dispose() {
    _testerIdController.dispose();
    super.dispose();
  }

  Future<void> _loadTester() async {
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
        const SnackBar(content: Text('No fue posible cargar el Tester.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _archiveTester() async {
    final tester = _tester;
    if (tester == null || _isLoading || _isArchiving) {
      return;
    }

    if (tester.status != 'invited') {
      final message = tester.status == 'archived'
          ? 'El Tester ya esta archivado.'
          : 'Solo Testers invited pueden archivarse.';
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
            'Esta accion cambiara el status del Tester a archived. '
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
      final updated = await widget.controller.archiveTester(
        testerId: tester.testerId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _tester = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tester archivado correctamente.')),
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
        const SnackBar(content: Text('No fue posible archivar el Tester.')),
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
    final tester = _tester;

    return Scaffold(
      appBar: AppBar(title: const Text('Archivar Tester')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H7.3',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga un Tester y confirma su archivado logico.'),
              const SizedBox(height: 16),
              Form(
                key: _loadFormKey,
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
                      onPressed: _isLoading || _isArchiving ? null : _loadTester,
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
              if (tester != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'testerId', value: tester.testerId),
                    _ReadOnlyField(label: 'betaId', value: tester.betaId),
                    _ReadOnlyField(label: 'displayName', value: tester.displayName),
                    _ReadOnlyField(label: 'email', value: tester.email),
                    _ReadOnlyField(label: 'status', value: tester.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: tester.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: tester.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed:
                            tester.status == 'invited' && !_isLoading && !_isArchiving
                                ? _archiveTester
                                : null,
                        child: _isArchiving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Archivar Tester'),
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
