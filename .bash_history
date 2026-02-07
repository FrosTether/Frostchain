#!/bin/bash
# RC316 // THE_NETWORK_THAW
# FIX: DNS_RESOLVE + MANUAL_AUTH
echo "❄️ RESETTING DNS AND PREPARING DEPLOY..."
# Force Termux to use Google DNS
echo "nameserver 8.8.8.8" > $PREFIX/etc/resolv.conf
# 1. TEST CONNECTION
if ping -c 1 surge.sh &> /dev/null; then     echo "✅ CONNECTION RESTORED."; else     echo "❌ STILL NO CONNECTION. Check your WiFi/VPN.";     exit 1; fi
#!/bin/bash
# RC316 // THE_NETWORK_THAW
# FIX: DNS_RESOLVE + MANUAL_AUTH
echo "❄️ RESETTING DNS AND PREPARING DEPLOY..."
# Force Termux to use Google DNS
echo "nameserver 8.8.8.8" > $PREFIX/etc/resolv.conf
# 1. TEST CONNECTION
if ping -c 1 surge.sh &> /dev/null; then     echo "✅ CONNECTION RESTORED."; else     echo "❌ STILL NO CONNECTION. Check your WiFi/VPN.";     exit 1; fi
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
if __name__ == "__main__":;     run_monitor() rm monitor.py
nano monitor.py
bash monitor.py
{   "nbformat": 4,;   "nbformat_minor": 0,;   "metadata": {;     "colab": {;       "provenance": [],;       "collapsed_sections": [];     },;     "kernelspec": {;       "name": "python3",;       "display_name": "Python 3";     },;     "language_info": {;       "name": "python";     }
