#!/bin/bash
# Frostchain ETC setup: builds core-geth (the Ethereum Classic client),
# creates a mining wallet, and initializes the chain from genesis.json.
set -e
cd "$(dirname "$0")"

DATADIR=./data
GETH=./bin/geth

if [ ! -x "$GETH" ]; then
    if command -v core-geth >/dev/null 2>&1; then
        mkdir -p bin && ln -sf "$(command -v core-geth)" "$GETH"
    else
        echo "Building core-geth (Ethereum Classic client)..."
        command -v go >/dev/null || { echo "Install Go first (Termux: pkg install golang git make)"; exit 1; }
        [ -d core-geth ] || git clone --depth 1 https://github.com/etclabscore/core-geth
        # -checklinkname=0 is needed for Go >= 1.23
        (cd core-geth && go build -ldflags=-checklinkname=0 -o ../bin/geth ./cmd/geth)
    fi
fi

mkdir -p "$DATADIR"

if [ ! -f "$DATADIR/password.txt" ]; then
    head -c 32 /dev/urandom | base64 > "$DATADIR/password.txt"
    chmod 600 "$DATADIR/password.txt"
fi

if [ -z "$($GETH --datadir "$DATADIR" account list 2>/dev/null)" ]; then
    echo "Creating mining wallet..."
    $GETH --datadir "$DATADIR" account new --password "$DATADIR/password.txt"
fi

if [ ! -d "$DATADIR/geth/chaindata" ]; then
    $GETH --datadir "$DATADIR" init genesis.json
fi

echo "Setup complete. Mining address:"
$GETH --datadir "$DATADIR" account list 2>/dev/null | head -n 1
echo "Run ./mine.sh to start mining."
