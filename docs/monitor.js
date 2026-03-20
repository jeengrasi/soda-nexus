/* ============================================================
   SODA‑NEXUS — Lógica del Monitor Web (VERSIÓN ESTÁTICA)
   Controla la visualización de ministerios y desviaciones.
   Lee datos desde monitor_data.json (generado por Termux).
   ============================================================ */

// OBS: Función para cargar datos desde el JSON estático
async function cargarDatos() {
    try {
        const response = await fetch('monitor_data.json');
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error cargando monitor_data.json:', error);
        return null;
    }
}

// OBS: Función para determinar clase CSS según estado
function snx_classForEstado(estado) {
    if (!estado) return "";
    const e = estado.toUpperCase();
    if (e === "OK" || e === "ACTIVO") return "btn-ok";
    if (e.includes("WARN") || e.includes("AVISO")) return "btn-warn";
    return "btn-error";
}

// OBS: Renderizar ministerios
function snx_renderMinisterios(ministerios) {
    const container = document.getElementById("snx-ministerios");
    if (!container) return;
    container.innerHTML = "";

    const orden = [
        "00-GOBIERNO",
        "01-MEMORIA",
        "02-SISTEMA",
        "03-OPERACIONES",
        "04-REGISTROS",
        "05-DOCUMENTACION",
        "06-MONITOR",
        "docs"
    ];

    orden.forEach((m) => {
        const count = ministerios[m] || 0;
        const estado = count > 0 ? "OK" : "SIN_DATOS";
        const div = document.createElement("div");
        div.className = "btn-ministerio " + snx_classForEstado(estado);
        div.innerHTML = `<div>${m}</div><span class="badge">${count} archivos</span>`;
        container.appendChild(div);
    });
}

// OBS: Actualizar estado global
function snx_actualizarEstadoGlobal(data) {
    const statusPill = document.getElementById("snx-status-pill");
    if (statusPill) {
        const estado = data.backend === "ACTIVO" ? "ACTIVO" : "INACTIVO";
        statusPill.textContent = estado;
        statusPill.className = "status-pill " + (estado === "ACTIVO" ? "status-ok" : "status-warn");
    }

    const metaCentral = document.getElementById("snx-meta-central");
    if (metaCentral) metaCentral.textContent = `Última actualización: ${data.timestamp || "—"}`;

    const metaAntiamnesia = document.getElementById("snx-meta-antiamnesia");
    if (metaAntiamnesia) metaAntiamnesia.textContent = `Versión: ${data.version || "1.0"}`;

    const metaValidacion = document.getElementById("snx-meta-validacion");
    if (metaValidacion) metaValidacion.textContent = `Scripts unificados: ${data.scripts_unificados?.length || 0}`;
}

// OBS: Renderizar desviaciones (simplificado)
function snx_renderDesviaciones(data) {
    const container = document.getElementById("snx-desviaciones");
    if (!container) return;

    if (data.backend !== "ACTIVO") {
        container.innerHTML = `<div class="desviacion-error">⚠️ Backend inactivo. Datos generados el ${data.timestamp || "fecha desconocida"}.</div>`;
        return;
    }

    container.innerHTML = `<div class="desviacion-info">✅ Sistema operativo. Última actualización: ${data.ultima_actualizacion || data.timestamp || "—"}</div>`;
}

// OBS: Inicialización al cargar la página
window.addEventListener('DOMContentLoaded', async () => {
    const data = await cargarDatos();
    if (data) {
        snx_actualizarEstadoGlobal(data);
        snx_renderMinisterios(data.ministerios);
        snx_renderDesviaciones(data);
    } else {
        document.getElementById("snx-ministerios").innerHTML = '<div class="error">Error cargando datos. Asegúrate de que monitor_data.json existe.</div>';
    }
});
