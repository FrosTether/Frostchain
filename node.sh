#!/bin/bash
# KILL OLD SERVER
fuser -k 5000/tcp > /dev/null 2>&1
# CLEAR CACHE
rm -rf ~/Finux/__pycache__
clear
echo -e "\033[1;35mFINUX QUANTUM KERNEL (FNR PRIVACY MODE)\033[0m"
echo -e "\033[1;33mLISTENING ON PORT 5000 (SAFE MODE)\033[0m"
echo "---"
cd ~/Finux
python3 frostit.py
