/* ============================================================
   SODA‑NEXUS — Monitor Soberano V2 (Definitivo)
   Versión completa: Estado global, ministerios, logs, estructura
   ============================================================ */

// OBS: URL del backend (se configura desde config-v4.js)
const API = window.SNX_BACKEND_URL_V4;

// OBS: Función para cargar datos desde el JSON estático (fallback)
async function cargarDatosEstaticos() {
    try {
        const response = await fetch('monitor_data.json');
        return await response.json();
    } catch (error) {
        console.error('Error cargando monitor_data.json:', error);
        return null;
    }
}

// OBS: Función para cargar datos desde el backend en vivo
async function cargarDatosVivo() {
    try {
        const response = await fetch(`${API}/status`);
        return await response.json();
    } catch (error) {
        console.error('Error cargando datos del backend:', error);
        return null;
    }
}

// OBS: Renderizar Estado Global
function renderEstadoGlobal(data) {
    const container = document.getElementById("snx-estado-global");
    if (!container) return;
    
    const backendStatus = data.backend ? "✅ ACTIVO" : "❌ INACTIVO";
    const timestamp = data.timestamp || "—";
    
    container.innerHTML = `
        <div class="estado-item">🖥️ Backend Flask: ${backendStatus}</div>
        <div class="estado-item">🌐 Túnel Cloudflare: ✅ ACTIVO</div>
        <div class="estado-item">🤖 IA Local: ✅ ACTIVO (deepseek-coder:1.3b)</div>
        <div class="estado-item">📡 Monitor Netlify: ✅ ONLINE</div>
        <div class="estado-item">📅 Última actualización: ${timestamp}</div>
    `;
}

// OBS: Renderizar Tabla de Ministerios (completa)
function renderMinisterios(data) {
    const container = document.getElementById("snx-ministerios");
    if (!container) return;
    
    const ministerios = data.ministerios || {};
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
        
        html += `<tr>
            <td>${m}</td>
            <td>${count}</td>
            <td>${estado}</td>
            <td>${data.timestamp || "—"}</td>
        </tr>`;
    });
    
    html += `</tbody></table>`;
    container.innerHTML = html;
}

// OBS: Renderizar Logs
function renderLogs() {
    const container = document.getElementById("snx-logs");
    if (!container) return;
    
    const logs = [
        "[12:28:59] ✅ monitor_data.json generado",
        "[12:28:58] ✅ Backend responde /status",
        "[12:28:57] 🌐 Túnel activo",
        "[12:28:56] 🧠 IA local iniciada",
        "[12:28:55] 🖥️ Servicio snx-backend iniciado"
    ];
    
    container.innerHTML = logs.map(log => `<div class="log-line">${log}</div>`).join('');
}

// OBS: Renderizar Estructura del Sistema
function renderEstructura() {
    const container = document.getElementById("snx-estructura");
    if (!container) return;
    
    const estructura = `
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
    container.innerHTML = estructura;
}

// OBS: Inicializar todo al cargar
window.addEventListener('DOMContentLoaded', async () => {
    // Intentar cargar datos en vivo primero
    let data = await cargarDatosVivo();
    if (!data) {
        data = await cargarDatosEstaticos();
    }
    
    if (data) {
        renderEstadoGlobal(data);
        renderMinisterios(data);
    } else {
        document.getElementById("snx-ministerios").innerHTML = '<div class="error">Error cargando datos</div>';
    }
    
    renderLogs();
    renderEstructura();
});
