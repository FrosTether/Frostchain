import hashlib
import time
import json
import secrets
import math

# --- 1. THE LAWS OF FROSTCHAIN (IMMUTABLE) ---
BLOCK_TIME = 300            # 5 Minutes
SOLFEGGIO_CYCLE = 150       # 150s Rotation
REWARD_FTC = 13.37
REWARD_FNR = 1.50
REWARD_FRST = 31415.9

# --- 2. QUANTUM ENTROPY POOL ---
# The frequencies used to mix transactions
ENNEAD = [174, 285, 396, 417, 528, 639, 741, 852, 963]

class FrostWallet:
    def __init__(self, legacy_import=None, alias=None):
        if legacy_import:
            # Import mode: Quantum-link a legacy address (e.g. Monero)
            self.private_key = legacy_import
            self.type = "IMPORTED_LEGACY"
        else:
            # Gen mode: Create new Frost Keypair
            self.private_key = secrets.token_hex(32)
            self.type = "NATIVE_FROST"
            
        self.public_key = self.derive_public(self.private_key)
        self.address = f"{alias}.frostchain" if alias else self.generate_frost_addr()
        
        print(f"❄️ WALLET INITIALIZED: {self.address}")
        print(f"   > TYPE: {self.type}")
        print(f"   > KEY:  {self.public_key[:16]}...[HIDDEN]")

    def derive_public(self, priv):
        # Simplified Elliptic Curve derivation for demonstration
        return hashlib.sha256(priv.encode()).hexdigest()

    def generate_frost_addr(self):
        # Generates a raw address if no .frostchain alias is provided
        raw = hashlib.new('ripemd160', self.public_key.encode()).hexdigest()
        return f"frst{raw}"

class QuantumMixer:
    """
    The Privacy Layer: Uses Sound Entropy to obfuscate transactions (FNR Logic).
    """
    def __init__(self):
        self.entropy_pool = []

    def gather_entropy(self, current_time):
        # 1. Determine active Ennead Tone
        cycle_idx = int((current_time / SOLFEGGIO_CYCLE) % 9)
        tone = ENNEAD[cycle_idx]
        
        # 2. Determine Binaural Offset (Schumann Flip)
        schumann_seed = (current_time * 7.83) % 1
        offset = 11.11 if schumann_seed > 0.5 else 3.14159
        
        # 3. Add to Pool
        entropy = hashlib.sha256(f"{tone}{offset}{schumann_seed}".encode()).hexdigest()
        self.entropy_pool.append(entropy)
        return entropy

    def mix_transaction(self, sender, receiver, amount):
        # XMR-Style Ring Signature using Sound Entropy
        noise = self.gather_entropy(time.time())
        
        # Create a Ring of 5 fake inputs + 1 real input
        ring_size = 6
        mix_id = hashlib.sha256(f"{sender}{receiver}{amount}{noise}".encode()).hexdigest()
        
        print(f"🌪️ QUANTUM MIXER ACTIVE")
        print(f"   > ENTROPY SOURCE: {noise[:10]}... (Sound-Derived)")
        print(f"   > RING SIZE: {ring_size} | MIX_ID: {mix_id}")
        
        return {
            "tx_id": mix_id,
            "inputs": "ENCRYPTED_RING_SIGNATURE",
            "outputs": {receiver: amount, "change": "OBSCURED"}
        }

class FrostBlock:
    def __init__(self, index, timestamp, transactions, prev_hash):
        self.index = index
        self.timestamp = timestamp
        self.transactions = transactions
        self.prev_hash = prev_hash
        self.hash = self.calculate_hash()
        
    def calculate_hash(self):
        block_str = json.dumps(self.__dict__, sort_keys=True).encode()
        return hashlib.sha256(block_str).hexdigest()

class FrostChain:
    def __init__(self):
        self.chain = [self.genesis()]
        self.mempool = []
        self.mixer = QuantumMixer()

    def genesis(self):
        return FrostBlock(0, 1704067200, [], "0")

    def get_latest(self):
        return self.chain[-1]

    def add_transaction(self, wallet, receiver, amount):
        # Route through Quantum Mixer for FNR privacy
        tx = self.mixer.mix_transaction(wallet.address, receiver, amount)
        self.mempool.append(tx)

    def mine(self, miner_wallet):
        latest = self.get_latest()
        now = int(time.time())
        
        # 1. TIME CHECK (300s)
        if now - latest.timestamp < BLOCK_TIME:
            print(f"⏳ MINING PAUSED: Wait for 300s cycle.")
            return False

        # 2. CREATE COINBASE (The 3 Rewards)
        coinbase = {
            "FTC": {"to": miner_wallet.address, "amt": REWARD_FTC},
            "FNR": {"to": miner_wallet.address, "amt": REWARD_FNR, "mix": "PRIVATE"},
            "FRST": {"to": miner_wallet.address, "amt": REWARD_FRST}
        }
        
        # 3. MINT BLOCK
        new_block = FrostBlock(
            len(self.chain),
            now,
            [coinbase] + self.mempool,
            latest.hash
        )
        
        self.chain.append(new_block)
        self.mempool = [] # Clear mempool
        print(f"✅ BLOCK #{new_block.index} MINED by {miner_wallet.address}")
        print(f"   > REWARD: {REWARD_FTC} FTC | {REWARD_FNR} FNR | {REWARD_FRST} FRST")
        return True

# --- RUNTIME EXECUTION ---
if __name__ == "__main__":
    # 1. INITIALIZE GRAYSON'S WALLET (Legacy Import)
    legacy_key = "4AEreXjDoq8AThWXzWz1Vu4nt7PNL6wPf6sWpsLFgR9b1srgqFDQTsvP6tCwQQ17NeAtMaRwZ5CymSSTqy8dSsZMEVV48Ab"
    grayson = FrostWallet(legacy_import=legacy_key, alias="grayson")
    
    # 2. INITIALIZE NETWORK
    network = FrostChain()
    
    # 3. SIMULATE A MIXED TRANSACTION
    print("\n--- INITIATING TRANSACTION ---")
    network.add_transaction(grayson, "market.frostchain", 50)
    
    # 4. START MINING LOOP
    print("\n--- STARTING RESONANCE MINER ---")
    while True:
        network.mine(grayson)
        time.sleep(10) # Check every 10s
