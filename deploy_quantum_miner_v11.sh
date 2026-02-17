#!/bin/bash

echo "❄️  DEPLOYING FROSTCHAIN MINER V11 (SECURITY CLEARANCE)..."

# 1. Environment Setup
if ! command -v node &> /dev/null; then
    echo "🔧 Installing Node.js..."
    if [ -x "$(command -v pkg)" ]; then pkg install nodejs -y; fi
    if [ -x "$(command -v apt)" ]; then sudo apt update && sudo apt install nodejs -y; fi
fi

if ! command -v surge &> /dev/null; then
    echo "🔧 Installing Surge..."
    npm install -g surge
fi

# 2. Directory Setup
mkdir -p frostchain-quantum-miner/public
cd frostchain-quantum-miner/public

# 3. WRITE THE MINER HTML/JS
cat <<'HTML' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>❄️ Frostchain V11 | Security Clearance</title>
    <style>
        :root { --neon: #00f3ff; --gold: #ffd700; --pink: #ff00ff; --dark: #050505; --glass: rgba(0, 20, 30, 0.98); }
        body { font-family: 'Courier New', monospace; background: var(--dark); color: var(--neon); margin: 0; padding: 20px; }
        
        /* SECURITY OVERLAY */
        #security-gate {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: #000; z-index: 9999;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
        }
        .pin-display {
            background: #111; border: 2px solid var(--neon); color: #fff;
            padding: 20px; font-size: 2em; text-align: center; width: 200px;
            margin-bottom: 20px; border-radius: 10px; letter-spacing: 10px;
        }
        .numpad { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; }
        .num-btn {
            background: rgba(0, 243, 255, 0.1); border: 1px solid var(--neon);
            color: var(--neon); font-size: 1.5em; padding: 20px;
            border-radius: 50%; width: 80px; height: 80px; cursor: pointer;
        }
        .num-btn:active { background: var(--neon); color: #000; }

        /* DASHBOARD */
        #dashboard { display: none; } /* Hidden until unlocked */
        
        .panel { 
            background: var(--glass); border: 1px solid var(--neon); 
            padding: 20px; margin-bottom: 20px; border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 243, 255, 0.1);
        }
        
        .token-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 10px;
        }
        .token-card {
            border: 1px solid #333; padding: 10px; border-radius: 5px; background: #000; font-size: 0.8em;
        }
        
        button.action-btn { 
            background: rgba(0, 243, 255, 0.1); border: 1px solid var(--neon); color: var(--neon); 
            padding: 12px; width: 100%; cursor: pointer; font-weight: bold; margin-bottom: 10px;
        }
        
        .stat-row { display: flex; justify-content: space-between; margin-bottom: 5px; font-size: 0.9em; }
        .val { font-weight: bold; color: #fff; }
        
        canvas { border: 1px solid #333; width: 100%; background: #000; }
        #log { height: 100px; overflow-y: auto; background: #000; border: 1px solid #333; padding: 10px; font-size: 0.8em; color: #888; }
    </style>
</head>
<body>

    <div id="security-gate">
        <h2 style="color:var(--neon); margin-bottom:30px;">IDENTITY VERIFICATION</h2>
        <div class="pin-display" id="pin-screen">_ _ _ _</div>
        <div class="numpad">
            <button class="num-btn" onclick="typePin(1)">1</button>
            <button class="num-btn" onclick="typePin(2)">2</button>
            <button class="num-btn" onclick="typePin(3)">3</button>
            <button class="num-btn" onclick="typePin(4)">4</button>
            <button class="num-btn" onclick="typePin(5)">5</button>
            <button class="num-btn" onclick="typePin(6)">6</button>
            <button class="num-btn" onclick="typePin(7)">7</button>
            <button class="num-btn" onclick="typePin(8)">8</button>
            <button class="num-btn" onclick="typePin(9)">9</button>
            <button class="num-btn" style="border-color:#f00; color:#f00;" onclick="clearPin()">C</button>
            <button class="num-btn" onclick="typePin(0)">0</button>
            <button class="num-btn" style="border-color:#0f0; color:#0f0;" onclick="unlock()">⏎</button>
        </div>
        <p style="color:#666; margin-top:20px;">REQ: GENESIS PIN</p>
    </div>

    <div id="dashboard">
        <div class="panel">
            <h1 style="margin:0; font-size:1.5em;">❄️ FROSTCHAIN V11</h1>
            <div class="stat-row" style="margin-top:10px;">
                <span>ID:</span><span class="val" style="color:var(--gold);">voluntaryistj.base.eth</span>
            </div>
            <div class="stat-row">
                <span>STATUS:</span><span class="val" style="color:#0f0;">SECURITY CLEARED</span>
            </div>
        </div>

        <div class="panel" style="border-color: var(--gold);">
            <h3 style="color: var(--gold); margin-top:0;">🔌 NEWKIRK NODE (ACTIVE)</h3>
            <div class="token-grid">
                <div class="token-card" style="border-color:var(--gold);">
                    <div style="color:var(--gold);">wBCH</div>
                    <div class="val" id="bal-wbch">1,337.00</div>
                </div>
                <div class="token-card" style="border-color:var(--gold);">
                    <div style="color:var(--gold);">wBTC</div>
                    <div class="val" id="bal-wbtc">33.37</div>
                </div>
            </div>
        </div>

        <div class="panel">
            <h3>👛 PORTFOLIO</h3>
            <div class="token-grid">
                <div class="token-card"><div>FTC</div><div class="val">11.87M</div></div>
                <div class="token-card"><div>FNR</div><div class="val">4.41M</div></div>
                <div class="token-card"><div>AMD</div><div class="val">404M</div></div>
                <div class="token-card"><div>FRST</div><div class="val">3.14M</div></div>
            </div>
        </div>

        <div class="panel">
            <h3>🧠 RESONANCE MINING</h3>
            <div style="display:flex; gap:10px; margin-bottom:15px;">
                <button class="action-btn" onclick="setMode('gamma')">GAMMA (40Hz)</button>
                <button class="action-btn" onclick="setMode('alpha')">ALPHA (10Hz)</button>
            </div>
            <button class="action-btn" style="background:var(--neon); color:#000;" onclick="toggleMining()">START / STOP</button>
            
            <div class="stat-row">
                <span>TARGET:</span><span id="carrier-disp" style="color:#0f0;">528 Hz</span>
            </div>
        </div>

        <div class="panel">
            <canvas id="tangle" height="150"></canvas>
            <div id="log"></div>
        </div>
    </div>

<script>
    // --- SECURITY LOGIC ---
    let currentPin = "";
    const CORRECT_PIN = "1991";

    function typePin(num) {
        if(currentPin.length < 4) {
            currentPin += num;
            updatePinDisplay();
            // Auto-submit if 4 digits
            if(currentPin.length === 4) unlock();
        }
    }

    function clearPin() {
        currentPin = "";
        updatePinDisplay();
    }

    function updatePinDisplay() {
        let display = "";
        for(let i=0; i<4; i++) {
            display += (i < currentPin.length) ? "*" : "_";
            display += " ";
        }
        document.getElementById('pin-screen').innerText = display;
    }

    function unlock() {
        if(currentPin === CORRECT_PIN) {
            document.getElementById('pin-screen').style.color = "#0f0";
            document.getElementById('pin-screen').innerText = "ACCESS GRANTED";
            setTimeout(() => {
                document.getElementById('security-gate').style.display = 'none';
                document.getElementById('dashboard').style.display = 'block';
                log("🔓 IDENTITY VERIFIED: voluntaryistj.base.eth");
                log("🔌 NEWKIRK NODE LINKED.");
                initAudio(); // Pre-load audio context
            }, 800);
        } else {
            document.getElementById('pin-screen').style.color = "#f00";
            document.getElementById('pin-screen').innerText = "DENIED";
            setTimeout(() => {
                currentPin = "";
                document.getElementById('pin-screen').style.color = "#fff";
                updatePinDisplay();
            }, 800);
        }
    }

    // --- APP LOGIC ---
    let miningInt = null;
    let audioCtx = null;
    let oscLeft, oscRight, gainMaster;

    function toggleMining() {
        if(miningInt) {
            clearInterval(miningInt); miningInt = null;
            if(audioCtx) audioCtx.suspend();
            log("🛑 MINING PAUSED.");
        } else {
            if(audioCtx) audioCtx.resume(); else initAudio();
            log("🚀 RESONANCE STARTED.");
            miningInt = setInterval(() => {
                const freq = [528, 432, 963][Math.floor(Math.random()*3)];
                document.getElementById('carrier-disp').innerText = freq + " Hz";
                log(`❄️ BLOCK MINED | FREQ: ${freq} Hz | REWARD: 13.37 FTC`);
                updateTangle();
            }, 3000);
        }
    }

    function initAudio() {
        if(audioCtx) return;
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        gainMaster = audioCtx.createGain(); gainMaster.gain.value = 0.05; gainMaster.connect(audioCtx.destination);
        
        oscLeft = audioCtx.createOscillator();
        const pL = audioCtx.createStereoPanner(); pL.pan.value = -1;
        oscLeft.connect(pL).connect(gainMaster); oscLeft.start();

        oscRight = audioCtx.createOscillator();
        const pR = audioCtx.createStereoPanner(); pR.pan.value = 1;
        oscRight.connect(pR).connect(gainMaster); oscRight.start();
        
        // Default to Gamma (40hz offset)
        setMode('gamma');
    }

    function setMode(mode) {
        if(!audioCtx) return;
        const base = 528;
        const offset = (mode === 'gamma') ? 40 : 10;
        oscLeft.frequency.value = base;
        oscRight.frequency.value = base + offset;
        log(`🧠 MODE: ${mode.toUpperCase()} (${offset}Hz OFFSET)`);
    }

    const ctx = document.getElementById('tangle').getContext('2d');
    function updateTangle() {
        const w = ctx.canvas.width; const h = ctx.canvas.height;
        ctx.fillStyle = 'rgba(0,0,0,0.2)'; ctx.fillRect(0,0,w,h);
        ctx.fillStyle = '#0f0';
        for(let i=0; i<8; i++) {
            ctx.beginPath(); ctx.arc(Math.random()*w, Math.random()*h, 2, 0, Math.PI*2); ctx.fill();
        }
    }

    function log(msg) {
        const d = document.getElementById('log');
        d.innerHTML = `> ${msg}<br>` + d.innerHTML;
    }
</script>
</body>
</html>
HTML

# 4. DEPLOY
echo "🚀 Deploying to Surge..."
surge . frost-miner.surge.sh
