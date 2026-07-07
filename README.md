# BetaTest Flow SDK (MVP)

`betatest_flow` is a reusable Flutter SDK for collecting beta feedback in apps that use Firebase.

This repository currently includes the **initial MVP package structure** and **base domain models** only.

## Current scope

- Generic SDK config model (`BetaTestFlowConfig`)
- Feedback report model (`BetaFeedbackReport`)
- Checklist item model (`BetaChecklistItem`)
- Base repository contract (`BetaFeedbackRepository`)
- Base service contract (`BetaTestFlowService`)
- Automatic markdown generation for reports (`markdownReport`)

## Out of scope for this phase

- Full UI flows
- Dashboards
- AI processing
- Product-specific logic from any app

## Architecture

```text
lib/
	betatest_flow.dart
	src/
		config/
		data/
		domain/
		presentation/
		utils/
```

## Basic usage

```dart
import 'package:betatest_flow/betatest_flow.dart';

final config = BetaTestFlowConfig(
	appId: 'my_app',
	appName: 'My App',
	campaignId: 'onboarding_v1',
	campaignName: 'Onboarding V1',
	checklistItems: const [
		BetaChecklistItem(id: 'login', title: 'Login flow works'),
	],
	reportVersion: 'v1',
);
```

## Next implementation steps

- Add local draft persistence implementation
- Add Firestore repository implementation
- Add reusable feedback button/modal widgets

## Local Export Tool

Use `tools/export_beta_reports.dart` to export Firestore beta reports into local analyzable files.

### What it generates

- `exports/beta_reports.json`
- `exports/beta_reports.csv`
- `exports/beta_summary.md`

### Filters supported

- `--app-id`
- `--campaign-id`

### Requirements

- Firebase service account JSON file with Firestore read access
- `project_id` in the JSON or provided via `--project-id`

### Example command

```bash
dart run tools/export_beta_reports.dart \
	--service-account /absolute/path/service-account.json \
	--project-id your-firebase-project \
	--app-id demo_app \
	--campaign-id demo_beta_1
```

You can also rely on `GOOGLE_APPLICATION_CREDENTIALS`:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/absolute/path/service-account.json
dart run tools/export_beta_reports.dart --project-id your-firebase-project
```
