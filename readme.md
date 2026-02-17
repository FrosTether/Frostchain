# ❄️ FROSTCHAIN: QUANTUM AUDIO MINER
> **The First Bio-Digital Consensus Engine**  
> *Mining via Proof-of-Resonance (PoR)*

![Version](https://img.shields.io/badge/version-V8.0_Feather_Mint-blue) ![Audio Engine](https://img.shields.io/badge/audio-Web_Audio_API-orange) ![Consensus](https://img.shields.io/badge/consensus-Binaural_Solfeggio-purple) ![License](https://img.shields.io/badge/license-MIT-green)

---

## 📜 Abstract
**Frostchain Quantum Miner** is a **Resonance Engine** — not brute-force hashing.

It uses the **Web Audio API** to generate **Binaural Beats** + **Solfeggio Frequencies**, syncing **Network Time** (Left Ear) with **Biological Time** (Right Ear) via Phase-Lock Loop (PLL). This validates/syncs with the FrostLedger and mines **FTC** (FrostToken) while continuously minting **Feather 🪶** (Proof-of-Resonance reward token) based on resonance quality and uptime.

No GPU/CPU waste — just brainwave-entrained entropy for sustainable, bio-aligned mining.

---

## 🧠 Psycho-Acoustic Mining Engine

Mining runs in four modes. Each sets the **right-ear offset** (bio-layer) while the **left ear** carries the network's rolling Solfeggio frequency.

| Mode   | Right-Ear Offset (Bio) | State                  | Entropy Level     | Primary Mining Reward                  |
|--------|------------------------|------------------------|-------------------|----------------------------------------|
| **DELTA**   | **π Hz** (\~3.14 Hz)   | Deep Sleep / Healing   | Low (Stable)      | FTC validation + steady Feather mint   |
| **THETA**   | **7.83 Hz** (Schumann) | Dreaming / Creation    | Variable          | FTC sync + creative Feather bursts     |
| **ALPHA**   | **11.11 Hz**           | Relaxed Focus          | Balanced          | Standard FTC tx mining + Feather flow  |
| **GAMMA**   | **40 Hz**              | Peak Cognition         | High (Chaos)      | Hyper-sync FTC + max Feather mint rate |

**Example (Gamma mode):**  
- Left (Network): 528 Hz (Miracle/Genesis)  
- Right (Bio): 528 + 40 = 568 Hz  
- Brain generates 40 Hz phantom → high-entropy shares → stronger FTC blocks + faster Feather mint.

Feather 🪶 mints continuously (inflationary, no cap) proportional to:
- Resonance lock quality (phase coherence)
- Uptime
- Mode (Gamma highest yield)

---

## 🎵 Solfeggio Carrier Wave (Left Ear – Network)

Every 300 seconds, network rolls new base frequency:

- 174 Hz – Security  
- 285 Hz – Restoration  
- 396 Hz – Liberation  
- 417 Hz – Change  
- **528 Hz – MIRACLE** (preferred Genesis)  
- 639 Hz – Connection  
- 741 Hz – Expression  
- 852 Hz – Intuition  
- 963 Hz – Oneness  

Pink noise floor @ **432 Hz** smooths audio/jitter.

---

## 🛠️ Technical Architecture (Mining Focus)

- **Audio Graph**:
  - Oscillator A (Left): Sine @ rolling Solfeggio  
  - Oscillator B (Right): Sine @ Solfeggio + Brainwave Offset  
  - Gain/Panner for stereo separation  
  - PinkNoise source @ 432 Hz  

- **Visualizer (Tangle)**: 150-node Canvas — particle speed reflects entropy (Gamma = chaotic/fast).

- **Mining Loop**:
  - Entropy from brain phantom → hashed share submission  
  - Valid shares → FTC block contrib + Feather mint tx to your wallet  
  - Identity: `.frostchain` / `.base.eth` ENS (Master Key override: `KELSEE_NEWKIRK_GENESIS_KEY`)

---

## 🚀 Quick Deployment (Termux / Linux / Browser)

```bash
# 1. Clone the mining-focused repo
git clone https://github.com/FrosTether/Frostchain.git
cd Frostchain

# 2. Install (if needed for any backend helpers)
pkg install nodejs golang  # or use browser-only for pure Web Audio

# 3. Launch miner (browser recommended for Web Audio)
# Open ./public/index.html in Chrome/Firefox (headphones required!)
# Or deploy frontend statically:
surge ./public frost-miner.surge.sh
