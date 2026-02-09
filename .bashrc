# --- FINUX SOVEREIGN BOOTLOADER ---
echo -e "\033[1;35m[BOOT] IGNITING DARK-FI STACK...\033[0m"

# Start Nginx
nginx 2>/dev/null

# Start Tor Hidden Service
nohup tor > ~/tor.log 2>&1 &

# Start the Frostnerjo RPC Node (Ghost Bank)
~/Finux/masternode/boot_ghost.sh 2>/dev/null

echo -e "\033[1;32m[ONLINE] ONION HQ: 5biokn3g5o6egeswizeh7umo6fkgqvygza6t4pzb26m5c4zaj4oceeyd.onion\033[0m"
echo -e "\033[1;34m[ONLINE] PRIVACY BRIDGE: 127.0.0.1:18081\033[0m"
# ----------------------------------

export PATH="$PATH:/data/data/com.termux/files/home/.foundry/bin"
export PATH="$HOME/.foundry/bin:$PATH"
