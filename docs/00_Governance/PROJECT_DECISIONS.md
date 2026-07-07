# PROJECT DECISIONS

## Proposito

Este documento define la estructura oficial para registrar todas las decisiones futuras del proyecto BetaTest Flow.

## Regla de uso

Cada decision debe registrarse usando exactamente la plantilla oficial de este documento.

## Plantilla oficial de decision

Numero: DEC-XXX

Fecha: YYYY-MM-DD

Version: Alpha 0.2 | Alpha 0.3 | Beta 1.0 | Release 1.0

Titulo: <titulo corto y unico>

Motivo: <razon funcional de la decision>

Impacto: <impacto en alcance, backlog, arquitectura aprobada o plan de trabajo>

Estado: Propuesta | Aprobada | Rechazada | Reemplazada

---

## Registro de decisiones

(Registrar aqui las decisiones futuras usando la plantilla oficial)

### DEC-001

Numero: DEC-001

Fecha: 2026-07-01

Version: Alpha 0.2

Titulo: La Configuracion General del Workspace tendra responsabilidad unica

Motivo: Mantener separacion clara de responsabilidades y evitar mezclar configuracion del Workspace con modulos fuera de su alcance.

Impacto: La Historia BTF-H1.4 queda acotada a configuracion propia del Workspace, sin extenderse a Apps, SDK, permisos o integraciones.

Estado: Aprobada

### DEC-005

Numero: DEC-005

Fecha: 2026-07-03

Version: Alpha 0.2

Titulo: Ciclo de vida base unificado para Pasos de prueba

Motivo: Mantener consistencia del dominio y reutilizacion del patron oficial del Metodo Revas.

Impacto: Pasos de prueba seguira el mismo ciclo de vida base que Workspace, Apps, Betas, Goals y Lista de pruebas: crear, editar, archivar, configuracion e informacion.

Estado: Aprobada

### DEC-006

Numero: DEC-006

Fecha: 2026-07-03

Version: Alpha 0.2

Titulo: Ciclo de vida base unificado para Tester

Motivo: Mantener consistencia del dominio y reutilizacion del patron oficial del Metodo Revas.

Impacto: Tester seguira el mismo ciclo base que Workspace, Apps, Betas, Goals, Lista de pruebas y Pasos de prueba: crear, editar, archivar, configuracion e informacion.

Estado: Aprobada

### DEC-007

Numero: DEC-007

Fecha: 2026-07-06

Version: Alpha 0.2

Titulo: Ciclo de vida base unificado para SDK

Motivo: Mantener una arquitectura uniforme y facilitar la evolucion del sistema.

Impacto: El componente SDK seguira el mismo ciclo base que todas las entidades y componentes del Metodo Revas: crear, editar, archivar, configuracion e informacion.

Estado: Aprobada

### DEC-008

Numero: DEC-008

Fecha: 2026-07-06

Version: Alpha 0.2

Titulo: Ciclo de vida base unificado para Resultados

Motivo: Mantener uniformidad arquitectonica y preservar la separacion entre evidencia, resultados y analisis.

Impacto: Resultados seguira el mismo ciclo base que todas las entidades y componentes del Metodo Revas: crear, editar, archivar, configuracion e informacion.

Estado: Aprobada

### DEC-009

Numero: DEC-009

Fecha: 2026-07-06

Version: Alpha 0.2

Titulo: Ciclo base unificado para Reportes

Contenido: La entidad Reportes adopta oficialmente el ciclo estandar del Metodo Revas: Crear -> Editar -> Archivar -> Configuracion General -> Informacion.

Motivo: Mantener uniformidad arquitectonica, separacion de responsabilidades y consistencia entre todas las entidades administradas por BetaTest Flow.

Impacto: Reportes seguira oficialmente el ciclo base del Metodo Revas: crear, editar, archivar, configuracion general e informacion.

Estado: Aprobada

### DEC-010

Numero: DEC-010

Fecha: 2026-07-07

Version: Alpha 0.2

Titulo: Ciclo base unificado para Prompt de Correccion

Contenido: Prompt de Correccion adopta el ciclo base del Metodo Revas: Crear -> Editar -> Archivar -> Configuracion General -> Informacion.

Motivo: Mantener trazabilidad, preservar la separacion entre Reportes, Prompt de Correccion y decision final del Developer.

Impacto: Prompt de Correccion seguira oficialmente el ciclo base del Metodo Revas: crear, editar, archivar, configuracion general e informacion.

Estado: Aprobada

### DEC-011

Numero: DEC-011

Fecha: 2026-07-07

Version: Alpha 0.2

Titulo: Sincronizacion documental obligatoria tras Final Review

Motivo: Corregir desalineaciones detectadas entre documentos de gobierno al cierre de Alpha 0.2.

Impacto: A partir de este cierre, cualquier ajuste post-review debe sincronizar en el mismo ciclo `MASTER_BACKLOG`, `ROADMAP`, `QUALITY_GATE` y `PROJECT_DECISIONS`, sin introducir cambios de alcance ni funcionalidades nuevas.

Estado: Aprobada

### DEC-012

Numero: DEC-012

Fecha: 2026-07-07

Version: Alpha 0.2

Titulo: Cierre formal de epicas requiere estado congelado y confirmacion explicita

Motivo: Evitar cierres parciales de epicas cuando faltan evidencias formales de validacion en la gobernanza del proyecto.

Impacto: El cierre de una epica queda formalmente completo solo cuando `QUALITY_GATE` registra "Aprobada y Congelada" y una linea de confirmacion de historias validadas, manteniendo coherencia con `MASTER_BACKLOG` y `ROADMAP`.

Estado: Aprobada

### DEC-004

Numero: DEC-004

Fecha: 2026-07-03

Version: Alpha 0.2

Titulo: Ciclo de vida base unificado para Lista de pruebas

Motivo: Mantener consistencia del dominio y reutilizacion del patron oficial del Metodo Revas.

Impacto: Lista de pruebas seguira el mismo ciclo de vida base que Workspace, Apps, Betas y Goals: crear, editar, archivar, configuracion e informacion.

Estado: Aprobada

### DEC-003

Numero: DEC-003

Fecha: 2026-07-02

Version: Alpha 0.2

Titulo: Ciclo de vida base unificado para Goals

Motivo: Mantener consistencia del dominio y reutilizacion del patron oficial del Metodo Revas.

Impacto: Goals seguira el mismo ciclo de vida base que Workspace, Apps y Betas: crear, editar, archivar, configuracion e informacion.

Estado: Aprobada

### DEC-002

Numero: DEC-002

Fecha: 2026-07-01

Version: Alpha 0.2

Titulo: Ciclo de vida base unificado para Apps y Workspace

Motivo: Mantener consistencia funcional y reducir complejidad de uso y desarrollo.

Impacto: Apps seguira el mismo ciclo de vida base que Workspace: crear, editar, archivar, configurar e informar.

Estado: Aprobada
