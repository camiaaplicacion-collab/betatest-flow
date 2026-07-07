import 'package:flutter/material.dart';

import '../../../domain/models/reports/report_model.dart';
import '../../controllers/reports/create_report_controller.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({
    super.key,
    required this.controller,
  });

  final CreateReportController controller;

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _resultIdController = TextEditingController();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();

  bool _isSubmitting = false;
  ReportModel? _createdReport;

  @override
  void dispose() {
    _resultIdController.dispose();
    _titleController.dispose();
    _summaryController.dispose();
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
      final report = await widget.controller.createReport(
        resultId: _resultIdController.text,
        title: _titleController.text,
        summary: _summaryController.text,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdReport = report;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte creado correctamente.')),
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
        const SnackBar(content: Text('No fue posible crear el Reporte.')),
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
      appBar: AppBar(title: const Text('Crear Reporte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H10.1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Crea un Reporte asociado obligatoriamente a un Resultado.',
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _resultIdController,
                      decoration: const InputDecoration(
                        labelText: 'resultId',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'resultId obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'title obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _summaryController,
                      minLines: 2,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'summary (opcional)',
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
                            : const Text('Crear Reporte'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_createdReport != null)
                _CreatedReportCard(report: _createdReport!),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatedReportCard extends StatelessWidget {
  const _CreatedReportCard({required this.report});

  final ReportModel report;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reporte creado',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('reportId: ${report.reportId}'),
            Text('resultId: ${report.resultId}'),
            Text('title: ${report.title}'),
            Text('status: ${report.status}'),
            Text('summary: ${report.summary ?? '-'}'),
            Text('createdAt: ${report.createdAt.toIso8601String()}'),
            Text('updatedAt: ${report.updatedAt.toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}
