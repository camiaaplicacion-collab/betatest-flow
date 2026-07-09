import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
  } catch (error) {
    if (kIsWeb && _isMissingWebOptionsError(error)) {
      await Firebase.initializeApp(options: _webDemoFirebaseOptions);
      return;
    }
    throw FlutterError(
      'Firebase initialization failed. Configure Firebase in example app first. Error: $error',
    );
  }
}

bool _isMissingWebOptionsError(Object error) {
  return error.toString().contains('FirebaseOptions cannot be null');
}

const _webDemoFirebaseOptions = FirebaseOptions(
  apiKey: 'demo-api-key',
  appId: '1:1234567890:web:betatestflowdemo',
  messagingSenderId: '1234567890',
  projectId: 'betatest-flow-demo',
  authDomain: 'betatest-flow-demo.firebaseapp.com',
  storageBucket: 'betatest-flow-demo.appspot.com',
);

const _demoConfig = BetaTestFlowConfig(
  appId: 'demo_app',
  appName: 'Demo App',
  campaignId: 'demo_beta_1',
  campaignName: 'Demo Beta 1',
  reportVersion: '1',
  fieldConfig: BetaFeedbackFieldConfig(
    showScreenName: true,
    showReproducibility: true,
    showUsageImpact: true,
    showPublishRecommendation: true,
    showUxDetails: true,
    showInterfaceEvaluation: true,
    showColorEvaluation: true,
    showUsabilityEvaluation: true,
  ),
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
