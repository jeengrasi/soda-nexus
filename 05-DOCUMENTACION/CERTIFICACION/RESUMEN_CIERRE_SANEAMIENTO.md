
### ANEXO: RESCATE DE LÓGICA DE PERSISTENCIA
- Se identificó el script `daemon_monitor_watchdog.sh` como motor de resiliencia.
- Se aplicó reingeniería para proteger el Mando Único V6.
- Se validó que el sistema es autoreparable bajo la nueva estructura 00-05.

### EVOLUCIÓN: AUDITOR DE PRESENCIA (Ex Antiamnesia)
- El script fue renombrado de `daemon_antiamnesia.sh` a `snx_auditor_presencia_v6.sh` para facilitar su comprensión lógica.
- Se actualizaron las rutas de verificación para apuntar a los nuevos pilares (MAPA_SOBERANO, REGLA_DE_GUARDADO).
- Se preservó la función de "latido de datos" cada 5 minutos.
