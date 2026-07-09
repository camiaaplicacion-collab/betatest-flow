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

  static const String _reproducibilityYes = 'Si';
  static const String _reproducibilityNo = 'No';
  static const String _reproducibilitySometimes = 'A veces';
  static const String _reproducibilityUnknown = 'No lo se';

  static const String _usageImpactNone = 'No afecta';
  static const String _usageImpactLittle = 'Afecta un poco';
  static const String _usageImpactHigh = 'Afecta mucho';
  static const String _usageImpactLeave = 'Me haria dejar de usarla';

  static const String _publishRecommendationYes = 'Si';
  static const String _publishRecommendationYesWithAdjustments =
      'Si, con ajustes menores';
  static const String _publishRecommendationNotYet = 'No todavia';
  static const String _publishRecommendationNo = 'No';

    static const String _interfaceVeryClear = 'Muy clara';
    static const String _interfaceClear = 'Clara';
    static const String _interfaceConfusing = 'Confusa';
    static const String _interfaceVeryConfusing = 'Muy confusa';

    static const String _colorCorrect = 'Correctos';
    static const String _colorImprove = 'Mejorables';
    static const String _colorConfusing = 'Confusos';
    static const String _colorNoHelp = 'No ayudan';

    static const String _usabilityVeryEasy = 'Muy facil';
    static const String _usabilityEasy = 'Facil';
    static const String _usabilityDifficult = 'Dificil';
    static const String _usabilityVeryDifficult = 'Muy dificil';

  static const String _submitErrorText =
      'No se pudo enviar el reporte. Intenta nuevamente.';

  final _formKey = GlobalKey<FormState>();
  final _submitErrorKey = GlobalKey();
  final _mainCommentController = TextEditingController();
  final _stepsController = TextEditingController();
  final _suggestionController = TextEditingController();
  final _screenNameController = TextEditingController();
  final _uxDetailsController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoadingDraft = true;
  bool _isSubmitting = false;
  bool _isSavingDraft = false;
  String? _submitErrorMessage;

  String _generalResult = _resultWorkedWell;
  String _severity = _severityLow;
  String _reproducibility = _reproducibilityUnknown;
  String _usageImpact = _usageImpactNone;
  String _publishRecommendation = _publishRecommendationYes;
  String _interfaceEvaluation = _interfaceVeryClear;
  String _colorEvaluation = _colorCorrect;
  String _usabilityEvaluation = _usabilityVeryEasy;
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
    _screenNameController.dispose();
    _uxDetailsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollSubmitErrorIntoView() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final context = _submitErrorKey.currentContext;
      if (context == null) {
        return;
      }

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0.95,
        curve: Curves.easeOut,
      );
    });
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
      _applyDraftFieldFallbacks(draft);
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
      final reproducibility = parsed['reproducibility'] as String?;
      final usageImpact = parsed['usageImpact'] as String?;
      final publishRecommendation = parsed['publishRecommendation'] as String?;
        final interfaceEvaluation = parsed['interfaceEvaluation'] as String?;
        final colorEvaluation = parsed['colorEvaluation'] as String?;
        final usabilityEvaluation = parsed['usabilityEvaluation'] as String?;
      _generalResult = _allowedGeneralResult(generalResult) ?? _generalResult;
      _severity = _allowedSeverity(severity) ?? _severity;
      _reproducibility =
          _allowedReproducibility(reproducibility) ?? _reproducibility;
      _usageImpact = _allowedUsageImpact(usageImpact) ?? _usageImpact;
      _publishRecommendation =
          _allowedPublishRecommendation(publishRecommendation) ??
          _publishRecommendation;
        _interfaceEvaluation =
          _allowedInterfaceEvaluation(interfaceEvaluation) ??
          _interfaceEvaluation;
        _colorEvaluation =
          _allowedColorEvaluation(colorEvaluation) ?? _colorEvaluation;
        _usabilityEvaluation =
          _allowedUsabilityEvaluation(usabilityEvaluation) ??
          _usabilityEvaluation;
      _stepsController.text = parsed['steps'] as String? ?? '';
      _suggestionController.text = parsed['suggestion'] as String? ?? '';
      _screenNameController.text = parsed['screenName'] as String? ?? '';
      _uxDetailsController.text = parsed['uxDetails'] as String? ?? '';
    } catch (_) {
      // Keep defaults if payload is malformed.
    }
  }

  void _applyDraftFieldFallbacks(BetaFeedbackReport draft) {
    if (_screenNameController.text.trim().isEmpty && draft.screenName != null) {
      _screenNameController.text = draft.screenName!;
    }
    if (_uxDetailsController.text.trim().isEmpty && draft.uxDetails != null) {
      _uxDetailsController.text = draft.uxDetails!;
    }

    _reproducibility =
        _allowedReproducibility(draft.reproducibility) ?? _reproducibility;
    _usageImpact = _allowedUsageImpact(draft.usageImpact) ?? _usageImpact;
    _publishRecommendation =
        _allowedPublishRecommendation(draft.publishRecommendation) ??
        _publishRecommendation;
    _interfaceEvaluation =
      _allowedInterfaceEvaluation(draft.interfaceEvaluation) ??
      _interfaceEvaluation;
    _colorEvaluation =
      _allowedColorEvaluation(draft.colorEvaluation) ?? _colorEvaluation;
    _usabilityEvaluation =
      _allowedUsabilityEvaluation(draft.usabilityEvaluation) ??
      _usabilityEvaluation;
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

  String? _allowedReproducibility(String? value) {
    switch (value) {
      case _reproducibilityYes:
      case _reproducibilityNo:
      case _reproducibilitySometimes:
      case _reproducibilityUnknown:
        return value;
      default:
        return null;
    }
  }

  String? _allowedUsageImpact(String? value) {
    switch (value) {
      case _usageImpactNone:
      case _usageImpactLittle:
      case _usageImpactHigh:
      case _usageImpactLeave:
        return value;
      default:
        return null;
    }
  }

  String? _allowedPublishRecommendation(String? value) {
    switch (value) {
      case _publishRecommendationYes:
      case _publishRecommendationYesWithAdjustments:
      case _publishRecommendationNotYet:
      case _publishRecommendationNo:
        return value;
      default:
        return null;
    }
  }

  String? _allowedInterfaceEvaluation(String? value) {
    switch (value) {
      case _interfaceVeryClear:
      case _interfaceClear:
      case _interfaceConfusing:
      case _interfaceVeryConfusing:
        return value;
      default:
        return null;
    }
  }

  String? _allowedColorEvaluation(String? value) {
    switch (value) {
      case _colorCorrect:
      case _colorImprove:
      case _colorConfusing:
      case _colorNoHelp:
        return value;
      default:
        return null;
    }
  }

  String? _allowedUsabilityEvaluation(String? value) {
    switch (value) {
      case _usabilityVeryEasy:
      case _usabilityEasy:
      case _usabilityDifficult:
      case _usabilityVeryDifficult:
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
      _submitErrorMessage = null;
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
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _submitErrorMessage = _submitErrorText;
      });
      _scrollSubmitErrorIntoView();
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

    if (widget.config.fieldConfig.showScreenName) {
      payload['screenName'] = _screenNameController.text.trim();
    }
    if (widget.config.fieldConfig.showReproducibility) {
      payload['reproducibility'] = _reproducibility;
    }
    if (widget.config.fieldConfig.showUsageImpact) {
      payload['usageImpact'] = _usageImpact;
    }
    if (widget.config.fieldConfig.showPublishRecommendation) {
      payload['publishRecommendation'] = _publishRecommendation;
    }
    if (widget.config.fieldConfig.showUxDetails) {
      payload['uxDetails'] = _uxDetailsController.text.trim();
    }
    if (widget.config.fieldConfig.showInterfaceEvaluation) {
      payload['interfaceEvaluation'] = _interfaceEvaluation;
    }
    if (widget.config.fieldConfig.showColorEvaluation) {
      payload['colorEvaluation'] = _colorEvaluation;
    }
    if (widget.config.fieldConfig.showUsabilityEvaluation) {
      payload['usabilityEvaluation'] = _usabilityEvaluation;
    }

    final feedbackText = '${_mainCommentController.text.trim()}\n[btf_form_v1]${jsonEncode(payload)}';

    return BetaFeedbackReport(
      appId: widget.config.appId,
      appName: widget.config.appName,
      campaignId: widget.config.campaignId,
      campaignName: widget.config.campaignName,
      userId: widget.userId,
      reportVersion: widget.config.reportVersion,
      feedbackText: feedbackText,
      screenName: widget.config.fieldConfig.showScreenName
          ? _optionalText(_screenNameController.text)
          : null,
      reproducibility: widget.config.fieldConfig.showReproducibility
          ? _reproducibility
          : null,
      usageImpact: widget.config.fieldConfig.showUsageImpact ? _usageImpact : null,
      publishRecommendation: widget.config.fieldConfig.showPublishRecommendation
          ? _publishRecommendation
          : null,
      uxDetails: widget.config.fieldConfig.showUxDetails
          ? _optionalText(_uxDetailsController.text)
          : null,
        interfaceEvaluation: widget.config.fieldConfig.showInterfaceEvaluation
          ? _interfaceEvaluation
          : null,
        colorEvaluation: widget.config.fieldConfig.showColorEvaluation
          ? _colorEvaluation
          : null,
        usabilityEvaluation: widget.config.fieldConfig.showUsabilityEvaluation
          ? _usabilityEvaluation
          : null,
      checklistResponses: Map<String, bool>.from(_checklistSelections),
      deviceTechnicalData: const <String, dynamic>{},
    );
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
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
                      controller: _scrollController,
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
                          if (widget.config.fieldConfig.showScreenName) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _screenNameController,
                              minLines: 1,
                              maxLines: 2,
                              enabled: !(_isSubmitting || _isSavingDraft),
                              decoration: const InputDecoration(
                                labelText: 'En que pantalla ocurrio?',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                          if (widget.config.fieldConfig.showReproducibility) ...[
                            const SizedBox(height: 12),
                            const Text('Se puede repetir?'),
                            _ResultRadioGroup(
                              currentValue: _reproducibility,
                              values: const <String>[
                                _reproducibilityYes,
                                _reproducibilityNo,
                                _reproducibilitySometimes,
                                _reproducibilityUnknown,
                              ],
                              enabled: !(_isSubmitting || _isSavingDraft),
                              onChanged: (value) {
                                setState(() {
                                  _reproducibility = value;
                                });
                              },
                            ),
                          ],
                          if (widget.config.fieldConfig.showUsageImpact) ...[
                            const SizedBox(height: 12),
                            const Text('Esto afecta tus ganas de seguir usando la app?'),
                            _ResultRadioGroup(
                              currentValue: _usageImpact,
                              values: const <String>[
                                _usageImpactNone,
                                _usageImpactLittle,
                                _usageImpactHigh,
                                _usageImpactLeave,
                              ],
                              enabled: !(_isSubmitting || _isSavingDraft),
                              onChanged: (value) {
                                setState(() {
                                  _usageImpact = value;
                                });
                              },
                            ),
                          ],
                          if (widget.config.fieldConfig.showPublishRecommendation) ...[
                            const SizedBox(height: 12),
                            const Text('Recomendarias publicar esta version?'),
                            _ResultRadioGroup(
                              currentValue: _publishRecommendation,
                              values: const <String>[
                                _publishRecommendationYes,
                                _publishRecommendationYesWithAdjustments,
                                _publishRecommendationNotYet,
                                _publishRecommendationNo,
                              ],
                              enabled: !(_isSubmitting || _isSavingDraft),
                              onChanged: (value) {
                                setState(() {
                                  _publishRecommendation = value;
                                });
                              },
                            ),
                          ],
                          if (widget.config.fieldConfig.showUxDetails) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _uxDetailsController,
                              minLines: 2,
                              maxLines: 4,
                              enabled: !(_isSubmitting || _isSavingDraft),
                              decoration: const InputDecoration(
                                labelText:
                                    'Comentarios sobre diseno, claridad o facilidad de uso',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                          if (widget.config.fieldConfig.showInterfaceEvaluation) ...[
                            const SizedBox(height: 12),
                            const Text('Evaluacion de interfaz'),
                            _ResultRadioGroup(
                              currentValue: _interfaceEvaluation,
                              values: const <String>[
                                _interfaceVeryClear,
                                _interfaceClear,
                                _interfaceConfusing,
                                _interfaceVeryConfusing,
                              ],
                              enabled: !(_isSubmitting || _isSavingDraft),
                              onChanged: (value) {
                                setState(() {
                                  _interfaceEvaluation = value;
                                });
                              },
                            ),
                          ],
                          if (widget.config.fieldConfig.showColorEvaluation) ...[
                            const SizedBox(height: 12),
                            const Text('Evaluacion de colores'),
                            _ResultRadioGroup(
                              currentValue: _colorEvaluation,
                              values: const <String>[
                                _colorCorrect,
                                _colorImprove,
                                _colorConfusing,
                                _colorNoHelp,
                              ],
                              enabled: !(_isSubmitting || _isSavingDraft),
                              onChanged: (value) {
                                setState(() {
                                  _colorEvaluation = value;
                                });
                              },
                            ),
                          ],
                          if (widget.config.fieldConfig.showUsabilityEvaluation) ...[
                            const SizedBox(height: 12),
                            const Text('Facilidad de uso'),
                            _ResultRadioGroup(
                              currentValue: _usabilityEvaluation,
                              values: const <String>[
                                _usabilityVeryEasy,
                                _usabilityEasy,
                                _usabilityDifficult,
                                _usabilityVeryDifficult,
                              ],
                              enabled: !(_isSubmitting || _isSavingDraft),
                              onChanged: (value) {
                                setState(() {
                                  _usabilityEvaluation = value;
                                });
                              },
                            ),
                          ],
                          if (_submitErrorMessage != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              key: _submitErrorKey,
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _submitErrorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                          ],
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
