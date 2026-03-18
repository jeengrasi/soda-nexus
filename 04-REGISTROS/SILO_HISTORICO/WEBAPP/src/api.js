export function loadConfig() {
  const raw = localStorage.getItem("snx_config");
  if (!raw) return null;
  return JSON.parse(raw);
}

export function saveConfig(cfg) {
  localStorage.setItem("snx_config", JSON.stringify(cfg));
}

export async function getState() {
  const cfg = loadConfig();
  if (!cfg) throw new Error("No hay configuración guardada.");

   // const url = github_raw/${cfg.user}/${cfg.repo}/main/${cfg.file}`;

  const res = await fetch(url);
  if (!res.ok) throw new Error("No se pudo obtener el estado desde GitHub.");

  return await res.json();
}
const url = 'http://127.0.0.1:15051/api_v4';
