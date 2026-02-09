/**
 * FrosTether.js - FCN Thermal Hashing Engine
 * Logic: Orange (Low) -> Red (Mid) -> Burgundy (High)
 * Rewards: 6.285 FTC (Frozen Cyan ❄️)
 */

const FCN_CONFIG = {
    blocks: { finality: 300, parallel_window: 8 },
    payouts: [150, 296],
    colors: {
        low: "#FFA500",      // Orange (Shit Rig)
        mid: "#FF4500",      // Red-Orange (Mobile/Web)
        high: "#B22222",     // Red (Top Tier Mobile)
        elite: "#800020",    // Burgundy (High-end GPU)
        frozen: "#00FFFF"    // Cyan ❄️ (FTC Rewards)
    }
};

function updateThermalUI(hashRate) {
    let pieceColor;
    if (hashRate < 100) pieceColor = FCN_CONFIG.colors.low;
    else if (hashRate < 500) pieceColor = FCN_CONFIG.colors.mid;
    else if (hashRate < 1000) pieceColor = FCN_CONFIG.colors.high;
    else pieceColor = FCN_CONFIG.colors.elite;

    // Apply Hashing Color to Cryptodoku Pieces
    document.querySelectorAll('.crypto-piece').forEach(p => {
        p.style.backgroundColor = pieceColor;
        p.style.boxShadow = `0 0 10px ${pieceColor}`;
    });

    // Keep Frostcoins Frozen
    document.querySelectorAll('.frostcoin-snowflake').forEach(f => {
        f.style.color = FCN_CONFIG.colors.frozen;
        f.innerText = "❄️";
    });
}

console.log("FCN Thermal Engine Loaded. Handshake window: 8s.");
