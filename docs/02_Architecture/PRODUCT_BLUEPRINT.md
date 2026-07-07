# 1. Vision General

BetaTest Flow es un producto para acelerar la preparacion de betas cerradas en proyectos Flutter con un flujo simple, guiado y sin complejidad innecesaria.

El recorrido funcional completo comienza cuando Developer crea su Workspace y registra sus Apps. Dentro de cada App define una o varias Betas, y en cada Beta establece Objetivos de la beta (Goals) claros para enfocar la validacion. A partir de esos Objetivos de la beta construye la Lista de pruebas sin usar codigo.

Con esa configuracion lista, el SDK se integra en la app Flutter y ejecuta la recoleccion de reportes durante la prueba. Los Tester completan la experiencia beta y generan reportes estructurados. Esos reportes se almacenan en Firebase y se transforman en Reports consultables desde la Console.

Luego Developer revisa Resultados, exporta la informacion en formatos analizables y finalmente genera el Prompt de Corrección para iniciar ciclos de mejora del producto.

El proposito del flujo es reducir el tiempo entre "definir que probar" y "decidir que corregir", manteniendo al Developer en control y eliminando friccion operativa.

# 2. Mapa General

Workspace

↓

Apps

↓

Betas

↓

Goals

↓

Lista de pruebas

↓

SDK

↓

Firebase

↓

Reports

↓

Resultados

↓

Prompt de Corrección

# 3. Relaciones entre modulos

Workspace administra Apps.

Apps administran Betas.

Betas contienen Goals.

Goals guian la construccion de la Lista de pruebas.

La Lista de pruebas es utilizada por el SDK durante la recoleccion de reportes.

El SDK envia reportes y evidencia funcional hacia Firebase.

Firebase centraliza y conserva los reportes de cada beta.

Los datos de Firebase alimentan Reports en la Console.

Reports se consolidan en Resultados para facilitar la lectura operativa.

Resultados habilitan la generacion del Prompt de Corrección.

Exportador opera sobre Reports y Resultados para producir JSON, CSV y Markdown.

Centro de Integracion conecta la configuracion funcional de Apps y Betas con la adopcion correcta del SDK.

Tester, Historial de contribuciones, Catalogo de Betas y Mensajes de agradecimiento se relacionan como modulos de soporte del ciclo beta, sin alterar el flujo principal ni reemplazar sus responsabilidades.

# 4. Responsabilidad de cada modulo

Workspace

Responsabilidad unica: Ser el contenedor principal de trabajo dDeveloper.

No hace: No captura reportes, no exporta reportes, no ejecuta logica del SDK.

Apps

Responsabilidad unica: Gestionar el catalogo de aplicaciones dDeveloper.

No hace: No define pruebas de una beta por si sola, no interpreta reportes.

Betas

Responsabilidad unica: Organizar iteraciones de prueba dentro de cada app.

No hace: No captura reportes directamente, no reemplaza Goals.

Goals

Responsabilidad unica: Definir el objetivo funcional de cada beta.

No hace: No actua como Lista de pruebas, no genera reportes por si mismo.

Lista de pruebas

Responsabilidad unica: Convertir Goals en puntos concretos de validacion para Tester.

No hace: No implementa UI runtime del SDK, no realiza analitica.

SDK

Responsabilidad unica: Capturar reportes beta dentro de la app y enviarlos como reporte estructurado.

No hace: No administra Workspace, no administra Apps o Betas de la Console.

Firebase

Responsabilidad unica: Almacenar y disponibilizar reportes y configuraciones persistentes.

No hace: No decide objetivos de negocio, no reemplaza la lectura funcional de Reports.

Reports

Responsabilidad unica: Mostrar reportes capturados de forma trazable por app y beta.

No hace: No genera recomendaciones automaticas, no ejecuta correcciones.

Resultados

Responsabilidad unica: Resumir el estado funcional de la beta para facilitar decisiones.

No hace: No se convierte en dashboard avanzado, no reemplaza exportaciones.

Exportador

Responsabilidad unica: Descargar datos de beta en JSON, CSV y Markdown.

No hace: No ejecuta transformaciones inteligentes ni analitica compleja.

Prompt de Corrección

Responsabilidad unica: Entregar un prompt estructurado para iniciar la fase de correccion.

No hace: No corre IA dentro del producto, no corrige codigo automaticamente.

Centro de Integracion

Responsabilidad unica: Alinear datos oficiales de configuracion para integrar SDK sin ambiguedades.

No hace: No despliega apps, no administra infraestructura avanzada.

Tester

Responsabilidad unica: Identificar al participante que reporta dentro del ciclo beta.

No hace: No introduce comunidad, reputacion o funciones sociales.

Historial de contribuciones

Responsabilidad unica: Registrar trazabilidad de aportes durante la beta.

No hace: No aplica gamificacion ni ranking.

Catalogo de Betas

Responsabilidad unica: Centralizar consulta de betas dDeveloper.

No hace: No es marketplace ni discovery publico.

Mensajes de agradecimiento

Responsabilidad unica: Registrar cierre comunicacional simple de una beta.

No hace: No implementa mensajeria automatica ni campañas de engagement.

# 5. Flujo dDeveloper

1. Crear Workspace.

2. Crear App dentro del Workspace.

3. Crear Beta asociada a la App.

4. Definir Objetivos de la beta.

5. Crear Lista de pruebas a partir de los Goals.

6. Integrar SDK con los datos oficiales de App y Beta.

7. Recibir Reportes enviados por Tester durante la beta.

8. Exportar Resultados en JSON, CSV o Markdown.

9. Generar Prompt de Corrección con base en los Resultados.

10. Ejecutar ciclo de mejora del producto fuera del alcance de este Blueprint.

# 6. Flujo del Tester

1. Entrar a la Beta asignada.

2. Leer Objetivos de la Beta para entender el foco de validacion.

3. Completar Lista de pruebas durante el uso real de la app.

4. Enviar reporte con datos estructurados.

5. Ver Historial de contribuciones en el contexto permitido por el producto.

# 7. Principios del Blueprint

Cada modulo tiene una unica responsabilidad.

La arquitectura manda; el codigo obedece.

El SDK nunca depende de la Workspace.

El usuario nunca debe aprender lenguaje tecnico para operar la Console.

Las decisiones funcionales se toman una sola vez y se mantienen estables.

Toda funcionalidad debe resolver un problema real del ciclo beta.

La simplicidad operativa tiene prioridad sobre la sofisticacion visual.

El flujo principal no se rompe por modulos secundarios.

La trazabilidad de reportes es obligatoria para decisiones de correccion.

La consistencia de nombres oficiales es obligatoria en todo el producto.

# 8. Restricciones

No IA.

No Dashboard avanzado.

No Gamificacion.

No Sistema de recompensas.

No Roles avanzados.

No Analitica compleja.

No funcionalidades sociales de comunidad.

No invitaciones avanzadas.

No notificaciones complejas.

No implementaciones tecnicas fuera de este documento funcional.

No cambios de alcance sin actualizacion formal del contrato del producto.
