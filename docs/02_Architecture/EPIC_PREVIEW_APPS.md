# EPIC PREVIEW APPS

Proyecto: BetaTest Flow

Metodo: Metodo Revas

Version: Alpha 0.2

Epic: 02 Apps

Estado: EPIC PREVIEW

## 1. Que es una App dentro de BetaTest Flow

Una App es la unidad funcional que representa un producto Flutter del Developer dentro de un Workspace. Es el contenedor organizativo inmediato para agrupar y administrar sus Betas.

En la arquitectura aprobada, la App es el punto donde se registra la identidad funcional del producto que participara en ciclos beta cerrados.

## 2. Que problema resuelve

La Epic Apps resuelve la necesidad de ordenar el trabajo beta por producto y evitar que la informacion de distintas iniciativas se mezcle.

Sin Apps, el Developer no puede separar claramente que Betas pertenecen a cada producto ni mantener trazabilidad operativa entre configuracion, ejecucion y reportes.

## 3. Cual es su responsabilidad dentro de la arquitectura

La responsabilidad unica de Apps es gestionar el catalogo de aplicaciones del Developer y habilitar el contexto para crear y administrar Betas.

Apps no reemplaza Workspace, no reemplaza Betas y no interpreta reportes.

## 4. Como se relaciona con Workspace

Workspace administra Apps.

La App depende del contexto de un Workspace para existir dentro del flujo oficial.

En terminos funcionales:
- Workspace define el espacio de trabajo.
- Apps organiza los productos dentro de ese espacio.

## 5. Como se relacionara en el futuro con Betas, Goals, Lista de pruebas, Reportes y Exportaciones

Relacion con Betas:
- Una App contiene y administra sus Betas.
- Cada Beta se crea dentro de una App.

Relacion con Goals:
- Los Goals pertenecen a la Beta, pero dependen del contexto de App para su organizacion.

Relacion con Lista de pruebas:
- La Lista de pruebas se define por Beta; la App actua como contenedor funcional del conjunto de listas por iteracion.

Relacion con Reportes:
- Los reportes se consultan por Beta, dentro del arbol funcional de la App.

Relacion con Exportaciones:
- Las exportaciones operan sobre reportes/resultados y pueden filtrarse por contexto de App.

## 6. Que informacion administrara una App (modelo funcional)

Modelo funcional minimo de App:
- appId
- appName
- workspaceId (referencia funcional al Workspace propietario)
- estado funcional de la App (activo/inactivo segun flujo aprobado)
- createdAt
- updatedAt

Este modelo es funcional y documental para iniciar Historias de implementacion, sin definir detalle tecnico.

## 7. Que informacion NO administrara

La App no administra:
- Usuarios
- Permisos
- Workspace
- Resultados
- SDK
- Roles avanzados
- Configuraciones de integraciones externas
- Notificaciones
- Comunidad o reputacion

## 8. Que funcionalidades pertenecen a Alpha 0.2

Segun contrato aprobado (MASTER_BACKLOG y ROADMAP), la Epic Apps en Alpha 0.2 incluye:
- Crear aplicacion
- Editar aplicacion
- Eliminar aplicacion
- Ver Betas asociadas

## 9. Que funcionalidades quedan explicitamente fuera del alcance

Fuera de alcance para la Epic Apps en Alpha 0.2:
- Configuracion de build pipelines
- Publicacion en stores
- Configuracion avanzada de integraciones externas
- Gestion de miembros, invitaciones y permisos
- Roles avanzados
- Dashboard y analitica compleja

## 10. Futuras ampliaciones previstas para una App

Ampliaciones previstas (solo referencia documental, sin diseno en esta fase):
- Metadatos extendidos de App para operaciones beta futuras
- Integraciones operativas adicionales aprobadas por version
- Capacidades de gobierno mas avanzadas para ciclos multi-app

Estas ampliaciones quedan sujetas a aprobacion formal en decisiones de proyecto y versiones futuras, sin alterar el alcance vigente de Alpha 0.2.
