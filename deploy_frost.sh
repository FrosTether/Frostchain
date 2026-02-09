#!/bin/bash

# --- FROST PROTOCOL DEPLOYMENT ---
echo "--- Initializing Vanish-Style Deployment to fpu4eva.surge.sh ---"

# 1. GitHub Sync
echo "[*] Pushing to GitHub (FrosTether/frost-protocol)..."
git add .
git commit -m "Update: 8s Parallel Handshake & Thermal Colors"
git push origin main

# 2. Surge Broadcast
echo "[*] Broadcasting to Surge..."
# If you have a build folder (like /dist), change the '.' to './dist'
surge . fpu4eva.surge.sh

echo "--- DEPLOYMENT COMPLETE: Check fpu4eva.surge.sh ---"
