import 'package:flutter/material.dart';

import '../../config/beta_test_flow_config.dart';
import '../../domain/repositories/beta_feedback_repository.dart';
import 'beta_feedback_sheet.dart';

class BetaFeedbackButton extends StatelessWidget {
  const BetaFeedbackButton({
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
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return BetaFeedbackSheet(
            config: config,
            repository: repository,
            userId: userId,
            email: email,
          );
        },
      ),
      style: config.primaryColor == null
          ? null
          : ElevatedButton.styleFrom(
              backgroundColor: config.primaryColor,
              foregroundColor: Colors.white,
            ),
      child: const Text('Enviar feedback beta'),
    );
  }
}
