# PLAN MAESTRO DEL MONITOR WEB DE SODA‑NEXUS  
Documento arquitectónico inicial — susceptible a modificaciones, ampliaciones y refinamientos conforme avance la construcción del sistema. Este documento funciona como planos oficiales para la creación del Monitor Web soberano.

## 1. Propósito del Monitor Web  
El Monitor Web de SODA‑NEXUS es la memoria viva, el panel de control y el sistema de alertas del ecosistema. Su función principal es garantizar orden, trazabilidad, seguridad y continuidad institucional sin depender de la memoria de ninguna IA.

El monitor debe:  
- Exponer el estado real del sistema en tiempo real.  
- Mostrar la estructura completa de carpetas y archivos.  
- Detectar anomalías, ruido, duplicados o desorden.  
- Registrar cambios y generar alertas.  
- Servir como interfaz universal accesible desde cualquier dispositivo.  
- Ser soberano, gratuito, robusto y sin dependencias externas.

## 2. Fases de Construcción del Monitor Web  
El desarrollo se divide en fases progresivas, cada una construida sobre la anterior. Todas las fases están sujetas a modificación según necesidades institucionales.

### Fase 0 — Preparación del Terreno  
- Verificación de estructura `~/soda/`.  
- Confirmación de carpetas oficiales.  
- Creación de rutas base para el backend.  
- Definición del estándar de estado institucional.  
- Preparación del entorno Bun + Termux.

### Fase 1 — Monitor de Carpetas (Vista Estructural)  
- Backend expone `/folders` con árbol completo.  
- WebApp muestra carpetas, subcarpetas y archivos.  
- Colores por estado: oficial, sospechosa, vacía, crítica.  
- Detección de carpetas no oficiales.  
- Registro de cambios en `monitor.log`.

### Fase 2 — Estado Institucional y Alertas  
- Panel de alertas en tiempo real.  
- Detección de archivos nuevos, eliminados o modificados.  
- Clasificación automática de riesgo.  
- Registro histórico de alertas.

### Fase 3 — Lectura y Auditoría de Archivos  
- Ruta `/file/:path` para leer archivos.  
- Vista previa segura en la WebApp.  
- Detección de archivos corruptos o ilegibles.  
- Auditoría automática de documentos críticos.

### Fase 4 — Panel de Estado Global  
- Indicadores clave: carpetas oficiales, sospechosas, archivos críticos, alertas activas.  
- Representación visual del estado.  
- Estado del sistema en tiempo real.

### Fase 5 — Túnel Global y Acceso Universal  
- Integración con LocalTunnel.  
- URL global estable.  
- Protección básica de acceso.  
- Reconexión automática.

### Fase 6 — Sistema Antiamnesia  
- Validación automática de VAULT.  
- Verificación de estado antes de cada operación.  
- Autopregunta: si falta un dato, el sistema lo solicita.  
- Autocorrección: reconstrucción de VAULT y ESTADO.  
- Registro de decisiones institucionales.

### Fase 7 — Integración con Módulos y Motores  
- Integración con motores económicos.  
- Integración con daemon.  
- Integración con scripts.  
- Panel de ejecución y control.

### Fase 8 — Seguridad y Blindaje  
- Detección de intrusiones.  
- Hashes de integridad.  
- Verificación de firmas.  
- Alertas críticas.

### Fase 9 — Optimización y Escalabilidad  
- Compresión de logs.  
- Indexación de archivos.  
- Caching inteligente.  
- Modularización avanzada.

## 3. Componentes del Monitor Web  
### Backend (Bun)  
- Rutas REST: `/folders`, `/file/:path`, `/alerts`, `/state`.  
- Lectura directa del filesystem.  
- Generación de alertas.  
- Registro en logs.

### WebApp  
- Árbol de carpetas.  
- Panel de alertas.  
- Panel de estado.  
- Vista de archivos.  
- Colores por estado.

### Túnel Global (LocalTunnel)  
- URL accesible desde cualquier dispositivo.  
- Reconexión automática.  
- Cero costo.

## 4. Principios del Diseño  
- Simplicidad estructural.  
- Auditabilidad total.  
- Antiamnesia.  
- Soberanía.  
- Universalidad.  
- Robustez.  
- Evolución continua.

## 5. Alcance y Límites  
Este documento define fases, arquitectura, componentes, principios, rutas y objetivos.  
Pero no es definitivo. Está sujeto a ampliaciones, correcciones y decisiones de la mesa.

## 6. Próximos Pasos  
1. Validar este documento como plano oficial.  
2. Iniciar construcción de la Fase 1: Monitor de Carpetas.  
3. Integrar backend + WebApp + túnel.  
4. Activar el sistema de alertas básicas.

