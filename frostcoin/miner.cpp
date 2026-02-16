// --- FROST_QUANTUM_MINER (miner.cpp) ---
// Logic: RandomX + Quantum Superposition Check

bool miner::find_nonce_quantum(Block& b, difficulty_type diff) {
    // Initialize RandomX VM
    rx_vm* vm = rx_create_vm(get_rx_flags(), get_seed_hash());
    
    while (!stop_mining) {
        b.nonce++;
        
        // 1. The Collapse: Hash the block
        hash result_hash;
        rx_calculate_hash(vm, &b, sizeof(b), &result_hash);

        // 2. Quantum Observer State (Check Logic)
        if (check_hash(result_hash, diff)) {
            // STATE 1: NETWORK BLOCK FOUND
            // Reward: 13.37 FTC + 2.5 FNR
            submit_block(b);
            return true;
        } 
        
        // 3. FNR Side-State (Feather Logic)
        // Even if block isn't found, check if valid for FNR merge-mine share
        if (check_hash(result_hash, diff / 2)) {
             // STATE 2: FEATHER SHARE FOUND
             submit_share_fnr(b);
        }
    }
    return false;
}
