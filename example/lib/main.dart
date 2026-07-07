import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/data/repositories/correction_prompts/firestore_correction_prompt_repository.dart';
import 'src/presentation/controllers/correction_prompts/correction_prompt_information_controller.dart';
import 'src/presentation/screens/correction_prompts/correction_prompt_information_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const WorkspaceApp());
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

class WorkspaceApp extends StatelessWidget {
  const WorkspaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final correctionPromptRepository = FirestoreCorrectionPromptRepository();
    final controller = CorrectionPromptInformationController(
      correctionPromptRepository: correctionPromptRepository,
    );

    return MaterialApp(
      title: 'BetaTest Flow - Workspace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: CorrectionPromptInformationScreen(
        controller: controller,
      ),
    );
  }
}
