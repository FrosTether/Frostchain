#!/data/data/com.termux/files/usr/bin/sh
# Location: ~/.termux/boot/frost_init.sh

# 1. Wake Lock (Prevents Android from killing the miner)
termux-wake-lock

# 2. Start the Hardware Bridge
python3 ~/frosted_ledger_2fa/listener.py &

# 3. Launch FNR/XMR Fork Miner
cd ~/xmrig/build && ./xmrig --config=config.json &

# 4. Notify System
echo "[FROST PROTOCOL]: All systems active. drfrost.frostchain is live."
