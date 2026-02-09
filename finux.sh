#!/bin/bash
# --- FINUX OS SESSION LAUNCHER ---
# Author: FrosTether

echo "❄️  BOOTING FINUX OS SESSION..."

# 1. Navigate to the project core
cd ~/Finux

# 2. Kill any existing zombie sessions on Port 5000 to prevent 'Address already in use'
fuser -k 5000/tcp 2>/dev/null

# 3. Source the environment fixes we set up in .bashrc
# This ensures $PREFIX/include and libandroid-spawn are linked
source ~/.bashrc

# 4. Launch the Frost Protocol Node
# We use 'python3' to ensure it hits your specific Termux install
python3 frostit.py
