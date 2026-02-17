#!/bin/bash

echo "❄️  DEPLOYING FROSTCOIN QUANTUM AUDIO MINER V13 (Solfeggio + Tangle)..."

# Environment Setup
if ! command -v node &> /dev/null; then
    echo "🔧 Installing Node.js..."
    if [ -x "$(command -v pkg)" ]; then pkg install nodejs -y; fi
    if [ -x "$(command -v apt)" ]; then sudo apt update && sudo apt install nodejs -y; fi
fi

if ! command -v surge &> /dev/null; then
    echo "🔧 Installing Surge..."
    npm install -g surge
fi

# Directory Setup
mkdir -p frostcoin-quantum-miner/public
cd frostcoin-quantum-miner/public

# WRITE THE MINER HTML/JS
cat <<'HTML' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>❄️ Frostcoin Quantum Miner V13</title>
    <style>
        body { margin:0; padding:20px; font-family:monospace; background:#000; color:#0f3; }
        h1, h2, h3 { color:#0ff; }
        input, button { background:#111; color:#0f3; border:1px solid #0f3; padding:10px; font-size:1.1em; margin:8px 0; }
        button:hover { background:#0f3; color:#000; }
        #login { position:fixed; inset:0; background:#000; display:flex; flex-direction:column; align-items:center; justify-content:center; z-index:100; }
        #dashboard { display:none; }
        canvas { border:1px solid #0f3; width:100%; max-width:900px; height:300px; background:#000; }
        #log { height:160px; overflow-y:auto; background:#000; border:1px solid #333; padding:10px; font-size:0.9em; white-space:pre-wrap; }
        .solf { color:#ff0; font-weight:bold; }
        .block { border-top:1px dashed #ff0; border-bottom:1px dashed #ff0; padding:6px 0; }
    </style>
</head>
<body>

<div id="login">
    <h1>❄️ FROSTCOIN QUANTUM MINER V13</h1>
    <p>Proof-of-Resonance • Binaural Solfeggio Consensus</p>
    <input id="identity" placeholder="yourname.frostchain or name.base.eth" style="width:320px;">
    <button onclick="gateIdentity()">INITIALIZE RESONANCE ENGINE</button>
</div>

<div id="dashboard">
    <h1>❄️ FROSTCOIN NODE ACTIVE</h1>
    <p>Identity: <span id="id-display" style="color:#ff0;"></span></p>
    <p>Master Key: KELSEE_NEWKIRK_GENESIS_KEY</p>

    <h3>Resonance Mode</h3>
    <button onclick="setMode('delta')">DELTA (π Hz)</button>
    <button onclick="setMode('theta')">THETA (7.83 Hz)</button>
    <button onclick="setMode('alpha')">ALPHA (11.11 Hz)</button>
    <button onclick="setMode('gamma')">GAMMA (40 Hz)</button>

    <h3>Current Solfeggio Carrier</h3>
    <p id="carrier">528 Hz – MIRACLE</p>

    <h3>Tangle Visualizer (IOTA-style DAG)</h3>
    <canvas id="tangle"></canvas>

    <h3>Mining Log</h3>
    <div id="log"></div>

    <button onclick="toggleMining()" style="margin-top:15px; font-size:1.2em;">START / STOP MINING</button>
</div>

<script>
// ────────────────────────────────────────────────
// CONFIG
// ────────────────────────────────────────────────
const NewkirkKey = "KELSEE_NEWKIRK_GENESIS_KEY";
const Solfeggio = [
    {hz:174, name:"Security & Pain Relief"},
    {hz:285, name:"Restoration"},
    {hz:396, name:"Liberation"},
    {hz:417, name:"Change"},
    {hz:528, name:"MIRACLE (Genesis / DNA Repair)"},
    {hz:639, name:"Connection"},
    {hz:741, name:"Expression"},
    {hz:852, name:"Intuition"},
    {hz:963, name:"Oneness"}
];
const Offsets = {delta: Math.PI, theta: 7.83, alpha: 11.11, gamma: 40};
let minerID = "";
let audioCtx, oscA, oscB, noise, gainNode, pannerA, pannerB;
let currentMode = "alpha";
let currentCarrier = 528;
let mining = false;
let blockTimer, tangleTimer;

// ────────────────────────────────────────────────
// IDENTITY GATE
// ────────────────────────────────────────────────
function gateIdentity() {
    const input = document.getElementById('identity').value.trim();
    if (input.endsWith('.frostchain') || input.endsWith('.base.eth')) {
        minerID = input;
        document.getElementById('id-display').textContent = minerID;
        document.getElementById('login').style.display = 'none';
        document.getElementById('dashboard').style.display = 'block';
        log(`🔓 ACCESS GRANTED: ${minerID}`);
        log(`🔑 ${NewkirkKey} VERIFIED`);
        initAudio();
    } else {
        alert("Identity must end with .frostchain or .base.eth");
    }
}

// ────────────────────────────────────────────────
// AUDIO (Binaural Solfeggio + Pink Noise)
// ────────────────────────────────────────────────
function initAudio() {
    audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    gainNode = audioCtx.createGain();
    gainNode.gain.value = 0.08;
    gainNode.connect(audioCtx.destination);

    // Left ear – Carrier
    oscA = audioCtx.createOscillator();
    oscA.type = 'sine';
    pannerA = audioCtx.createStereoPanner();
    pannerA.pan.value = -1;
    oscA.connect(pannerA).connect(gainNode);

    // Right ear – Carrier + offset
    oscB = audioCtx.createOscillator();
    oscB.type = 'sine';
    pannerB = audioCtx.createStereoPanner();
    pannerB.pan.value = 1;
    oscB.connect(pannerB).connect(gainNode);

    // Pink noise floor (\~432 Hz flavor)
    noise = audioCtx.createBufferSource();
    const bufSize = audioCtx.sampleRate * 5;
    const buffer = audioCtx.createBuffer(1, bufSize, audioCtx.sampleRate);
    const data = buffer.getChannelData(0);
    let b = 0;
    for (let i = 0; i < bufSize; i++) {
        const white = Math.random() * 2 - 1;
        b = 0.02 * white + b * 0.98;
        data[i] = b * 3.5;
    }
    noise.buffer = buffer;
    noise.loop = true;
    const noiseGain = audioCtx.createGain();
    noiseGain.gain.value = 0.015;
    noise.connect(noiseGain).connect(audioCtx.destination);

    updateAudio();
    noise.start();
}

function updateAudio() {
    if (!audioCtx) return;
    const offset = Offsets[currentMode];
    oscA.frequency.setValueAtTime(currentCarrier, audioCtx.currentTime);
    oscB.frequency.setValueAtTime(currentCarrier + offset, audioCtx.currentTime);
    document.getElementById('carrier').innerHTML = `<span class="solf">${currentCarrier} Hz – ${Solfeggio.find(f=>f.hz===currentCarrier)?.name || 'Unknown'}</span><br>Offset: \( {offset.toFixed(2)} Hz ( \){currentMode.toUpperCase()})`;
}

function setMode(mode) {
    currentMode = mode;
    updateAudio();
    log(`🧠 Switched to \( {mode.toUpperCase()} mode ( \){Offsets[mode]} Hz offset)`);
}

// ────────────────────────────────────────────────
// TANGLE VISUALIZER (150 nodes, mouse-responsive)
// ────────────────────────────────────────────────
const canvas = document.getElementById('tangle');
const ctx = canvas.getContext('2d');
let particles = [];
for (let i = 0; i < 150; i++) {
    particles.push({
        x: Math.random() * canvas.width,
        y: Math.random() * canvas.height,
        vx: (Math.random()-0.5)*1.2,
        vy: (Math.random()-0.5)*1.2
    });
}

function drawTangle() {
    ctx.fillStyle = 'rgba(0,0,0,0.12)';
    ctx.fillRect(0,0,canvas.width,canvas.height);

    const speedMult = {delta:0.4, theta:0.9, alpha:1.4, gamma:2.8}[currentMode];

    particles.forEach(p => {
        p.x += p.vx * speedMult;
        p.y += p.vy * speedMult;
        if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
        if (p.y < 0 || p.y > canvas.height) p.vy *= -1;

        ctx.beginPath();
        ctx.arc(p.x, p.y, 2.5, 0, Math.PI*2);
        ctx.fillStyle = '#0f3';
        ctx.fill();
    });

    // Draw connections
    for (let i = 0; i < particles.length; i++) {
        for (let j = i+1; j < particles.length; j++) {
            const dx = particles[i].x - particles[j].x;
            const dy = particles[i].y - particles[j].y;
            const dist = Math.hypot(dx, dy);
            if (dist < 90) {
                ctx.beginPath();
                ctx.moveTo(particles[i].x, particles[i].y);
                ctx.lineTo(particles[j].x, particles[j].y);
                ctx.strokeStyle = `rgba(0,255,51,${0.4 - dist/225})`;
                ctx.stroke();
            }
        }
    }

    requestAnimationFrame(drawTangle);
}
drawTangle();

// Mouse perturbation (touch mechanic)
canvas.addEventListener('mousemove', e => {
    const rect = canvas.getBoundingClientRect();
    const mx = e.clientX - rect.left;
    const my = e.clientY - rect.top;
    particles.forEach(p => {
        const d = Math.hypot(p.x - mx, p.y - my);
        if (d < 120) {
            const force = (120 - d) / 120;
            p.vx += (mx - p.x) * force * 0.08;
            p.vy += (my - p.y) * force * 0.08;
        }
    });
});

// ────────────────────────────────────────────────
// MINING LOGIC (300s blocks + 4s tangle syncs)
// ────────────────────────────────────────────────
function toggleMining() {
    if (mining) {
        clearInterval(blockTimer);
        clearInterval(tangleTimer);
        if (audioCtx) audioCtx.suspend();
        log("🛑 MINING HALTED");
        mining = false;
    } else {
        if (!minerID) return alert("Identity required");
        if (audioCtx) audioCtx.resume();
        log("🚀 PROOF-OF-RESONANCE ACTIVE");

        // Tangle sync simulation (every 4s)
        tangleTimer = setInterval(() => {
            log(`⚡ TANGLE SYNC – ${Math.random().toString(36).slice(2,10)} confirmed (IOTA-style tip approval)`);
        }, 4000);

        // Block reward every 300s
        blockTimer = setInterval(() => {
            // Quantum dice roll new Solfeggio carrier
            const choice = Solfeggio[Math.floor(Math.random() * Solfeggio.length)];
            currentCarrier = choice.hz;
            updateAudio();

            log(`<span class="block">🏆 BLOCK MINED | REWARD: 13.37 FCN | CARRIER: ${currentCarrier} Hz – ${choice.name}</span>`);
        }, 300000);

        mining = true;
    }
}

function log(msg) {
    const logEl = document.getElementById('log');
    logEl.innerHTML = `> ${new Date().toLocaleTimeString()} | ${msg}<br>` + logEl.innerHTML;
    logEl.scrollTop = logEl.scrollHeight;
}

// Start with default mode & carrier
setMode('alpha');
</script>
</body>
</html>
HTML

# Deploy
echo "🚀 Deploying to Surge..."
surge . frostcoin-miner.surge.sh

