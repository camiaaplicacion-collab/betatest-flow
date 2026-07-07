import 'package:flutter/material.dart';

import '../../../domain/models/testers/tester_model.dart';
import '../../controllers/testers/create_tester_controller.dart';

class CreateTesterScreen extends StatefulWidget {
  const CreateTesterScreen({
    super.key,
    required this.controller,
  });

  final CreateTesterController controller;

  @override
  State<CreateTesterScreen> createState() => _CreateTesterScreenState();
}

class _CreateTesterScreenState extends State<CreateTesterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _betaIdController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isSubmitting = false;
  TesterModel? _createdTester;

  @override
  void dispose() {
    _betaIdController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
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
      final tester = await widget.controller.createTester(
        betaId: _betaIdController.text,
        displayName: _displayNameController.text,
        email: _emailController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdTester = tester;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tester creado correctamente.')),
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
        const SnackBar(content: Text('No fue posible crear el Tester.')),
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
      appBar: AppBar(title: const Text('Crear Tester')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H7.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crea un Tester asociado obligatoriamente a una Beta.',
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
                            : const Text('Crear Tester'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdTester != null)
                _CreatedTesterCard(tester: _createdTester!),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedTesterCard extends StatelessWidget {
  const _CreatedTesterCard({required this.tester});

  final TesterModel tester;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tester creado',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('testerId: ${tester.testerId}'),
            Text('betaId: ${tester.betaId}'),
            Text('displayName: ${tester.displayName}'),
            Text('email: ${tester.email}'),
            Text('status: ${tester.status}'),
            Text('createdAt: ${tester.createdAt.toIso8601String()}'),
            Text('updatedAt: ${tester.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
