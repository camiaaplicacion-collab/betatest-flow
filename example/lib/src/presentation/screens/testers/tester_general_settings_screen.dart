import 'package:flutter/material.dart';

import '../../../domain/models/testers/tester_model.dart';
import '../../controllers/testers/tester_general_settings_controller.dart';

class TesterGeneralSettingsScreen extends StatefulWidget {
  const TesterGeneralSettingsScreen({
    super.key,
    required this.controller,
  });

  final TesterGeneralSettingsController controller;

  @override
  State<TesterGeneralSettingsScreen> createState() =>
      _TesterGeneralSettingsScreenState();
}

class _TesterGeneralSettingsScreenState extends State<TesterGeneralSettingsScreen> {
  final _loadFormKey = GlobalKey<FormState>();
  final _settingsFormKey = GlobalKey<FormState>();
  final _testerIdController = TextEditingController();
  final _emailController = TextEditingController();

  TesterModel? _tester;
  bool _isLoading = false;
  bool _isSaving = false;
  int _selectedColor = _palette.first.value;

  static const List<_ColorOption> _palette = [
    _ColorOption(label: 'Teal', value: 0xFF0F766E),
    _ColorOption(label: 'Blue', value: 0xFF1D4ED8),
    _ColorOption(label: 'Green', value: 0xFF15803D),
    _ColorOption(label: 'Orange', value: 0xFFEA580C),
    _ColorOption(label: 'Red', value: 0xFFB91C1C),
  ];

  @override
  void dispose() {
    _testerIdController.dispose();
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
          _emailController.clear();
          _selectedColor = _palette.first.value;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tester no encontrado.')),
        );
        return;
      }

      setState(() {
        _tester = tester;
        _emailController.text = tester.email;
        _selectedColor = _resolveColor(tester.primaryColor);
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

  Future<void> _saveGeneralSettings() async {
    final tester = _tester;
    if (tester == null || _isLoading || _isSaving) {
      return;
    }

    final valid = _settingsFormKey.currentState?.validate() ?? false;
    if (!valid) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = await widget.controller.updateTesterGeneralSettings(
        testerId: tester.testerId,
        email: _emailController.text,
        primaryColor: _selectedColor,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _tester = updated;
        _emailController.text = updated.email;
        _selectedColor = _resolveColor(updated.primaryColor);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuracion general del Tester actualizada correctamente.'),
        ),
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
        const SnackBar(
          content: Text('No fue posible guardar la configuracion general del Tester.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  int _resolveColor(int colorValue) {
    if (_palette.any((item) => item.value == colorValue)) {
      return colorValue;
    }
    return _palette.first.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion General del Tester'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historia BTF-H7.4',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualiza y administra la configuracion basica del Tester.',
              ),
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
                          final normalized = (value ?? '').trim();
                          if (normalized.isEmpty) {
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
                  key: _settingsFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ReadOnlyField(
                        label: 'displayName actual',
                        value: _tester!.displayName,
                      ),
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
                      DropdownButtonFormField<int>(
                        initialValue: _selectedColor,
                        decoration: const InputDecoration(
                          labelText: 'Color principal',
                          border: OutlineInputBorder(),
                        ),
                        items: _palette
                            .map(
                              (item) => DropdownMenuItem<int>(
                                value: item.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: Color(item.value),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(item.label),
                                  ],
                                ),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: _isSaving
                            ? null
                            : (value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedColor = value;
                                });
                              },
                        validator: (value) {
                          if (value == null) {
                            return 'Color obligatorio';
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
                          onPressed:
                              _isSaving || _isLoading ? null : _saveGeneralSettings,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Guardar configuracion general'),
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

class _ColorOption {
  const _ColorOption({required this.label, required this.value});

  final String label;
  final int value;
}
