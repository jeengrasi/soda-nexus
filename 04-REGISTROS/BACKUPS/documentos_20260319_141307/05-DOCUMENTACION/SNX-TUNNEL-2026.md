# SNX‑TUNNEL‑2026
## Documento institucional — Debate multi‑IA sobre alternativas a Cloudflare Tunnel
### SODA‑NEXUS — Sistema soberano, auditable y antiamnesia  
**Fecha:** 2026‑02‑26

---

## 1. Contexto institucional

Cloudflare Tunnel dejó de permitir la creación de túneles sin asociarlos a un dominio. Esto bloquea el flujo soberano de SODA‑NEXUS porque:

- Exige un dominio para generar `cert.pem`.
- Introduce dependencia corporativa.
- Rompe la autonomía del sistema.
- Impide operar desde Termux sin infraestructura externa.

El Consejo de IA (Gemini, DeepSeek, Qwen) analizó alternativas, rutas y estrategias para restaurar la conectividad soberana del backend Flask y la WebApp.

---

## 2. Síntesis de las tres respuestas IA

### 2.1 Gemini — Soberanía y estrategia financiera

- Cloudflare representa un riesgo de vendor lock‑in.
- Recomienda abandonar la dependencia de dominios.
- Propone Zrok y Tailscale como rutas soberanas.
- Sugiere integrar tokens de túnel en la bóveda y reportes en Telegram.
- Enfatiza que la infraestructura debe servir al motor económico, no frenarlo.

### 2.2 DeepSeek — Comparativa técnica exhaustiva

- Clasifica alternativas en:
  - Servicios gestionados.
  - Soluciones de malla / Zero‑Trust.
  - Herramientas autoalojadas.
- Evalúa Pinggy, Ngrok, LocalTunnel, LocalXpose, Tailscale, Zrok, FRP, Rathole, Pangolin, Octelium.
- Propone una ruta por fases:
  - Fase 1: Pinggy (inmediato).
  - Fase 2: Tailscale Funnel (seguridad).
  - Fase 3: FRP/Pangolin (soberanía total).
- Documenta casos de éxito y compatibilidad con Termux.

### 2.3 Qwen — Análisis técnico honesto

- Aclara que los túneles no generan ingresos; solo habilitan infraestructura.
- Recomienda Pinggy como solución inmediata.
- Propone una hoja de ruta técnica de 7 días.
- Enfatiza validación en DEMO antes de operar en real.
- Proporciona scripts para automatizar túneles y logs.

---

## 3. Comparativa integrada de alternativas (2026)

| Alternativa       | Requiere dominio | Soberanía | Persistencia | Protocolos          | Costo        | Ideal para                |
|-------------------|------------------|-----------|--------------|---------------------|-------------:|---------------------------|
| Cloudflare Tunnel | Sí               | Baja      | Alta         | HTTP/HTTPS          | $0           | Empresas con dominio      |
| Pinggy            | No               | Media     | Baja         | TCP/UDP/HTTP        | $0–2.50      | Pruebas rápidas           |
| Ngrok             | No               | Baja      | Media        | HTTP                | $8+          | Webhooks                  |
| LocalTunnel       | No               | Baja      | Baja         | HTTP                | $0           | Desarrollo                |
| localhost.run     | No               | Alta      | Baja         | HTTP                | $0           | Túneles desechables       |
| LocalXpose        | No               | Media     | Media        | TCP/UDP/HTTP        | $6           | Apps pequeñas             |
| Tailscale Funnel  | No               | Alta      | Alta         | WireGuard (todos)   | $0 personal  | Acceso privado            |
| Zrok              | No               | Muy alta  | Alta         | TCP/UDP             | $0 (self‑hosted) | Zero‑trust soberano   |
| FRP               | No               | Muy alta  | Alta         | TCP/UDP/HTTP/HTTPS  | $3–5 (VPS)   | Infraestructura propia    |
| Rathole           | No               | Muy alta  | Alta         | TCP/UDP             | $3–5 (VPS)   | Alto rendimiento          |
| Pangolin          | No               | Muy alta  | Alta         | TCP/UDP             | $3–5 (VPS)   | Dashboard y control       |
| Octelium          | No               | Muy alta  | Alta         | Multi‑protocolo     | $3–5 (VPS)   | Zero‑trust avanzado       |

---

## 4. Rutas estratégicas para SODA‑NEXUS

### 4.1 Ruta 1 — Solución inmediata (hoy)

Pinggy:

- No requiere instalación adicional (usa SSH).
- Funciona en Termux.
- Soporta WebSockets (vía TCP).
- No requiere dominio.
- Permite avanzar ya con la WebApp.

Comando base: ssh -p 443 -R0:localhost:5050 a.pinggy.io

---

### 4.2 Ruta 2 — Solución intermedia (seguridad + estabilidad)

Tailscale Funnel:

- Seguridad WireGuard.
- Persistencia real.
- Ideal para acceso privado desde el iPad.
- No requiere dominio.

Comandos base:
- pkg install tailscale
- tailscale up
- tailscale funnel 5050

---

### 4.3 Ruta 3 — Solución soberana (control total)

FRP / Rathole / Zrok / Pangolin:

- Requieren un VPS mínimo ($3–5/mes).
- Ofrecen control total de la infraestructura.
- Permiten persistencia 24/7.
- Soportan múltiples protocolos.
- Son compatibles con arquitecturas Zero‑Trust.

Ejemplo FRP (cliente en Termux): ./frpc -c frpc.toml

---

## 5. Conclusiones institucionales

1. Cloudflare Tunnel queda descartado como solución principal para SODA‑NEXUS.
2. Pinggy es la solución inmediata para avanzar hoy.
3. Tailscale Funnel es la solución intermedia para operación diaria.
4. FRP/Pangolin/Zrok/Rathole son la solución final para soberanía total.
5. Los túneles no generan ingresos; solo habilitan infraestructura.
6. La libertad financiera depende de estrategias económicas validadas.
7. SODA‑NEXUS debe mantener antiamnesia documentando cada cambio.

---

## 6. Próximos pasos sugeridos

- Crear snx_tunnel_manager.sh para automatizar túneles.
- Integrar URL dinámica en la WebApp.
- Registrar eventos en auditoría.
- Planificar VPS para soberanía total.

---

## Footer institucional

SODA‑NEXUS — Sistema soberano, auditable y antiamnesia  
Documento: SNX‑TUNNEL‑2026.md  
Ubicación: ~/soda/00-DOCS/SNX-TUNNEL-2026.md
