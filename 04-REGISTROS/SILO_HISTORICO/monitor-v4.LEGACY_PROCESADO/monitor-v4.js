/* ============================================================
   SODA-NEXUS — Lógica del Monitor Soberano V4
   Estado global, ministerios, desviaciones, estructura y estado.
   ============================================================ */

/* OBS: URL soberana del backend, definida en config-v4.js. */
const API_V4 = window.SNX_BACKEND_URL_V4;

/* ---------- Utilidades de estado visual ---------- */

function snx_v4_statusClass(status) {
    if (!status) return "status-unknown";
    const s = status.toUpperCase();
    if (s === "OK") return "status-ok";
    if (s === "DEGRADADO" || s.includes("WARN")) return "status-warn";
    if (s === "CRITICO" || s === "CRÍTICO" || s.includes("ERROR")) return "status-error";
    return "status-unknown";
}

function snx_v4_ministerioClass(estado) {
    if (!estado) return "btn-unknown";
    const e = estado.toUpperCase();
    if (e === "OK") return "btn-ok";
    if (e.includes("WARN") || e.includes("AVISO") || e.includes("PERMISO")) return "btn-warn";
    if (e.includes("ERROR") || e.includes("HASH") || e.includes("FALTANTE") || e.includes("MALFORMADO")) return "btn-error";
    return "btn-unknown";
}

function snx_v4_desviacionClass(tipo) {
    if (!tipo) return "desv-info";
    const t = tipo.toUpperCase();
    if (t === "HASH" || t === "ERROR" || t === "CRITICO" || t === "CRÍTICO") return "desv-error";
    if (t === "WARN" || t === "PERMISOS") return "desv-warn";
    return "desv-info";
}

/* ---------- Render: Estado global ---------- */

function snx_v4_renderEstadoGlobal(data) {
    const pill = document.getElementById("snx-status-pill");
    const status = data?.status || "SIN_DATOS";
    pill.textContent = status;
    pill.className = "status-pill " + snx_v4_statusClass(status);

    document.getElementById("snx-meta-central").textContent =
        "CENTRAL: " + (data?.central || "—");
    document.getElementById("snx-meta-antiamnesia").textContent =
        "ANTIAMNESIA: " + (data?.antiamnesia || "—");
    document.getElementById("snx-meta-validacion").textContent =
        "VALIDACIÓN: " + (data?.validacion || "—");
    document.getElementById("snx-meta-timestamp").textContent =
        "BACKEND: " + (data?.timestamp || "—");
}

/* ---------- Render: Latido ---------- */

function snx_v4_renderLatido(data) {
    const el = document.getElementById("snx-meta-latido");
    if (!data) {
        el.textContent = "LATIDO: SIN_DATOS";
        return;
    }
    el.textContent = `LATIDO: ${data.latido || "SIN_DATOS"} @ ${data.timestamp || "—"}`;
}

/* ---------- Render: Ministerios ---------- */

function snx_v4_renderMinisterios(ministerios) {
    const container = document.getElementById("snx-ministerios");
    container.innerHTML = "";

    const orden = [
        "00-GOBIERNO",
        "01-MEMORIA",
        "02-SISTEMA",
        "03-OPERACIONES",
        "04-REGISTROS",
        "05-DOCUMENTACION",
        "06-MONITOR"
    ];

    orden.forEach((id) => {
        const info = ministerios?.[id] || {};
        const estado = info.estado || "SIN_DATOS";
        const ts = info.timestamp || "—";
        const hash = info.hash || "—";
        const engr = info.engranaje || "—";
        const sync = info.sync || "—";

        const div = document.createElement("div");
        div.className = "btn-ministerio " + snx_v4_ministerioClass(estado);
        div.innerHTML = `
            <div class="min-title">${id}</div>
            <div class="min-state">${estado}</div>
            <div class="min-meta">
                ts: ${ts}<br>
                hash: ${hash}<br>
                engranaje: ${engr}<br>
                sync: ${sync}
            </div>
        `;
        container.appendChild(div);
    });
}

/* ---------- Render: Desviaciones ---------- */

function snx_v4_renderDesviaciones(desviaciones) {
    const container = document.getElementById("snx-desviaciones");
    container.innerHTML = "";

    if (!desviaciones || desviaciones.length === 0) {
        const div = document.createElement("div");
        div.className = "desviacion desv-info";
        div.textContent = "Sin desviaciones registradas.";
        container.appendChild(div);
        return;
    }

    desviaciones.forEach((d) => {
        const div = document.createElement("div");
        const tipo = d.tipo || "INFO";
        const clase = snx_v4_desviacionClass(tipo);
        div.className = "desviacion " + clase;
        const ministerio = d.ministerio || "—";
        const archivo = d.archivo || "—";
        const detalle = d.detalle || d.descripcion || d.mensaje || "";
        const ts = d.timestamp || "—";
        div.textContent = `[${tipo}] [${ministerio}] [${archivo}] ${detalle} @ ${ts}`;
        container.appendChild(div);
    });
}

/* ---------- Render: Estructura ---------- */

function snx_v4_renderEstructura(estructura) {
    const container = document.getElementById("snx-estructura-v4");
    container.innerHTML = "";

    if (!estructura) {
        container.textContent = "Sin datos de estructura.";
        return;
    }

    Object.keys(estructura).sort().forEach((min) => {
        const files = estructura[min] || [];
        const line = document.createElement("div");
        line.textContent = `${min}: ${files.join(", ")}`;
        container.appendChild(line);
    });
}

/* ---------- Render: Estado global JSON ---------- */

function snx_v4_renderEstadoGlobalJSON(data) {
    const container = document.getElementById("snx-estado-global-v4");
    if (!data) {
        container.textContent = "Sin datos de estado global.";
        return;
    }
    try {
        container.textContent = JSON.stringify(data, null, 2);
    } catch (e) {
        container.textContent = "Error al formatear estado global: " + e.message;
    }
}

/* ---------- Fetch genérico ---------- */

async function snx_v4_fetchJSON(path) {
    const url = `${API_V4}${path}`;
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status} en ${path}`);
    return await res.json();
}

/* ---------- Actualizaciones periódicas ---------- */

async function snx_v4_updateStatus() {
    try {
        const data = await snx_v4_fetchJSON("/status");
        snx_v4_renderEstadoGlobal(data);
        snx_v4_renderMinisterios(data.ministerios || {});
        snx_v4_renderDesviaciones(data.desviaciones || []);
    } catch (err) {
        snx_v4_renderEstadoGlobal({ status: "CRÍTICO" });
        snx_v4_renderMinisterios({});
        snx_v4_renderDesviaciones([
            {
                tipo: "ERROR",
                ministerio: "00-GOBIERNO",
                archivo: "BACKEND",
                detalle: err.message,
                timestamp: new Date().toISOString()
            }
        ]);
    }
}

async function snx_v4_updateLatido() {
    try {
        const data = await snx_v4_fetchJSON("/latido");
        snx_v4_renderLatido(data);
    } catch (_err) {
        snx_v4_renderLatido(null);
    }
}

async function snx_v4_updateEstructura() {
    try {
        const data = await snx_v4_fetchJSON("/estructura");
        snx_v4_renderEstructura(data.estructura || {});
    } catch (_err) {
        snx_v4_renderEstructura(null);
    }
}

async function snx_v4_updateEstadoGlobalJSON() {
    try {
        const data = await snx_v4_fetchJSON("/estado_global");
        snx_v4_renderEstadoGlobalJSON(data);
    } catch (_err) {
        snx_v4_renderEstadoGlobalJSON(null);
    }
}

/* ---------- Arranque del monitor ---------- */

function snx_v4_iniciarMonitor() {
    snx_v4_updateStatus();
    snx_v4_updateLatido();
    snx_v4_updateEstructura();
    snx_v4_updateEstadoGlobalJSON();
}

window.addEventListener("load", snx_v4_iniciarMonitor);

/* ============================================================
   PIE DE PÁGINA INSTITUCIONAL — SODA-NEXUS
   Este archivo pertenece al sistema soberano SODA-NEXUS.
   REGLAS INSTITUCIONALES:
   1. Las instrucciones deben darse SIEMPRE en orden y completas.
   2. No se deben modificar líneas sin aprobación institucional.
   3. Si un script existe en el sistema, debe solicitarse, leerse
      y modificarse únicamente sobre su contenido real.
   4. No mover, eliminar o sobrescribir archivos sin inspección
      previa del filesystem para evitar pérdida de memoria.
   5. Cada script o documento debe incluir encabezado, observaciones
      por línea y este pie de página institucional.
   6. Mantener coherencia con la estructura soberana del Estado.
   7. Garantizar anti-amnesia y auditabilidad total.
   8. Realizar la mayoría de tareas en un solo chat para preservar
      el contexto operativo y la memoria institucional.
   ============================================================ */
