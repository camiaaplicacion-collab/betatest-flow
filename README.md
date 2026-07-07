# BetaTest Flow

`betatest_flow` es un SDK Flutter para capturar feedback beta en apps conectadas a Firebase.

## Caracteristicas

- SDK Flutter reutilizable para feedback beta.
- Persistencia en Firebase Firestore mediante repositorio incluido.
- Captura de feedback textual, checklist y datos tecnicos del dispositivo.
- Generacion de reporte estructurado con `markdownReport`.
- Soporte de borrador local con `SharedPreferences`.
- Herramienta de exportacion local (`tools/export_beta_reports.dart`) a JSON, CSV y Markdown.
- Configuracion por app/campana con `BetaTestFlowConfig`.

## Requisitos

- Dart: `^3.11.5`
- Flutter: `>=1.17.0`

## Instalacion

Agregar dependencia en `pubspec.yaml` de la app host:

```yaml
dependencies:
	betatest_flow:
		path: ../betatest_flow
```

Instalar paquetes:

```bash
flutter pub get
```

## Configuracion Firebase

Antes de usar el SDK, la app host debe:

1. Tener proyecto Firebase creado.
2. Tener Firestore habilitado.
3. Tener Firebase configurado en las plataformas objetivo de Flutter.
4. Inicializar Firebase en `main()` antes de usar el repositorio del SDK.
5. Definir reglas de Firestore adecuadas para el entorno beta cerrado.

## Inicializacion

Ejemplo minimo de inicializacion en la app host:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
	runApp(const MyApp());
}
```

## Uso basico

Ejemplo simple de configuracion + boton de feedback:

```dart
import 'package:betatest_flow/betatest_flow.dart';
import 'package:flutter/material.dart';

final config = BetaTestFlowConfig(
	appId: 'demo_app',
	appName: 'Demo App',
	campaignId: 'demo_beta_1',
	campaignName: 'Demo Beta 1',
	reportVersion: '1',
	checklistItems: const [
		BetaChecklistItem(id: 'login', title: 'Login funciona'),
		BetaChecklistItem(id: 'home', title: 'Home carga correctamente'),
	],
);

final repository = FirebaseBetaFeedbackRepository(config: config);

class FeedbackEntryPoint extends StatelessWidget {
	const FeedbackEntryPoint({super.key});

	@override
	Widget build(BuildContext context) {
		return BetaFeedbackButton(
			config: config,
			repository: repository,
			userId: 'demo_user_001',
			email: 'tester@example.com',
		);
	}
}
```

## API recomendada para integracion

Para una integracion basica, se recomienda usar:

- `BetaTestFlowConfig`
- `FirebaseBetaFeedbackRepository`
- `BetaFeedbackButton`
- `BetaChecklistItem`

El paquete exporta otras clases publicas para casos avanzados (por ejemplo modelos, contratos, servicios y hoja de feedback), pero no son necesarias para la integracion basica.

## Flujo recomendado

1. Instalar el paquete en la app Flutter.
2. Configurar Firebase y Firestore en la app host.
3. Inicializar Firebase antes de usar el SDK.
4. Mostrar `BetaFeedbackButton` en un punto de entrada de la UI.
5. Enviar reporte desde el modal; el SDK guarda/actualiza en Firestore y limpia borrador si aplica.

## Manejo de errores

Errores comunes durante integracion:

- `Firebase.initializeApp()` no ejecutado: el repositorio Firestore falla al operar.
- Reglas/permisos de Firestore bloquean escritura: falla `submitReport`.
- Usuario/campana vacios o inconsistentes: genera `reportKey` incorrecto.
- Fallo de persistencia local: `saveDraft` puede lanzar `StateError`.
- Payload local invalido: `getDraft` puede lanzar `FormatException`.

## Licencia

El archivo `LICENSE` del repositorio esta como placeholder (`TODO: Add your license here.`).

## Exportacion local de reportes

La herramienta `tools/export_beta_reports.dart` exporta reportes de Firestore a:

- `exports/beta_reports.json`
- `exports/beta_reports.csv`
- `exports/beta_summary.md`

Comando de ejemplo:

```bash
dart run tools/export_beta_reports.dart \
	--service-account /absolute/path/service-account.json \
	--project-id your-firebase-project \
	--app-id demo_app \
	--campaign-id demo_beta_1
```
