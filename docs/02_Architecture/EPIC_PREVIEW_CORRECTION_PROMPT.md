# EPIC PREVIEW REFORZADO

Proyecto: BetaTest Flow  
Metodo: Metodo Revas  
Version: Alpha 0.2  
Epica: 11  
Nombre: Prompt de Correccion

## Objetivo del documento

Definir funcionalmente la Epica Prompt de Correccion, sin implementacion tecnica, para establecer limites claros entre Reportes, Prompt de Correccion y Developer, evitando responsabilidades duplicadas.

## 1. Que es un Prompt de Correccion dentro de BetaTest Flow

Prompt de Correccion es la entidad funcional que toma Reportes ya resumidos y construye propuestas textuales estructuradas de mejora.

No ejecuta cambios. No modifica datos. No aplica soluciones. Solo propone.

## 2. Que problema resuelve

Prompt de Correccion resuelve la brecha entre entender un problema y preparar una accion de mejora.

Sin esta entidad, el equipo puede ver hallazgos en Reportes, pero no siempre tiene una guia clara, consistente y reutilizable para convertir esos hallazgos en decisiones de correccion.

## 3. Por que BetaTest Flow necesita una entidad Prompt de Correccion

BetaTest Flow necesita Prompt de Correccion para:
- Estandarizar como se redactan propuestas de mejora.
- Reducir ambiguedad entre hallazgo y accion sugerida.
- Mantener trazabilidad entre lo observado y lo recomendado.
- Mejorar la velocidad de analisis sin perder control del Developer.
- Separar claramente resumen de datos (Reportes) y propuesta de correccion (Prompt).

## 4. Cual es su responsabilidad arquitectonica

Responsabilidad principal:
- Proponer acciones de correccion en formato textual estructurado a partir de Reportes.

Responsabilidades funcionales:
- Consumir informacion resumida por Reportes.
- Generar texto orientado a decision tecnica.
- Mantener referencia explicita al problema reportado.
- Presentar alternativas o pasos sugeridos de mejora.
- Dejar la decision final siempre en manos del Developer.

## 5. Como se relaciona con Workspace, Apps, Betas, Goals, Lista de pruebas, Pasos de prueba, Tester, SDK, Resultados y Reportes

- Workspace: aporta contexto organizativo, pero Prompt no administra Workspace.
- Apps: define producto evaluado; Prompt no modifica App, solo propone mejoras sobre hallazgos.
- Betas: delimita ciclo de evaluacion; Prompt usa ese contexto para orientar la propuesta.
- Goals: aporta objetivo funcional; Prompt propone correcciones alineadas al objetivo.
- Lista de pruebas: aporta estructura de validacion; Prompt identifica donde enfocar ajustes.
- Pasos de prueba: aporta detalle operativo; Prompt puede proponer mejoras puntuales por paso.
- Tester: aporta ejecucion observada; Prompt no gestiona Tester ni su estado.
- SDK: aporta evidencia capturada; Prompt no captura ni altera evidencia.
- Resultados: organiza hechos; Prompt no reorganiza ni recalcula resultados.
- Reportes: resume lectura; Prompt usa ese resumen para proponer como corregir.

## 6. Como se relacionara posteriormente con futuras IA o asistentes

En futuras versiones, Prompt de Correccion podra ser consumido por asistentes o IA como insumo estructurado para sugerencias mas completas.

Relacion funcional prevista:
- BetaTest Flow define el contexto y las reglas.
- Prompt de Correccion entrega propuesta textual base.
- IA o asistentes podran ampliar, reformular o priorizar la propuesta.
- El Developer mantiene aprobacion final.

Nota: esta version no define integraciones tecnicas ni automatizaciones.

## 7. Que informacion administrara (modelo funcional)

Prompt de Correccion administrara solo informacion funcional de propuesta:
- Identidad del prompt de correccion.
- Referencia al reporte origen.
- Contexto funcional (modulo, flujo, objetivo afectado).
- Problema resumido tomado del reporte.
- Hipotesis de correccion propuesta.
- Recomendaciones de accion en texto estructurado.
- Riesgo funcional estimado de no corregir.
- Prioridad sugerida de atencion.
- Trazabilidad temporal de creacion y actualizacion del prompt.

Solo modelo funcional. Sin diseno tecnico. Sin implementacion.

## 8. Que informacion NO administrara

Prompt de Correccion NO administrara:
- Evidencia cruda de ejecucion (corresponde a SDK).
- Organizacion base de hechos (corresponde a Resultados).
- Resumen principal de estado (corresponde a Reportes).
- Implementacion del cambio en codigo (corresponde al Developer).
- Ejecucion automatica de cambios sobre Flutter, Firebase o Firestore.

Frontera explicita de responsabilidades:
- Reportes responde: Que muestran los datos.
- Prompt de Correccion responde: Como podria corregirse el problema.
- Developer responde: Que se decide implementar y como se implementa realmente.

## 9. Cuales seran las funcionalidades de Alpha 0.2

Alcance funcional esperado para Alpha 0.2:
- Definicion funcional completa de Prompt de Correccion.
- Delimitacion clara frente a Reportes y Developer.
- Definicion de tipos funcionales de prompt.
- Definicion del ciclo de generacion del prompt.
- Base funcional para historias H11.1 a H11.5.

## 10. Que funcionalidades quedan explicitamente fuera del alcance

Fuera de alcance en Alpha 0.2:
- Generacion automatica por IA en tiempo real.
- Aplicacion automatica de cambios en codigo.
- Integracion tecnica con IDE para escritura de codigo.
- Orquestacion automatica con pipelines de despliegue.
- Correcciones automaticas sobre bases de datos o configuraciones.
- Sistema de aprobacion colaborativa multi-rol.

## 11. Cuales son las ampliaciones previstas para futuras versiones

Ampliaciones documentadas (sin diseno en esta fase):
- Integracion opcional con asistentes especializados por tecnologia.
- Versionado historico de prompts y decisiones tomadas.
- Priorizacion automatizada por riesgo e impacto.
- Plantillas de prompt por tipo de problema recurrente.
- Vinculacion con metricas post-correccion para aprendizaje continuo.

## Diferencia entre Reportes y Prompt de Correccion

Definicion conceptual:
- Reportes responde: Que muestran los datos.
- Prompt de Correccion responde: Como podria corregirse el problema.

Rol adicional:
- Developer decide: Que accion se acepta, se adapta o se descarta.

Ejemplo 1
- Reporte: En login movil, 22% de sesiones muestran abandono en validacion de OTP.
- Prompt de Correccion: Proponer revisar tiempos de expiracion del OTP, claridad del mensaje de error y reintento guiado.
- Developer: Decide si ajusta UX, logica de expiracion o ambos, y define implementacion concreta.

Ejemplo 2
- Reporte: En checkout, el paso de seleccion de metodo de pago presenta friccion alta en iOS.
- Prompt de Correccion: Proponer simplificar opciones visibles, validar orden de metodos y agregar texto de ayuda contextual.
- Developer: Decide prioridad, alcance y cambios tecnicos reales en el flujo.

Ejemplo 3
- Reporte: En onboarding, testers completan tutorial pero fallan en primera accion clave.
- Prompt de Correccion: Proponer reforzar llamada a la accion inicial y reducir ruido visual en la pantalla posterior al tutorial.
- Developer: Define si aplica cambios de UX, contenido o navegacion.

Ejemplo 4
- Reporte: En sincronizacion, hay demoras recurrentes al guardar feedback en red inestable.
- Prompt de Correccion: Proponer estrategia de reintentos, cola local temporal y mensajes de estado al usuario.
- Developer: Decide arquitectura tecnica final y validaciones necesarias.

Ejemplo 5
- Reporte: En configuracion de notificaciones, usuarios no encuentran la opcion de desactivacion.
- Prompt de Correccion: Proponer reubicar opcion, mejorar etiquetado y agregar confirmacion de estado activo/inactivo.
- Developer: Elige la solucion final y su implementacion en producto.

## Ciclo de generacion del Prompt

Developer
↓
Prepara Beta
↓
Tester ejecuta pruebas
↓
SDK captura evidencia
↓
Resultados organiza
↓
Reportes resume
↓
Prompt de Correccion genera propuesta
↓
Developer decide

## Principios de diseno

Reglas funcionales:
- Nunca modifica el codigo.
- Nunca modifica Firestore.
- Nunca modifica Flutter.
- Solo consume Reportes.
- Nunca altera Resultados.
- Produce texto estructurado.
- El desarrollador siempre tiene la decision final.

## Tipos de Prompt

Definicion funcional (sin implementacion tecnica):
- Prompt para Flutter.
- Prompt para Firebase.
- Prompt para UX.
- Prompt para rendimiento.
- Prompt para arquitectura.
- Prompt para pruebas.

## Jerarquia de generacion

Realidad
↓
SDK
(Captura)
↓
Resultados
(Organiza)
↓
Reportes
(Resume)
↓
Prompt de Correccion
(Propone)
↓
Developer
(Decide)

Proposito por nivel:
- Realidad: comportamiento real observado en uso.
- SDK (Captura): registra evidencia objetiva sin interpretacion.
- Resultados (Organiza): estructura lo ocurrido en informacion funcional.
- Reportes (Resume): convierte resultados en lectura clara.
- Prompt de Correccion (Propone): transforma lectura en propuesta de mejora.
- Developer (Decide): acepta, adapta o rechaza propuesta y ejecuta cambios reales.

## Secuencia oficial de la Epica

EPIC PREVIEW

↓

H11.1 Crear

↓

H11.2 Editar

↓

H11.3 Archivar

↓

H11.4 Configuracion

↓

H11.5 Informacion

↓

EPIC REVIEW

↓

Congelacion

## Cierre funcional de EPIC PREVIEW

La Epica 11 Prompt de Correccion queda funcionalmente definida para Alpha 0.2 con:
- Responsabilidad arquitectonica delimitada.
- Frontera explicita frente a Reportes y Developer.
- Modelo funcional de informacion administrada y no administrada.
- Ciclo de generacion, principios de diseno, tipos de prompt y jerarquia documentados.
- Secuencia oficial de ejecucion de la epica establecida.
