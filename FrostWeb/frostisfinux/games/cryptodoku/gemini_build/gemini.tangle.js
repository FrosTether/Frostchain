import { GENESIS } from "./gemini.constants.js";
let lastTick = Date.now();
let activeChain = "A";

export function tangleTick(syncFn) {
  const now = Date.now();
  if (now - lastTick >= GENESIS.TANGLE_TICK_MS) {
    activeChain = activeChain === "A" ? "B" : "A";
    syncFn(activeChain, now);
    lastTick = now;
  }
}

export function getActiveChain() {
  return activeChain;
}
