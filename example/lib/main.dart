import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:betatest_flow/betatest_flow.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const BetaTestFlowDemoApp());
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp();
  } on Exception catch (error) {
    throw FlutterError(
      'Firebase initialization failed. Configure Firebase in example app first. Error: $error',
    );
  }
}

const _demoConfig = BetaTestFlowConfig(
  appId: 'demo_app',
  appName: 'Demo App',
  campaignId: 'demo_beta_1',
  campaignName: 'Demo Beta 1',
  reportVersion: '1',
  checklistItems: <BetaChecklistItem>[
    BetaChecklistItem(id: 'login', title: 'Login'),
    BetaChecklistItem(id: 'home', title: 'Home'),
    BetaChecklistItem(id: 'feedback', title: 'Feedback'),
  ],
);

class BetaTestFlowDemoApp extends StatelessWidget {
  const BetaTestFlowDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FirebaseBetaFeedbackRepository(
      config: _demoConfig,
    );

    return MaterialApp(
      title: 'BetaTest Flow SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('BetaTest Flow SDK Demo')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Demo minima de integracion publica del SDK BetaTest Flow.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                BetaFeedbackButton(
                  config: _demoConfig,
                  repository: repository,
                  userId: 'demo_user_001',
                  email: 'tester@example.com',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
