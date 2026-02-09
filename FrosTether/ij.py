cat << 'PY_EOF' > ~/FrosTether/frostoise_inject.py
import sys, getpass
from web3 import Web3
from eth_account import Account

# --- FAI ENGINE CONFIG ---
RPC_URL = "https://polygon-rpc.com"
VAULT_DOGE = "DJTDVRxJGtcuSsxwT7GHbkdCabqaTa1C7s"
SOURCE_FJ = "FJTDVRxJGtcuSsxwT7GHbkdCabqaTa1C7s"

Account.enable_unaudited_hdwallet_features()

def inject():
    print("\033[1;36m[FROSTOISE] MAGNUM OPUS INJECTOR\033[0m")
    
    # Using getpass forces the terminal to wait and hides the text
    print("Paste your 12-word seed below (text will be hidden):")
    mnemonic = getpass.getpass(prompt='Seed Phrase: ').strip().lower()
    
    if len(mnemonic.split()) != 12:
        print(f"\033[1;31m[ERROR]\033[0m Detected {len(mnemonic.split())} words. Need 12.")
        return

    try:
        acc = Account.from_mnemonic(mnemonic)
        print(f"\033[1;32m[LOADED]\033[0m Architect: {acc.address}")
        
        # Security Check for Frostoise
        if acc.address.lower() != SOURCE_FJ.lower():
            print(f"\033[1;33m[WARNING]\033[0m Mnemonic does not match Architect FJ address.")
    except Exception as e:
        print(f"\033[1;31m[ERROR]\033[0m {e}")
        return

    # Connection Check
    w3 = Web3(Web3.HTTPProvider(RPC_URL))
    
    if len(sys.argv) > 2:
        contract = sys.argv[1]
        recipient = sys.argv[2]
        pi_wei = 3141592650000000000 
        
        print(f"[BLOKIEN] Syncing Pi-Airdrop to {recipient}...")
        
        tx = {
            'nonce': w3.eth.get_transaction_count(acc.address),
            'to': contract,
            'value': 0,
            'gas': 120000,
            'gasPrice': w3.eth.gas_price,
            'data': '0xa9059cbb' + recipient[2:].lower().zfill(64) + hex(pi_wei)[2:].zfill(64),
            'chainId': w3.eth.chain_id
        }
        
        signed = w3.eth.account.sign_transaction(tx, acc.private_key)
        tx_hash = w3.eth.send_raw_transaction(signed.rawTransaction)
        print(f"\033[1;33m[INJECTED]\033[0m Hash: {tx_hash.hex()}")

if __name__ == "__main__":
    inject()
PY_EOF
