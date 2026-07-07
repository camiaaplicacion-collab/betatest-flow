# EPIC PREVIEW REFORZADO

Proyecto: BetaTest Flow  
Metodo: Metodo Revas  
Version: Alpha 0.2  
Epica: 07  
Nombre: Tester

## Objetivo del documento

Definir funcionalmente la Epica Tester, sin implementacion tecnica, para eliminar ambiguedades y establecer limites claros de alcance en Alpha 0.2.

## 1. Que es un Tester dentro de BetaTest Flow

Un Tester es el actor operativo que ejecuta validaciones funcionales sobre una Beta siguiendo una Lista de pruebas y sus Pasos de prueba definidos por el developer.

## 2. Que problema resuelve

Resuelve la necesidad de ejecucion real de las pruebas. Sin Tester, la planificacion de validacion existe, pero no se transforma en evidencia de comportamiento del producto.

## 3. Por que una Beta necesita Testers

Una Beta necesita Testers para:
- Validar el comportamiento real del producto en uso.
- Detectar fricciones funcionales antes de release.
- Ejecutar escenarios definidos de forma consistente.
- Aportar observaciones de uso desde un rol externo al desarrollo.
- Convertir objetivos de calidad en ejecucion verificable.

## 4. Cual es la responsabilidad del Tester dentro de la arquitectura

Responsabilidad principal:
- Ejecutar pruebas definidas, no disenar pruebas.

Responsabilidades funcionales:
- Aceptar participar en una Beta.
- Recibir la Lista de pruebas asignada.
- Ejecutar cada Paso de prueba segun el orden definido.
- Confirmar avance y finalizacion de ejecucion.
- Aportar la base operativa para la captura posterior de evidencia.

## 5. Como se relaciona con Workspace, Apps, Betas, Goals, Lista de pruebas y Pasos de prueba

- Workspace: es el contexto organizativo donde vive la operacion, pero el Tester no lo administra.
- Apps: es el producto que el Tester valida, pero no configura su definicion.
- Betas: es la ventana de prueba donde el Tester participa y ejecuta.
- Goals: definen que debe validarse; el Tester ejecuta, no redefine objetivos.
- Lista de pruebas: define el conjunto de validaciones que el Tester debe recorrer.
- Pasos de prueba: definen cada accion concreta que el Tester debe realizar.

## 6. Como se relacionara posteriormente con SDK, Reportes, Resultados y Prompt de Correccion

- SDK: capturara evidencia de ejecucion del Tester (eventos, contexto tecnico y trazabilidad).
- Reportes: consolidaran lo ocurrido durante la ejecucion del Tester por beta, lista y paso.
- Resultados: derivaran metricas de cumplimiento, fallas y calidad observada.
- Prompt de Correccion: utilizara hallazgos de ejecucion para proponer mejoras tecnicas y funcionales.

## 7. Que informacion administrara un Tester (modelo funcional)

El Tester administrara solo informacion funcional de participacion y ejecucion:
- Identidad funcional del tester dentro de la beta.
- Referencia a la Beta en la que participa.
- Estado de participacion (invitado, activo, finalizado, rechazado o equivalente funcional).
- Estado de avance de ejecucion sobre Lista de pruebas y Pasos.
- Trazabilidad temporal de participacion (inicio, progreso y cierre).
- Metadato funcional minimo para identificar contexto de ejecucion.

Nota: esta seccion define solo modelo funcional, no esquema tecnico ni persistencia.

## 8. Que informacion NO administrara

El Tester no administrara entidades fuera de su dominio:
- Workspace.
- Apps.
- Betas (solo participa, no administra).
- Goals.
- Lista de pruebas (solo ejecuta, no disena).
- Pasos de prueba (solo ejecuta, no define).
- Resultados (solo genera insumo operativo).
- SDK.
- Reportes.
- Exportaciones.

Tampoco administrara:
- Configuracion global del producto.
- Reglas de arquitectura.
- Decisiones de versionado o gobierno del proyecto.

## 9. Cuales seran las funcionalidades de Alpha 0.2

Alcance funcional esperado para Alpha 0.2:
- Definicion funcional del rol Tester dentro del dominio BetaTest Flow.
- Delimitacion clara de responsabilidades del Tester.
- Integracion conceptual del Tester con Beta, Lista de pruebas y Pasos de prueba.
- Claridad de frontera entre ejecucion de pruebas y diseno de pruebas.
- Base funcional para implementacion futura por historias.

## 10. Que funcionalidades quedan explicitamente fuera del alcance

Fuera de alcance en Alpha 0.2:
- Implementacion tecnica del modulo Tester.
- Gestion real de invitaciones y aceptacion en producto.
- Ejecucion instrumentada por SDK en produccion.
- Generacion automatica de resultados y reportes.
- Automatizacion de asignacion de testers por reglas.
- Analitica avanzada de desempeno por tester.
- Moderacion o reputacion de testers.

## 11. Cuales son las ampliaciones previstas para futuras versiones

Ampliaciones documentadas (sin diseno en esta fase):
- Asignacion inteligente de testers segun perfil de app/beta.
- Seguimiento de cobertura de pruebas por tester y por ciclo.
- Mecanismos de disponibilidad y carga de trabajo de testers.
- Trazabilidad comparativa entre testers en una misma beta.
- Integracion completa con resultados, reportes y recomendacion de correcciones.

## Diferencia entre Paso de prueba y Tester

Definicion conceptual:
- Paso de prueba responde a: Que debe hacerse.
- Tester responde a: Quien ejecuta ese paso.

Ejemplo 1
Paso de prueba: "Ingresar credenciales validas y verificar acceso exitoso".
Tester: "Ana ejecuta el paso en Android 14 y confirma que el login abre Home sin errores".

Ejemplo 2
Paso de prueba: "Solicitar recuperacion de contrasena con correo registrado".
Tester: "Luis ejecuta el paso en iOS y verifica recepcion del correo en menos de 1 minuto".

Ejemplo 3
Paso de prueba: "Agregar producto al carrito y confirmar checkout".
Tester: "Marta ejecuta el flujo completo y valida que el pedido quede en estado confirmado".

Ejemplo 4
Paso de prueba: "Editar perfil y verificar persistencia luego de reiniciar sesion".
Tester: "Diego realiza la edicion, cierra sesion, vuelve a entrar y confirma datos guardados".

Ejemplo 5
Paso de prueba: "Buscar contenido por termino y abrir el primer resultado".
Tester: "Sofia ejecuta la busqueda en web y valida relevancia entre termino y contenido mostrado".

## Ciclo de trabajo del Tester

Flujo funcional completo:

Developer  
↓  
Prepara Beta  
↓  
Publica Beta  
↓  
Tester acepta participar  
↓  
Recibe Lista de pruebas  
↓  
Ejecuta Paso 1  
↓  
Ejecuta Paso 2  
↓  
...  
↓  
Finaliza ejecucion  
↓  
SDK captura evidencia  
↓  
Se generan Resultados

## Principios de diseno del Tester

Reglas funcionales:
- Un Tester ejecuta pruebas, no las disena.
- Un Tester no modifica Goals.
- Un Tester no modifica Listas de pruebas.
- Un Tester sigue exactamente los Pasos definidos.
- Toda evidencia sera capturada posteriormente por el SDK.
- Un Tester no redefine criterios de aceptacion durante la ejecucion.
- Un Tester no altera el orden de pruebas salvo regla explicita futura.

## Cierre funcional de EPIC PREVIEW

La Epica 07 Tester queda funcionalmente definida para Alpha 0.2 con:
- Identidad conceptual clara.
- Frontera de responsabilidad delimitada.
- Diferencia no ambigua entre Paso de prueba y Tester.
- Alcance y fuera de alcance explicitados.
- Trayectoria de evolucion futura documentada.

## Secuencia oficial de ejecucion de la Epica 07

EPIC PREVIEW

↓

H7.1 Crear

↓

H7.2 Editar

↓

H7.3 Archivar

↓

H7.4 Configuracion

↓

H7.5 Informacion

↓

EPIC REVIEW

↓

Congelacion
