# Protocolo de Herramientas del Orquestador Soberano

Este documento define el lenguaje formal mediante el cual la IA (local o remota) solicita operaciones al Orquestador de SODA‑NEXUS.  
Es un estándar institucional que garantiza **soberanía**, **seguridad**, **auditabilidad** y **compatibilidad futura**.

---

## 1. Propósito del Protocolo

- Establecer un **lenguaje universal** para que cualquier IA pueda interactuar con el sistema SODA.
- Garantizar que **ninguna IA acceda directamente al filesystem**, sino solo a través del Orquestador.
- Permitir que el Orquestador decida qué IA usar y cómo ejecutar cada herramienta.
- Mantener **soberanía**, **seguridad**, **auditabilidad** y **consistencia**.

---

## 2. Principios del Protocolo

### 2.1. Soberanía
La IA nunca accede directamente al sistema. Solo puede solicitar herramientas.

### 2.2. Seguridad
- Todas las rutas deben comenzar con `/soda/`.
- No se permiten rutas absolutas del sistema Android.
- No se permiten comandos directos.

### 2.3. Auditabilidad
Cada uso de herramienta queda registrado en:

```
/soda/04-REGISTROS/ia_sesiones/
```

### 2.4. Universalidad
El protocolo funciona igual para:
- IA local  
- IA remota  
- Futuras IAs  

---

## 3. Formato General de Solicitud

La IA debe enviar solicitudes en formato JSON:

```json
{
  "herramienta": "nombre_de_la_herramienta",
  "parametros": {
    ...
  }
}
```

---

## 4. Formato General de Respuesta

```json
{
  "exito": true,
  "resultado": { ... },
  "error": null
}
```

En caso de error:

```json
{
  "exito": false,
  "resultado": null,
  "error": "Descripción del error"
}
```

---

## 5. Herramientas Internas (Filesystem SODA)

### 5.1. leer_archivo

Lee un archivo dentro de `/soda`.

**Solicitud:**
```json
{
  "herramienta": "leer_archivo",
  "parametros": { "ruta": "/soda/03-OPERACIONES/motor.py" }
}
```

---

### 5.2. listar_carpeta

Lista archivos y carpetas.

**Solicitud:**
```json
{
  "herramienta": "listar_carpeta",
  "parametros": { "ruta": "/soda/04-REGISTROS" }
}
```

---

### 5.3. arbol

Devuelve estructura recursiva.

**Solicitud:**
```json
{
  "herramienta": "arbol",
  "parametros": { "ruta": "/soda" }
}
```

---

### 5.4. buscar_archivo

Busca archivos por nombre.

**Solicitud:**
```json
{
  "herramienta": "buscar_archivo",
  "parametros": { "nombre": "motor" }
}
```

---

### 5.5. leer_log

Devuelve las últimas N líneas de un log.

**Solicitud:**
```json
{
  "herramienta": "leer_log",
  "parametros": {
    "ruta": "/soda/04-REGISTROS/log.txt",
    "lineas": 50
  }
}
```

---

## 6. Herramientas Externas (IA Remota)

### 6.1. buscar_web

Realiza una búsqueda externa.

**Solicitud:**
```json
{
  "herramienta": "buscar_web",
  "parametros": { "query": "noticias del broker" }
}
```

---

### 6.2. consultar_api

Consulta una API externa.

**Solicitud:**
```json
{
  "herramienta": "consultar_api",
  "parametros": {
    "url": "https://api.example.com/data",
    "payload": { "id": 123 }
  }
}
```

---

## 7. Herramientas de Auditoría Crítica  
*(Siempre ejecutadas por IA local)*

### 7.1. analizar_riesgo  
Analiza riesgo de scripts o motores.

### 7.2. validar_modificacion  
Valida si una modificación es segura.

### 7.3. pre_ejecucion  
Simula ejecución sin correr nada.

---

## 8. Reglas de Seguridad

1. **Solo rutas dentro de `/soda/`.**  
2. **Nunca ejecutar comandos directos.**  
3. **IA remota no ve rutas absolutas.**  
4. **Auditoría crítica → IA local obligatoria.**  
5. **Todo queda registrado.**

---

## 9. Ejemplo Completo de Flujo

### Instrucción del usuario:
> “Revisa el motor y dime si hay riesgos y busca noticias del broker.”

### Flujo:
1. Orquestador detecta tarea mixta.  
2. IA remota pide:  
   - `leer_archivo` del motor  
   - `buscar_web` sobre el broker  
3. Orquestador ejecuta herramientas.  
4. IA remota analiza.  
5. Orquestador registra sesión.  
6. Monitor recibe una sola respuesta.

---

## 10. Estado del Documento

- **Versión:** 1.0  
- **Estado:** Borrador para validación  
- **Rol:** Plano oficial del Protocolo de Herramientas  
- **Ubicación sugerida:** `/soda/04-DOCS/PROTOCOLO_HERRAMIENTAS.md`

