#!/bin/bash

echo "❄️ STARTING FROSTCHAIN DEPLOYMENT SEQUENCE..."

# Check for Node.js
if ! command -v npm &> /dev/null
then
    echo "❌ Node.js could not be found. Please install Node.js."
    exit
fi

# Install Surge if not present
if ! command -v surge &> /dev/null
then
    echo "📦 Installing Surge.sh CLI..."
    npm install --global surge
fi

echo "🚀 Deploying 'public' folder to the Quantum Mesh..."

# The Deploy Command
# usage: surge [project path] [domain]
surge ./public frost-miner.surge.sh

echo "✅ DEPLOYMENT COMPLETE."
echo "🔗 Live Link: https://frost-miner.surge.sh"
