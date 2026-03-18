# SNX — RESUMEN ACTUAL DEL SISTEMA

## Fecha
Fri Mar  6 14:50:41 EST 2026

## Raíz de SODA
```
00-GOBIERNO
00-VAULT
01-DOCUMENTOS
01-MEMORIA
02-SCRIPTS
02-SISTEMA
03-OPERACIONES
04-COMUNICACIONES
04-REGISTROS
05-DOCUMENTACION
05-LOGS
05-REGISTROS
06-DOCUMENTACION
06-MONITOR
07-VERSIONES
99-TMP
SNX-FASE0-ESTRUCTURA.sh
SNX-FASE1-INFRA.sh
SNX-FASE2-TOR.sh
SNX-FASE3-MONITOR.sh
SNX-FASE3_5-MONITOR-TOR.sh
docs
```

## Monitor y backend
- monitor_data.json: /data/data/com.termux/files/home/soda/06-MONITOR/V3/monitor_data.json
- backend scripts:   /data/data/com.termux/files/home/soda/02-SCRIPTS/GLOBAL/
- backend monitor:   /data/data/com.termux/files/home/soda/02-SISTEMA/BACKEND/MONITOR/

## IP detectada (best-effort)
flags=4163<UP,BROADCAST,RUNNING,MULTICAST>

## Scripts clave
```
snx_auditoria_integridad.sh
snx_central.sh
snx_central_backend.sh
snx_central_backend_v2.sh
snx_central_backend_v3.sh
snx_deploy_estado.sh
snx_detect_repos.sh
snx_ia_diagnostico.sh
snx_memoria_resumen_v1.sh
snx_monitor_clone_repo.sh
snx_monitor_migrar_a_raiz.sh
snx_monitor_publish_frontend.sh
snx_publish_monitor.sh
snx_select_repo.sh
```

## Fases registradas en raíz
```
SNX-FASE0-ESTRUCTURA.sh
SNX-FASE1-INFRA.sh
SNX-FASE2-TOR.sh
SNX-FASE3-MONITOR.sh
SNX-FASE3_5-MONITOR-TOR.sh
```

## Nota para IA
Este archivo existe para que el usuario lo copie y lo pegue en cualquier
nueva sesión de IA, permitiendo rehidratar el contexto sin depender de
memoria interna del modelo.
