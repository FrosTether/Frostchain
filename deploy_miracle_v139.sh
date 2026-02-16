#!/bin/bash
echo "🚀 DEPLOYING MIRACLE_NODE_V139 [HARDENED_STABILIZED]..."

mkdir -p miracle-node

cat << 'INNER' > miracle-node/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no,maximum-scale=1.0">
    <title>MIRACLE // V139_HARDENED</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root { --bg: #000; --blue: #00e0ff; --gold: #ffd700; --pink: #ff69b4; --violet: #4b0082; --green: #00ff00; }
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; background: var(--bg); color: #eee; font-family: "Share Tech Mono", monospace; overflow: hidden; touch-action: none; user-select: none; }
        
        canvas { position: absolute; top: 0; left: 0; width: 100%; height: 100%; z-index: 1; }
        #strobeLock { position: absolute; bottom: 0; right: 0; width: 4px; height: 4px; z-index: 100; background: #000; }
        
        .hud { position: absolute; top: 20px; right: 20px; text-align: right; font-size: 10px; color: var(--blue); z-index: 11; pointer-events: none; }
        .ticker-box { background: rgba(0, 0, 0, 0.9); border: 1px solid #222; border-left: 3px solid var(--gold); padding: 12px; border-radius: 10px; margin-top: 8px; text-align: left; }
        
        .ui-layer { position: absolute; z-index: 10; width: 100%; height: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center; pointer-events: none; }
        .btn { padding: 20px; background: rgba(0, 0, 0, 0.95); border: 2px solid var(--blue); border-radius: 100px; text-align: center; cursor: pointer; pointer-events: auto; transition: 0.4s; width: 260px; letter-spacing: 5px; margin-bottom: 15px; }
        .btn-tuning { border-color: var(--gold); color: var(--gold); font-size: 10px; }
        .btn-alpha { border-color: var(--pink); color: var(--pink); }
        .btn-alpha.active { background: var(--pink); color: #000; box-shadow: 0 0 50px var(--pink); }
        .btn-delta { border-color: var(--violet); color: var(--violet); }
        .btn-delta.active { background: var(--violet); color: #fff; box-shadow: 0 0 50px var(--violet); }

        #initOverlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.98); z-index: 999; display: flex; flex-direction: column; justify-content: center; align-items: center; cursor: pointer; pointer-events: auto; }
        .init-circle { width: 180px; height: 180px; border: 2px solid var(--gold); border-radius: 50%; display: flex; justify-content: center; align-items: center; color: var(--gold); font-size: 14px; letter-spacing: 3px; text-align: center; box-shadow: 0 0 30px rgba(255,215,0,0.2); transition: 0.3s; }
        .init-circle:hover { box-shadow: 0 0 60px var(--gold); background: rgba(255,215,0,0.05); }
        #aliasIn { background: transparent; border: none; border-bottom: 1px solid var(--blue); color: var(--blue); font-family: inherit; font-size: 20px; text-align: center; margin-bottom: 40px; outline: none; width: 220px; }
    </style>
</head>
<body>
    <canvas id="tangleViz"></canvas>
    <canvas id="strobeLock"></canvas>
    <video id="keepAlive" playsinline loop muted style="display:none;"><source src="data:video/mp4;base64,AAAAHGZ0eXBpc29tAAACAGlzb21pc28yYXZjMQAAAAhmcmVlAAAGF21kYXQAAAYzZ2JsbQAAAAAAAAAAAB5gbWZmYwAAAAAAAAGaAAAAAQAAAAAAAAAAAAAAA2dtZGlhAAAAIG1kaGQAAAAA1cNIQdXDSEEAyu4AAKruAAAAAAAAAAAAAAAtaGRscgAAAAAAAAAAdmlkZQAAAAAAAAAAAAAAAAAAAAB2aWRlb2hhbmRsZXIAAAACZ21pbmYAAAAUdm1oZAAAAAEAAAAAAAAAAAAAACRkaW5mAAAAHGRyZWYAAAAAAAAAAQAAAAx1cmwgAAAAAQAAAA5zdGJsAAAAp3N0c2QAAAAAAAAAAQAAAJ9hdmMxAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAEAAQABAAAAAAAZYXZjQwH0AAr/4QAZZ/QACq609jIBAAAAAwAEAAAGgu88gAAAAxBiaXRyAAAAAAAAAAAAEEdhZmcAAAAAAAAAAAACAAAABl11aWQAAAAAAAAAAAAAAAB1c210AAAAAAAAAAEAAAQAZtQAAAA4c3R0cwAAAAAAAAABAAAAAQAAABAAAAA0c3RzYwAAAAAAAAABAAAAAQAAAAEAAAABAAAAFHN0c3oAAAAAAAAAEwAAAAEAAAAUc3RjbwAAAAAAAAABAAAALAAAAGB1ZHRhAAAAWG1ldGEAAAAAAAAAIWhkbHIAAAAAAAAAAG1kaXJhcHBsAAAAAAAAAAAAAAAAK2lsc3QAAAAjqXRvbwAAABsAAABkYXRhAAAAAQAAAABMYXZmNTguMjkuMTAw" type="video/mp4"></video>

    <div id="initOverlay" onclick="systemStart()">
        <input type="text" id="aliasIn" placeholder="IDENTITY" onclick="event.stopPropagation()">
        <div class="init-circle">INITIALIZE<br>HARDENED_V139</div>
    </div>

    <div class="hud">
        <div style="color:var(--gold);">HARDENED_V139</div>
        <div class="ticker-box">
            FTC: 12,370,000 | [span_0](start_span)FNR: 4,412,100[span_0](end_span)<br>
            LOCAL_HS: <span id="hs">0</span> H/s | [span_1](start_span)SYNC: 13.37%[span_1](end_span)<br>
            TUNE: <span id="currentA">432</span>Hz | [span_2](start_span)<span id="timer">45:00</span>[span_2](end_span)
        </div>
    </div>

    <div class="ui-layer" id="mainUI" style="display:none;">
        <div id="tuneBtn" class="btn btn-tuning">TUNING: 432Hz</div>
        <div id="aB" class="btn btn-alpha active" onclick="setMode('alpha')">ALPHA_FOCUS</div>
        <div id="dB" class="btn btn-delta" onclick="setMode('delta')">DELTA_SLEEP</div>
    </div>

    <script>
        let isRunning = false, mode = 'alpha', alias = "grayson";
        let ac, gain, script, oscL, oscR, ftc=0, lastT=Date.now();
        const ENNEAD = [174, 285, 396, 417, 528, 639, 741, 852, 963];

        async function systemStart() {
            if(isRunning) return;
            alias = document.getElementById('aliasIn').value || "grayson";
            document.getElementById('initOverlay').style.display = 'none';
            document.getElementById('mainUI').style.display = 'flex';
            document.getElementById('mainUI').style.pointerEvents = 'auto';
            
            // Wake Lock & Video Anchor
            try { await document.getElementById('keepAlive').play(); } catch(e){}
            if('wakeLock' in navigator) { try { await navigator.wakeLock.request('screen'); } catch(e){} }
            
            initAudio();
            isRunning = true;
        }

        function initAudio() {
            const AC = window.AudioContext || window.webkitAudioContext;
            ac = new AC();
            gain = ac.createGain();
            gain.gain.value = 0.01;
            gain.connect(ac.destination);

            script = ac.createScriptProcessor(4096, 1, 1);
            script.onaudioprocess = (e) => {
                const out = e.outputBuffer.getChannelData(0);
                for(let i=0; i<4096; i++) {
                    const w = Math.random()*2-1;
                    out[i] = w * 0.05;
                    if(i%8===0 && (Math.abs(w)*432)%1 > 0.5) ftc++;
                }
                const now = Date.now();
                if(now - lastT > 1000) {
                    document.getElementById('hs').innerText = (ftc/10).toFixed(1);
                    ftc=0; lastT=now;
                }
            };
            script.connect(gain);
            
            oscL = ac.createOscillator(); oscR = ac.createOscillator();
            const m = ac.createChannelMerger(2);
            oscL.connect(m, 0, 0); oscR.connect(m, 0, 1);
            m.connect(gain);
            oscL.start(); oscR.start();
            updateFreqs();
        }

        function updateFreqs() {
            if(!ac) return;
            const now = ac.currentTime;
            let base = mode === 'alpha' ? 432 : 174;
            let off = mode === 'alpha' ? 11.11 : 3.14159;
            oscL.frequency.setTargetAtTime(base, now, 0.5);
            oscR.frequency.setTargetAtTime(base + off, now, 0.5);
            document.getElementById('currentA').innerText = base;
            document.getElementById('tuneBtn').innerText = `TUNING: ${base}Hz`;
        }

        function setMode(m) {
            mode = m;
            document.getElementById('aB').classList.toggle('active', m === 'alpha');
            document.getElementById('dB').classList.toggle('active', m === 'delta');
            updateFreqs();
        }

        // Tangle Viz
        const cvs = document.getElementById('tangleViz'), ctx = cvs.getContext('2d');
        let w, h, nodes = [], mouse = {x:-999, y:-999};
        function resize() { w = window.innerWidth; h = window.innerHeight; cvs.width = w; cvs.height = h; }
        window.onresize = resize; resize();
        window.addEventListener('mousemove', e => { mouse.x=e.clientX; mouse.y=e.clientY; });
        window.addEventListener('touchmove', e => { mouse.x=e.touches[0].clientX; mouse.y=e.touches[0].clientY; });
        for(let i=0; i<80; i++) nodes.push({ x: Math.random()*w, y: Math.random()*h, vx: (Math.random()-0.5), vy: (Math.random()-0.5) });
        
        function animate() {
            ctx.fillStyle = 'rgba(0,0,0,0.2)'; ctx.fillRect(0,0,w,h);
            const color = mode === 'alpha' ? '#ff69b4' : '#4b0082';
            nodes.forEach((n, i) => {
                let dx = mouse.x - n.x, dy = mouse.y - n.y, d = Math.sqrt(dx*dx+dy*dy);
                if(d < 200) { n.vx += dx*0.001 * (mode==='alpha'?1:-2); n.vy += dy*0.001 * (mode==='alpha'?1:-2); }
                n.x += n.vx; n.y += n.vy; n.vx *= 0.98; n.vy *= 0.98;
                if(n.x<0)n.x=w; if(n.x>w)n.x=0; if(n.y<0)n.y=h; if(n.y>h)n.y=0;
                ctx.fillStyle = color; ctx.beginPath(); ctx.arc(n.x, n.y, 2, 0, Math.PI*2); ctx.fill();
                nodes.forEach((n2, j) => {
                    if(i<=j) return;
                    let d2 = Math.sqrt((n.x-n2.x)**2+(n.y-n2.y)**2);
                    if(d2 < 100) { ctx.strokeStyle = color; ctx.globalAlpha = 1 - d2/100; ctx.beginPath(); ctx.moveTo(n.x, n.y); ctx.lineTo(n2.x, n2.y); ctx.stroke(); ctx.globalAlpha = 1; }
                });
            });
            requestAnimationFrame(animate);
        }
        animate();
    </script>
</body>
</html>
INNER

surge miracle-node miracle-node.surge.sh
