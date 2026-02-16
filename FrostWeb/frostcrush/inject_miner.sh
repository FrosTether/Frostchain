#!/bin/bash
echo "> MONITORING VIRGO KERNEL..."
while true; do
  # Checking for completion flag from FrostMaster.py
  if grep -q "MINER_CYCLE_COMPLETE" ~/frost_logs/miner.log; then
    echo "> [FAI] INJECTING FROSTCRUSH STABLE BUILD..."
    
    # Push the fixed physics double-buffer build
    surge . frostcrush.surge.sh
    
    echo "> [SUCCESS] FROSTCRUSH LIVE. 55% FAI ADVANTAGE ACTIVE."
    break
  fi
  sleep 60
done
