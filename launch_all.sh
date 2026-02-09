#!/bin/bash
# --- FINUX KERNEL: ONE-SHOT SB-200K DEPLOY ---

echo -e "\033[1;36m[SYSTEM] KILLING OLD GHOSTS... PREPPING MAGNUM OPUS...\033[0m"
pkill -f python
pkill -f zrok

# 1. Start the Python Validator in the background
echo "[1/4] Waking the Masternode..."
python ~/Finux/fnr_validator.py > ~/masternode.log 2>&1 &
sleep 2

# 2. Start zrok and capture the URL
echo "[2/4] Opening the zrok Tunnel..."
# This starts zrok and saves the log so we can steal the URL
zrok share public http://localhost:5000 --backend-mode proxy > ~/zrok.log 2>&1 &

echo "Waiting for zrok URL..."
sleep 8 # Give it time to connect

# 3. Extract URL and Update HTML
# We look for the 'https://' string in the log file
ZROK_URL=$(grep -o 'https://[^ ]*share.zrok.io' ~/zrok.log | head -n 1)

if [ -z "$ZROK_URL" ]; then
    echo -e "\033[1;31m[ERROR]\033[0m Could not grab zrok URL. Check 'cat ~/zrok.log'"
    exit 1
fi

echo -e "\033[1;32m[SYNC]\033[0m Found URL: $ZROK_URL"
sed -i "s|https://.*.share.zrok.io|$ZROK_URL|g" ~/Finux/dist/index.html

# 4. Final Surge Push
echo "[4/4] Blasting to fpu4eva.surge.sh..."
surge ~/Finux/dist fpu4eva.surge.sh

echo -e "\033[1;35m[LIVE]\033[0m SB-200K IS ONLINE UNTIL MIDNIGHT EST."
echo "Keep this window open. Logs are running in background."
# Tail the logs so you can see claims in real-time
tail -f ~/masternode.log

