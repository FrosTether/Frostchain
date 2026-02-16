import os
import subprocess
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
# Secure CORS: Only allow your specific Surge sites to communicate with the node
CORS(app, resources={r"/api/*": {"origins": ["https://KelseeMfrostchain.surge.sh", "https://miracle-node.surge.sh"]}})

# Hardware Identity Token - This is the "Unhackable" key
SYSTEM_SIG = "FROST_PROTOCOL_MASTER_777"

@app.route('/api/cli', methods=['POST'])
def handle_cli():
    # Security: Hardware lock to Localhost only
    if request.remote_addr != '127.0.0.1':
        return jsonify({"status": "locked", "msg": "Unauthorized External Access"}), 403

    data = request.json
    if data.get('sig') != SYSTEM_SIG:
        return jsonify({"status": "denied", "msg": "Identity Mismatch"}), 401

    cmd = data.get('cmd')
    params = data.get('params', [])
    
    # Logic to handle both Frostchain-CLI and XMRig Miner status
    try:
        if cmd == "miner-status":
            status = os.popen("pgrep xmrig").read().strip()
            return jsonify({"status": "success", "output": "ACTIVE" if status else "OFFLINE"})
        
        # Execute actual Frostchain ledger commands
        full_cmd = ["frostchain-cli", cmd] + params
        result = subprocess.run(full_cmd, capture_output=True, text=True)
        return jsonify({"status": "success", "output": result.stdout.strip()})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    # Lockdown: Port 8082 on 127.0.0.1 (Internal Only)
    app.run(host='127.0.0.1', port=8082)
