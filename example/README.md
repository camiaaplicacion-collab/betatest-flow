# BetaTest Flow Example

## Que demuestra este ejemplo

Este ejemplo demuestra una integracion publica real del SDK BetaTest Flow en una app Flutter minima:

- Inicializacion de Firebase con `Firebase.initializeApp()`.
- Configuracion con `BetaTestFlowConfig`.
- Repositorio `FirebaseBetaFeedbackRepository`.
- Punto de entrada UI con `BetaFeedbackButton`.

Datos demo usados:

- `userId`: `demo_user_001`
- `email`: `tester@example.com`
- `appId`: `demo_app`
- `appName`: `Demo App`
- `campaignId`: `demo_beta_1`
- `campaignName`: `Demo Beta 1`
- `reportVersion`: `1`
- checklist: `login`, `home`, `feedback`

## Como ejecutarlo

```bash
cd example
flutter pub get
flutterfire configure
flutter run
```

## Que necesita Firebase

Antes de ejecutar:

1. Crear o usar un proyecto Firebase.
2. Configurar FlutterFire para la carpeta `example/`.

```bash
cd example
flutterfire configure
```

3. Verificar que `Firebase.initializeApp()` pueda ejecutarse correctamente en `example/lib/main.dart`.
4. Tener Firestore habilitado y permisos de escritura para la coleccion `beta_reports` segun las reglas del proyecto host.

## Que debe esperar el desarrollador

- Se muestra una pantalla simple con titulo `BetaTest Flow SDK Demo`.
- Se muestra un texto corto que indica que es una demo de integracion.
- Se puede abrir el modal de feedback desde `BetaFeedbackButton` y enviar reporte con los datos demo.

## Que NO demuestra este ejemplo

- No demuestra autenticacion de usuarios.
- No demuestra flujos avanzados de UI fuera del boton/modal de feedback.
- No reemplaza las reglas de seguridad de Firestore del proyecto host.
