# SDK Roadmap - BetaTest Flow

## 1. Estado actual del SDK

- Version actual: `v0.0.3-beta`.
- Consumidor externo validado: `CUADRIA`.
- Proximo consumidor objetivo: `BUSKIA`.
- Criterio rector de evolucion: no romper compatibilidad hacia atras.

### Contexto de validacion

`BetaTest Flow SDK v0.0.1-rc1` ya fue validado en una aplicacion externa real (`CUADRIA`) usando unicamente la API publica del SDK.

`BUSKIA`, laboratorio original del flujo beta, se adopta como referencia funcional para la evolucion del SDK debido a que su formulario beta legacy es funcionalmente mas completo que la version actual del SDK.

### Estado de cierre de versiones

- ✔ `v0.0.2-alpha` completada: paridad funcional con formulario BUSKIA.
- ✔ `v0.0.3-beta` completada: tooling QA, exportacion offline y reporte ejecutivo.
- Fase activa siguiente: `v0.1.0`.

## 2. Matriz de paridad funcional SDK vs BUSKIA

| Funcionalidad | Estado actual SDK | Prioridad | Complejidad | Version objetivo |
|---|---|---|---|---|
| Boton reutilizable | Disponible en API publica | Alta | Baja | v0.0.2-alpha |
| Configuracion por campana | Parcial (configuracion base) | Alta | Media | v0.0.2-alpha |
| Checklist configurable | Disponible basico | Alta | Media | v0.0.2-alpha |
| Resultado general | Disponible | Alta | Baja | v0.0.2-alpha |
| Gravedad | Disponible | Alta | Baja | v0.0.2-alpha |
| Comentario obligatorio | Parcial (validaciones limitadas) | Alta | Baja | v0.0.2-alpha |
| Pasos para reproducir | No disponible | Alta | Media | v0.0.2-alpha |
| Sugerencia | No disponible | Media | Baja | v0.0.2-alpha |
| Persistencia Firestore | Disponible | Alta | Media | v0.0.2-alpha |
| Markdown automatico | Disponible basico | Media | Baja | v0.0.2-alpha |
| Informacion tecnica | Disponible parcial | Alta | Media | v0.0.2-alpha |
| Un reporte por usuario | Disponible basico | Alta | Media | v0.0.2-alpha |
| Evaluacion de interfaz | No disponible | Media | Baja | v0.0.2-alpha |
| Evaluacion de colores | No disponible | Media | Baja | v0.0.2-alpha |
| Facilidad de uso | No disponible | Media | Baja | v0.0.2-alpha |
| Observacion UX | No disponible | Media | Baja | v0.0.2-alpha |
| Repetibilidad del problema | No disponible | Alta | Baja | v0.0.2-alpha |
| Impacto para continuar usando la app | No disponible | Alta | Media | v0.0.2-alpha |
| Pantalla donde ocurrio | No disponible | Alta | Baja | v0.0.2-alpha |
| Calificacion general | Disponible parcial | Alta | Baja | v0.0.2-alpha |
| Recomendacion para publicar | No disponible | Alta | Baja | v0.0.2-alpha |
| Markdown enriquecido | No disponible | Media | Media | v0.0.3-beta |
| Autosave continuo | No disponible | Media | Alta | v0.0.3-beta |

## 3. Roadmap de versiones

### v0.0.2-alpha

Estado: ✔ Completada.

**Objetivo:** paridad funcional con BUSKIA.

Alcance de planificacion:
- Cerrar brechas funcionales prioritarias de la matriz de paridad.
- Mantener intacta la API publica existente.
- Garantizar migracion no disruptiva para consumidores actuales.

### v0.0.3-beta

Estado: ✔ Completada.

**Objetivo:** herramientas QA y exportacion.

Alcance de planificacion:
- Consolidar capacidades de soporte QA sobre el flujo de feedback.
- Introducir capacidades de exportacion en formatos operativos.
- Mejorar calidad y completitud de reportes para equipos de producto.

### v0.1.0

Estado: Fase activa siguiente.

**Objetivo:** SDK reutilizable para multiples equipos y aplicaciones.

Alcance de planificacion:
- Estandarizar componentes y contratos para adopcion transversal.
- Fortalecer configurabilidad para escenarios de negocio diversos.
- Preparar base estable para escalamiento organizacional.

### v1.0.0

**Objetivo:** plataforma profesional de beta testing.

Alcance de planificacion:
- Consolidar el SDK como plataforma madura y confiable.
- Integrar analitica, trazabilidad y capacidades avanzadas de operacion.
- Formalizar estandares de calidad, compatibilidad y evolucion.

## 4. Reglas de evolucion del SDK

- Toda nueva capacidad debe ser opcional.
- No romper consumidores existentes.
- BUSKIA solo migrara al SDK cuando exista paridad funcional o superior.
- CUADRIA no debe requerir cambios obligatorios.
- La API publica debe mantenerse estable salvo justificacion tecnica.

## 5. Futuras capacidades (planificacion, sin implementacion)

- Dashboard Web.
- Exportador JSON.
- Exportador CSV.
- Exportador Markdown.
- Exportador PDF.
- Estadisticas automaticas.
- Resumen por IA.
- Deteccion de errores repetidos.
- Ranking de gravedad.
- Ranking por pantalla.
- Capturas opcionales.
- Adjuntos opcionales.
- Logs automaticos.
- Crash Reports.
- Analytics de campanas.
- Historial de campanas.
- Comparacion entre campanas.
- Metricas de estabilidad.
- API publica.
- SDK para multiples aplicaciones.
- Configuracion por tema.
- Internacionalizacion.
- Plugins Flutter.

## Criterio de ejecucion

Este documento define planificacion y direccion de producto para la evolucion del SDK. No implica implementacion tecnica inmediata ni cambios directos en codigo, infraestructura o contratos actuales.
