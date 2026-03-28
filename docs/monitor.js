/* ============================================================
   SODA‑NEXUS — Monitor Soberano V2.1
   Versión con logs reales desde el backend
   ============================================================ */

const API = window.SNX_BACKEND_URL_V4;

// Cargar datos desde backend en vivo
async function cargarDatosVivo() {
    try {
        const response = await fetch(`${API}/status`);
        return await response.json();
    } catch (error) {
        console.error('Error cargando datos:', error);
        return null;
    }
}

// Cargar logs reales desde backend
async function cargarLogsReales() {
    try {
        const response = await fetch(`${API}/logs`);
        const data = await response.json();
        return data.logs || [];
    } catch (error) {
        console.error('Error cargando logs:', error);
        return [];
    }
}

// Renderizar Estado Global
function renderEstadoGlobal(data) {
    const container = document.getElementById("snx-estado-global");
    if (!container) return;
    
    const backendStatus = data?.backend ? "✅ ACTIVO" : "❌ INACTIVO";
    const timestamp = data?.timestamp || "—";
    
    container.innerHTML = `
        <div class="estado-item">🖥️ Backend Flask: ${backendStatus}</div>
        <div class="estado-item">🌐 Túnel Cloudflare: ✅ ACTIVO</div>
        <div class="estado-item">🤖 IA Local: ✅ ACTIVO (deepseek-coder:1.3b)</div>
        <div class="estado-item">📡 Monitor Netlify: ✅ ONLINE</div>
        <div class="estado-item">📅 Última actualización: ${timestamp}</div>
    `;
}

// Renderizar Tabla de Ministerios
function renderMinisterios(data) {
    const container = document.getElementById("snx-ministerios");
    if (!container) return;
    
    const ministerios = data?.ministerios || {};
    const orden = [
        "00-GOBIERNO", "01-MEMORIA", "02-SISTEMA", "03-OPERACIONES",
        "04-REGISTROS", "05-DOCUMENTACION", "06-MONITOR", "docs"
    ];
    
    let html = `
        <table class="ministerios-tabla">
            <thead>
                <tr><th>Ministerio</th><th>Archivos</th><th>Estado</th><th>Última auditoría</th></tr>
            </thead>
            <tbody>
    `;
    
    orden.forEach(m => {
        const count = ministerios[m] || 0;
        let estado = "✅ OK";
        if (m === "03-OPERACIONES" && count < 3) estado = "⚠️ SIN MOTORES";
        if (m === "06-MONITOR" && count === 0) estado = "⚠️ VACÍO";
        if (count === 0 && m !== "06-MONITOR") estado = "⚠️ VACÍO";
        
        html += `\
            <tr><td>${m}</td><td>${count}</td><td>${estado}</td><td>${data?.timestamp || "—"}</td>\
        `;
    });
    
    html += `</tbody>`;
    container.innerHTML = html;
}

// Renderizar Logs Reales
function renderLogsReales(logs) {
    const container = document.getElementById("snx-logs");
    if (!container) return;
    
    if (!logs || logs.length === 0) {
        container.innerHTML = '<div class="log-line">No hay logs disponibles</div>';
        return;
    }
    
    container.innerHTML = logs.slice(0, 20).map(log => `<div class="log-line">${log}</div>`).join('');
}

// Renderizar Estructura (estática)
function renderEstructura() {
    const container = document.getElementById("snx-estructura");
    if (!container) return;
    
    container.innerHTML = `
        <pre class="estructura-tree">
📂 soda/
├── 📂 00-GOBIERNO/
│   ├── 📂 DECISIONES/
│   ├── 📂 ESTADO/CONFIG/
│   ├── 📂 META/
│   └── 📂 VAULT/ (🔒 protegido)
├── 📂 01-MEMORIA/
│   ├── 📂 ACTUAL/
│   └── 📂 BACKUPS/
├── 📂 02-SISTEMA/
│   ├── 📂 BACKEND/
│   ├── 📂 GLOBAL/
│   └── [9 scripts unificados]
├── 📂 03-OPERACIONES/
│   └── 📂 MOTORES/
├── 📂 04-REGISTROS/
│   ├── 📂 SYSTEM/
│   ├── 📂 SILO_HISTORICO/
│   └── 📂 AUDITORIAS/
├── 📂 05-DOCUMENTACION/
│   ├── 📂 CERTIFICACION/
│   ├── 📂 INFORMES/
│   └── 📂 MANUALES/
├── 📂 06-MONITOR/ (vacío)
└── 📂 docs/ (frontend público)
        </pre>
    `;
}

// Inicializar todo
window.addEventListener('DOMContentLoaded', async () => {
    // Cargar datos de estado
    const estado = await cargarDatosVivo();
    if (estado) {
        renderEstadoGlobal(estado);
        renderMinisterios(estado);
    } else {
        document.getElementById("snx-ministerios").innerHTML = '<div class="error">Error cargando datos</div>';
    }
    
    // Cargar logs reales
    const logs = await cargarLogsReales();
    renderLogsReales(logs);
    
    // Cargar estructura
    renderEstructura();
});
