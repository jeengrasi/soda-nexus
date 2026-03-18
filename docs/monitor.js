/* ============================================================
   SODA‑NEXUS — Lógica del Monitor Web (V1)
   Controla la visualización de ministerios y desviaciones.
   ============================================================ */

const API = window.SNX_BACKEND_URL;

function snx_classForEstado(estado) {
    if (!estado) return "";
    const e = estado.toUpperCase();
    if (e === "OK") return "btn-ok";
    if (e.includes("WARN") || e.includes("AVISO")) return "btn-warn";
    return "btn-error";
}

function snx_renderMinisterios(ministerios) {
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

    orden.forEach((m) => {
        const info = ministerios[m] || { estado: "SIN_DATOS" };
        const div = document.createElement("div");
        div.className = "btn-ministerio " + snx_classForEstado(info.estado);
        div.innerHTML = `<div>${m}</div><span class="badge">${info.estado}</span>`;
        container.appendChild(div);
    });
}

function snx_renderDesviaciones(desviaciones) {
    const container = document.getElementById("snx-desviaciones");
    container.innerHTML = "";

    if (!desviaciones || desviaciones.length === 0) {
        container.innerHTML = `<div style="font-size:13px;color:#8b949e;">Sin desviaciones registradas.</div>`;
        return;
    }

    desviaciones.forEach((d) => {
        const div = document.createElement("div");
        div.className = "desviacion-error";
        div.innerText = d;
        container.appendChild(div);
    });
}

async function snx_getStatus() {
    try {
        const response = await fetch(`${API}/status`);
        const data = await response.json();

        document.getElementById("snx-status").innerText = data.status || "SIN_DATOS";
        snx_renderMinisterios(data.ministerios || {});
        snx_renderDesviaciones(data.desviaciones || []);

        return data;
    } catch (err) {
        document.getElementById("snx-status").innerText = "ERROR DE CONEXIÓN";
        snx_renderMinisterios({});
        snx_renderDesviaciones([`ERROR: ${err.message}`]);
        return null;
    }
}

window.onload = () => snx_getStatus();

/* ============================================================
   PIE DE PÁGINA INSTITUCIONAL — SODA‑NEXUS
   Este archivo pertenece al sistema soberano SODA‑NEXUS.
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
   7. Garantizar anti‑amnesia y auditabilidad total.
   8. Realizar la mayoría de tareas en un solo chat para preservar
      el contexto operativo y la memoria institucional.
   ============================================================ */
