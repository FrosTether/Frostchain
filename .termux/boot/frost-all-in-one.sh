#!/data/data/com.termux/files/usr/bin/sh

# Keep the device awake for mining
termux-wake-lock

# 1. Start the Grayson API / Local Node Bridge
# Runs in the background (Port 8082)
python3 ~/frosted_ledger_2fa/miracle_miner_node/listener.py &

# 2. Start the XMR / FNR Fork Miner
# Replace '~/miner' with your actual miner path
cd ~/xmrig/build && ./xmrig --config=config.json &

# 3. Final Confirmation Log
echo "[SYSTEM]: Frost Protocol Bridge & Miner Active."
