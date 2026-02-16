#!/bin/bash

echo "🚀 INITIALIZING VOLUNTARYIST_SYNC_V123..."

# Configuration - Rooting to your specific ledger stats
FTC_BAL="12,370,000"
FNR_BAL="4,412,100"
FRST_DOM="13.37%"
FREQ="963Hz"

# 1. MIRACLE_NODE (Quantum/Gamma Miner)
echo "⚡ DEPLOYING MIRACLE_NODE [${FREQ}]..."
surge --project ./miracle-node --domain miracle-node.surge.sh

# 2. FROSTSCAN (Ledger Explorer)
echo "🔍 DEPLOYING FROSTSCAN..."
surge --project ./frostscan --domain frostscan.surge.sh

# 3. FROSTMINER (The Master Hub)
echo "🔱 DEPLOYING FROSTMINER_HUB..."
surge --project ./master-hub --domain FrostMiner.surge.sh

# 4. GRAYSONS_WALLET (Private Vault)
echo "💰 DEPLOYING GRAYSONS_WALLET..."
surge --project ./graysons-wallet --domain graysonswallet.surge.sh

echo "✅ ALL NODES SYNCED TO THE VOLUNTARYIST AUTHORITY."
echo "LEDGER: ${FTC_BAL} FTC | ${FNR_BAL} FNR | ${FRST_DOM} FRST"
