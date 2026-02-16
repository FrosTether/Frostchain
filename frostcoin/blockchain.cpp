// --- GENESIS INJECTION (blockchain.cpp) ---

bool Blockchain::create_frost_genesis(Block& genesis_block) {
    Transaction tx;
    
    // 1. Construct the Sovereign Output (FTC)
    TxOut out_ftc;
    out_ftc.amount = config::PREMINE_AMOUNT_FTC; // 13,370,000 FTC
    out_ftc.target = AccountPublicAddress(config::GENESIS_TX_DESTINATION);
    tx.vout.push_back(out_ftc);

    // 2. Construct the Sovereign Output (FNR)
    // Note: This requires the Dual-Asset Protocol Patch (v150)
    TxOut out_fnr;
    out_fnr.amount = config::PREMINE_AMOUNT_FNR; // 4,412,100 FNR
    out_fnr.target = AccountPublicAddress(config::GENESIS_TX_DESTINATION);
    tx.vout.push_back(out_fnr);

    // 3. Lock Logic (Unlock immediately? Or vest?)
    tx.unlock_time = 0; // Immediate Access

    genesis_block.miner_tx = tx;
    return true;
}
