#!/bin/bash

echo "❄️  DEPLOYING FROSTCOIN MINER V13 (IDENTITY ACCESS)..."

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
mkdir -p frostcoin-quantum-miner/public
cd frostcoin-quantum-miner/public

# 3. WRITE THE MINER HTML/JS
cat <<'HTML' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>❄️ Frostcoin V13 | Identity Access</title>
    <style>
        :root { --neon: #00f3ff; --gold: #ffd700; --green: #00ff41; --dark: #050505; --glass: rgba(0, 20, 30, 0.98); }
        body { font-family: 'Courier New', monospace; background: var(--dark); color: var(--neon); margin: 0; padding: 20px; }
        
        /* LOGIN GATE */
        #login-gate {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: #000; z-index: 9999;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
        }
        
        input#identity-input {
            background: #111; border: 2px solid var(--neon); color: #fff;
            padding: 15px; font-size: 1.2em; text-align: center; width: 80%; max-width: 400px;
            margin-bottom: 20px; border-radius: 5px; font-family: inherit;
        }
        
        button.login-btn {
            background: var(--neon); color: #000; border: none;
            padding: 15px 40px; font-size: 1.2em; font-weight: bold; cursor: pointer;
            border-radius: 5px; box-shadow: 0 0 20px rgba(0, 243, 255, 0.4);
        }

        /* DASHBOARD */
        #dashboard { display: none; }
        
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
        #log { height: 150px; overflow-y: auto; background: #000; border: 1px solid #333; padding: 10px; font-size: 0.8em; color: #888; }
        
        .log-tangle { color: var(--green); }
        .log-block { color: var(--gold); font-weight: bold; border-top: 1px dashed var(--gold); border-bottom: 1px dashed var(--gold); padding: 5px 0; }
    </style>
</head>
<body>

    <div id="login-gate">
        <h1 style="color:var(--neon); margin-bottom:10px;">❄️ FROSTCOIN V13</h1>
        <p style="color:#666; margin-bottom:30px;">SECURE QUANTUM TERMINAL</p>
        
        <input type="text" id="identity-input" placeholder="Enter Identity (e.g. voluntaryistj.base.eth)">
        <button class="login-btn" onclick="login()">INITIALIZE MINER</button>
    </div>

    <div id="dashboard">
        <div class="panel">
            <h1 style="margin:0; font-size:1.5em;">❄️ CONSOLE ACTIVE</h1>
            <div class="stat-row" style="margin-top:10px;">
                <span>USER:</span><span class="val" id="display-id" style="color:var(--gold);">--</span>
            </div>
            <div class="stat-row">
                <span>PROTOCOL:</span><span class="val" style="color:#0f0;">HYPER-TANGLE (4s)</span>
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
            <div style="margin-top:10px; font-size:0.8em; color:#666;">* WITHDRAWALS DISABLED BY ADMIN</div>
        </div>

        <div class="panel">
            <h3>🧠 RESONANCE MINING</h3>
            <div style="display:flex; gap:10px; margin-bottom:15px;">
                <button class="action-btn" onclick="setMode('gamma')">GAMMA (40Hz)</button>
                <button class="action-btn" onclick="setMode('alpha')">ALPHA (10Hz)</button>
            </div>
            <button class="action-btn" style="background:var(--neon); color:#000;" onclick="toggleMining()">START / STOP</button>
            
            <div class="stat-row">
                <span>NEXT REWARD:</span><span id="countdown" style="color:var(--gold);">300s</span>
            </div>
            <div class="stat-row">
                <span>TANGLE STATUS:</span><span id="tangle-status" style="color:var(--green);">IDLE</span>
            </div>
        </div>

        <div class="panel">
            <canvas id="tangle" height="150"></canvas>
            <div id="log"></div>
        </div>
    </div>

<script>
    // --- LOGIN LOGIC ---
    function login() {
        const id = document.getElementById('identity-input').value.trim();
        if(id.length > 3) {
            document.getElementById('display-id').innerText = id;
            document.getElementById('login-gate').style.display = 'none';
            document.getElementById('dashboard').style.display = 'block';
            log(`🔓 ACCESS GRANTED: ${id}`);
            log("🔌 NEWKIRK NODE LINKED.");
            initAudio(); // Pre-load audio
        } else {
            alert("Please enter a valid identity.");
        }
    }

    // --- MINING LOGIC ---
    let tangleInt = null;
    let blockInt = null;
    let countdownInt = null;
    let secondsToBlock = 300;
    
    // Audio
    let audioCtx = null;
    let oscLeft, oscRight, gainMaster;

    function toggleMining() {
        if(tangleInt) {
            // STOP
            clearInterval(tangleInt); tangleInt = null;
            clearInterval(blockInt); blockInt = null;
            clearInterval(countdownInt); countdownInt = null;
            if(audioCtx) audioCtx.suspend();
            log("🛑 MINING PAUSED.");
        } else {
            // START
            if(audioCtx) audioCtx.resume(); else initAudio();
            log("🚀 RESONANCE STARTED.");
            
            // 1. TANGLE LOOP (4 Seconds)
            tangleInt = setInterval(() => {
                const hash = Math.random().toString(36).substr(2, 6);
                const tps = Math.floor(Math.random() * 50) + 10;
                log(`<span class="log-tangle">⚡ TANGLE SYNC: \( {hash} confirmed ( \){tps} TPS)</span>`);
                document.getElementById('tangle-status').innerText = "SYNCED";
                updateTangle();
                playBlip(600, 0.05); // Short high blip
            }, 4000);

            // 2. REWARD LOOP (300 Seconds)
            secondsToBlock = 300;
            countdownInt = setInterval(() => {
                secondsToBlock--;
                document.getElementById('countdown').innerText = secondsToBlock + "s";
                if(secondsToBlock <= 0) secondsToBlock = 300;
            }, 1000);

            blockInt = setInterval(() => {
                const freq = [528, 432, 963][Math.floor(Math.random()*3)];
                log(`<span class="log-block">🏆 BLOCKCHAIN CONSENSUS REACHED | REWARD: 13.37 FCN | FREQ: ${freq} Hz</span>`);
                playBlip(freq, 0.5); // Long tone
            }, 300000); // 5 minutes
        }
    }

    // --- AUDIO SYSTEM ---
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
        
        setMode('gamma');
    }

    function setMode(mode) {
        if(!audioCtx) return;
        const base = 528;
        const offset = (mode === 'gamma') ? 40 : 10;
        oscLeft.frequency.value = base;
        oscRight.frequency.value = base + offset;
        log(`🧠 MODE: \( {mode.toUpperCase()} ( \){offset}Hz OFFSET)`);
    }

    function playBlip(freq, duration) {
        if(!audioCtx) return;
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.frequency.value = freq;
        gain.gain.value = 0.1;
        osc.connect(gain).connect(audioCtx.destination);
        osc.start();
        setTimeout(() => osc.stop(), duration * 1000);
    }

    // --- VISUALS ---
    const ctx = document.getElementById('tangle').getContext('2d');
    function updateTangle() {
        const w = ctx.canvas.width; const h = ctx.canvas.height;
        ctx.fillStyle = 'rgba(0,0,0,0.2)'; ctx.fillRect(0,0,w,h);
        ctx.fillStyle = '#0f0';
        for(let i=0; i<10; i++) {
            let x = Math.random()*w; let y = Math.random()*h;
            ctx.beginPath(); ctx.arc(x, y, 2, 0, Math.PI*2); ctx.fill();
            if(i>0) {
                ctx.beginPath(); ctx.moveTo(x,y); ctx.lineTo(Math.random()*w, Math.random()*h); 
                ctx.strokeStyle = 'rgba(0,255,0,0.3)'; ctx.stroke();
            }
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
