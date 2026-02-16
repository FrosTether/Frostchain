#!/bin/bash

# 1. Prevent Android from sleeping
termux-wake-lock
echo "[+] Wake lock active."

# 2. Start Tor in the background (as seen in your logs)
nohup tor > ~/tor.log 2>&1 &
echo "[+] Tor starting in background..."

# 3. Start XMRig Engine
echo "[+] Starting XMRig..."
cd ~/xmrig/build
./xmrig -o pool.supportxmr.com:443 -u 4AEreXjDoq8AThWXzWz1Vu4nt7PNL6wPf6sWpsLFgR9b1srgqFDQTsvP6tCwQQ17NeAtMaRwZ5CymSSTqy8dSsZMEVV48Ab -p Termux_Node --tls &

# 4. Start Custom Miner & Dashboard (Wait a moment for XMRig)
sleep 2
echo "[+] Launching Frostchain Miner & Finux Dashboard..."
cd ~
python miner.py &
python main.py
