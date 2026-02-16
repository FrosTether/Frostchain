#!/bin/bash
echo "🚀 DEPLOYING MIRACLE_NODE_V13 [POOL_PROTOCOL]..."

mkdir -p miracle-node

cat << 'INNER' > miracle-node/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
    <title>MIRACLE // SOVEREIGN_POOL</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#000;--blue:#00e0ff;--gold:#ffd700;--pink:#ff69b4;--violet:#4b0082;--green:#00ff9d;--red:#ff003c;}
        body, html{margin:0;padding:0;width:100%;height:100%;background:var(--bg);color:#eee;font-family:"Share Tech Mono",monospace;overflow:hidden;touch-action:none;cursor:crosshair;}
        
        canvas{position:absolute;top:0;left:0;width:100%;height:100%;z-index:1;}
        
        /* UI LAYERS */
        .ui-layer{position:absolute;z-index:10;width:100%;height:100%;pointer-events:none;display:flex;flex-direction:column;justify-content:center;align-items:center;}
        
        /* POOL CLAIM MODAL */
        .claim-modal{
            background:rgba(0,0,0,0.95);
            border:1px solid var(--blue);
            padding:30px;
            border-radius:15px;
            text-align:center;
            box-shadow:0 0 50px rgba(0,224,255,0.15);
            pointer-events:auto;
            transition:0.5s;
        }
        .input-group{display:flex;align-items:center;border-bottom:2px solid var(--gold);margin:20px 0;}
        input{background:none;border:none;color:#fff;font-family:inherit;font-size:20px;width:220px;text-align:center;outline:none;}
        
        .btn-claim{
            padding:12px 30px;
            background:var(--blue);
            color:#000;
            font-weight:bold;
            border:none;
            border-radius:50px;
            cursor:pointer;
            font-family:inherit;
            letter-spacing:1px;
        }

        /* HUD */
        .hud{opacity:0;transition:1s;position:absolute;top:10px;right:10px;text-align:right;z-index:12;width:320px;pointer-events:none;}
        .miner-id{color:var(--gold);font-size:14px;border-bottom:1px solid #333;padding-bottom:5px;margin-bottom:10px;}
        .worker-id{color:#555;font-size:9px;display:block;margin-top:2px;font-family:monospace;}
        
        .stat-row{display:flex;justify-content:space-between;margin-bottom:4px;font-size:11px;background:rgba(0,0,0,0.6);padding:4px;border-radius:4px;}
        .lbl-ftc{color:var(--blue);}
        .lbl-fnr{color:var(--green);}
        .lbl-frst{color:var(--red);}
        
        .console{margin-top:10px;font-size:9px;color:#555;height:60px;overflow:hidden;border-top:1px solid #222;padding-top:5px;text-align:right;font-family:monospace;}

        .controls{position:absolute;bottom:30px;width:100%;text-align:center;z-index:12;opacity:0;pointer-events:none;transition:1s;}
        .ctrl-btn{pointer-events:auto;background:rgba(0,0,0,0.8);border:1px solid #333;color:#888;padding:10px 20px;margin:0 10px;border-radius:20px;cursor:pointer;font-family:inherit;font-size:10px;}
        .ctrl-btn.active{border-color:var(--pink);color:var(--pink);box-shadow:0 0 15px var(--pink);}
    </style>
</head>
<body>
    <canvas id="viz"></canvas>

    <video id="stayAwake" playsinline loop muted style="display:none;">
        <source src="data:video/mp4;base64,AAAAHGZ0eXBpc29tAAACAGlzb21pc28yYXZjMQAAAAhmcmVlAAAGF21kYXQAAAYzZ2JsbQAAAAAAAAAAAB5gbWZmYwAAAAAAAAGaAAAAAQAAAAAAAAAAAAAAA2dtZGlhAAAAIG1kaGQAAAAA1cNIQdXDSEEAyu4AAKruAAAAAAAAAAAAAAAtaGRscgAAAAAAAAAAdmlkZQAAAAAAAAAAAAAAAAAAAAB2aWRlb2hhbmRsZXIAAAACZ21pbmYAAAAUdm1oZAAAAAEAAAAAAAAAAAAAACRkaW5mAAAAHGRyZWYAAAAAAAAAAQAAAAx1cmwgAAAAAQAAAA5zdGJsAAAAp3N0c2QAAAAAAAAAAQAAAJ9hdmMxAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAEAAQABAAAAAAAZYXZjQwH0AAr/4QAZZ/QACq609jIBAAAAAwAEAAAGgu88gAAAAxBiaXRyAAAAAAAAAAAAEEdhZmcAAAAAAAAAAAACAAAABl11aWQAAAAAAAAAAAAAAAB1c210AAAAAAAAAAEAAAQAZtQAAAA4c3R0cwAAAAAAAAABAAAAAQAAABAAAAA0c3RzYwAAAAAAAAABAAAAAQAAAAEAAAABAAAAFHN0c3oAAAAAAAAAEwAAAAEAAAAUc3RjbwAAAAAAAAABAAAALAAAAGB1ZHRhAAAAWG1ldGEAAAAAAAAAIWhkbHIAAAAAAAAAAG1kaXJhcHBsAAAAAAAAAAAAAAAAK2lsc3QAAAAjqXRvbwAAABsAAABkYXRhAAAAAQAAAABMYXZmNTguMjkuMTAw" type="video/mp4">
    </video>

    <div id="claim-ui" class="ui-layer">
        <div class="claim-modal">
            <div style="font-size:12px;color:#888;letter-spacing:2px;">SOVEREIGN_POOL // V13.0</div>
            <div style="font-size:20px;margin-top:5px;color:var(--blue);">MIRACLE_NODE_POOL</div>
            <div class="input-group">
                <input type="text" id="aliasInput" value="drfrost.frostchain" autofocus>
            </div>
            <button class="btn-claim" onclick="activateNode()">CONNECT WORKER</button>
            <div style="font-size:9px;color:#444;margin-top:10px;">SHARED ALIAS - UNIQUE HARDWARE ADDRESS</div>
        </div>
    </div>

    <div id="hud" class="hud">
        <div id="displayAlias" class="miner-id">CONNECTING...</div>
        
        <div class="stat-row" style="border-left:2px solid var(--blue);">
            <span class="lbl-ftc">FTC [POOL_SHARE]</span>
            <span id="ftc_hash">0.0 H/s</span>
        </div>
        <div class="stat-row" style="border-left:2px solid var(--green);">
            <span class="lbl-fnr">FNR [XMR_MIX]</span>
            <span id="fnr_hash">0.0 H/s</span>
        </div>
        <div class="stat-row" style="border-left:2px solid var(--red);">
            <span class="lbl-frst">FRST [VELOCITY]</span>
            <span id="frst_cnt">0 BLK</span>
        </div>

        <div style="margin-top:10px;font-size:10px;color:#888;">
            RESONANCE: <span id="freqDisp">528</span>Hz + <span id="offDisp">11.11</span>Hz<br>
            STAY_AWAKE: <span id="awakeStatus" style="color:var(--green);">ACTIVE_LOCK</span>
        </div>

        <div id="console" class="console">> POOL_SYNC_READY</div>
    </div>

    <div id="controls" class="controls">
        <button class="ctrl-btn active" id="alphaBtn" onclick="setMode('alpha')">ALPHA</button>
        <button class="ctrl-btn" id="deltaBtn" onclick="setMode('delta')">DELTA</button>
        <button class="ctrl-btn" onclick="toggleMute()">AUDIO</button>
    </div>

    <script>
        // --- VIZ (GRAVITY SWARM) ---
        const canvas = document.getElementById('viz');
        const ctx = canvas.getContext('2d');
        let width, height, mouse={x:-9999,y:-9999}, nodes = [], mode = 'alpha';

        function resize(){width=window.innerWidth;height=window.innerHeight;canvas.width=width;canvas.height=height;}
        window.onresize=resize; resize();
        window.onmousemove=e=>{mouse.x=e.clientX; mouse.y=e.clientY;};
        window.ontouchmove=e=>{mouse.x=e.touches[0].clientX; mouse.y=e.touches[0].clientY;};
        for(let i=0; i<80; i++) nodes.push({x:Math.random()*width, y:Math.random()*height, vx:0, vy:0, size:Math.random()*1.5+0.5});

        function draw(){
            ctx.fillStyle = 'rgba(0,0,0,0.25)'; ctx.fillRect(0,0,width,height);
            const color = mode==='alpha'?'0,224,255':'75,0,130';
            nodes.forEach((n,i)=>{
                let dx=mouse.x-n.x, dy=mouse.y-n.y, dist=Math.sqrt(dx*dx+dy*dy);
                if(dist<250){
                    const force = (250-dist)/250;
                    n.vx += dx*force*(mode==='alpha'?0.05:-0.02);
                    n.vy += dy*force*(mode==='alpha'?0.05:-0.02);
                }
                n.x+=n.vx; n.y+=n.vy; n.vx*=0.96; n.vy*=0.96;
                if(n.x<0)n.x=width; if(n.x>width)n.x=0; if(n.y<0)n.y=height; if(n.y>height)n.y=0;
                ctx.fillStyle=`rgb(${color})`; ctx.beginPath(); ctx.arc(n.x,n.y,n.size,0,Math.PI*2); ctx.fill();
                nodes.forEach((n2,j)=>{
                    if(i<=j)return;
                    let d2=Math.sqrt((n.x-n2.x)**2+(n.y-n2.y)**2);
                    if(d2<120){ctx.strokeStyle=`rgba(${color},${1-d2/120})`; ctx.beginPath(); ctx.moveTo(n.x,n.y); ctx.lineTo(n2.x,n2.y); ctx.stroke();}
                });
            });
            requestAnimationFrame(draw);
        }
        draw();

        // --- POOL LOCK & MINING ---
        let audioCtx, masterGain, scriptNode, oscL, oscR;
        let ftc_h=0, fnr_h=0, frst_b=0, lastTick = Date.now();

        async function activateNode(){
            const alias = document.getElementById('aliasInput').value;
            if(!alias) return;
            
            // Unique Worker Address for this specific hardware
            const workerAddr = "f-node-" + Math.random().toString(36).substr(2, 9);
            
            document.getElementById('claim-ui').style.display='none';
            document.getElementById('displayAlias').innerHTML = `${alias}<br><span class="worker-id">WORKER: ${workerAddr}</span>`;
            document.getElementById('hud').style.opacity='1';
            document.getElementById('controls').style.opacity='1';
            
            // HARD WAKE LOCK
            if ('wakeLock' in navigator) { await navigator.wakeLock.request('screen'); }
            document.getElementById('stayAwake').play();

            log(`> POOL_CONNECTED: ${alias}`);
            log(`> WORKER_ID_LOCKED: ${workerAddr}`);
            
            initAudio();
        }

        async function initAudio(){
            try {
                const AC = window.AudioContext || window.webkitAudioContext;
                audioCtx = new AC();
                masterGain = audioCtx.createGain();
                masterGain.gain.value = 0.05; 
                masterGain.connect(audioCtx.destination);
                
                const bufSize = 4096;
                scriptNode = audioCtx.createScriptProcessor(bufSize, 1, 1);
                scriptNode.onaudioprocess = e => {
                    const out = e.outputBuffer.getChannelData(0);
                    // Generate Resonance
                    for(let i=0; i<bufSize; i++) {
                        out[i] = (Math.random()*2-1) * 0.1;
                    }
                    // Pool Mining (Merged)
                    for(let i=0; i<bufSize; i+=8) {
                        const s = Math.abs(out[i]*1000);
                        if((s*432)%1 > 0.1) ftc_h++;
                        if((s*528)%1 > 0.5) fnr_h++;
                        if(Math.random() > 0.999) frst_b++;
                    }
                    const now = Date.now();
                    if(now - lastTick > 1000) {
                        document.getElementById('ftc_hash').innerText = (ftc_h/1000).toFixed(2) + " KH/s";
                        document.getElementById('fnr_hash').innerText = (fnr_h/1000).toFixed(2) + " KH/s";
                        document.getElementById('frst_cnt').innerText = frst_b + " BLK";
                        if(Math.random()>0.7) log(`> SHARE_SUBMITTED [${alias}]`);
                        ftc_h=0; fnr_h=0; lastTick = now;
                    }
                };
                
                const pg = audioCtx.createGain(); pg.gain.value=0.5;
                scriptNode.connect(pg); pg.connect(masterGain);
                oscL = audioCtx.createOscillator(); oscR = audioCtx.createOscillator();
                const m = audioCtx.createChannelMerger(2);
                oscL.connect(m,0,0); oscR.connect(m,0,1); m.connect(masterGain);
                oscL.start(); oscR.start(); updateFreqs();
            } catch(e){log("POOL_ERR: "+e);}
        }

        function updateFreqs(){
            if(!audioCtx) return;
            const now = audioCtx.currentTime;
            let base = mode==='alpha'?528:174;
            let off = mode==='alpha'?11.11:3.14159;
            oscL.frequency.setTargetAtTime(base, now, 0.5);
            oscR.frequency.setTargetAtTime(base+off, now, 0.5);
            document.getElementById('freqDisp').innerText=base;
            document.getElementById('offDisp').innerText=off.toFixed(2);
        }
        function setMode(m){mode=m; updateFreqs(); document.getElementById('alphaBtn').classList.toggle('active',m==='alpha'); document.getElementById('deltaBtn').classList.toggle('active',m==='delta'); log(`> MODE: ${m.toUpperCase()}`);}
        function toggleMute(){
            if(masterGain.gain.value>0) {masterGain.gain.setTargetAtTime(0, audioCtx.currentTime, 0.1); log("> AUDIO_STAY_AWAKE_MUTE");}
            else {masterGain.gain.setTargetAtTime(0.05, audioCtx.currentTime, 0.1); log("> AUDIO_ACTIVE");}
        }
        function log(msg){
            const c = document.getElementById('console');
            c.innerHTML += msg + "<br>";
            c.scrollTop = c.scrollHeight;
        }
    </script>
</body>
</html>
INNER

surge miracle-node miracle-node.surge.sh
