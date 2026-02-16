// --- FROSTCHAIN CONFIGURATION (cryptonote_config.h) ---
// Sovereignty: drfrost.frostchain
// Base: Monero v0.18 (Fluorine Fermi)

#pragma once
#include <string>
#include <cstdint>

namespace config {
    // 1. QUANTUM BLOCK TIME
    uint64_t const CRYPTONOTE_TARGET_BLOCK_TIME = 300; // 5 Minutes (Quantum Tick)
    uint64_t const CRYPTONOTE_BLOCK_FUTURE_TIME_LIMIT = 60 * 60 * 2;

    // 2. TOTAL SUPPLY CAPS (Atomic Units)
    // 100 Million FTC | 33 Million FNR
    uint64_t const MONEY_SUPPLY_FTC = 100000000 * ((uint64_t)1000000000000); 
    uint64_t const MONEY_SUPPLY_FNR = 33000000 * ((uint64_t)1000000000000);

    // 3. EMISSION LOGIC (Static Reward requested: 13.37 FTC)
    // Unlike Monero's curve, we enforce a Sovereign Fix until cap.
    uint64_t const FROST_BLOCK_REWARD_FTC = 13370000000000; // 13.370...
    uint64_t const FROST_BLOCK_REWARD_FNR = 2500000000000;  // 2.500...

    // 4. PREMINE CONFIGURATION (13.37% of TOTAL)
    // FTC: 13,370,000 | FNR: 4,412,100
    uint64_t const PREMINE_AMOUNT_FTC = 13370000 * ((uint64_t)1000000000000);
    uint64_t const PREMINE_AMOUNT_FNR = 4412100 * ((uint64_t)1000000000000);

    // 5. GENESIS COINBASE TX (The "Big Bang")
    // This public key MUST match your private view/spend keys to claim the premine.
    std::string const GENESIS_TX_DESTINATION = "867chP2RA9D9xd2tHzxB8L4JfE2Jhdd5FPEwC56HJhmyA7x3EEnuLpGUerQsN9kqQ9A7e7rXQvqZaCNsTsJeBsAxV2B5wxA";
    
    // 6. PORT MAPPING
    int const P2P_DEFAULT_PORT = 13370;
    int const RPC_DEFAULT_PORT = 13371;
}
