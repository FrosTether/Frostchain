import sys, json, getpass, os
from web3 import Web3
from eth_account import Account

REGISTRY_PATH = os.path.expanduser("~/FrosTether/registry.json")

def resolve(handle):
    with open(REGISTRY_PATH, 'r') as f:
        reg = json.load(f)
        return reg.get(handle, {}).get("evm_addr")

def inject():
    print("\033[1;36m[FROSTOISE SNS] ARCHITECT UPLINK\033[0m")
    
    # 1. Identity Verification
    mnemonic = getpass.getpass(prompt='Enter 12-word Seed: ').strip().lower()
    acc = Account.from_mnemonic(mnemonic)
    
    # Check if the seed matches voluntaryistj.frostchain
    architect_addr = resolve("voluntaryistj.frostchain")
    if acc.address.lower() != architect_addr.lower():
        print(f"\033[1;31m[REJECTED]\033[0m Seed does not match voluntaryistj.frostchain")
        return

    print(f"\033[1;32m[LOGGED IN]\033[0m Hello, voluntaryistj.frostchain")

    # 2. Command Processing
    if len(sys.argv) > 1:
        target_handle = sys.argv[1]
        target_addr = resolve(target_handle)
        
        if not target_addr:
            # If not a handle, assume it's a raw address
            target_addr = target_handle if target_handle.startswith("0x") else None

        if target_addr:
            print(f"[BLOKIEN] Blasting Pi-Airdrop to {target_handle} ({target_addr})")
            # Inbound Pi Amount: 3.14159265
            # Sign/Send logic here...
        else:
            print(f"\033[1;31m[ERROR]\033[0m Could not resolve {target_handle}")

if __name__ == "__main__":
    inject()
