import os
import subprocess
import json
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/api/*": {"origins": "*"}})

# HARDWARE LOCK
SYSTEM_SIG = "FROST_PROTOCOL_MASTER_777"

@app.route('/api/cli', methods=['POST'])
def handle_cli():
    # 1. Hardware IP Lock
    if request.remote_addr != '127.0.0.1':
        return jsonify({"status": "locked"}), 403

    data = request.json
    cmd = data.get('cmd')
    
    # --- BIOMETRIC LOGIC ---
    if cmd == "biometric-auth":
        try:
            # Calls the native Android Fingerprint API via Termux
            result = subprocess.run(["termux-fingerprint"], capture_output=True, text=True)
            output = result.stdout.strip()
            
            # Check for the specific success code from Android
            if "AUTH_RESULT_SUCCESS" in output:
                return jsonify({"status": "success", "output": "BIOMETRIC_MATCH"})
            else:
                return jsonify({"status": "error", "message": "NO_MATCH"})
        except Exception as e:
            return jsonify({"status": "error", "message": "TERMUX_API_MISSING"})
    # -----------------------

    # Standard CLI commands (Miner/Wallet)
    if data.get('sig') != SYSTEM_SIG:
        return jsonify({"status": "denied"}), 401
        
    params = data.get('params', [])
    full_cmd = ["frostchain-cli", cmd] + params
    
    try:
        result = subprocess.run(full_cmd, capture_output=True, text=True)
        return jsonify({"status": "success", "output": result.stdout.strip()})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8082)
