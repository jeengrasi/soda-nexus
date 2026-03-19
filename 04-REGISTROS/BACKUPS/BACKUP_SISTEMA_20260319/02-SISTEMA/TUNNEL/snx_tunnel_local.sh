#!/data/data/com.termux/files/usr/bin/bash
# ---------------------------------------------------------
# SODA‑NEXUS — Túnel Soberano LocalTunnel
# ---------------------------------------------------------
# Observación:
# Este túnel NO depende de DNS del sistema, NI de SRV,
# NI de QUIC, NI de edge discovery. Funciona en T‑Mobile.
# ---------------------------------------------------------

PORT=5000
SUBDOMAIN="snxmonitor"

echo "Iniciando túnel soberano LocalTunnel..."
lt --port $PORT --subdomain $SUBDOMAIN
# URL resultante:
# https://$SUBDOMAIN.loca.lt

# ---------------------------------------------------------
# Observación institucional:
# LocalTunnel garantiza accesibilidad global incluso en
# redes con DNS cifrado, IPv6-only o NAT carrier.
# ---------------------------------------------------------
