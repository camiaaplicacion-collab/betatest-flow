import 'package:flutter/material.dart';

import '../../../domain/models/apps/app_model.dart';
import '../../controllers/apps/app_information_controller.dart';

class AppInformationScreen extends StatefulWidget {
  const AppInformationScreen({
    super.key,
    required this.controller,
  });

  final AppInformationController controller;

  @override
  State<AppInformationScreen> createState() => _AppInformationScreenState();
}

class _AppInformationScreenState extends State<AppInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _appIdController = TextEditingController();

  AppModel? _app;
  bool _isLoading = false;

  @override
  void dispose() {
    _appIdController.dispose();
    super.dispose();
  }

  Future<void> _loadApp() async {
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
      final app = await widget.controller.loadApp(_appIdController.text);

      if (!mounted) {
        return;
      }

      if (app == null) {
        setState(() {
          _app = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App no encontrada.')),
        );
        return;
      }

      setState(() {
        _app = app;
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
        const SnackBar(content: Text('No fue posible consultar la App.')),
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
    final app = _app;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion de la App'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H2.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text('Consulta la identidad y estado de una App en modo solo lectura.'),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
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
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loadApp,
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
              if (app != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Nombre', value: app.name),
                    _ReadOnlyField(
                      label: 'Descripcion',
                      value: app.description ?? 'Sin descripcion',
                    ),
                    _ReadOnlyField(label: 'appId', value: app.appId),
                    _ReadOnlyField(label: 'workspaceId', value: app.workspaceId),
                    _ReadOnlyField(label: 'status', value: app.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: app.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: app.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(app.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('0x${app.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}'),
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
