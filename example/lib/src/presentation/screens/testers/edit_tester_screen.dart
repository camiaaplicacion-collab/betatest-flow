import 'package:flutter/material.dart';

import '../../../domain/models/testers/tester_model.dart';
import '../../controllers/testers/edit_tester_controller.dart';

class EditTesterScreen extends StatefulWidget {
  const EditTesterScreen({
    super.key,
    required this.controller,
  });

  final EditTesterController controller;

  @override
  State<EditTesterScreen> createState() => _EditTesterScreenState();
}

class _EditTesterScreenState extends State<EditTesterScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final _testerIdController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();

  TesterModel? _tester;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _testerIdController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadTester() async {
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
      final tester = await widget.controller.loadTester(_testerIdController.text);

      if (!mounted) {
        return;
      }

      if (tester == null) {
        setState(() {
          _tester = null;
          _displayNameController.clear();
          _emailController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tester no encontrado.')),
        );
        return;
      }

      setState(() {
        _tester = tester;
        _displayNameController.text = tester.displayName;
        _emailController.text = tester.email;
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

  Future<void> _saveChanges() async {
    final tester = _tester;
    if (tester == null || _isLoading || _isSaving) {
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
      final updated = await widget.controller.updateTester(
        testerId: tester.testerId,
        displayName: _displayNameController.text,
        email: _emailController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _tester = updated;
        _displayNameController.text = updated.displayName;
        _emailController.text = updated.email;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tester actualizado correctamente.')),
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
        const SnackBar(content: Text('No fue posible actualizar el Tester.')),
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
      appBar: AppBar(title: const Text('Editar Tester')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H7.2',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Carga un Tester existente y actualiza displayName y email.'),
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
                      onPressed: _isLoading || _isSaving ? null : _loadTester,
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
              if (_tester != null)
                Form(
                  key: _editFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'displayName',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'displayName obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'email obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _ReadOnlyField(label: 'testerId', value: _tester!.testerId),
                      _ReadOnlyField(label: 'betaId', value: _tester!.betaId),
                      _ReadOnlyField(label: 'status', value: _tester!.status),
                      _ReadOnlyField(
                        label: 'createdAt',
                        value: _tester!.createdAt.toIso8601String(),
                      ),
                      _ReadOnlyField(
                        label: 'updatedAt',
                        value: _tester!.updatedAt.toIso8601String(),
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
