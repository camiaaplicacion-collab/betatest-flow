# EPIC PREVIEW GOALS

Proyecto: BetaTest Flow

Metodo: Metodo Revas

Version: Alpha 0.2

Epic: 04 Goals

Estado: EPIC PREVIEW

## Objetivo del documento

Definir funcionalmente la Epic Goals para habilitar el inicio de la Historia BTF-H4.1 Crear Goal, sin incluir implementacion tecnica ni cambios de arquitectura.

## 1. Que es un Goal dentro de BetaTest Flow

Un Goal es un objetivo funcional de validacion dentro de una Beta.

Define que se desea comprobar durante la iteracion de prueba para orientar a Tester y estructurar la evaluacion.

Ejemplos de Goals:
- Validar inicio de sesion.
- Validar recuperacion de contrasena.
- Validar pagos.
- Validar rendimiento.
- Validar notificaciones.
- Validar estabilidad.

Un Goal NO representa una tarea de desarrollo.
Un Goal NO representa una pantalla.
Un Goal SI representa aquello que el Developer desea validar durante una Beta.

## 2. Que problema resuelve

La Epic Goals resuelve la falta de foco en las pruebas beta.

Sin Goals, la recoleccion de evidencia se vuelve difusa, los reportes pierden contexto y las decisiones de correccion se basan en observaciones desordenadas.

## 3. Por que una Beta necesita Goals

Una Beta necesita Goals para:
- Delimitar el alcance funcional de la iteracion.
- Priorizar lo que Tester debe validar.
- Alinear la Lista de pruebas con objetivos concretos.
- Facilitar lectura de reportes y resultados por objetivo.

Sin Goals, la Beta existe como contenedor, pero sin direccion operativa clara.

## 4. Cual es la responsabilidad de un Goal dentro de la arquitectura

Responsabilidad unica de Goals:
- Definir el objetivo funcional de validacion de cada Beta.
- Servir como referencia para Lista de pruebas, reportes y resultados.

Goals no reemplaza Betas, no reemplaza Lista de pruebas y no reemplaza Reportes.

## 5. Como se relaciona con Workspace, Apps y Betas

Relacion con Workspace:
- Workspace es el contexto superior de organizacion.
- Goals no se crean directamente en Workspace.

Relacion con Apps:
- Apps organizan productos y sus Betas.
- Goals no pertenecen directamente a la App, sino a una Beta de esa App.

Relacion con Betas:
- Cada Goal pertenece a una Beta.
- Una Beta puede contener uno o varios Goals segun el alcance aprobado.
- Goals dan direccion funcional a la iteracion beta.

## 6. Como se relacionara posteriormente con Lista de pruebas, SDK, Reportes, Resultados y Prompt de Correccion

Relacion con Lista de pruebas:
- La Lista de pruebas se construye a partir de Goals.
- Cada item de prueba debe responder a un objetivo funcional definido.

Relacion con SDK:
- El SDK no define Goals.
- El SDK ejecuta captura de evidencia dentro del contexto funcional establecido por Goals.

Relacion con Reportes:
- Los reportes se interpretan contra Goals para saber si el objetivo fue validado o presenta fallas.

Relacion con Resultados:
- Resultados consolidan estado de validacion por Goal dentro de la Beta.

Relacion con Prompt de Correccion:
- El Prompt de Correccion utiliza hallazgos alineados a Goals para generar instrucciones de mejora mas precisas.

## 7. Que informacion administrara un Goal (modelo funcional)

Modelo funcional minimo de Goal:
- goalId
- betaId (referencia funcional a la Beta propietaria)
- goalTitle
- goalDescription
- goalStatus (ejemplo funcional: active, archived)
- createdAt
- updatedAt

Nota: Este modelo es funcional y contractual. No define implementacion tecnica.

## 8. Que informacion NO administrara

Un Goal no administra:
- Usuarios
- Workspace
- Apps
- Betas como entidad de ciclo de vida
- SDK
- Resultados consolidados finales
- Exportaciones
- Permisos avanzados
- Integraciones externas

## 9. Cuales seran las funcionalidades de Alpha 0.2

Segun contrato vigente (MASTER_BACKLOG), la Epic Goals en Alpha 0.2 cubre:
- Registrar objetivo principal de una Beta.
- Editar objetivo durante fase activa.
- Consultar objetivo desde modulos de pruebas y resultados.

Estas funcionalidades mantienen Goals como modulo funcional simple y orientador del ciclo beta.

## 10. Que funcionalidades quedan explicitamente fuera del alcance

Fuera de alcance para Alpha 0.2 en Goals:
- Objetivos multinivel complejos.
- Arboles de metricas.
- Reglas de evaluacion automatica.
- Scoring automatico por IA.
- Dashboards avanzados de cumplimiento por objetivo.

## 11. Cuales son las ampliaciones previstas para futuras versiones

Ampliaciones previstas (solo referencia documental):
- Mayor profundidad en estado y trazabilidad de Goals.
- Relacion mas avanzada entre Goals y resultados comparativos.
- Priorizacion y agrupacion extendida de objetivos por iteracion.
- Automatizaciones de analisis aprobadas por version.

Estas ampliaciones no se disenan en esta fase y requieren aprobacion formal en backlog, roadmap y decisiones del proyecto.

## Criterio de salida de EPIC PREVIEW

La Epic Goals queda funcionalmente especificada para iniciar BTF-H4.1 Crear Goal sin cambios de arquitectura ni implementacion tecnica en este documento.
