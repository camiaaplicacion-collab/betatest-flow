# CHANGELOG

## Proposito

Este documento define la estructura oficial para registrar cambios del producto por version.

## Regla de uso

Solo registrar cambios aprobados y cerrados por version.

## Alpha 0.1

Cambios:
- <pendiente de registro oficial>

Estado:
- Cerrada

## Alpha 0.2

Cambios:
- BTF-H1.4 implementada y aprobada: Configuracion General del Workspace.
- BTF-H1.5 implementada y validada: Informacion del Workspace.
- BTF-H2.1 implementada y validada: Crear App.
- BTF-H2.2 implementada y validada: Editar App.
- BTF-H2.3 Archivar App implementada y validada.
- Archivado logico.
- Confirmacion previa.
- Actualizacion de updatedAt.
- Conservacion de appId, workspaceId y createdAt.
- BTF-H2.4 Configuracion General de la App implementada y validada.
- primaryColor agregado al modelo App.
- description editable.
- updatedAt actualizado.
- appId, workspaceId, status y createdAt conservados.
- BTF-H2.5 Informacion de la App implementada y validada.
- EPIC 02 Apps completada, revisada y congelada en Alpha 0.2.
- BTF-H3.1 Crear Beta implementada y validada.
- BTF-H3.2 Editar Beta implementada y validada.
- BTF-H3.3 Archivar Beta implementada y validada.
- archivado logico.
- transicion draft/active a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de betaId, appId y createdAt.
- BTF-H3.4 Configuracion General de la Beta implementada y validada.
- primaryColor agregado al modelo Beta.
- description editable.
- updatedAt actualizado.
- betaId, appId, status y createdAt conservados.
- BTF-H3.5 Informacion de la Beta implementada y validada.
- BTF-H4.1 Crear Goal implementada y validada.
- BTF-H4.2 Editar Goal implementada y validada.
- BTF-H4.3 Archivar Goal implementada y validada.
- archivado logico.
- transicion active a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de goalId, betaId y createdAt.
- BTF-H4.4 Configuracion General del Goal implementada y validada.
- primaryColor agregado al modelo Goal.
- description editable.
- updatedAt actualizado.
- goalId, betaId, status y createdAt conservados.
- BTF-H4.5 Informacion del Goal implementada y validada.
- EPIC 04 Goals completada, revisada y congelada en Alpha 0.2.
- BTF-H5.1 Crear Lista de pruebas implementada y validada.
- BTF-H5.2 Editar Lista de pruebas implementada y validada.
- BTF-H5.3 Archivar Lista de pruebas implementada y validada.
- archivado logico.
- transicion active a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de checklistId, goalId y createdAt.
- BTF-H5.4 Configuracion General de la Lista de pruebas implementada y validada.
- primaryColor agregado al modelo Checklist.
- description editable.
- updatedAt actualizado.
- checklistId, goalId, status y createdAt conservados.
- BTF-H5.5 Informacion de la Lista de pruebas implementada y validada.
- EPIC 05 Lista de pruebas completada, revisada y congelada en Alpha 0.2.
- BTF-H6.1 Crear Paso de prueba implementada y validada.
- testStepId automatico.
- checklistId obligatorio.
- status inicial pending.
- validacion de Checklist existente.
- BTF-H6.2 Editar Paso de prueba implementada y validada.
- BTF-H6.3 Archivar Paso de prueba implementada y validada.
- archivado logico.
- transicion pending a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de testStepId, checklistId y createdAt.
- BTF-H6.4 Configuracion General del Paso de prueba implementada y validada.
- primaryColor agregado al modelo TestStep.
- description editable.
- updatedAt actualizado.
- testStepId, checklistId, status y createdAt conservados.
- BTF-H6.5 Informacion del Paso de prueba implementada y validada.
- EPIC 06 Pasos de prueba completada, revisada y congelada en Alpha 0.2.
- BTF-H7.1 Crear Tester implementada y validada.
- testerId automatico.
- betaId obligatorio.
- status inicial invited.
- validacion de Beta existente.
- BTF-H7.2 Editar Tester implementada y validada.
- BTF-H7.3 Archivar Tester implementada y validada.
- archivado logico.
- transicion invited a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de testerId, betaId y createdAt.
- BTF-H7.4 Configuracion General del Tester implementada y validada.
- primaryColor agregado al modelo Tester.
- email editable.
- updatedAt actualizado.
- testerId, betaId, status y createdAt conservados.
- BTF-H7.5 Informacion del Tester implementada y validada.
- EPIC 07 Tester completada, revisada y congelada en Alpha 0.2.
- BTF-H8.1 Crear Configuracion SDK implementada y validada.
- sdkId automatico.
- betaId obligatorio.
- status inicial active.
- validacion de Beta existente.
- BTF-H8.2 Editar Configuracion SDK implementada y validada.
- BTF-H8.3 Archivar Configuracion SDK implementada y validada.
- archivado logico.
- transicion active a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de sdkId, betaId y createdAt.
- BTF-H8.4 Configuracion General del SDK implementada y validada.
- primaryColor agregado al modelo SDKConfiguration.
- description editable.
- updatedAt actualizado.
- sdkId, betaId, status y createdAt conservados.
- BTF-H8.5 Informacion del SDK implementada y validada.
- EPIC 08 SDK completada, revisada y congelada en Alpha 0.2.
- BTF-H9.1 Crear Resultado implementada y validada.
- resultId automatico.
- sdkId obligatorio.
- testerId obligatorio.
- status inicial pending.
- validacion de SDK y Tester existentes.
- BTF-H9.2 Editar Resultado implementada y validada.
- BTF-H9.3 Archivar Resultado implementada y validada.
- archivado logico.
- transicion pending a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de resultId, sdkId, testerId y createdAt.
- BTF-H9.4 Configuracion General del Resultado implementada y validada.
- description agregado al modelo Result.
- primaryColor agregado al modelo Result.
- updatedAt actualizado.
- resultId, sdkId, testerId, status y createdAt conservados.
- BTF-H9.5 Informacion del Resultado implementada y validada.
- EPIC 09 Resultados completada, revisada y congelada en Alpha 0.2.
- BTF-H10.1 Crear Reporte implementada y validada.
- reportId automatico.
- resultId obligatorio.
- title obligatorio.
- status inicial draft.
- validacion de Resultado existente.
- BTF-H10.2 Editar Reporte implementada y validada.
- BTF-H10.3 Archivar Reporte implementada y validada.
- archivado logico.
- transicion draft a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de reportId, resultId y createdAt.
- BTF-H10.4 Configuracion General del Reporte implementada y validada.
- description agregado al modelo Report.
- primaryColor agregado al modelo Report.
- updatedAt actualizado.
- reportId, resultId, status y createdAt conservados.
- BTF-H10.5 Informacion del Reporte implementada y validada.
- EPIC 10 Reportes completada, revisada y congelada en Alpha 0.2.
- BTF-H11.1 Crear Prompt de Correccion implementada y validada.
- correctionPromptId automatico.
- reportId obligatorio.
- title obligatorio.
- prompt obligatorio.
- status inicial draft.
- validacion de Reporte existente.
- BTF-H11.2 Editar Prompt de Correccion implementada y validada.
- BTF-H11.3 Archivar Prompt de Correccion implementada y validada.
- archivado logico.
- transicion draft a archived.
- confirmacion previa.
- updatedAt actualizado.
- conservacion de correctionPromptId, reportId y createdAt.
- BTF-H11.4 Configuracion General del Prompt de Correccion implementada y validada.
- description agregado al modelo CorrectionPrompt.
- primaryColor agregado al modelo CorrectionPrompt.
- updatedAt actualizado.
- correctionPromptId, reportId, status, createdAt y title conservados.
- BTF-H11.5 Informacion del Prompt de Correccion implementada y validada.
- EPIC 11 Prompt de Correccion completada, revisada y congelada en Alpha 0.2.

Estado:
- En curso

## Alpha 0.3

Cambios:
- <pendiente de registro oficial>

Estado:
- Planificada

## Beta 1.0

Cambios:
- <pendiente de registro oficial>

Estado:
- Planificada

## Release 1.0

Cambios:
- <pendiente de registro oficial>

Estado:
- Planificada
