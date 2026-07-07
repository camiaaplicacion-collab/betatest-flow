# EPIC PREVIEW BETAS

Proyecto: BetaTest Flow

Metodo: Metodo Revas

Version: Alpha 0.2

Epic: 03 Betas

Estado: EPIC PREVIEW

## Objetivo del documento

Definir funcionalmente la Epic Betas para habilitar el inicio de la Historia BTF-H3.1 Crear Beta, sin incluir implementacion tecnica ni cambios de arquitectura.

## 1. Que es una Beta dentro de BetaTest Flow

Una Beta es la unidad de iteracion de pruebas cerradas dentro de una App.

Representa una campana de validacion con contexto propio (identidad, estado y trazabilidad) sobre la que se organizan objetivos, lista de pruebas y recoleccion de reportes.

## 2. Que problema resuelve

La Epic Betas resuelve la necesidad de separar y ordenar ciclos de prueba por iteracion dentro de una misma App.

Sin Betas, los reportes y resultados de distintas rondas se mezclan, se pierde trazabilidad temporal y se dificulta comparar avances entre iteraciones.

## 3. Cual es su responsabilidad dentro de la arquitectura

Responsabilidad unica de Betas:
- Gestionar iteraciones beta por App.
- Proveer el contenedor funcional para Goals y Lista de pruebas de cada iteracion.
- Mantener el contexto de referencia para reportes y resultados.

Betas no reemplaza Workspace, no reemplaza Apps, no reemplaza Goals y no reemplaza Reportes.

## 4. Como se relaciona con Workspace y App

Relacion con Workspace:
- Workspace es el contenedor superior.
- Betas no existen de forma directa bajo Workspace; siempre pasan por una App del Workspace.

Relacion con App:
- Una App administra multiples Betas.
- Cada Beta pertenece a una unica App.
- La Beta hereda el contexto organizativo de su App y, por extension, de su Workspace.

## 5. Como se relacionara posteriormente con Goals, Lista de pruebas, SDK, Reportes, Resultados y Exportaciones

Relacion con Goals:
- Cada Beta define el contexto donde se registran Goals.
- Goals dependen de una Beta activa para tener sentido funcional.

Relacion con Lista de pruebas:
- La Lista de pruebas se configura por Beta.
- Los items de prueba responden al alcance funcional de esa iteracion.

Relacion con SDK:
- El SDK consume el contexto oficial de App + Beta para etiquetar correctamente reportes.
- Betas no implementa el SDK; solo administra su referencia funcional.

Relacion con Reportes:
- Reportes se consultan por Beta para mantener trazabilidad de la iteracion.
- Betas aporta el marco de agrupacion de evidencia.

Relacion con Resultados:
- Resultados se consolidan por Beta para evaluar estado de la iteracion.
- Betas permite comparar progreso entre ciclos.

Relacion con Exportaciones:
- Exportaciones operan sobre reportes/resultados filtrados por Beta.
- Betas define el recorte funcional para JSON, CSV y Markdown.

## 6. Que informacion administrara una Beta (modelo funcional)

Modelo funcional minimo de Beta:
- betaId
- appId (referencia funcional a la App propietaria)
- workspaceId (referencia funcional heredada para trazabilidad)
- betaName
- betaStatus (ejemplo funcional: draft, active, archived)
- createdAt
- updatedAt

Nota: Este modelo es solo funcional y contractual para guiar historias; no define estructura tecnica de implementacion.

## 7. Que informacion NO administrara

Una Beta no administra:
- Usuarios
- Workspace
- Apps
- SDK
- Resultados consolidados finales
- Exportaciones
- Permisos avanzados
- Integraciones externas

## 8. Cuales seran las funcionalidades de Alpha 0.2

Segun el contrato vigente, la Epic Betas en Alpha 0.2 cubre:
- Crear Beta por aplicacion
- Editar Beta
- Eliminar Beta
- Asociar cada Beta a su App

Estas funciones se ejecutan dentro del alcance de EPIC 03 y habilitan continuidad hacia Goals y Lista de pruebas.

## 9. Que funcionalidades quedan explicitamente fuera del alcance

Fuera de alcance para Alpha 0.2 en Betas:
- Segmentacion avanzada de audiencias
- Invitaciones automatizadas
- Notificaciones de lanzamiento
- Analitica avanzada de cohortes
- Automatizaciones de ciclo de vida
- Flujos sociales o comunidad

## 10. Ampliaciones previstas para versiones futuras

Ampliaciones previstas (solo referencia documental):
- Estados beta mas ricos con reglas de transicion formal
- Mayor trazabilidad historica entre iteraciones
- Filtros avanzados de comparacion entre Betas
- Automatizaciones operativas aprobadas por version

Estas ampliaciones no se disenan en esta fase y requieren aprobacion formal en backlog, roadmap y decisiones de proyecto.

## Criterio de salida de EPIC PREVIEW

La Epic Betas queda funcionalmente especificada para iniciar BTF-H3.1 Crear Beta sin cambios de arquitectura ni implementacion tecnica en este documento.
