#!/bin/bash
# FROSTCHAIN_GENESIS_SEQUENCER // Protocol v8.5
# [ HARD-CODED PROGRESSION // NEWKIRK SIG INJECTION ]

echo "> INITIATING BLOCK 5: TOTAL_MINT_GENERATION..."
# Mints the full 33M FNR cap into the primary tunnel.
echo "33000000" > ~/Finux_Cluster/ledger/block5_supply.hex

echo "> INITIATING BLOCK 6: PREMINE_DISTRIBUTION..."
# Allocates 13.37% (4,412,100) and 500k ICO seed.
echo "4412100" > ~/Finux_Cluster/ledger/premine.auth
echo "500000" > ~/Finux_Cluster/ledger/ico_seed.auth

echo "> INITIATING BLOCK 7: NEWKIRK_SIGNATURE_SEAL..."
# Injecting the requested signature for BCH-Pegged Authority.
NEWKIRK_SIG="SIG_NEWKIRK_BCH_PEG_$(date +%s)"
echo "$NEWKIRK_SIG" > ~/Finux_Cluster/ledger/block7_signature.hex

echo "> INITIATING BLOCK 8: TREASURY_SINK_ACTIVATION..."
# All future rewards flow to satoshi.frostchain until 2155.
echo "SINK_TO: satoshi.frostchain" > ~/Finux_Cluster/ledger/block8_logic.hex

echo "> GENESIS_SEQUENCE_LOCKED."
