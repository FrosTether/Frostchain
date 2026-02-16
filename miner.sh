#!/bin/bash
pkill -9 geth
sleep 2

MY_ADDR=$(geth --datadir ./frostchain account list | head -n 1 | awk -F'[{}]' '{print $2}')

echo "Launching Frostchain Node..."
nohup geth --datadir ./frostchain \
     --networkid 1337 \
     --port 30303 \
     --ipcdisable \
     --http --http.addr "0.0.0.0" --http.port 8545 --http.corsdomain "*" --http.vhosts "*" \
     --http.api "eth,net,web3,miner,personal,clique" \
     --mine \
     --miner.etherbase "0x$MY_ADDR" \
     --unlock "0x$MY_ADDR" \
     --password ./password.txt \
     --allow-insecure-unlock > geth.log 2>&1 &

NODE_PID=$!
echo "Node Started (PID: $NODE_PID)"
sleep 8

while true; do
    BLOCK=$(geth --exec "eth.blockNumber" attach http://127.0.0.1:8545 2>/dev/null)
    if [ -z "$BLOCK" ]; then
        echo "Node booting... check 'tail -f geth.log'"
    else
        echo "[$(date +%T)] FROSTCHAIN HEIGHT: $BLOCK | MINING: ACTIVE"
    fi
    sleep 10
done
