import { GENESIS } from "./gemini.constants.js";

let windowStart = Date.now();
let shares = new Map();

export function submitShare(playerId, weight = 1) {
  const now = Date.now();
  // Reset window if time elapsed
  if (now - windowStart >= GENESIS.BLOCK_INTERVAL_MS) {
    resetWindow(now);
  }
  shares.set(playerId, (shares.get(playerId) || 0) + weight);
  console.log(`[POOL] Share accepted from ${playerId}`);
}

export function closeWindow() {
  const totalShares = [...shares.values()].reduce((a,b)=>a+b,0);
  if (totalShares === 0) return [];

  const payouts = [];
  for (const [player, s] of shares.entries()) {
    payouts.push({
      player,
      reward: +(GENESIS.BLOCK_REWARD * (s / totalShares)).toFixed(6)
    });
  }
  return payouts;
}

function resetWindow(now) {
  shares.clear();
  windowStart = now;
}
