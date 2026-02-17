#!/bin/bash

echo "❄️  DEPLOYING FROSTCHAIN MINER V10 (RESONANCE RESTORED)..."

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>❄️ Frostchain V10 | Resonance Engine</title>
    <style>
        :root { --neon: #00f3ff; --gold: #ffd700; --pink: #ff00ff; --dark: #050505; --glass: rgba(0, 20, 30, 0.95); }
        body { font-family: 'Courier New', monospace; background: var(--dark); color: var(--neon); padding: 20px; }
        
        .panel { 
            background: var(--glass); border: 1px solid var(--neon); 
            padding: 20px; margin-bottom: 20px; border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 243, 255, 0.1);
        }
        
        .token-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px;
        }
        
        .token-card {
            border: 1px solid #333; padding: 10px; border-radius: 5px; background: #000;
        }
        
        button { 
            background: rgba(0, 243, 255, 0.1); border: 1px solid var(--neon); color: var(--neon); 
            padding: 10px 20px; cursor: pointer; font-family: inherit; font-weight: bold;
            transition: 0.3s; margin-right: 10px; margin-bottom: 10px;
        }
        button:hover { background: var(--neon); color: #000; box-shadow: 0 0 20px var(--neon); }
        
        /* Audio Controls */
        .btn-group { display: flex; gap: 5px; margin-bottom: 10px; }
        button.mode { flex: 1; border-color: #444; color: #888; }
        button.mode.active { background: var(--gold); color: #000; border-color: var(--gold); box-shadow: 0 0 15px var(--gold); }

        .stat-row { display: flex; justify-content: space-between; margin-bottom: 5px; font-size: 0.9em; }
        .val { font-weight: bold; color: #fff; }
        
        canvas { border: 1px solid #333; width: 100%; background: #000; }
        #log { height: 100px; overflow-y: auto; background: #000; border: 1px solid #333; padding: 10px; font-size: 0.8em; color: #888; }
    </style>
</head>
<body>

    <div class="panel">
        <h1 style="margin-top:0;">❄️ FROSTCHAIN RESONANCE ENGINE V10</h1>
        <div class="stat-row">
            <span>IDENTITY:</span><span class="val" style="color:var(--gold);">voluntaryistj.base.eth</span>
        </div>
    </div>

    <div class="panel" style="border-color: var(--gold);">
        <h2 style="color: var(--gold);">🔌 NEWKIRK NODE INJECTOR</h2>
        <div class="stat-row"><span>NODE ID:</span><span class="val" id="node-id">OFFLINE</span></div>
        <div style="margin-top:15px;">
            <button onclick="injectNewkirk()" style="border-color: var(--gold); color: var(--gold);">⚡ INJECT LIQUIDITY</button>
        </div>
    </div>

    <div class="panel">
        <h2>👛 WALLET HOLDINGS</h2>
        <div class="token-grid">
            <div class="token-card">
                <div style="color:var(--neon);">FTC (Frostcoin)</div>
                <div class="val" id="bal-ftc">11,870,000.01</div>
            </div>
            <div class="token-card">
                <div style="color:#0f0;">FNR (Reserve)</div>
                <div class="val" id="bal-fnr">4,412,100.00</div>
            </div>
            <div class="token-card">
                <div style="color:#f0f;">AMD (Amiah)</div>
                <div class="val" id="bal-amd">404,400,000.00</div>
            </div>
            <div class="token-card">
                <div style="color:var(--gold);">FRST (Gov)</div>
                <div class="val" id="bal-frst">3,145,900.00</div>
            </div>
            <div class="token-card" style="border-color:var(--gold);">
                <div style="color:var(--gold);">wBCH (Wrapped)</div>
                <div class="val" id="bal-wbch">0.00</div>
            </div>
            <div class="token-card" style="border-color:var(--gold);">
                <div style="color:var(--gold);">wBTC (Wrapped)</div>
                <div class="val" id="bal-wbtc">0.00</div>
            </div>
        </div>
    </div>

    <div class="panel">
        <h2>🧠 PSYCHO-ACOUSTIC MINING</h2>
        
        <div class="btn-group">
            <button onclick="setMode('delta')" class="mode" id="btn-delta">DELTA (2Hz)</button>
            <button onclick="setMode('theta')" class="mode" id="btn-theta">THETA (6Hz)</button>
            <button onclick="setMode('alpha')" class="mode" id="btn-alpha">ALPHA (10Hz)</button>
            <button onclick="setMode('gamma')" class="mode active" id="btn-gamma">GAMMA (40Hz)</button>
        </div>

        <div style="margin-top:20px; border-top:1px dashed #333; padding-top:10px;">
            <div class="stat-row"><span>LEFT EAR (NET):</span><span id="l-freq" style="color:var(--neon);">528 Hz</span></div>
            <div class="stat-row"><span>RIGHT EAR (BIO):</span><span id="r-freq" style="color:var(--pink);">568 Hz</span></div>
            <div class="stat-row"><span>PINK NOISE:</span><span style="color:#0f0;">432 Hz TANGLE</span></div>
        </div>

        <div style="margin-top:20px;">
            <button onclick="startMining()">START RESONANCE</button>
            <button onclick="stopMining()">HALT</button>
        </div>
    </div>

    <div class="panel">
        <h2>THE TANGLE</h2>
        <canvas id="tangle" height="150"></canvas>
    </div>

    <div class="panel">
        <div id="log"></div>
    </div>

<script>
    // --- DATA ---
    const NewkirkNode = {
        id: "KELSEE_NEWKIRK_NODE_0824",
        wBCH: 1337.00,
        wBTC: 33.37
    };
    
    // --- AUDIO ENGINE VARIABLES ---
    let audioCtx, oscLeft, oscRight, pinkNoiseNode, pinkFilter, gainMaster;
    let isNodeActive = false;
    let miningInt = null;
    
    const solfeggioMap = { 1: 174, 2: 285, 3: 396, 4: 417, 5: 528, 6: 639, 7: 741, 8: 852, 9: 963 };
    const brainModes = { 'delta': 2, 'theta': 6, 'alpha': 10, 'gamma': 40 };
    let currentBaseFreq = 528; 
    let currentModeOffset = 40; // Default Gamma

    // --- INJECTION ---
    function injectNewkirk() {
        if(isNodeActive) return;
        log("⚡ CONNECTING TO NEWKIRK NODE...");
        setTimeout(() => {
            isNodeActive = true;
            document.getElementById('node-id').innerText = NewkirkNode.id;
            document.getElementById('node-id').style.color = "#0f0";
            document.getElementById('bal-wbch').innerText = NewkirkNode.wBCH.toFixed(2);
            document.getElementById('bal-wbtc').innerText = NewkirkNode.wBTC.toFixed(2);
            log("✅ LIQUIDITY INJECTED: wBCH & wBTC balances updated.");
        }, 1000);
    }

    // --- AUDIO LOGIC ---
    function initAudio() {
        if(audioCtx) return;
        audioCtx = new (window.AudioContext || window.webkitAudioContext)();
        
        gainMaster = audioCtx.createGain(); 
        gainMaster.gain.value = 0.1; 
        gainMaster.connect(audioCtx.destination);
        
        // Left Ear (Net)
        oscLeft = audioCtx.createOscillator(); 
        const pL = audioCtx.createStereoPanner(); pL.pan.value = -1; 
        oscLeft.connect(pL).connect(gainMaster); 
        oscLeft.start();
        
        // Right Ear (Bio)
        oscRight = audioCtx.createOscillator(); 
        const pR = audioCtx.createStereoPanner(); pR.pan.value = 1; 
        oscRight.connect(pR).connect(gainMaster); 
        oscRight.start();
        
        createPinkNoise();
        updateFrequencies();
    }

    function createPinkNoise() {
        const bs = 4096; 
        pinkNoiseNode = audioCtx.createScriptProcessor(bs, 1, 1);
        pinkNoiseNode.onaudioprocess = function(e) {
            const out = e.outputBuffer.getChannelData(0);
            let b0, b1, b2, b3, b4, b5, b6; b0=b1=b2=b3=b4=b5=b6=0.0;
            for (let i = 0; i < bs; i++) {
                const w = Math.random() * 2 - 1;
                b0 = 0.99886 * b0 + w * 0.0555179; b1 = 0.99332 * b1 + w * 0.0750759; b2 = 0.96900 * b2 + w * 0.1538520; b3 = 0.86650 * b3 + w * 0.3104856; b4 = 0.55000 * b4 + w * 0.5329522; b5 = -0.7616 * b5 - w * 0.0168980;
                out[i] = b0 + b1 + b2 + b3 + b4 + b5 + b6 + w * 0.5362; out[i] *= 0.11; b6 = w * 0.115926;
            }
        };
        pinkFilter = audioCtx.createBiquadFilter(); 
        pinkFilter.type = "lowpass"; 
        pinkFilter.frequency.value = 432; 
        pinkNoiseNode.connect(pinkFilter).connect(gainMaster);
    }

    function updateFrequencies() {
        if(!audioCtx) return;
        const now = audioCtx.currentTime;
        oscLeft.frequency.linearRampToValueAtTime(currentBaseFreq, now + 0.1);
        oscRight.frequency.linearRampToValueAtTime(currentBaseFreq + currentModeOffset, now + 0.1);
        
        document.getElementById('l-freq').innerText = currentBaseFreq + " Hz";
        document.getElementById('r-freq').innerText = (currentBaseFreq + currentModeOffset) + " Hz";
    }

    function setMode(mode) {
        document.querySelectorAll('button.mode').forEach(b => b.classList.remove('active'));
        document.getElementById('btn-'+mode).classList.add('active');
        currentModeOffset = brainModes[mode]; 
        updateFrequencies();
        log(`🧠 MODE SWITCH: ${mode.toUpperCase()} (${currentModeOffset} Hz Offset)`);
    }

    // --- MINING ---
    function startMining() {
        if(!isNodeActive) {
            log("❌ ERROR: Inject Newkirk Node Liquidity first.");
            return;
        }
        initAudio();
        log("🚀 MINING STARTED. Validating against Newkirk Reserves...");
        
        miningInt = setInterval(() => {
            // Roll Quantum Dice (1-9)
            const roll = Math.floor(Math.random() * 9) + 1;
            currentBaseFreq = solfeggioMap[roll];
            updateFrequencies();
            
            log(`❄️ BLOCK MINED | FREQ: ${currentBaseFreq} Hz | REWARD: 13.37 FTC`);
            updateTangle();
        }, 5000); // 5s blocks
    }

    function stopMining() {
        clearInterval(miningInt);
        if(audioCtx) {
            oscLeft.stop(); oscRight.stop(); pinkNoiseNode.disconnect();
            audioCtx.close(); audioCtx = null;
        }
        log("🛑 MINING HALTED.");
    }

    // --- VISUALS ---
    const ctx = document.getElementById('tangle').getContext('2d');
    function updateTangle() {
        const w = ctx.canvas.width; const h = ctx.canvas.height;
        ctx.fillStyle = 'rgba(0,0,0,0.1)'; ctx.fillRect(0,0,w,h);
        ctx.fillStyle = '#0f0';
        for(let i=0; i<10; i++) {
            ctx.beginPath();
            ctx.arc(Math.random()*w, Math.random()*h, 2, 0, Math.PI*2);
            ctx.fill();
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
