#!/bin/bash
echo "🚀 DEPLOYING MIRACLE_NODE_V6 [QUANTUM_RANDOMX]..."

mkdir -p miracle-node

cat << 'INNER' > miracle-node/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
    <title>MIRACLE // QUANTUM_X</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#000;--blue:#00e0ff;--gold:#ffd700;--pink:#ff69b4;--violet:#4b0082;--green:#00ff9d;}
        body, html{margin:0;padding:0;width:100%;height:100%;background:var(--bg);color:#eee;font-family:"Share Tech Mono",monospace;overflow:hidden;touch-action:none;cursor:crosshair;}
        
        canvas{position:absolute;top:0;left:0;width:100%;height:100%;z-index:1;}
        .ui-layer{position:absolute;z-index:10;width:100%;height:100%;pointer-events:none;display:flex;flex-direction:column;justify-content:center;align-items:center;}
        
        .claim-modal{
            background:rgba(0,0,0,0.95);
            border:1px solid var(--blue);
            padding:40px;
            border-radius:20px;
            text-align:center;
            box-shadow:0 0 50px rgba(0,224,255,0.1);
            pointer-events:auto;
            transition:0.5s;
        }
        .input-group{display:flex;align-items:center;border-bottom:2px solid var(--gold);margin:20px 0;}
        input{background:none;border:none;color:#fff;font-family:inherit;font-size:20px;width:150px;text-align:right;outline:none;text-transform:lowercase;}
        
        .btn-claim{
            margin-top:20px;
            padding:15px 40px;
            background:var(--blue);
            color:#000;
            font-weight:bold;
            border:none;
            border-radius:50px;
            cursor:pointer;
            font-family:inherit;
            letter-spacing:2px;
            transition:0.3s;
        }
        .btn-claim:hover{box-shadow:0 0 30px var(--blue);transform:scale(1.05);}

        .hud{opacity:0;transition:1s;position:absolute;top:20px;right:20px;text-align:right;z-index:12;}
        .hash-stream{font-size:10px;color:#555;margin-top:5px;font-family:monospace;}
        
        .controls{position:absolute;bottom:30px;width:100%;text-align:center;z-index:12;opacity:0;pointer-events:none;transition:1s;}
        .ctrl-btn{pointer-events:auto;background:rgba(0,0,0,0.8);border:1px solid #333;color:#888;padding:10px 20px;margin:0 10px;border-radius:20px;cursor:pointer;font-family:inherit;font-size:10px;}
        .ctrl-btn.active{border-color:var(--pink);color:var(--pink);box-shadow:0 0 15px var(--pink);}
    </style>
</head>
<body>
    <canvas id="viz"></canvas>

    <div id="claim-ui" class="ui-layer">
        <div class="claim-modal">
            <div style="font-size:12px;color:#888;letter-spacing:2px;">QUANTUM_X MINING PROTOCOL</div>
            <div style="font-size:24px;margin-top:10px;color:var(--blue);">INITIALIZE NODE</div>
            <div class="input-group">
                <input type="text" id="aliasInput" placeholder="identity" autofocus>
                <span style="font-size:20px;color:var(--gold);margin-left:5px;">.frostchain</span>
            </div>
            <button class="btn-claim" onclick="claimShare()">START HASHING</button>
        </div>
    </div>

    <div id="hud" class="hud">
        <div id="minerID" style="color:var(--gold);font-size:14px;border-bottom:1px solid var(--gold);padding-bottom:5px;">...</div>
        <div style="color:var(--blue);font-size:12px;line-height:1.5;margin-top:5px;">
            ALGO: <span style="color:var(--pink);">QUANTUM_X (AUDIO_MEM)</span><br>
            HASHRATE: <span id="hashrate">0.0</span> H/s<br>
            NONCE: <span id="nonce">0</span>
        </div>
        <div id="hashStream" class="hash-stream">waiting for audio buffer...</div>
    </div>

    <div id="controls" class="controls">
        <button class="ctrl-btn active" id="alphaBtn" onclick="setMode('alpha')">ALPHA [FOCUS]</button>
        <button class="ctrl-btn" id="deltaBtn" onclick="setMode('delta')">DELTA [SLEEP]</button>
        <button class="ctrl-btn" onclick="toggleMute()">MUTE AUDIO</button>
    </div>

    <script>
        // --- VISUAL ENGINE (TANGLE) ---
        const canvas = document.getElementById('viz');
        const ctx = canvas.getContext('2d');
        let width, height, mouse = {x:-1000, y:-1000};
        let nodes = [];
        let mode = 'alpha';

        function resize(){width=window.innerWidth; height=window.innerHeight; canvas.width=width; canvas.height=height;}
        window.onresize=resize; resize();
        window.onmousemove=e=>{mouse.x=e.clientX; mouse.y=e.clientY;};
        window.ontouchmove=e=>{mouse.x=e.touches[0].clientX; mouse.y=e.touches[0].clientY;};

        for(let i=0; i<90; i++) nodes.push({x:Math.random()*width, y:Math.random()*height, vx:(Math.random()-0.5), vy:(Math.random()-0.5), size:Math.random()*2+1});

        function draw(){
            ctx.fillStyle = 'rgba(0,0,0,0.2)'; ctx.fillRect(0,0,width,height);
            const color = mode==='alpha'?'0,224,255':'75,0,130';
            nodes.forEach((n,i)=>{
                let dx=mouse.x-n.x, dy=mouse.y-n.y, dist=Math.sqrt(dx*dx+dy*dy);
                if(dist<200){
                    const f=(200-dist)/200; 
                    const dir = mode==='alpha'?0.03:-0.01;
                    n.vx+=dx*f*dir; n.vy+=dy*f*dir;
                }
                n.x+=n.vx; n.y+=n.vy;
                if(n.x<0||n.x>width)n.vx*=-1; if(n.y<0||n.y>height)n.vy*=-1;
                
                ctx.fillStyle=`rgb(${color})`; ctx.beginPath(); ctx.arc(n.x,n.y,n.size,0,Math.PI*2); ctx.fill();
                nodes.forEach((n2,j)=>{
                    if(i<=j)return;
                    let d2=Math.sqrt((n.x-n2.x)**2+(n.y-n2.y)**2);
                    if(d2<150){
                        ctx.strokeStyle=`rgba(${color},${1-d2/150})`; ctx.beginPath(); ctx.moveTo(n.x,n.y); ctx.lineTo(n2.x,n2.y); ctx.stroke();
                    }
                });
            });
            requestAnimationFrame(draw);
        }
        draw();

        // --- QUANTUM_X MINING ENGINE ---
        let audioCtx, masterGain, scriptNode, oscL, oscR;
        let hashes = 0, lastTime = Date.now();
        
        function claimShare(){
            const alias = document.getElementById('aliasInput').value;
            if(!alias) return;
            document.getElementById('claim-ui').style.display='none';
            document.getElementById('minerID').innerText = alias + ".frostchain";
            document.getElementById('hud').style.opacity='1';
            document.getElementById('controls').style.opacity='1';
            initAudio();
        }

        async function initAudio(){
            try {
                const AC = window.AudioContext || window.webkitAudioContext;
                audioCtx = new AC();
                masterGain = audioCtx.createGain();
                masterGain.gain.value = 0.05; 
                masterGain.connect(audioCtx.destination);

                // WORKER NODE: Uses Audio Buffer as "Scratchpad"
                const bufSize = 4096;
                scriptNode = audioCtx.createScriptProcessor(bufSize, 1, 1);
                
                scriptNode.onaudioprocess = e => {
                    const output = e.outputBuffer.getChannelData(0);
                    const inputBuffer = output; // In this gen setup, we use output buffer as memory
                    
                    // 1. GENERATE SOUND (Pink Noise)
                    let b0=0,b1=0,b2=0,b3=0,b4=0,b5=0,b6=0;
                    for(let i=0; i<bufSize; i++) {
                        const white = Math.random()*2-1;
                        b0 = 0.99886 * b0 + white * 0.0555179;
                        b1 = 0.99332 * b1 + white * 0.0750759;
                        b2 = 0.96900 * b2 + white * 0.1538520;
                        b3 = 0.86650 * b3 + white * 0.3104856;
                        b4 = 0.55000 * b4 + white * 0.5329522;
                        b5 = -0.7616 * b5 - white * 0.0168980;
                        output[i] = (b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362) * 0.11;
                        b6 = white * 0.115926;
                    }

                    // 2. QUANTUM_X HASHING (The "Work")
                    // We iterate over the audio buffer and perform "Resonance Math"
                    let quantumHash = 0;
                    for(let i=0; i<bufSize; i+=16) { // Stride to simulate random access
                        let sample = Math.abs(output[i] * 10000); // Convert float audio to int-like
                        // Monero-style math operations
                        quantumHash = (quantumHash + sample) * 432; 
                        quantumHash = (quantumHash ^ Math.floor(sample)) % 528;
                        hashes++; 
                    }
                    
                    // 3. UI UPDATE
                    const now = Date.now();
                    if(now - lastTime > 1000) {
                        document.getElementById('hashrate').innerText = hashes.toLocaleString();
                        hashes = 0; 
                        lastTime = now;
                        document.getElementById('nonce').innerText = Math.floor(Math.random() * 999999);
                        document.getElementById('hashStream').innerText = "HASH: 0x" + Math.floor(Math.random()*16777215).toString(16) + "...";
                    }
                };

                const pinkGain = audioCtx.createGain(); pinkGain.gain.value=0.5;
                scriptNode.connect(pinkGain); pinkGain.connect(masterGain);

                // Binaural Overlay
                oscL = audioCtx.createOscillator(); oscR = audioCtx.createOscillator();
                const merger = audioCtx.createChannelMerger(2);
                oscL.connect(merger, 0, 0); oscR.connect(merger, 0, 1);
                merger.connect(masterGain);
                oscL.start(); oscR.start();
                updateFreqs();

            } catch(e){console.log(e);}
        }

        function updateFreqs(){
            const now = audioCtx.currentTime;
            let base = mode==='alpha'?528:174;
            let off = mode==='alpha'?11.11:3.14159;
            oscL.frequency.setTargetAtTime(base, now, 0.5);
            oscR.frequency.setTargetAtTime(base+off, now, 0.5);
        }
        function setMode(m){mode=m; updateFreqs(); document.getElementById('alphaBtn').classList.toggle('active', m==='alpha'); document.getElementById('deltaBtn').classList.toggle('active', m==='delta');}
        function toggleMute(){ if(masterGain.gain.value>0) masterGain.gain.setTargetAtTime(0, audioCtx.currentTime, 0.1); else masterGain.gain.setTargetAtTime(0.05, audioCtx.currentTime, 0.1);}

    </script>
</body>
</html>
INNER

surge miracle-node miracle-node.surge.sh
