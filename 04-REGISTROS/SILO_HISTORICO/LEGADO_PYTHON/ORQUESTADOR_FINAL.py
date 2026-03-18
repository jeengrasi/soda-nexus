from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
import os, json

app = Flask(__name__)
CORS(app)

STATIC_DIR = os.path.expanduser('~/soda/SODA_LIVE_PRODUCTION')
DATA_PATH = os.path.expanduser('~/soda/06-MONITOR/V3/monitor_data.json')

@app.route('/')
def index():
    return send_from_directory(STATIC_DIR, 'index.html')

@app.route('/api/data')
@app.route('/monitor/data')
def get_data():
    try:
        with open(DATA_PATH, 'r') as f:
            return jsonify(json.load(f))
    except:
        return jsonify({"status": "error", "message": "Sincronizando..."}), 202

@app.route('/<path:path>')
def static_files(path):
    return send_from_directory(STATIC_DIR, path)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=15051)
