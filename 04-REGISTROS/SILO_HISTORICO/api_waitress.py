from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
from waitress import serve
import os, json

app = Flask(__name__)
CORS(app)

# COHERENCIA DE RUTAS: Servimos desde el Ministerio 06 directamente
MONITOR_DIR = os.path.expanduser('~/soda/06-MONITOR/V3')
MONITOR_DATA = os.path.join(MONITOR_DIR, 'monitor_data.json')

@app.route('/')
def index():
    # Buscamos el HTML real en el Ministerio 06
    return send_from_directory(MONITOR_DIR, 'index-v4.html')

@app.route('/api/data')
@app.route('/status')
def get_data():
    try:
        with open(MONITOR_DATA, 'r') as f:
            return jsonify(json.load(f))
    except Exception as e:
        return jsonify({"status": "error", "msg": str(e)}), 500

@app.route('/<path:path>')
def static_files(path):
    # Los JS y CSS también están en el Ministerio 06
    return send_from_directory(MONITOR_DIR, path)

if __name__ == '__main__':
    print("🚀 SODA-NEXUS ONLINE (Waitress Soberano)")
    print("🌐 Acceso iPad: http://192.168.12.183:18080")
    serve(app, host='0.0.0.0', port=18080, threads=6)
