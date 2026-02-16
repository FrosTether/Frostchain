#!/data/data/com.termux/files/usr/bin/bash

# SESSION 1: FNR_CORE (Softfork Miner)
screen -dmS fnr_core bash -c "nice -n 15 cpulimit -l 60 -- node ~/Finux_Games/cryptodoku/miner.js"

# SESSION 2: XMR_BONE (Master Address)
screen -dmS xmr_bone bash -c "nice -n 19 cpulimit -l 55 -- ~/xmrig/build/xmrig -o pool.supportxmr.com:3333 -u 4AEreXjDoq8AThWXzWz1Vu4nt7PNL6wPf6sWpsLFgR9b1srgqFDQTsvP6tCwQQ17NeAtMaRwZ5CymSSTqy8dSsZMEVV48Ab -k --threads=2"

# SESSION 3: TANGLE_SYNC
screen -dmS tangle_sync bash -c "nice -n 10 node ~/Finux_Cluster/tangle_sync.js"

# SESSION 4: REZ_HUD (Thermal Monitor)
screen -dmS rez_hud bash -c "watch -n 2 'echo STATUS: MINING_ACTIVE && echo ADDRESS: 4AEreXj...SsZMEVV48Ab && top -n 1 -b | head -n 10'"

# SESSION 5: LOG_STREAM
screen -dmS log_stream bash -c "tail -f ~/mining_logs.txt"
