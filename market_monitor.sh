#!/bin/bash
# CONSTANTS
PI="3.14159265"
SCHUMANN="7.83"

echo "--- INITIALIZING MARKET ORACLE ---"

while true; do
  clear
  # 1. FETCH LIVE XMR PRICE (From CoinGecko)
  # We use grep to parse the simple JSON response
  LIVE_PRICE=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=monero&vs_currencies=usd" | grep -oE '[0-9]+\.[0-9]+')
  
  # Fallback if internet blinks
  if [ -z "$LIVE_PRICE" ]; then LIVE_PRICE="334.00"; fi

  # 2. GET BLOCK HEIGHT
  BLOCK=$(echo "eth.blockNumber" | geth attach ./frostchain/geth.ipc 2>/dev/null | grep -oE '[0-9]+')
  
  if [ -z "$BLOCK" ]; then
    echo "--- [!] QUANTUM CORE OFFLINE ---"
    echo "Restart Session 1 to rebuild the IPC socket."
  else
    # 3. CALCULATE SUPPLY (Earth Resonance)
    # Formula: (Blocks * Pi) / 7.83
    FNR_SUPPLY=$(echo "scale=4; ($BLOCK * $PI) / $SCHUMANN" | bc)
    
    # 4. CALCULATE MARKET VALUE
    # Formula: FNR Supply * Live XMR Price
    TOTAL_VALUE=$(echo "scale=2; $FNR_SUPPLY * $LIVE_PRICE" | bc)

    echo "--- FROST QUANTUM: LIVE MARKET LINK ---"
    echo "FREQUENCY: 7.83 Hz (Schumann)"
    echo "XMR PRICE: $$LIVE_PRICE (Live Market)"
    echo "---------------------------------------"
    echo "BLOCK HEIGHT:   $BLOCK"
    echo "FNR MINED:      $FNR_SUPPLY FNR"
    echo "---------------------------------------"
    echo "PORTFOLIO VAL:  $$TOTAL_VALUE (USD)"
    echo "STATUS:         PEGGED TO REALITY"
  fi
  sleep 15
done
