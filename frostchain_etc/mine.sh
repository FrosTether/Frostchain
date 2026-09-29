#!/bin/bash
# Frostchain ETC miner: runs a core-geth node that mines Etchash PoW blocks.
cd "$(dirname "$0")"

DATADIR=./data
GETH=./bin/geth
THREADS=${THREADS:-$(nproc 2>/dev/null || echo 2)}
HTTP_ADDR=${HTTP_ADDR:-127.0.0.1}
HTTP_PORT=${HTTP_PORT:-8545}
P2P_PORT=${P2P_PORT:-30303}

[ -x "$GETH" ] && [ -d "$DATADIR/geth/chaindata" ] || { echo "Run ./setup.sh first"; exit 1; }

MY_ADDR=${MY_ADDR:-0x$($GETH --datadir "$DATADIR" account list | head -n 1 | awk -F'[{}]' '{print $2}')}

pkill -f "geth --datadir $DATADIR" 2>/dev/null && sleep 2

echo "Launching Frostchain (Ethereum Classic / Etchash PoW)..."
echo "Mining to $MY_ADDR with $THREADS CPU threads"
nohup $GETH --datadir "$DATADIR" \
    --networkid 13370 \
    --port "$P2P_PORT" \
    --ipcdisable \
    --http --http.addr "$HTTP_ADDR" --http.port "$HTTP_PORT" \
    --http.corsdomain "*" --http.vhosts "*" \
    --http.api "eth,net,web3,txpool" \
    --ethash.dagdir "$DATADIR/ethash" \
    --mine --miner.threads "$THREADS" \
    --miner.etherbase "$MY_ADDR" > geth.log 2>&1 &

echo "Node started (PID: $!). First run generates the ~1GB DAG; watch: tail -f geth.log"
sleep 8

while true; do
    BLOCK=$($GETH --exec "eth.blockNumber" attach "http://127.0.0.1:$HTTP_PORT" 2>/dev/null)
    BAL=$($GETH --exec "web3.fromWei(eth.getBalance('$MY_ADDR'), 'ether')" attach "http://127.0.0.1:$HTTP_PORT" 2>/dev/null)
    if [ -z "$BLOCK" ]; then
        echo "Node booting... check 'tail -f geth.log'"
    else
        echo "[$(date +%T)] FROSTCHAIN HEIGHT: $BLOCK | BALANCE: $BAL FROST | MINING: ACTIVE"
    fi
    sleep 10
done
