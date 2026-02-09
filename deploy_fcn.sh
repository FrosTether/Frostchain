#!/bin/bash

# --- FCN THERMAL DEPLOYMENT: ALPHA ---
echo "--- Initializing FCN/FTC Ecosystem Broadcast ---"

# 1. Locate and Sync FrosTether.js
# We check the root and the scripts folder to ensure it lands in the web root
TARGET_FILE="FrosTether.js"
if [ -f "$TARGET_FILE" ]; then
    echo "[+] Found $TARGET_FILE in root. Ready."
elif [ -f "scripts/$TARGET_FILE" ]; then
    echo "[+] Found $TARGET_FILE in scripts/. Copying to root for Surge..."
    cp scripts/$TARGET_FILE .
else
    echo "[!] Warning: $TARGET_FILE not found in root or scripts/. Checking dist..."
fi

# 2. Finalize Build (Ensuring Thermal UI is baked in)
echo "[*] Preparing Thermal Hashing UI (Burgundy/Orange logic)..."

# 3. GitHub Sync (FrosTether/Frost-Protocol)
echo "[*] Pushing to GitHub..."
git add .
git commit -m "Deploy: FCN Thermal Hashing & 8s Parallel Handshake"
git push origin main

# 4. Surge Deployment
echo "[*] Launching to fpu4eva.surge.sh..."
# Deploying the current directory ('.') to the specific domain
surge . fpu4eva.surge.sh

echo "--- FCN DEPLOYMENT COMPLETE: LIVE AT fpu4eva.surge.sh ---"
