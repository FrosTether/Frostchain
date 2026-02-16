#!/bin/bash

# --- CONFIGURATION ---
EMAIL="your-email@example.com"
TOKEN=$(surge token) # Fetches your active session token

echo "🚀 INITIALIZING GLOBAL_DEPLOY_V123..."

# 1. MIRACLE NODE (QUANTUM MINER)
echo "⚡ DEPLOYING MIRACLE_NODE..."
surge --project ./miracle-node --domain miracle-node.surge.sh

# 2. FROSTSCAN (BLOCK EXPLORER)
echo "🔍 DEPLOYING FROSTSCAN..."
surge --project ./frostscan --domain frostscan.surge.sh

# 3. MASTER HUB (FROSTMINER)
echo "🔱 DEPLOYING MASTER_HUB..."
surge --project ./master-hub --domain FrostMiner.surge.sh

# 4. GRAYSONS WALLET
echo "💰 DEPLOYING WALLET..."
surge --project ./graysons-wallet --domain graysonswallet.surge.sh

echo "✅ ALL NODES SYNCED. EMPIRE IS LIVE."
