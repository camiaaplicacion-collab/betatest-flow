import 'package:flutter/material.dart';

import '../../../domain/models/reports/report_model.dart';
import '../../controllers/reports/report_information_controller.dart';

class ReportInformationScreen extends StatefulWidget {
  const ReportInformationScreen({
    super.key,
    required this.controller,
  });

  final ReportInformationController controller;

  @override
  State<ReportInformationScreen> createState() => _ReportInformationScreenState();
}

class _ReportInformationScreenState extends State<ReportInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reportIdController = TextEditingController();

  ReportModel? _report;
  bool _isLoading = false;

  @override
  void dispose() {
    _reportIdController.dispose();
    super.dispose();
  }

  Future<void> _loadReport() async {
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
      final report = await widget.controller.loadReport(_reportIdController.text);

      if (!mounted) {
        return;
      }

      if (report == null) {
        setState(() {
          _report = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte no encontrado.')),
        );
        return;
      }

      setState(() {
        _report = report;
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
        const SnackBar(content: Text('No fue posible consultar el Reporte.')),
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
    final report = _report;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion del Reporte'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H10.5',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Consulta toda la informacion de un Reporte en modo solo lectura.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _reportIdController,
                        decoration: const InputDecoration(
                          labelText: 'reportId',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if ((value ?? '').trim().isEmpty) {
                            return 'reportId obligatorio';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loadReport,
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
              if (report != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReadOnlyField(label: 'Title', value: report.title),
                    _ReadOnlyField(label: 'Summary', value: report.summary ?? ''),
                    _ReadOnlyField(
                      label: 'Description',
                      value: report.description ?? '',
                    ),
                    _ReadOnlyField(label: 'reportId', value: report.reportId),
                    _ReadOnlyField(label: 'resultId', value: report.resultId),
                    _ReadOnlyField(label: 'status', value: report.status),
                    _ReadOnlyField(
                      label: 'createdAt',
                      value: report.createdAt.toIso8601String(),
                    ),
                    _ReadOnlyField(
                      label: 'updatedAt',
                      value: report.updatedAt.toIso8601String(),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Color principal: '),
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(report.primaryColor),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0x${report.primaryColor.toRadixString(16).padLeft(8, '0').toUpperCase()}',
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
