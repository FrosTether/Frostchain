import os
import subprocess
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
# Lock CORS down specifically to your Surge domains
CORS(app, resources={r"/api/*": {"origins": ["https://KelseeMfrostchain.surge.sh", "https://miracle-node.surge.sh"]}})

# This is your unique System Signature. Even without a PIN, 
# the web UI must send this exact token to trigger the wallet.
SYSTEM_TOKEN = "FROST_OS_ADMIN_SECURE_777"

@app.route('/api/cli', methods=['POST'])
def handle_cli():
    # 1. IP Security: Only allow requests from your own device
    if request.remote_addr != '127.0.0.1':
        return jsonify({"status": "error", "message": "Unauthorized Hardware Access"}), 403

    data = request.json
    token = data.get('auth_token')
    
    # 2. Token Handshake
    if token != SYSTEM_TOKEN:
        return jsonify({"status": "error", "message": "System Signature Mismatch"}), 401

    cmd = data.get('cmd')
    params = data.get('params', [])
    
    # Force the source to always be your wallet for security
    full_cmd = ["frostchain-cli", cmd] + params
    
    try:
        result = subprocess.run(full_cmd, capture_output=True, text=True)
        return jsonify({"status": "success", "output": result.stdout.strip()})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    # Running only on 127.0.0.1 ensures the gate is closed to the outside world
    app.run(host='127.0.0.1', port=8082)

