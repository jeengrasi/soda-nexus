from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
import os, json

app = Flask(__name__)
CORS(app)

# CONFIGURACIÓN DE RUTAS CERTIFICADAS
STATIC_DIR = "/data/data/com.termux/files/home/soda/03-OPERACIONES/WEB/monitor-v4.LEGACY_PROCESADO"
DATA_PATH = os.path.expanduser('~/soda/06-MONITOR/V3/monitor_data.json')

@app.route('/')
def index():
    # Buscamos el archivo index principal de esa carpeta
    return send_from_directory(STATIC_DIR, 'index-v4.html' if os.path.exists(os.path.join(STATIC_DIR, 'index-v4.html')) else 'index.html')

@app.route('/api/data')
@app.route('/api_v4')
def get_data():
    try:
        with open(DATA_PATH, 'r') as f:
            return jsonify(json.load(f))
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/<path:path>')
def static_files(path):
    return send_from_directory(STATIC_DIR, path)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=15051)
