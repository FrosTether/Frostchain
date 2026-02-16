#!/bin/bash
echo "🚀 DEPLOYING MIRACLE_NODE_V4 [WEB_RESONANCE]..."

mkdir -p miracle-node

cat << 'INNER' > miracle-node/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
    <title>MIRACLE // V4_RESONANCE</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#000;--blue:#00e0ff;--gold:#ffd700;--pink:#ff69b4;--violet:#4b0082;--green:#00ff9d;}
        body, html{margin:0;padding:0;width:100%;height:100%;background:var(--bg);color:#eee;font-family:"Share Tech Mono",monospace;overflow:hidden;touch-action:none;}
        
        /* IOTA TANGLE LAYER */
        canvas{position:absolute;top:0;left:0;width:100%;height:100%;z-index:1;}
        
        /* HUD LAYER */
        .hud{position:absolute;top:20px;right:20px;text-align:right;font-size:10px;color:var(--blue);z-index:11;pointer-events:none;}
        .ticker-box{background:rgba(0,0,0,0.8);border:1px solid #222;padding:12px;border-radius:10px;margin-top:8px;text-align:left;border-left:3px solid var(--gold);pointer-events:auto;}
        
        /* UI CONTROL LAYER */
        #master-ui{position:absolute;z-index:10;width:100%;height:100%;display:flex;flex-direction:column;justify-content:center;align-items:center;pointer-events:none;gap:20px;}
        .btn{padding:15px 30px;background:rgba(0,0,0,0.9);border:1px solid var(--blue);border-radius:50px;text-align:center;cursor:pointer;pointer-events:auto;transition:0.3s;width:240px;letter-spacing:3px;font-size:12px;box-shadow:0 0 10px rgba(0,224,255,0.1);}
        .btn:hover{transform:scale(1.05);box-shadow:0 0 20px rgba(0,224,255,0.3);}
        
        .btn-tune{border-color:var(--gold);color:var(--gold);}
        .btn-alpha{border-color:var(--pink);color:var(--pink);}
        .btn-alpha.active{background:var(--pink);color:#000;box-shadow:0 0 30px var(--pink);}
        .btn-delta{border-color:var(--violet);color:var(--violet);}
        .btn-delta.active{background:var(--violet);color:#fff;box-shadow:0 0 30px var(--violet);}
        
        /* STEALTH MODE TOGGLE */
        .stealth-box{position:absolute;bottom:30px;width:100%;text-align:center;z-index:12;}
        .btn-stealth{background:transparent;border:1px solid #333;color:#555;padding:10px 20px;font-size:10px;border-radius:20px;cursor:pointer;pointer-events:auto;}
        .btn-stealth.active{border-color:var(--green);color:var(--green);box-shadow:0 0 10px var(--green);}
        
        /* STROBE KEEP-ALIVE */
        #strobe{position:absolute;bottom:0;right:0;width:2px;height:2px;background:#000;z-index:999;}
    </style>
</head>
<body>
    <canvas id="viz"></canvas>
    <div id="strobe"></div>

    <div class="hud">
        <div style="color:var(--gold);">MIRACLE_NODE_V4.0</div>
        <div class="ticker-box">
            FTC: 13.37 | FNR: 1.50 | FRST: 31,415.9<br>
            <span style="color:var(--pink);">LAYER: PINK_NOISE + BINAURAL</span><br>
            FREQ: <span id="freqDisp">528</span>Hz + <span id="offsetDisp">11.11</span>Hz<br>
            MINER: <span id="timer">ACTIVE</span>
        </div>
    </div>

    <div id="master-ui">
        <div id="startBtn" class="btn" style="border-color:#fff;color:#fff;" onclick="initAudio()">[ INITIALIZE SYSTEM ]</div>
        
        <div id="controls" style="display:none;flex-direction:column;gap:15px;align-items:center;">
            <div id="alphaBtn" class="btn btn-alpha active" onclick="setMode('alpha')">ALPHA [FOCUS]</div>
            <div id="deltaBtn" class="btn btn-delta" onclick="setMode('delta')">DELTA [SLEEP]</div>
            <div class="btn btn-tune" onclick="cycleTuning()">MANUAL ROTATION</div>
        </div>
    </div>

    <div class="stealth-box" style="display:none;" id="stealthUI">
        <button id="stealthBtn" class="btn-stealth" onclick="toggleStealth()">MODE: STANDARD (5%)</button>
    </div>

    <script>
        // --- CONFIGURATION ---
        const ENNEAD = [174, 285, 396, 417, 528, 639, 741, 852, 963];
        let audioCtx, masterGain, pinkGain, oscL, oscR, pinkNode;
        let isRunning = false;
        let currentMode = 'alpha'; // alpha or delta
        let baseFreq = 528;
        let offsetFreq = 11.11;
        let stealthMode = false;
        let rotationInterval;

        // --- AUDIO ENGINE ---
        async function initAudio() {
            if(isRunning) return;
            
            try {
                const AudioContext = window.AudioContext || window.webkitAudioContext;
                audioCtx = new AudioContext();
                
                // MASTER VOLUME (Lowered DB by default)
                masterGain = audioCtx.createGain();
                masterGain.gain.value = 0.05; // 5% Volume Default
                masterGain.connect(audioCtx.destination);

                // PINK NOISE GENERATOR
                const bufferSize = 4096;
                pinkNode = audioCtx.createScriptProcessor(bufferSize, 1, 1);
                pinkNode.onaudioprocess = function(e) {
                    const output = e.outputBuffer.getChannelData(0);
                    let b0, b1, b2, b3, b4, b5, b6;
                    b0 = b1 = b2 = b3 = b4 = b5 = b6 = 0.0;
                    for (let i = 0; i < bufferSize; i++) {
                        const white = Math.random() * 2 - 1;
                        b0 = 0.99886 * b0 + white * 0.0555179;
                        b1 = 0.99332 * b1 + white * 0.0750759;
                        b2 = 0.96900 * b2 + white * 0.1538520;
                        b3 = 0.86650 * b3 + white * 0.3104856;
                        b4 = 0.55000 * b4 + white * 0.5329522;
                        b5 = -0.7616 * b5 - white * 0.0168980;
                        output[i] = b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362;
                        output[i] *= 0.11; // Internal Pink Gain
                        b6 = white * 0.115926;
                    }
                };
                pinkGain = audioCtx.createGain();
                pinkGain.gain.value = 0.5; // Mix level relative to Master
                pinkNode.connect(pinkGain);
                pinkGain.connect(masterGain);

                // BINAURAL OSCILLATORS
                oscL = audioCtx.createOscillator();
                oscR = audioCtx.createOscillator();
                
                // Channel Merger for Stereo Separation
                const merger = audioCtx.createChannelMerger(2);
                oscL.connect(merger, 0, 0); // Left
                oscR.connect(merger, 0, 1); // Right
                merger.connect(masterGain);

                // Start
                updateFrequencies();
                oscL.start();
                oscR.start();

                // UI Updates
                document.getElementById('startBtn').style.display = 'none';
                document.getElementById('controls').style.display = 'flex';
                document.getElementById('stealthUI').style.display = 'block';
                
                isRunning = true;
                startRotation();
                
                // Keep-Alive Strobe
                requestAnimationFrame(strobeAnim);

            } catch (e) {
                alert("Audio Init Failed: " + e);
            }
        }

        // --- FREQUENCY LOGIC ---
        function updateFrequencies() {
            if(!audioCtx) return;
            const now = audioCtx.currentTime;
            
            // Smooth Transition
            oscL.frequency.setTargetAtTime(baseFreq, now, 0.5);
            oscR.frequency.setTargetAtTime(baseFreq + offsetFreq, now, 0.5);
            
            document.getElementById('freqDisp').innerText = baseFreq;
            document.getElementById('offsetDisp').innerText = offsetFreq.toFixed(2);
        }

        function setMode(mode) {
            currentMode = mode;
            
            // BUTTON STYLING
            document.getElementById('alphaBtn').classList.toggle('active', mode === 'alpha');
            document.getElementById('deltaBtn').classList.toggle('active', mode === 'delta');

            if (mode === 'alpha') {
                // ALPHA: Standard Rotation, 11.11Hz Offset (Creativity/Focus)
                offsetFreq = 11.11;
                // Pick a random mid-range tone immediately
                baseFreq = ENNEAD[Math.floor(Math.random() * ENNEAD.length)];
            } else {
                // DELTA: Deep Sleep, Pi Offset, Low Frequencies
                offsetFreq = 3.14159; // PI
                // Force low tones (174, 285, 396)
                const lowTones = [174, 285, 396];
                baseFreq = lowTones[Math.floor(Math.random() * lowTones.length)];
            }
            updateFrequencies();
        }

        function startRotation() {
            // Rotate every 150 seconds (simulated faster here for feedback, say 30s)
            rotationInterval = setInterval(() => {
                if (currentMode === 'alpha') {
                    // Next Ennead Tone
                    let idx = ENNEAD.indexOf(baseFreq);
                    idx = (idx + 1) % ENNEAD.length;
                    baseFreq = ENNEAD[idx];
                } else {
                    // Stay in low range for Delta
                    const lowTones = [174, 285, 396];
                    baseFreq = lowTones[Math.floor(Math.random() * lowTones.length)];
                }
                updateFrequencies();
            }, 30000); // 30s rotation for UX
        }

        function cycleTuning() {
            let idx = ENNEAD.indexOf(baseFreq);
            idx = (idx + 1) % ENNEAD.length;
            baseFreq = ENNEAD[idx];
            updateFrequencies();
        }

        // --- VOLUME CONTROL ---
        function toggleStealth() {
            stealthMode = !stealthMode;
            const btn = document.getElementById('stealthBtn');
            
            if (stealthMode) {
                // VERY LOW AUDIO (1%)
                masterGain.gain.setTargetAtTime(0.01, audioCtx.currentTime, 0.5);
                btn.innerText = "MODE: STEALTH (1%)";
                btn.classList.add('active');
            } else {
                // STANDARD LOW (5%)
                masterGain.gain.setTargetAtTime(0.05, audioCtx.currentTime, 0.5);
                btn.innerText = "MODE: STANDARD (5%)";
                btn.classList.remove('active');
            }
        }

        // --- VISUALIZER (IOTA TANGLE) ---
        const canvas = document.getElementById('viz');
        const ctx = canvas.getContext('2d');
        let nodes = [];
        
        function resize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
        window.onresize = resize; resize();

        // Init Particles
        for(let i=0; i<60; i++) {
            nodes.push({
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                vx: (Math.random()-0.5) * 0.5,
                vy: (Math.random()-0.5) * 0.5
            });
        }

        function draw() {
            ctx.fillStyle = 'rgba(0,0,0,0.1)'; // Trail effect
            ctx.fillRect(0,0,canvas.width, canvas.height);
            
            // Color based on Mode
            const color = currentMode === 'alpha' ? '0, 224, 255' : '75, 0, 130'; // Blue or Violet

            nodes.forEach((n, i) => {
                n.x += n.vx; n.y += n.vy;
                if(n.x < 0 || n.x > canvas.width) n.vx *= -1;
                if(n.y < 0 || n.y > canvas.height) n.vy *= -1;

                // Draw Connections (Tangle)
                nodes.forEach((n2, j) => {
                    if (i===j) return;
                    let dx = n.x - n2.x;
                    let dy = n.y - n2.y;
                    let dist = Math.sqrt(dx*dx + dy*dy);
                    if (dist < 150) {
                        ctx.beginPath();
                        ctx.strokeStyle = `rgba(${color}, ${1 - dist/150})`;
                        ctx.lineWidth = 0.5;
                        ctx.moveTo(n.x, n.y);
                        ctx.lineTo(n2.x, n2.y);
                        ctx.stroke();
                    }
                });
            });
            requestAnimationFrame(draw);
        }
        draw();

        // --- KEEPALIVE ---
        const sDiv = document.getElementById('strobe');
        function strobeAnim() {
            sDiv.style.opacity = Math.random() > 0.5 ? 1 : 0.1;
            requestAnimationFrame(strobeAnim);
        }

    </script>
</body>
</html>
INNER

surge miracle-node miracle-node.surge.sh
