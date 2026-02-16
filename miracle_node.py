import time
import sys
import random
import os

# --- MIRACLE NODE CONFIGURATION ---
NODE_VERSION = "Miracle-v3.0 (Frostchain Validator)"
BLOCK_REWARD = 13.37
COIN_SYMBOL = "FTC"
BLOCK_TIME_TARGET = 300  # 5 Minutes (Strict Enforced)

class MiracleNode:
    def __init__(self):
        self.last_block_time = 0
        self.total_blocks_found = 0
        self.node_id = f"NODE-{random.randint(1000,9999)}"
        # Initialize timer
        self.last_block_time = 0 

    def log_node_status(self, message):
        # formatted output for the node dashboard
        timestamp = time.strftime("%H:%M:%S", time.localtime())
        print(f"[{timestamp}] [{self.node_id}] {message}")

    def sync_network(self):
        # Simulates syncing with other Frostchain peers
        self.log_node_status("Syncing with Frostchain peers...")
        time.sleep(1)
        self.log_node_status("Network latency: 12ms | Peers: 4/8 Active")

    def start_node(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"❄️  {NODE_VERSION} STARTING...")
        print(f"❄️  Consensus Rule: 1 Block every {BLOCK_TIME_TARGET} seconds")
        print("--------------------------------------------------")
        
        self.sync_network()

        while True:
            current_time = time.time()
            time_diff = current_time - self.last_block_time
            
            # --- THE 5-MINUTE CAP LOGIC ---
            if time_diff < BLOCK_TIME_TARGET:
                # If we are too early, we VALIDATE instead of MINE
                wait_time = int(BLOCK_TIME_TARGET - time_diff)
                
                # Visual heartbeat for the node (only prints every 60s to keep log clean)
                if wait_time % 60 == 0:
                    self.log_node_status(f"Validating transactions... [Next Block: {wait_time}s]")
                
                time.sleep(1) 
                continue

            # --- BLOCK REWARD UNLOCKED ---
            self.total_blocks_found += 1
            print("\n" + "="*40)
            self.log_node_status(f"⚡ MIRACLE BLOCK FOUND! ⚡")
            print(f"    Reward: +{BLOCK_REWARD} {COIN_SYMBOL}")
            print(f"    Block Height: {1024 + self.total_blocks_found}")
            print(f"    Validator Hash: 0x{random.getrandbits(64):x}")
            print("="*40 + "\n")
            
            # RESET TIMER
            self.last_block_time = time.time()
            
            # Stability Pause
            time.sleep(2)

if __name__ == "__main__":
    try:
        node = MiracleNode()
        node.start_node()
    except KeyboardInterrupt:
        print("\n\n[!] Miracle Node shutdown safely.")
        sys.exit()
