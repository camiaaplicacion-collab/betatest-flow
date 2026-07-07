import 'package:flutter/material.dart';

import '../../../domain/models/checklists/checklist_model.dart';
import '../../controllers/checklists/checklist_information_controller.dart';

class ChecklistInformationScreen extends StatefulWidget {
  const ChecklistInformationScreen({
    super.key,
    required this.controller,
  });

  final ChecklistInformationController controller;

  @override
  State<ChecklistInformationScreen> createState() =>
      _ChecklistInformationScreenState();
}

class _ChecklistInformationScreenState extends State<ChecklistInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _checklistIdController = TextEditingController();

  ChecklistModel? _checklist;
  bool _isLoading = false;

  @override
  void dispose() {
    _checklistIdController.dispose();
    super.dispose();
  }

  Future<void> _loadChecklist() async {
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
      final checklist = await widget.controller.loadChecklist(_checklistIdController.text);

      if (!mounted) {
        return;
      }

      if (checklist == null) {
        setState(() {
          _checklist = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lista de pruebas no encontrada.')),
        );
        return;
      }

      setState(() {
        _checklist = checklist;
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
        const SnackBar(content: Text('No fue posible consultar la Lista de pruebas.')),
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
    final checklist = _checklist;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion de la Lista de pruebas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H5.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta identidad y estado de una Lista de pruebas en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _checklistIdController,
                        decoration: const InputDecoration(
                          labelText: 'checklistId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'checklistId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loadChecklist,
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
              if (checklist != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Titulo', value: checklist.title),
                    _ReadOnlyField(
                      label: 'Descripcion',
                      value: checklist.description ?? 'Sin descripcion',
                    ),
                    _ReadOnlyField(
                      label: 'checklistId',
                      value: checklist.checklistId,
                    ),
                    _ReadOnlyField(label: 'goalId', value: checklist.goalId),
                    _ReadOnlyField(label: 'status', value: checklist.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: checklist.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: checklist.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(checklist.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${checklist.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
