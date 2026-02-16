#!/bin/bash
echo "[-] Building Frost Payload..."
export KANES_KEY="KANES_WRATH_KEY_V1" 
node ota_builder.js

echo "[-] Deploying to Surge..."
# Ensure surge is installed
if ! command -v surge &> /dev/null; then
    npm install --global surge
fi

# Push to the specific domain
surge ./dist frostofthings.surge.sh
