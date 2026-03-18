#!/data/data/com.termux/files/usr/bin/bash
LOG_FILE="/data/data/com.termux/files/home/soda/04-REGISTROS/motor_ingresos_v1.log"
echo "[$(date)] --- ESCANEO DE ARBITRAJE V1.2 ---" >> "$LOG_FILE"

# Obtener precio de Binance
P1=$(curl -s "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT" | grep -oP '(?<="price":")[^"]*')
# Obtener precio de KuCoin
P2=$(curl -s "https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=BTC-USDT" | grep -oP '(?<="price":")[^"]*')

if [ -z "$P1" ] || [ -z "$P2" ]; then
    echo "[$(date)] ALERTA: Fallo de conexión en Nodos de Mercado." >> "$LOG_FILE"
else
    echo "[$(date)] Binance: \$${P1} | KuCoin: \$${P2}" >> "$LOG_FILE"
    # Lógica de detección de oportunidad (Simulada por ahora)
    echo "[$(date)] ANALISIS: Spread detectado. Sistema en espera de liquidez." >> "$LOG_FILE"
fi
