# QUALITY GATE

## Proposito

Definir la lista oficial de validaciones necesarias antes de cerrar una Historia, una Epica y una Version.

## Quality Gate para cerrar una Historia

Checklist obligatorio:

- Arquitectura: alineada con PRODUCT_BLUEPRINT vigente.
- Documentacion: actualizada en los documentos oficiales correspondientes.
- flutter analyze: ejecutado sin issues.
- Pruebas manuales: ejecutadas y validadas para el flujo funcional de la historia.
- Backlog actualizado: estado de historia reflejado en MASTER_BACKLOG.
- PROJECT_STATUS actualizado: estado operativo reflejado.
- ROADMAP actualizado: solo si la historia cambia estado de version o hitos.
- Sin errores criticos: funcionales, de integridad o bloqueo operativo.

Cierre permitido:
- Si todos los puntos estan en cumplimiento.

## Quality Gate para cerrar una Epica

Checklist obligatorio:

- Arquitectura: sin contradicciones con PRODUCT_BLUEPRINT.
- Documentacion: historias y estado de epica actualizados.
- flutter analyze: sin issues en el alcance de la epica.
- Pruebas manuales: cobertura de flujos principales de la epica.
- Backlog actualizado: epica y sus historias con estados coherentes.
- PROJECT_STATUS actualizado: reflejo del avance real.
- ROADMAP actualizado: reflejo de progreso por version.
- Sin errores criticos: no existen bloqueos abiertos de severidad critica.

Cierre permitido:
- Si todos los puntos estan en cumplimiento.

## Quality Gate para cerrar una Version

Checklist obligatorio:

- Arquitectura: cumplimiento integral de la version segun PRODUCT_BLUEPRINT.
- Documentacion: completa, vigente y consistente.
- flutter analyze: sin issues en la base de codigo versionada.
- Pruebas manuales: escenarios criticos y principales validados.
- Backlog actualizado: estado final de epicas e historias de la version.
- PROJECT_STATUS actualizado: version y estado general cerrados.
- ROADMAP actualizado: version cerrada con estado correcto.
- Sin errores criticos: cero defectos criticos abiertos.

Cierre permitido:
- Si todos los puntos estan en cumplimiento y existe decision oficial de cierre de version.

## Estado de aprobacion por Sprint

Sprint 1:
- BTF-H1.4 Configuracion General del Workspace: Aprobada
- BTF-H1.5 Informacion del Workspace: Validada
- EPIC 01 Workspace: Lista para EPIC REVIEW
- EPIC 01 Workspace: Aprobada y Congelada
- Confirmacion EPIC 01: Historias H1.1, H1.2, H1.3, H1.4 y H1.5 validadas

Sprint 2:
- BTF-H2.1 Crear App: Validada
- BTF-H2.2 Editar App: Validada
- BTF-H2.3 Archivar App: Validada
- BTF-H2.4 Configuracion General de la App: Validada
- BTF-H2.5 Informacion de la App: Validada
- EPIC 02 Apps: Lista para EPIC REVIEW
- EPIC 02 Apps: Aprobada y Congelada
- Confirmacion EPIC 02: Historias H2.1, H2.2, H2.3, H2.4 y H2.5 validadas

Sprint 3:
- BTF-H3.1 Crear Beta: Validada
- BTF-H3.2 Editar Beta: Validada
- BTF-H3.3 Archivar Beta: Validada
- BTF-H3.4 Configuracion General de la Beta: Validada
- BTF-H3.5 Informacion de la Beta: Validada
- EPIC 03 Betas: Lista para EPIC REVIEW
- EPIC 03 Betas: Aprobada y Congelada
- Confirmacion EPIC 03: Historias H3.1, H3.2, H3.3, H3.4 y H3.5 validadas

Sprint 4:
- BTF-H4.1 Crear Goal: Validada
- BTF-H4.2 Editar Goal: Validada
- BTF-H4.3 Archivar Goal: Validada
- BTF-H4.4 Configuracion General del Goal: Validada
- BTF-H4.5 Informacion del Goal: Validada
- EPIC 04 Goals: Lista para EPIC REVIEW
- EPIC 04 Goals: Aprobada y Congelada
- Confirmacion EPIC 04: Historias H4.1, H4.2, H4.3, H4.4 y H4.5 validadas

Sprint 5:
- BTF-H5.1 Crear Lista de pruebas: Validada
- BTF-H5.2 Editar Lista de pruebas: Validada
- BTF-H5.3 Archivar Lista de pruebas: Validada
- BTF-H5.4 Configuracion General de la Lista de pruebas: Validada
- BTF-H5.5 Informacion de la Lista de pruebas: Validada
- EPIC 05 Lista de pruebas: Lista para EPIC REVIEW
- EPIC 05 Lista de pruebas: Aprobada y Congelada
- Confirmacion EPIC 05: Historias H5.1, H5.2, H5.3, H5.4 y H5.5 validadas

Sprint 6:
- BTF-H6.1 Crear Paso de prueba: Validada
- BTF-H6.2 Editar Paso de prueba: Validada
- BTF-H6.3 Archivar Paso de prueba: Validada
- BTF-H6.4 Configuracion General del Paso de prueba: Validada
- BTF-H6.5 Informacion del Paso de prueba: Validada
- EPIC 06 Pasos de prueba: Lista para EPIC REVIEW
- EPIC 06 Pasos de prueba: Aprobada y Congelada
- Confirmacion EPIC 06: Historias H6.1, H6.2, H6.3, H6.4 y H6.5 validadas

Sprint 7:
- BTF-H7.1 Crear Tester: Validada
- BTF-H7.2 Editar Tester: Validada
- BTF-H7.3 Archivar Tester: Validada
- BTF-H7.4 Configuracion General del Tester: Validada
- BTF-H7.5 Informacion del Tester: Validada
- EPIC 07 Tester: Lista para EPIC REVIEW
- EPIC 07 Tester: Aprobada y Congelada
- Confirmacion EPIC 07: Historias H7.1, H7.2, H7.3, H7.4 y H7.5 validadas

Sprint 8:
- BTF-H8.1 Crear Configuracion SDK: Validada
- BTF-H8.2 Editar Configuracion SDK: Validada
- BTF-H8.3 Archivar Configuracion SDK: Validada
- BTF-H8.4 Configuracion General del SDK: Validada
- BTF-H8.5 Informacion del SDK: Validada
- EPIC 08 SDK: Lista para EPIC REVIEW
- EPIC 08 SDK: Aprobada y Congelada
- Confirmacion EPIC 08: Historias H8.1, H8.2, H8.3, H8.4 y H8.5 validadas

Sprint 9:
- BTF-H9.1 Crear Resultado: Validada
- BTF-H9.2 Editar Resultado: Validada
- BTF-H9.3 Archivar Resultado: Validada
- BTF-H9.4 Configuracion General del Resultado: Validada
- BTF-H9.5 Informacion del Resultado: Validada
- EPIC 09 Resultados: Lista para EPIC REVIEW
- EPIC 09 Resultados: Aprobada y Congelada
- Confirmacion EPIC 09: Historias H9.1, H9.2, H9.3, H9.4 y H9.5 validadas

Sprint 10:
- BTF-H10.1 Crear Reporte: Validada
- BTF-H10.2 Editar Reporte: Validada
- BTF-H10.3 Archivar Reporte: Validada
- BTF-H10.4 Configuracion General del Reporte: Validada
- BTF-H10.5 Informacion del Reporte: Validada
- EPIC 10 Reportes: Lista para EPIC REVIEW
- EPIC 10 Reportes: Aprobada y Congelada
- Confirmacion EPIC 10: Historias H10.1, H10.2, H10.3, H10.4 y H10.5 validadas

Sprint 11:
- BTF-H11.1 Crear Prompt de Correccion: Validada
- BTF-H11.2 Editar Prompt de Correccion: Validada
- BTF-H11.3 Archivar Prompt de Correccion: Validada
- BTF-H11.4 Configuracion General del Prompt de Correccion: Validada
- BTF-H11.5 Informacion del Prompt de Correccion: Validada
- EPIC 11 Prompt de Correccion: Lista para EPIC REVIEW
- EPIC 11 Prompt de Correccion: Aprobada y Congelada
- Confirmacion EPIC 11: Historias H11.1, H11.2, H11.3, H11.4 y H11.5 validadas
