#!/bin/bash

# FROSTLEDGER IGNITION SEQUENCE
# -----------------------------

echo "❄️  SYSTEM CHECK: INITIATING FROSTLEDGER..."

# 1. Navigate to Core
if [ -d "frost-ledger" ]; then
    cd frost-ledger
else
    echo "❌ Error: 'frost-ledger' directory not found."
    echo "   Run the installer script first."
    exit 1
fi

# 2. Dependency Check
echo "📦 Verifying Go Modules..."
if ! command -v go &> /dev/null; then
    echo "❌ Error: Go is not installed."
    exit 1
fi
go mod tidy

# 3. Build Binary
echo "🔨 Compiling FrostNode Binary..."
go build -o frostnode main.go

# 4. Launch
echo "🚀 FROSTLEDGER IS LIVE."
echo "   - Identity: voluntaryistj.base.eth"
echo "   - Port: 1337"
echo "   - Consensus: Active"
echo "=========================================="

# Run the node
./frostnode
