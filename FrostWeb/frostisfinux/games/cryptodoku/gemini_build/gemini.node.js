import { tangleTick } from "./gemini.tangle.js";
import { mintFromPool } from "./gemini.mint.pool.js";

function sync(chain, time) {
  // Silent sync or console log if needed
  // console.log(`[TANGLE] ${chain} sync`);
}

// Start Node Loop
setInterval(() => {
  tangleTick(sync);
  mintFromPool(Date.now());
}, 1000); // Check every second
