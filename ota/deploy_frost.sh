#!/bin/bash
echo "[-] Building Frost Payload..."
export KANES_KEY="${KANES_KEY:?Set KANES_KEY in your environment}"
node ota_builder.js

echo "[-] Deploying to Surge..."
# Ensure surge is installed
if ! command -v surge &> /dev/null; then
    npm install --global surge
fi

# Push to the specific domain
surge ./dist frostofthings.surge.sh
