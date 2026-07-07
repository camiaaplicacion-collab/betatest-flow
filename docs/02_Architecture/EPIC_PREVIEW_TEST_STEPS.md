# EPIC PREVIEW REFORZADO

Proyecto: BetaTest Flow  
Metodo: Metodo Revas  
Version: Alpha 0.2  
Epica: 06  
Nombre: Pasos de prueba

## Objetivo del documento

Definir funcionalmente la Epica Pasos de prueba, sin implementacion tecnica, para eliminar ambiguedades y establecer limites claros de alcance en Alpha 0.2.

## 1. Que es un Paso de prueba dentro de BetaTest Flow

Un Paso de prueba es la unidad minima de ejecucion funcional que describe una accion concreta y verificable que el tester debe realizar dentro de una Lista de pruebas.

## 2. Que problema resuelve

Resuelve la ambiguedad operativa en la ejecucion de pruebas. Sin Pasos de prueba, una Lista de pruebas queda enunciada pero no es ejecutable de forma consistente por distintos testers.

## 3. Por que una Lista de pruebas necesita Pasos de prueba

Una Lista de pruebas necesita Pasos de prueba para:
- Convertir un objetivo de validacion en acciones concretas.
- Asegurar que todos los testers ejecuten el mismo procedimiento.
- Permitir trazabilidad de avance y cumplimiento por accion.
- Reducir interpretaciones subjetivas durante la prueba.

## 4. Cual es la responsabilidad de un Paso de prueba dentro de la arquitectura

Responsabilidad principal:
- Operativizar una Lista de pruebas en acciones secuenciales, claras y verificables.

Responsabilidades funcionales:
- Definir una accion puntual a ejecutar.
- Definir el resultado observable esperado de esa accion.
- Delimitar orden y coherencia dentro de la Lista de pruebas.
- Facilitar seguimiento de ejecucion por paso.

## 5. Relacion con Workspace, Apps, Betas, Goals y Lista de pruebas

- Workspace: define el contexto organizativo, pero no define acciones de ejecucion.
- Apps: es el producto evaluado, pero no define el procedimiento de prueba.
- Betas: provee el entorno temporal de validacion donde se ejecutan pasos.
- Goals: define que validar.
- Lista de pruebas: define el conjunto de validaciones; el Paso de prueba define cada accion especifica para ejecutar ese conjunto.

## 6. Relacion posterior con Tester, SDK, Reportes, Resultados y Prompt de Correccion

- Tester: ejecuta cada Paso de prueba en el orden definido.
- SDK: captura evidencia asociada a cada paso ejecutado.
- Reportes: consolidan resultados por paso, por lista y por goal.
- Resultados: calculan cumplimiento, fallas recurrentes y calidad de ejecucion.
- Prompt de Correccion: utiliza hallazgos por paso para proponer mejoras concretas.

## 7. Que informacion administrara un Paso de prueba (modelo funcional)

El Paso de prueba administrara solo informacion funcional de ejecucion:
- Identidad funcional del paso dentro de su lista.
- Referencia a la Lista de pruebas a la que pertenece.
- Titulo corto de accion.
- Instruccion concreta para el tester.
- Orden secuencial dentro de la lista.
- Criterio de verificacion esperado.
- Estado funcional del paso (por ejemplo: pendiente, en ejecucion, completado) cuando aplique al flujo de ejecucion.
- Trazabilidad temporal basica de mantenimiento del paso.

Nota: esta seccion define solo modelo funcional, no esquema tecnico ni persistencia.

## 8. Que informacion NO administrara

El Paso de prueba no administrara entidades fuera de su dominio:
- Usuarios.
- Workspace.
- Apps.
- Betas.
- Goals.
- Lista de pruebas (solo referencia, no gestion).
- SDK.
- Resultados.
- Exportaciones.

Tampoco administrara:
- Permisos globales.
- Integraciones externas.
- Decisiones de scoring final del producto.

## 9. Cuales seran las funcionalidades de Alpha 0.2

Alcance funcional esperado para Alpha 0.2:
- Crear Paso de prueba dentro de una Lista de pruebas.
- Editar Paso de prueba.
- Archivar Paso de prueba.
- Configuracion general de Paso de prueba.
- Informacion de Paso de prueba en modo solo lectura.
- Ordenamiento funcional de pasos dentro de la Lista de pruebas.

## 10. Que funcionalidades quedan explicitamente fuera del alcance

Fuera de alcance en Alpha 0.2:
- Ejecucion automatica de pasos.
- Motor avanzado de dependencia entre pasos.
- Ramificaciones condicionales complejas en tiempo real.
- Plantillas inteligentes autogeneradas por IA.
- Sincronizacion con herramientas externas de QA.
- Analitica predictiva por paso.
- Restauracion automatica masiva de pasos archivados.

## 11. Cuales son las ampliaciones previstas para futuras versiones

Ampliaciones documentadas (sin diseno en esta fase):
- Biblioteca reutilizable de pasos por tipo de validacion.
- Recomendacion asistida de pasos segun historico de fallas.
- Dependencias declarativas entre pasos (prerrequisitos).
- Variantes de pasos por plataforma o dispositivo.
- Automatizacion parcial de ejecucion para regresiones repetitivas.
- Comparativas entre ejecuciones por paso y por beta.

## Diferencia entre Lista de pruebas y Paso de prueba

Definicion conceptual:
- Lista de pruebas responde a: Que conjunto de validaciones ejecutare.
- Paso de prueba responde a: Que accion especifica debe realizar el tester.

Ejemplo 1
Lista de pruebas: Validar Login.
Pasos de prueba:
1. Abrir la aplicacion.
2. Presionar "Iniciar sesion".
3. Escribir usuario valido.
4. Escribir contrasena valida.
5. Presionar Ingresar.
6. Verificar acceso exitoso.

Ejemplo 2
Lista de pruebas: Validar recuperacion de contrasena.
Pasos de prueba:
1. Abrir la pantalla de acceso.
2. Seleccionar "Olvide mi contrasena".
3. Escribir correo registrado.
4. Solicitar enlace de recuperacion.
5. Abrir el enlace recibido.
6. Definir nueva contrasena.
7. Verificar inicio de sesion con la nueva contrasena.

Ejemplo 3
Lista de pruebas: Validar creacion de pedido.
Pasos de prueba:
1. Iniciar sesion como comprador.
2. Buscar un producto disponible.
3. Agregar el producto al carrito.
4. Ir a checkout.
5. Confirmar direccion de envio.
6. Confirmar compra.
7. Verificar mensaje de pedido confirmado.

Ejemplo 4
Lista de pruebas: Validar edicion de perfil.
Pasos de prueba:
1. Iniciar sesion.
2. Abrir la pantalla de perfil.
3. Modificar nombre y telefono.
4. Guardar cambios.
5. Cerrar sesion.
6. Iniciar sesion nuevamente.
7. Verificar persistencia de datos editados.

Ejemplo 5
Lista de pruebas: Validar busqueda de contenido.
Pasos de prueba:
1. Abrir el modulo de busqueda.
2. Escribir termino relevante.
3. Ejecutar busqueda.
4. Revisar los primeros resultados.
5. Abrir un resultado.
6. Verificar relacion entre termino y contenido mostrado.

## Ciclo de ejecucion del Tester

Flujo funcional completo:

Developer  
↓  
Define Goal  
↓  
Crea Lista de pruebas  
↓  
Construye Pasos de prueba  
↓  
Publica Beta  
↓  
Tester ejecuta Paso 1  
↓  
Tester ejecuta Paso 2  
↓  
...  
↓  
SDK captura resultados  
↓  
Se generan Reportes  
↓  
Se calculan Resultados  
↓  
Se genera Prompt de Correccion

## Principios de diseno de un Paso de prueba

Reglas funcionales:
- Un paso describe una unica accion.
- Un paso debe ser claro y verificable.
- Un paso no debe mezclar varias acciones.
- Un paso debe poder marcarse como completado.
- Un paso debe ser entendible por cualquier tester sin contexto adicional.
- Un paso debe tener resultado observable.
- Un paso debe aportar trazabilidad al flujo de validacion.

## Cierre funcional de EPIC PREVIEW

La Epica 06 Pasos de prueba queda funcionalmente definida para Alpha 0.2 con:
- Identidad conceptual clara.
- Frontera de responsabilidad delimitada.
- Diferencia no ambigua entre Lista de pruebas y Paso de prueba.
- Alcance y fuera de alcance explicitados.
- Trayectoria de evolucion futura documentada.
