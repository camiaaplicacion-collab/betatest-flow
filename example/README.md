# BetaTest Flow Example

This app demonstrates how an external Flutter developer integrates `betatest_flow` with Firebase.

## What this example validates

- `FirebaseBetaFeedbackRepository`
- `BetaTestFlowConfig`
- `BetaFeedbackButton` + `BetaFeedbackSheet`
- Dynamic checklist from config
- Persistent draft with SharedPreferences
- Firestore submission using unique `reportKey` as `documentId`
- Automatic technical data enrichment via `DeviceInfoService`

## Demo user/config used

- `userId`: `demo_user_001`
- `email`: `tester@example.com`
- `appId`: `demo_app`
- `appName`: `Demo App`
- `campaignId`: `demo_beta_1`
- `campaignName`: `Demo Beta 1`
- `reportVersion`: `1`
- checklist ids: `login`, `home`, `profile`, `payments`, `notifications`, `design`

## Firebase setup

1. Create a Firebase project.
2. Add Android/iOS/Web app entries as needed.
3. Configure FlutterFire for this example folder.

```bash
cd example
flutterfire configure
```

4. Ensure `lib/main.dart` initializes Firebase.
5. For Android/iOS, ensure platform Firebase files are generated and linked.
6. Create Firestore database and allow writes for test users (dev rules only).

Suggested dev collection/document pattern used by SDK:

- Collection: `beta_reports` (or `config.firebaseCollection`)
- Document ID: `{campaignId}_{userId}`

## Run example

```bash
cd example
flutter pub get
flutter run
```
