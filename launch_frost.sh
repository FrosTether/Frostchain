#!/bin/bash

# 1. Wake Lock
termux-wake-lock

# 2. Paths
CLI="/data/data/com.termux/files/home/frostchain-cli"
XMR="/data/data/com.termux/files/home/xmrig/build"
LOG="/data/data/com.termux/files/home/frost_logs"

echo "--------------------------------------------------"
echo "   ❄️  FROST PROTOCOL SUITE ACTIVE  ❄️"
echo "--------------------------------------------------"

# 3. Frostchain CLI
if pgrep -f "frostchain-cli" > /dev/null; then
    echo "[!] CLI already active."
else
    echo "[+] Starting Frostchain CLI..."
    # Check if CLI binary exists before running
    if [ -f "$CLI" ]; then
        nohup "$CLI" start > "$LOG/frostchain.log" 2>&1 &
    else
        echo "[!] CLI binary not found at $CLI (Skipping)"
    fi
fi

# 4. Main Miner
echo "[+] Starting Main XMR Miner..."
cd "$XMR" || exit
nohup ./xmrig --config=config.json > "$LOG/xmrig_main.log" 2>&1 &

# 5. FNR Miner
echo "[+] Starting FNR Softfork Miner..."
nohup ./xmrig --config=config_fnr.json > "$LOG/xmrig_fnr.log" 2>&1 &

# 6. Quantum Miner
echo "[+] Starting Quantum Solfeggio Miner..."
nohup nice -n -10 ./xmrig --config=config_quantum.json > "$LOG/xmrig_quantum.log" 2>&1 &

echo "--------------------------------------------------"
echo "✅ DEPLOYMENT COMPLETE."
echo "   - Main Log:    tail -f $LOG/xmrig_main.log"
echo "   - Quantum Log: tail -f $LOG/xmrig_quantum.log"
echo "--------------------------------------------------"
