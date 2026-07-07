# MASTER BACKLOG

## Información general

Version: Alpha 0.2 (base) - contrato de desarrollo hasta Alpha 1.0

Estado: Aprobado

Objetivo: Definir el backlog funcional oficial de BetaTest Flow para guiar la implementacion sin ambiguedades ni cambios de alcance.

Método utilizado: Método Revas

## EPIC 01
Workspace

Propósito
Establecer el espacio principal de trabajo del desarrollador dentro de la Console para centralizar sus aplicaciones y el acceso al flujo de preparacion de betas.

Alcance
- Acceso al Workspace del desarrollador.
- Vista de aplicaciones asociadas.
- Entrada a modulos Apps, Betas, Goals, Lista de pruebas, Reports, Resultados, Centro de Integracion, Exportador y Prompt de Corrección.

Fuera de alcance
- Multi-organizacion avanzada.
- Gestion de roles y permisos avanzados.
- Configuracion de equipos.

Dependencias
- EPIC 02 Apps
- EPIC 03 Betas

Historias de Usuario

Historia 1.1

Como Developer

Quiero acceder a un Workspace unico

Para administrar mis aplicaciones beta desde un solo lugar

Prioridad
Alta

Dependencias
Ninguna

Estado
Validada

Criterios de aceptación
- El Workspace muestra el nombre del proyecto BetaTest Flow.
- El Workspace permite navegar a los modulos aprobados.
- El Workspace no expone funciones fuera de alcance.

Historia 1.2

Como Developer

Quiero ver un resumen de mis aplicaciones dentro del Workspace

Para seleccionar rapidamente en que app voy a trabajar

Prioridad
Alta

Dependencias
Historia 2.1

Estado
Validada

Criterios de aceptación
- Se listan las aplicaciones creadas.
- Cada aplicacion permite acceso al modulo Betas.
- No se muestran metricas avanzadas ni dashboard.

Prioridad
Alta

Criterios de aceptación
- Epic definida y validada para Alpha 0.2.

Estado
Aprobada y Congelada

## EPIC 02
Apps

Propósito
Permitir gestionar aplicaciones como unidad principal de organizacion funcional.

Alcance
- Crear aplicacion.
- Editar aplicacion.
- Eliminar aplicacion.
- Ver betas asociadas.

Fuera de alcance
- Configuracion de build pipelines.
- Publicacion en stores.
- Configuracion avanzada de integraciones externas.

Dependencias
- EPIC 01 Workspace

Historias de Usuario

Historia 2.1

Como Developer

Quiero crear una aplicacion

Para registrar un proyecto que participara en betas cerradas

Prioridad
Alta

Dependencias
EPIC 01 Workspace

Estado
Validada

Criterios de aceptación
- Se puede crear una aplicacion con identificador y nombre.
- La aplicacion queda disponible en el listado de Apps.
- La aplicacion puede ser seleccionada para crear Betas.

Historia 2.2

Como Developer

Quiero editar una aplicacion

Para mantener su informacion funcional actualizada

Prioridad
Alta

Dependencias
Historia 2.1

Estado
Validada

Criterios de aceptación
- Se puede actualizar la informacion editable de la aplicacion.
- Los cambios se reflejan en el listado de Apps.
- No se altera el historial de reportes ya existentes.

Historia 2.3

Como Developer

Quiero eliminar una aplicacion

Para retirar proyectos que ya no forman parte de mi ciclo beta

Prioridad
Media

Dependencias
Historia 2.1

Estado
Validada

Criterios de aceptación
- La aplicacion se elimina del listado de Apps.
- La accion requiere confirmacion explicita.
- No se introducen modulos ni funciones no aprobadas.

Prioridad
Alta

Criterios de aceptación
- CRUD funcional de Apps definido en backlog.

Estado
Aprobada y Congelada

## EPIC 03
Betas

Propósito
Gestionar campañas beta por aplicacion para organizar iteraciones de prueba cerrada.

Alcance
- Crear beta por aplicacion.
- Editar beta.
- Eliminar beta.
- Asociar cada beta a su aplicacion.

Fuera de alcance
- Segmentacion avanzada de audiencias.
- Invitaciones automatizadas.
- Notificaciones de lanzamiento.

Dependencias
- EPIC 02 Apps

Historias de Usuario

Historia 3.1

Como Developer

Quiero crear una beta dentro de una aplicacion

Para ejecutar una iteracion de pruebas con contexto definido

Prioridad
Alta

Dependencias
Historia 2.1

Estado
Validada

Criterios de aceptación
- Se puede crear una beta asociada a una app existente.
- La beta queda visible en la lista de betas de la app.
- La beta permite continuar al modulo Goals y Lista de pruebas.

Historia 3.2

Como Developer

Quiero editar una beta

Para ajustar su informacion funcional antes de cerrar la iteracion

Prioridad
Alta

Dependencias
Historia 3.1

Estado
Validada

Criterios de aceptación
- Se puede modificar la informacion editable de la beta.
- El cambio queda visible en la lista de betas.
- No se altera el identificador funcional ya usado por el SDK.

Historia 3.3

Como Developer

Quiero eliminar una beta

Para mantener limpia la lista de iteraciones activas

Prioridad
Media

Dependencias
Historia 3.1

Estado
Validada

Criterios de aceptación
- Se puede eliminar una beta con confirmacion.
- La beta deja de aparecer en el listado.
- No se crean funciones fuera de alcance.

Prioridad
Alta

Criterios de aceptación
- Gestion de Betas definida y alineada con Apps.

Estado
Aprobada y Congelada

## EPIC 04
Goals

Propósito
Definir el objetivo funcional de cada beta para que la recoleccion de reportes tenga direccion clara.

Alcance
- Registrar objetivo principal de una beta.
- Editar objetivo durante la fase activa.
- Consultar objetivo desde los modulos de pruebas y resultados.

Fuera de alcance
- Objetivos multinivel complejos.
- Arboles de metricas.
- Reglas de evaluacion automatica.

Dependencias
- EPIC 03 Betas

Historias de Usuario

Historia 4.1

Como Developer

Quiero definir el objetivo principal de una beta

Para que el equipo de prueba tenga un foco claro

Prioridad
Alta

Dependencias
Historia 3.1

Estado
Validada

Criterios de aceptación
- Cada beta admite un objetivo principal.
- El objetivo queda visible en el contexto de la beta.
- El objetivo puede usarse como referencia en reportes.

Historia 4.2

Como Developer

Quiero editar el objetivo de la beta

Para reflejar cambios controlados del alcance de prueba

Prioridad
Media

Dependencias
Historia 4.1

Estado
Validada

Criterios de aceptación
- Se puede actualizar el objetivo de una beta activa.
- El ultimo objetivo queda visible para futuras exportaciones.
- No se agregan capas tecnicas fuera de este backlog.

Prioridad
Media

Criterios de aceptación
- Goals definidos como modulo funcional simple.

Estado
Aprobada y Congelada

## EPIC 05
Lista de pruebas

Propósito
Permitir configurar visualmente la Lista de pruebas de una beta sin codigo ni JSON manual.

Alcance
- Crear items de Lista de pruebas.
- Editar items de Lista de pruebas.
- Eliminar items de Lista de pruebas.
- Ordenar items de la Lista de pruebas.

Fuera de alcance
- Plantillas complejas automatizadas.
- Versionado avanzado con ramas.
- Motor de reglas dinamicas.

Dependencias
- EPIC 03 Betas
- EPIC 04 Goals

Historias de Usuario

Historia 5.1

Como Developer

Quiero crear items en la lista de pruebas

Para definir que areas debe validar la beta

Prioridad
Alta

Dependencias
Historia 3.1

Estado
Validada

Criterios de aceptación
- Se pueden agregar items de Lista de pruebas a una beta.
- Los items quedan vinculados a la beta correcta.
- Los items son visibles para el flujo del SDK.

Historia 5.2

Como Developer

Quiero ordenar visualmente los items de la Lista de pruebas

Para priorizar el orden de validacion durante la prueba

Prioridad
Media

Dependencias
Historia 5.1

Estado
Validada

Criterios de aceptación
- El orden de Lista de pruebas se puede ajustar.
- El orden guardado se mantiene en consultas posteriores.
- No se requiere edicion en codigo ni JSON manual.

Historia 5.3

Como Developer

Quiero editar y eliminar items de la Lista de pruebas

Para mantener una lista de pruebas vigente por beta

Prioridad
Alta

Dependencias
Historia 5.1

Estado
Validada

Criterios de aceptación
- Se puede editar el contenido de un item.
- Se puede eliminar un item con confirmacion.
- Los cambios impactan solo la beta seleccionada.

Prioridad
Alta

Criterios de aceptación
- Constructor funcional de Lista de pruebas definido para Alpha.

Estado
Aprobada y Congelada

## EPIC 06
Reports

Propósito
Consolidar reportes generados por el SDK para consulta operativa por app y beta.

Alcance
- Listar reportes por aplicacion y beta.
- Consultar detalle de reporte.
- Mantener integridad del reporte original generado por SDK.

Fuera de alcance
- Analitica avanzada.
- Graficos estadisticos.
- IA de interpretacion automatica.

Dependencias
- EPIC 03 Betas
- EPIC 05 Lista de pruebas
- Integracion con SDK existente

Historias de Usuario

Historia 6.1

Como Developer

Quiero listar reportes de una beta

Para revisar rapidamente los reportes recibidos

Prioridad
Alta

Dependencias
EPIC 03 Betas

Estado
Validada

Criterios de aceptación
- Se muestran reportes asociados a una beta.
- Cada reporte identifica usuario y fecha.
- La lista no incluye metricas avanzadas.

Historia 6.2

Como Developer

Quiero abrir el detalle de un reporte

Para leer reportes, Lista de pruebas, severidad y datos tecnicos

Prioridad
Alta

Dependencias
Historia 6.1

Estado
Validada

Criterios de aceptación
- El detalle muestra campos funcionales del reporte aprobado.
- Se conserva markdown generado por SDK.
- No se modifica el contenido original del reporte.

Prioridad
Alta

Criterios de aceptación
- Reports definidos como lectura funcional de datos del SDK.

Estado
Aprobada y Congelada

## EPIC 07
Resultados

Propósito
Ofrecer una vista simple de resultados funcionales de una beta, sin dashboard complejo.

Alcance
- Resumen textual de estado por beta.
- Conteos basicos por severidad y resultado.
- Acceso a reportes relevantes.

Fuera de alcance
- Graficas interactivas.
- Modelos de scoring avanzados.
- Predicciones.

Dependencias
- EPIC 06 Reports

Historias de Usuario

Historia 7.1

Como Developer

Quiero ver un resumen de resultados de la beta

Para tomar decisiones rapidas de continuidad o correccion

Prioridad
Alta

Dependencias
Historia 6.1

Estado
Validada

Criterios de aceptación
- Se muestra resumen textual de reportes de la beta.
- Se puede identificar rapidamente severidades altas y criticas.
- El resumen se mantiene simple y funcional.

Historia 7.2

Como Developer

Quiero ubicar los reportes mas relevantes desde Resultados

Para priorizar correcciones de manera operativa

Prioridad
Media

Dependencias
Historia 7.1

Estado
Validada

Criterios de aceptación
- Se pueden localizar reportes con mayor impacto funcional.
- Se mantiene traza hacia el modulo Reports.
- No se introducen funcionalidades fuera de alcance.

Prioridad
Media

Criterios de aceptación
- Resultados definido sin evolucionar a dashboard.

Estado
Aprobada y Congelada

## EPIC 08
Centro de Integración

Propósito
Centralizar la informacion necesaria para integrar el SDK en apps Flutter.

Alcance
- Mostrar parametros requeridos de integracion.
- Mostrar identificadores oficiales de app y beta.
- Mostrar estado funcional de la integracion.

Fuera de alcance
- Provisionamiento automatico.
- Integraciones con terceros no aprobados.
- Diagnostico avanzado de CI/CD.

Dependencias
- EPIC 02 Apps
- EPIC 03 Betas
- SDK existente

Historias de Usuario

Historia 8.1

Como Developer

Quiero consultar los datos oficiales de integracion de una app y beta

Para configurar el SDK correctamente sin ambiguedad

Prioridad
Alta

Dependencias
Historia 2.1, Historia 3.1

Estado
Validada

Criterios de aceptación
- Se muestran appId, appName, campaignId, campaignName, reportVersion y Lista de pruebas.
- La informacion coincide con la configuracion actual aprobada.
- La consulta es directa y sin pasos innecesarios.

Historia 8.2

Como Developer

Quiero validar que mi integracion usa los identificadores correctos

Para evitar reportes en campañas equivocadas

Prioridad
Alta

Dependencias
Historia 8.1

Estado
Validada

Criterios de aceptación
- Se puede verificar coherencia entre app y beta seleccionadas.
- Se evita ambiguedad en nombres oficiales.
- No se agregan validaciones fuera de alcance funcional.

Prioridad
Alta

Criterios de aceptación
- Centro de Integracion definido como modulo funcional simple.

Estado
Aprobada y Congelada

## EPIC 09
Exportador

Propósito
Permitir descarga de datos beta en formatos analizables para uso externo.

Alcance
- Exportar JSON.
- Exportar CSV.
- Exportar Markdown.
- Filtrar por app y beta.

Fuera de alcance
- Exportaciones programadas automaticas.
- Conectores BI avanzados.
- Transformaciones complejas no aprobadas.

Dependencias
- EPIC 06 Reports
- EPIC 07 Resultados

Historias de Usuario

Historia 9.1

Como Developer

Quiero exportar reportes en JSON

Para procesarlos en flujos de analisis personalizados

Prioridad
Alta

Dependencias
Historia 6.1

Estado
Validada

Criterios de aceptación
- Se puede descargar archivo JSON por filtros seleccionados.
- El contenido respeta los campos funcionales del reporte.
- La exportacion se genera sin agregar logica extra.

Historia 9.2

Como Developer

Quiero exportar reportes en CSV

Para analizarlos en hojas de calculo

Prioridad
Alta

Dependencias
Historia 6.1

Estado
Validada

Criterios de aceptación
- Se puede descargar archivo CSV por filtros seleccionados.
- Las columnas mantienen consistencia entre exportaciones.
- No se alteran nombres oficiales de campos.

Historia 9.3

Como Developer

Quiero exportar reportes en Markdown

Para compartir un resumen legible del estado beta

Prioridad
Alta

Dependencias
Historia 7.1

Estado
Validada

Criterios de aceptación
- Se puede descargar archivo Markdown con resumen funcional.
- El archivo incluye secciones oficiales del resumen beta.
- No se incluyen graficos ni IA.

Prioridad
Alta

Criterios de aceptación
- Exportador definido con solo 3 formatos aprobados.

Estado
Aprobada y Congelada

## EPIC 10
Prompt de Corrección

Propósito
Proveer un prompt funcional listo para usar en correcciones manuales del equipo de desarrollo.

Alcance
- Generar bloque de prompt basado en datos exportados.
- Incluir contexto de severidad, resultado y problemas reportados.
- Incluir formato de salida esperado para correccion.

Fuera de alcance
- Ejecucion automatica de IA.
- Sugerencias autonomas.
- Correcciones automaticas de codigo.

Dependencias
- EPIC 09 Exportador

Historias de Usuario

Historia 10.1

Como Developer

Quiero obtener un Prompt de Corrección estructurado

Para usarlo manualmente en mi proceso de solucion de bugs

Prioridad
Media

Dependencias
Historia 9.3

Estado
Validada

Criterios de aceptación
- El prompt se puede copiar y reutilizar.
- El contenido refleja el contexto real de reportes exportados.
- No existe ejecucion de IA dentro de la Console.

Prioridad
Media

Criterios de aceptación
- Prompt de Corrección definido solo como salida documental.

Estado
Aprobada y Congelada

## EPIC 11
Tester

Propósito
Registrar la referencia funcional del tester asociado a una ejecucion de beta.

Alcance
- Asociar identificador simple de tester a un reporte o corrida.
- Visualizar lista basica de testers involucrados en una beta.

Fuera de alcance
- Gestion de comunidad.
- Reputacion.
- Sistema de invitaciones.
- Roles y permisos avanzados.

Dependencias
- EPIC 06 Reports

Historias de Usuario

Historia 11.1

Como Developer

Quiero identificar que tester reporto un problema

Para dar seguimiento funcional en la misma beta

Prioridad
Baja

Dependencias
Historia 6.1

Estado
Validada

Criterios de aceptación
- Se puede asociar un identificador de tester al reporte.
- La informacion queda visible en contexto de beta.
- No se implementan funciones sociales.

Prioridad
Baja

Criterios de aceptación
- Alcance de Tester limitado y sin expansion funcional.

Estado
Aprobada y Congelada

## EPIC 12
Historial de contribuciones

Propósito
Mantener traza funcional de aportes y actividad de reportes por beta.

Alcance
- Registrar contribuciones por periodo.
- Consultar historial por app y beta.

Fuera de alcance
- Puntajes de gamificacion.
- Rankings.
- Recompensas.

Dependencias
- EPIC 06 Reports
- EPIC 11 Tester

Historias de Usuario

Historia 12.1

Como Developer

Quiero consultar un historial de contribuciones

Para entender continuidad de los reportes durante la beta

Prioridad
Baja

Dependencias
Historia 11.1

Estado
Pendiente

Criterios de aceptación
- Existe registro cronologico de contribuciones.
- Se puede filtrar por app y beta.
- No se agregan mecanicas de reputacion.

Prioridad
Baja

Criterios de aceptación
- Historial definido como registro funcional simple.

Estado
Aprobada

## EPIC 13
Catálogo de Betas

Propósito
Consolidar una vista funcional de todas las betas para facilitar consulta y organizacion.

Alcance
- Listado global de betas por app.
- Filtros basicos por estado y aplicacion.
- Acceso rapido a Goals, Lista de pruebas, Reports y Exportador.

Fuera de alcance
- Discovery publico.
- Marketplace de betas.
- Catalogo comunitario.

Dependencias
- EPIC 03 Betas
- EPIC 07 Resultados

Historias de Usuario

Historia 13.1

Como Developer

Quiero consultar un catalogo de todas mis betas

Para navegar rapidamente entre iteraciones activas e historicas

Prioridad
Media

Dependencias
Historia 3.1

Estado
Pendiente

Criterios de aceptación
- El catalogo lista betas por aplicacion.
- Se permite filtro basico por estado.
- Cada beta habilita acceso a sus modulos funcionales.

Prioridad
Media

Criterios de aceptación
- Catalogo definido como indice funcional interno.

Estado
Aprobada

## EPIC 14
Mensajes de agradecimiento

Propósito
Permitir gestionar mensajes de agradecimiento simples para cierre de ciclo beta.

Alcance
- Definir mensaje de agradecimiento por beta.
- Consultar mensaje registrado en cierre de beta.

Fuera de alcance
- Automatizacion de envios.
- Sistema de mensajeria avanzado.
- Plantillas dinamicas complejas.

Dependencias
- EPIC 03 Betas
- EPIC 11 Tester

Historias de Usuario

Historia 14.1

Como Developer

Quiero registrar un mensaje de agradecimiento para una beta

Para cerrar el ciclo de colaboracion con comunicacion clara

Prioridad
Baja

Dependencias
Historia 3.1

Estado
Pendiente

Criterios de aceptación
- Se puede guardar un mensaje de agradecimiento por beta.
- El mensaje queda asociado a la beta correspondiente.
- No se implementa sistema de envio automatico.

Prioridad
Baja

Criterios de aceptación
- Mensajes de agradecimiento definidos en alcance funcional minimo.

Estado
Aprobada
