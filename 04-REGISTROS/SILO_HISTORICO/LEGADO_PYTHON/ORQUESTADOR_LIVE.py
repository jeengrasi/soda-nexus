from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
import os, json

app = Flask(__name__)
CORS(app)

STATIC_DIR = os.path.expanduser('~/soda/SODA_LIVE_PRODUCTION')
DATA_FILE = os.path.expanduser('~/soda/06-MONITOR/V3/monitor_data.json')

@app.route('/')
def index():
    return send_from_directory(STATIC_DIR, 'index.html')

@app.route('/api/data')
@app.route('/monitor/data')
def get_data():
    try:
        if os.path.exists(DATA_FILE):
            with open(DATA_FILE, 'r') as f:
                return jsonify(json.load(f))
        return jsonify({"status": "offline", "message": "Esperando datos..."}), 202
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/<path:path>')
def static_files(path):
    return send_from_directory(STATIC_DIR, path)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=15051, threaded=True)
