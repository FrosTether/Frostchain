from web3 import Web3

# Base Mainnet RPC
RPC_URL = "https://mainnet.base.org"
w3 = Web3(Web3.HTTPProvider(RPC_URL))

# Your Wallet & Contracts
MY_WALLET = "0x6556fBB94508bFa8CE919f691ef71d4181D36D20"
FNR_ADDRESS = "0x32fd87d023bcbc26b5d33946faaaa1b6657dcbb2"
AMA_ADDRESS = "0xc668e3895c6453a701d605be1f71573de720664f"

# Minimal ABI
ABI = [{"constant":True,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"type":"function"}]

def run_monitor():
    if not w3.is_connected():
        print("Error: Could not connect to Base Mainnet.")
        return
    
    fnr = w3.eth.contract(address=w3.to_checksum_address(FNR_ADDRESS), abi=ABI)
    ama = w3.eth.contract(address=w3.to_checksum_address(AMA_ADDRESS), abi=ABI)
    
    # Getting balances
    fnr_bal = fnr.functions.balanceOf(MY_WALLET).call() / 10**18
    ama_bal = ama.functions.balanceOf(MY_WALLET).call() / 10**18
    eth_bal = w3.eth.get_balance(MY_WALLET) / 10**18
    
    print("\n" + "="*30)
    print(" FROST PROTOCOL MOBILE DASHBOARD ")
    print("="*30)
    print(f"Wallet: {MY_WALLET[:6]}...{MY_WALLET[-4:]}")
    print(f"Base ETH: {eth_bal:.4f} ETH")
    print(f"FNR Bal:  {fnr_bal:,.2f}")
    print(f"AMA Bal:  {ama_bal:,.2f}")
    print("-" * 30)
    print("Status: DEV FUND MONITORED")
    print("="*30 + "\n")

if __name__ == "__main__":
    run_monitor()
