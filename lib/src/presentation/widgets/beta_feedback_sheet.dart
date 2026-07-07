import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/beta_test_flow_config.dart';
import '../../domain/models/beta_feedback_report.dart';
import '../../domain/repositories/beta_feedback_repository.dart';

class BetaFeedbackSheet extends StatefulWidget {
  const BetaFeedbackSheet({
    super.key,
    required this.config,
    required this.repository,
    required this.userId,
    this.email,
  });

  final BetaTestFlowConfig config;
  final BetaFeedbackRepository repository;
  final String userId;
  final String? email;

  @override
  State<BetaFeedbackSheet> createState() => _BetaFeedbackSheetState();
}

class _BetaFeedbackSheetState extends State<BetaFeedbackSheet> {
  static const String _resultWorkedWell = 'funciono_bien';
  static const String _resultWorkedPartial = 'funciono_a_medias';
  static const String _resultDidNotWork = 'no_funciono';

  static const String _severityLow = 'baja';
  static const String _severityMedium = 'media';
  static const String _severityHigh = 'alta';
  static const String _severityCritical = 'critica';

  final _formKey = GlobalKey<FormState>();
  final _mainCommentController = TextEditingController();
  final _stepsController = TextEditingController();
  final _suggestionController = TextEditingController();

  bool _isLoadingDraft = true;
  bool _isSubmitting = false;
  bool _isSavingDraft = false;

  String _generalResult = _resultWorkedWell;
  String _severity = _severityLow;
  final Map<String, bool> _checklistSelections = <String, bool>{};

  @override
  void initState() {
    super.initState();
    for (final item in widget.config.checklistItems) {
      _checklistSelections[item.id] = false;
    }
    _loadDraft();
  }

  @override
  void dispose() {
    _mainCommentController.dispose();
    _stepsController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  Future<void> _loadDraft() async {
    try {
      final draft = await widget.repository.getDraft(
        appId: widget.config.appId,
        userId: widget.userId,
        campaignId: widget.config.campaignId,
      );

      if (draft == null || !mounted) {
        return;
      }

      for (final item in widget.config.checklistItems) {
        final value = draft.checklistResponses[item.id];
        if (value != null) {
          _checklistSelections[item.id] = value;
        }
      }

      _applyFeedbackTextToFields(draft.feedbackText);
      setState(() {});
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDraft = false;
        });
      }
    }
  }

  void _applyFeedbackTextToFields(String? feedbackText) {
    if (feedbackText == null || feedbackText.trim().isEmpty) {
      return;
    }

    final markerIndex = feedbackText.lastIndexOf('\n[btf_form_v1]');
    if (markerIndex == -1) {
      _mainCommentController.text = feedbackText.trim();
      return;
    }

    final visibleComment = feedbackText.substring(0, markerIndex).trim();
    final payload = feedbackText.substring(markerIndex + '\n[btf_form_v1]'.length).trim();
    _mainCommentController.text = visibleComment;

    try {
      final parsed = Map<String, dynamic>.from(
        (payload.isEmpty ? <String, dynamic>{} : _safeDecodeMap(payload)),
      );

      final generalResult = parsed['generalResult'] as String?;
      final severity = parsed['severity'] as String?;
      _generalResult = _allowedGeneralResult(generalResult) ?? _generalResult;
      _severity = _allowedSeverity(severity) ?? _severity;
      _stepsController.text = parsed['steps'] as String? ?? '';
      _suggestionController.text = parsed['suggestion'] as String? ?? '';
    } catch (_) {
      // Keep defaults if payload is malformed.
    }
  }

  Map<String, dynamic> _safeDecodeMap(String raw) {
    final value = raw.isEmpty ? <String, dynamic>{} : jsonDecode(raw);
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, value) => MapEntry('$key', value));
    }
    return <String, dynamic>{};
  }

  String? _allowedGeneralResult(String? value) {
    switch (value) {
      case _resultWorkedWell:
      case _resultWorkedPartial:
      case _resultDidNotWork:
        return value;
      default:
        return null;
    }
  }

  String? _allowedSeverity(String? value) {
    switch (value) {
      case _severityLow:
      case _severityMedium:
      case _severityHigh:
      case _severityCritical:
        return value;
      default:
        return null;
    }
  }

  Future<void> _saveDraft() async {
    if (_isSubmitting || _isSavingDraft) {
      return;
    }

    if (!_validateBeforeSubmit(showSnackBar: true)) {
      return;
    }

    setState(() {
      _isSavingDraft = true;
    });

    try {
      final draftReport = _buildReport();
      await widget.repository.saveDraft(draftReport);

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrador guardado')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSavingDraft = false;
        });
      }
    }
  }

  Future<void> _submitReport() async {
    if (_isSubmitting || _isSavingDraft) {
      return;
    }

    if (!_validateBeforeSubmit(showSnackBar: true)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final report = _buildReport();
      await widget.repository.submitReport(report);
      await widget.repository.deleteDraft(
        appId: widget.config.appId,
        userId: widget.userId,
        campaignId: widget.config.campaignId,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado con exito')),
      );
      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool _validateBeforeSubmit({required bool showSnackBar}) {
    final hasChecklistSelection = _checklistSelections.values.any((value) => value);
    if (!hasChecklistSelection) {
      if (showSnackBar && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona al menos un item del checklist')),
        );
      }
      return false;
    }

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return false;
    }

    return true;
  }

  BetaFeedbackReport _buildReport() {
    final payload = <String, dynamic>{
      'generalResult': _generalResult,
      'severity': _severity,
      'steps': _stepsController.text.trim(),
      'suggestion': _suggestionController.text.trim(),
      'email': (widget.email ?? '').trim(),
    };

    final feedbackText = '${_mainCommentController.text.trim()}\n[btf_form_v1]${jsonEncode(payload)}';

    return BetaFeedbackReport(
      appId: widget.config.appId,
      appName: widget.config.appName,
      campaignId: widget.config.campaignId,
      campaignName: widget.config.campaignName,
      userId: widget.userId,
      reportVersion: widget.config.reportVersion,
      feedbackText: feedbackText,
      checklistResponses: Map<String, bool>.from(_checklistSelections),
      deviceTechnicalData: const <String, dynamic>{},
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.config.primaryColor;
    final effectiveColorScheme = color == null
        ? Theme.of(context).colorScheme
        : Theme.of(context).colorScheme.copyWith(primary: color);

    return SafeArea(
      child: Material(
        child: Theme(
          data: Theme.of(context).copyWith(colorScheme: effectiveColorScheme),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: _isLoadingDraft
                ? const SizedBox(
                    height: 240,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Feedback beta',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          const Text('Checklist'),
                          ...widget.config.checklistItems.map(
                            (item) => CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              value: _checklistSelections[item.id] ?? false,
                              onChanged: (_isSubmitting || _isSavingDraft)
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _checklistSelections[item.id] = value ?? false;
                                      });
                                    },
                              title: Text(item.title),
                              subtitle: item.description == null
                                  ? null
                                  : Text(item.description!),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Resultado general'),
                          _ResultRadioGroup(
                            currentValue: _generalResult,
                            values: const <String>[
                              _resultWorkedWell,
                              _resultWorkedPartial,
                              _resultDidNotWork,
                            ],
                            enabled: !(_isSubmitting || _isSavingDraft),
                            onChanged: (value) {
                              setState(() {
                                _generalResult = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          const Text('Gravedad'),
                          _ResultRadioGroup(
                            currentValue: _severity,
                            values: const <String>[
                              _severityLow,
                              _severityMedium,
                              _severityHigh,
                              _severityCritical,
                            ],
                            enabled: !(_isSubmitting || _isSavingDraft),
                            onChanged: (value) {
                              setState(() {
                                _severity = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _mainCommentController,
                            minLines: 3,
                            maxLines: 5,
                            enabled: !(_isSubmitting || _isSavingDraft),
                            decoration: const InputDecoration(
                              labelText: 'Comentario principal *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El comentario principal es obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _stepsController,
                            minLines: 2,
                            maxLines: 4,
                            enabled: !(_isSubmitting || _isSavingDraft),
                            decoration: const InputDecoration(
                              labelText: 'Pasos (opcional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _suggestionController,
                            minLines: 2,
                            maxLines: 4,
                            enabled: !(_isSubmitting || _isSavingDraft),
                            decoration: const InputDecoration(
                              labelText: 'Sugerencia (opcional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: (_isSubmitting || _isSavingDraft)
                                      ? null
                                      : _saveDraft,
                                  child: _isSavingDraft
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Guardar borrador'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: (_isSubmitting || _isSavingDraft)
                                      ? null
                                      : _submitReport,
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Enviar reporte'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ResultRadioGroup extends StatelessWidget {
  const _ResultRadioGroup({
    required this.currentValue,
    required this.values,
    required this.enabled,
    required this.onChanged,
  });

  final String currentValue;
  final List<String> values;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values
          .map(
            (value) => ChoiceChip(
              label: Text(value),
              selected: currentValue == value,
              onSelected: enabled
                  ? (selected) {
                      if (selected) {
                        onChanged(value);
                      }
                    }
                  : null,
            ),
          )
          .toList(growable: false),
    );
  }
}
