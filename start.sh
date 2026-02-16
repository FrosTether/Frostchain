#!/bin/bash

# 1. Acquire Wake Lock (Crucial for Android background stability)
echo "[*] Acquiring Termux Wake Lock..."
termux-wake-lock

# Configuration - Update these paths if your folders are named differently
FROST_CLI_PATH="$HOME/frostchain-cli"  # Path to your CLI tool
XMRIG_DIR="$HOME/xmrig/build"           # Path to XMRig build folder
FNR_MINER_DIR="$HOME/fnr-miner"         # Path to your FNR softfork miner

# Log files (so you can check status later)
LOG_DIR="$HOME/frost_logs"
mkdir -p "$LOG_DIR"

echo "--------------------------------------------------"
echo "   ❄️  STARTING FROST PROTOCOL SUITE  ❄️"
echo "--------------------------------------------------"

# 2. Launch Frostchain CLI
# Assuming 'start' or 'daemon' is the command. Adjust flags as needed.
if pgrep -f "frostchain-cli" > /dev/null; then
    echo "[!] Frostchain CLI is already running."
else
    echo "[+] Launching Frostchain CLI..."
    # Running in background, sending logs to file
    nohup "$FROST_CLI_PATH" start > "$LOG_DIR/frostchain.log" 2>&1 &
    echo "    PID: $!"
fi

# 3. Launch XMR Miner (Monero)
if pgrep -f "xmrig" > /dev/null; then
    echo "[!] XMRig is already running."
else
    echo "[+] Launching XMR Miner..."
    cd "$XMRIG_DIR" || { echo "❌ XMRig directory not found!"; exit 1; }
    # Using config.json by default
    nohup ./xmrig > "$LOG_DIR/xmrig_xmr.log" 2>&1 &
    echo "    PID: $!"
fi

# 4. Launch FNR Softfork Miner
# Assuming the executable is named 'fnr-miner' or similar. Change to './xmrig' if it's just a renamed xmrig instance.
if pgrep -f "fnr-miner" > /dev/null; then
    echo "[!] FNR Miner is already running."
else
    echo "[+] Launching FNR Softfork Miner..."
    if [ -d "$FNR_MINER_DIR" ]; then
        cd "$FNR_MINER_DIR" || exit
        # Launch command for FNR. Adjust flags or config file name if needed.
        nohup ./fnr-miner --coin=fnr-softfork > "$LOG_DIR/fnr_miner.log" 2>&1 &
        echo "    PID: $!"
    else
        echo "❌ FNR Miner directory not found at $FNR_MINER_DIR"
    fi
fi

echo "--------------------------------------------------"
echo "✅ All systems executed."
echo "   - View logs in: $LOG_DIR"
echo "   - Monitor CPU usage with: htop"
echo "   - To stop all: pkill -f xmrig && pkill -f frostchain-cli"
echo "--------------------------------------------------"
