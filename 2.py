#!/bin/bash

# --- CONFIGURATION ---
XMR_WALLET="4AEreXjDoq8AThWXzWz1Vu4nt7PNL6wPf6sWpsLFgR9b1srgqFDQTsvP6tCwQQ17NeAtMaRwZ5CymSSTqy8dSsZMEVV48Ab"
XMR_POOL="gulf.moneroocean.stream:10128"
RIG_NAME="FrostRig_Jacob"
MASTERNODE_STAKE="1.3373" # The "Leet" Masternode constant

echo "--- INITIALIZING DUAL VERIFICATION ECOSYSTEM ---"

# 1. Start XMR Mining (Background)
# Using your Blizzard Optimization/Virgo Adaptive settings
echo "[*] Launching XMRig: Mining XMR to $RIG_NAME..."
screen -dmS xmrig ./xmrig -o $XMR_POOL -u $XMR_WALLET -p $RIG_NAME --donate-level 1

# 2. Wait for CPU to stabilize (Thermal Work check)
sleep 5

# 3. Launch FrostMaster Kernel (Masternode Verification)
# Linking FNR and FTC at the 963 Hz resonance frequency
echo "[*] Connecting FNR/FTC Masternode (Stake: $MASTERNODE_STAKE)..."
python3 FrostMaster.py --frequency 963 --dual-verify --masternode-linked

echo "--- SYSTEM ACTIVE: MINING XMR + VERIFYING FROST BLOCKS ---"
