import { submitShare } from "./gemini.pool.js";

export function gameSolved(playerId = "anon", score = 1) {
  // Weight based on score
  const weight = Math.max(1, Math.floor(score / 100));
  submitShare(playerId, weight);
  window.postMessage({
    type: "POOL_SHARE",
    msg: "Share accepted. Pending block close.",
    weight: weight
  });
}
