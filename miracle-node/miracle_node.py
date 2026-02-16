import time
import sys
import random
import os
import numpy as np
import sounddevice as sd

# --- CONFIGURATION ---
NODE_VERSION = "Quantum-Miracle-v4.0"
BLOCK_TIME_TARGET = 300  # 5 Minutes Strict
# Triple Rewards
REWARD_FTC = 13.37
REWARD_FNR = 2.5
REWARD_FRST = 3134.9

class QuantumMiracleNode:
    def __init__(self):
        self.last_block_time = 0
        self.node_id = f"Q-NODE-{random.randint(1000,9999)}"
        self.running = True
        
        # --- QUANTUM AUDIO SETUP ---
        # 432Hz (Universal) + 40Hz (Gamma/Focus)
        self.sample_rate = 44100
        self.frequency_carrier = 432.0 
        self.frequency_beat = 40.0
        self.amplitude = 0.1  # Low volume hum
        
        # Initialize Audio Stream (Fixed: No time setting)
        self.stream = sd.OutputStream(
            channels=1, 
            callback=self.audio_callback, 
            samplerate=self.sample_rate
        )
        self.phase = 0

    def audio_callback(self, outdata, frames, time_info, status):
        if status:
            print(status, file=sys.stderr)
        
        # Generate Quantum Hum (Sine wave math)
        t = (np.arange(frames) + self.phase) / self.sample_rate
        t = t.reshape(-1, 1)
        
        # Carrier + Beat frequency logic
        wave = self.amplitude * np.sin(2 * np.pi * self.frequency_carrier * t)
        wave += (self.amplitude * 0.5) * np.sin(2 * np.pi * (self.frequency_carrier + self.frequency_beat) * t)
        
        outdata[:] = wave
        self.phase += frames

    def start_hum(self):
        # Starts the background quantum audio stream
        self.stream.start()

    def stop_hum(self):
        self.stream.stop()

    def log_status(self, message):
        timestamp = time.strftime("%H:%M:%S", time.localtime())
        print(f"[{timestamp}] [{self.node_id}] {message}")

    def start_node(self):
        os.system('cls' if os.name == 'nt' else 'clear')
        print(f"❄️  {NODE_VERSION} INITIALIZED")
        print(f"🔊  Quantum Audio Engine: ACTIVE (432Hz + 40Hz)")
        print(f"⏳  Consensus: 300s Block Time")
        print("--------------------------------------------------")
        
        # Start the Audio Engine
        try:
            self.start_hum()
        except Exception as e:
            print(f"[!] Audio Warning: {e}")

        # Main Loop
        while self.running:
            current_time = time.time()
            time_diff = current_time - self.last_block_time
            
            # --- WAITING PHASE (Mining/Validating) ---
            if time_diff < BLOCK_TIME_TARGET:
                wait_time = int(BLOCK_TIME_TARGET - time_diff)
                
                # Visual Heartbeat (every 30s)
                if wait_time % 30 == 0:
                    self.log_status(f"Quantum Hashing... [Next Block: {wait_time}s]")
                
                time.sleep(1)
                continue

            # --- BLOCK FOUND PHASE ---
            self.stop_hum() # Briefly stop hum for "Drop" effect (Optional)
            
            print("\n" + "★"*50)
            self.log_status(f"⚡ QUANTUM BLOCK COLLAPSED! ⚡")
            print(f"    > Reward 1: +{REWARD_FTC} FTC")
            print(f"    > Reward 2: +{REWARD_FNR} FNR")
            print(f"    > Reward 3: +{REWARD_FRST:,} FRST")
            print(f"    > Waveform Hash: 0x{random.getrandbits(64):x}")
            print("★"*50 + "\n")
            
            # Reset Timer
            self.last_block_time = time.time()
            
            # Restart Hum
            time.sleep(2)
            self.start_hum()

if __name__ == "__main__":
    try:
        node = QuantumMiracleNode()
        node.start_node()
    except KeyboardInterrupt:
        print("\n\n[!] Quantum Miner Deactivated.")
        sys.exit()
    except Exception as e:
        print(f"\n[!] Critical Error: {e}")
