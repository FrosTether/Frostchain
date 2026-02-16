#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock

# Start the Bridge
python3 ~/frosted_ledger_2fa/miracle_miner_node/listener.py &

# Start the Miner
cd ~/xmrig/build && ./xmrig &

echo "[SYSTEM]: Frost Protocol Active. Miner & Bridge Engaged."
