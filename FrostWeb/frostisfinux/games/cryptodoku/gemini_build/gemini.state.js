import { GENESIS } from "./gemini.constants.js";
import { saveState, loadState } from "./gemini.persist.js";

export const STATE = {
  mintedTotal: 0,
  blocks: [],
  lastSeal: null
};

// Load state on boot
(async () => {
  const saved = await loadState();
  if (saved) Object.assign(STATE, saved);
})();

export function applyBlock(block) {
  if (STATE.mintedTotal + block.reward > GENESIS.TOTAL_CAP) {
    console.warn("MAX CAP REACHED. Minting halted.");
    return false;
  }

  STATE.mintedTotal += block.reward;
  STATE.blocks.push(block);
  sealState();
  saveState(STATE); // Persist
  return true;
}

function sealState() {
  const payload = JSON.stringify({
    mintedTotal: STATE.mintedTotal,
    blocks: STATE.blocks.length
  });
  STATE.lastSeal = hash(payload);
}

function hash(str) {
  let h = 0;
  for (let i = 0; i < str.length; i++) {
    h = (h << 5) - h + str.charCodeAt(i);
    h |= 0;
  }
  return "0x" + (h >>> 0).toString(16);
}
