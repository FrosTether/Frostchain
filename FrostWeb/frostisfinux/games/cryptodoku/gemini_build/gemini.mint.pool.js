import { closeWindow } from "./gemini.pool.js";
import { applyBlock } from "./gemini.state.js";

export function mintFromPool(timestamp) {
  const payouts = closeWindow();
  if (!payouts.length) return;

  const totalReward = payouts.reduce((a,b)=>a+b.reward,0);

  const success = applyBlock({
    reward: totalReward,
    payouts,
    timestamp,
    pooled: true
  });
  
  if (success) {
      // Notify UI
      window.postMessage({
        type: "GEMINI_MINT",
        reward: totalReward,
        payouts: payouts
      });
  }
}
