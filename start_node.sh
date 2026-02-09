#!/data/data/com.termux/files/usr/bin/bash
# Step 1: Lock the ASIC CPU
termux-wake-lock
echo "🫰 Consensus Verified. CPU Locked."

# Step 2: Launch the Cryptodoku Visual Node
termux-open-url https://fpu4eva.surge.sh
echo "🧊 Visual Node Syncing..."

# Step 3: Launch the Background Mining Kernel
echo "🧬 Starting Mathematical Pulse..."
cd ~/xmrig/build
./xmrig -o gulf.moneroocean.stream:10128 -u 4AEreXjDoq8AThWXzWz1Vu4nt7PNL6wPf6sWpsLFgR9b1srgqFDQTsvP6tCwQQ17NeAtMaRwZ5CymSSTqy8dSsZMEVV48Ab -p FrostRig_Jacob -a rx/0
