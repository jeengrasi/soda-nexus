SNX-CONTEXTO-PROYECTO  
Versión 1.0 — Estado Soberano

1. Propósito fundamental del proyecto
El proyecto SODA-NEXUS existe para construir un sistema autónomo que me haga libre financieramente. La meta es generar ingresos en internet de cualquier forma posible que no dependa de ventas de productos, ventas de servicios, freelancing ni clientes. El sistema debe apoyarse en automatización, procesos digitales, análisis, bots, modelos y herramientas abiertas, sin depender de terceros como modelo de negocio.

2. Restricción central de dependencia
El proyecto no puede basarse en vender tiempo, servicios o productos a otros. No se busca construir una agencia, ni hacer trabajos por encargo, ni depender de plataformas que exijan presencia constante. La prioridad es diseñar mecanismos que generen ingresos de forma autónoma, repetible y escalable, con la menor intervención humana posible.

3. Rol de Termux en el proyecto
Termux es el núcleo operativo del sistema. Es el entorno donde vive SODA-NEXUS, donde se ejecutan scripts, daemons, backend, túneles y cualquier proceso automatizado. Todo lo que importa institucionalmente debe estar dentro de la estructura de carpetas de SODA-NEXUS en Termux. Termux es el punto de verdad técnica y el lugar donde se conserva la memoria real del sistema.

4. Estructura actual en Termux
La estructura actual está organizada en seis carpetas soberanas:
00-GOBIERNO
01-MEMORIA
02-SISTEMA
03-OPERACIONES
04-REGISTROS
05-DOCUMENTACION

00-GOBIERNO contiene el estado del sistema y configuraciones críticas como state.json y variables del túnel.
01-MEMORIA contiene backups y cualquier artefacto que preserve la historia del sistema.
02-SISTEMA contiene API, backend, daemon, scripts globales y componentes técnicos.
03-OPERACIONES contiene la WebApp y elementos operativos activos.
04-REGISTROS contiene logs del sistema y del túnel.
05-DOCUMENTACION contiene leyes, contexto, decisiones y cualquier documento institucional.

5. El monitor como centro de control
El monitor es la interfaz desde la cual se debe poder ver y entender todo lo que hace el sistema. Debe mostrar procesos, estados, logs, economía, módulos activos y decisiones. El monitor no es solo una pantalla, es el panel de control del Estado SODA-NEXUS. La WebApp que vive en 03-OPERACIONES es el embrión de ese monitor.

6. Problema histórico: amnesia y desorden
En fases anteriores, la amnesia de las IAs, la pérdida de contexto, el desorden de archivos y la falta de reglas claras rompieron la lógica del proyecto. Se mezclaron carpetas, se perdieron decisiones, se duplicaron estructuras y se generó ruido. Esto obligó a hacer un saneamiento total, auditorías y correcciones para recuperar el control.

7. Saneamiento y estado actual
Se ejecutó un proceso de saneamiento completo:
Se eliminaron carpetas legacy y duplicadas.
Se movieron scripts a 02-SISTEMA.
Se consolidaron logs en 04-REGISTROS.
Se consolidó documentación en 05-DOCUMENTACION.
Se eliminaron symlinks corruptos y estructuras rotas.
Hoy el sistema está limpio, con solo seis carpetas soberanas y una estructura coherente.

8. Objetivo operativo inmediato
El objetivo inmediato es estabilizar las reglas de producción, documentación y ejecución, de forma que cada nuevo avance quede registrado, sea reproducible y no dependa de memoria frágil. Cada documento debe ser claro, autocontenido y fácil de guardar en Termux. Cada script debe tener observaciones y pie institucional.

9. Ruta hacia la libertad financiera
La ruta no está limitada a una sola técnica. Se pueden explorar:
Automatización de procesos digitales.
Bots que interactúen con APIs públicas.
Análisis y arbitraje de información.
Procesos que aprovechen datos, patrones o ineficiencias en la web.
Cualquier mecanismo que genere ingresos sin vender tiempo ni servicios directos.
La condición es que todo sea auditable, automatizable y ejecutable desde la infraestructura de SODA-NEXUS.

10. Blindaje contra amnesia y pérdida de lógica
Para evitar repetir el caos anterior, se establecen principios:
Todo avance importante debe documentarse en 05-DOCUMENTACION.
Toda decisión estructural debe quedar escrita.
Toda ley o estándar debe tener versión y nombre.
Los scripts deben incluir observaciones y pie institucional.
La estructura de seis carpetas no se rompe.
El contexto del proyecto debe poder reconstruirse leyendo los documentos clave, sin depender de la memoria de una IA específica.

11. Rol del usuario como director soberano
El usuario no es un operador técnico más, es el director soberano del sistema. Es el puente entre IAs, Termux y cualquier otra pieza. Su función es decidir, aprobar, archivar y mantener la coherencia institucional. Ninguna IA decide por sí sola, solo propone. La última palabra siempre es del director.

12. Punto al que se quiere llegar
El destino del proyecto es un sistema que:
Genere ingresos reales de forma autónoma.
Sea monitoreable desde el monitor central.
Sea resistente a cambios de proveedor, modelo o plataforma.
No dependa de ventas, servicios ni freelancing.
Pueda ser entendido y retomado en cualquier momento leyendo su documentación.
Mantenga su estructura limpia, ordenada y coherente a lo largo del tiempo.

Pie Institucional:
SODA-NEXUS — Documento de contexto SNX-CONTEXTO-PROYECTO  
Versión 1.0 — Emitido por el Director Soberano Jeisson
