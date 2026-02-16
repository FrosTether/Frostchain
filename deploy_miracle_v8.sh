#!/bin/bash
echo "🚀 DEPLOYING MIRACLE_NODE_V8 [INFINITY_LOCK]..."

mkdir -p miracle-node

cat << 'INNER' > miracle-node/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
    <title>MIRACLE // INFINITY_LOCK</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#000;--blue:#00e0ff;--gold:#ffd700;--pink:#ff69b4;--violet:#4b0082;--green:#00ff9d;--red:#ff003c;}
        body, html{margin:0;padding:0;width:100%;height:100%;background:var(--bg);color:#eee;font-family:"Share Tech Mono",monospace;overflow:hidden;touch-action:none;cursor:crosshair;}
        
        canvas{position:absolute;top:0;left:0;width:100%;height:100%;z-index:1;}
        
        /* HIDDEN ANCHORS */
        #keepAliveVideo{position:absolute;opacity:0.01;width:1px;height:1px;z-index:0;pointer-events:none;}
        
        /* UI LAYERS */
        .ui-layer{position:absolute;z-index:10;width:100%;height:100%;pointer-events:none;display:flex;flex-direction:column;justify-content:center;align-items:center;}
        
        /* CLAIM MODAL */
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
        input{background:none;border:none;color:#fff;font-family:inherit;font-size:20px;width:180px;text-align:center;outline:none;}
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
            transition:0.3s;
        }
        .btn-claim:hover{box-shadow:0 0 30px var(--blue); transform:scale(1.05);}

        /* HUD */
        .hud{opacity:0;transition:1s;position:absolute;top:10px;right:10px;text-align:right;z-index:12;width:300px;pointer-events:none;}
        .miner-id{color:var(--gold);font-size:14px;border-bottom:1px solid #333;padding-bottom:5px;margin-bottom:10px;}
        .stat-row{display:flex;justify-content:space-between;margin-bottom:4px;font-size:11px;background:rgba(0,0,0,0.6);padding:4px;border-radius:4px;}
        
        /* FULLSCREEN TOGGLE */
        .fs-toggle{
            position:absolute;top:10px;left:10px;z-index:99;opacity:0;transition:1s;
            background:rgba(0,0,0,0.5);border:1px solid #333;color:#555;padding:8px;border-radius:5px;font-size:10px;cursor:pointer;pointer-events:auto;
        }
        .fs-toggle:hover{color:var(--blue);border-color:var(--blue);}

        .console{margin-top:10px;font-size:9px;color:#555;height:60px;overflow:hidden;border-top:1px solid #222;padding-top:5px;text-align:right;font-family:monospace;}

        /* CONTROLS */
        .controls{position:absolute;bottom:30px;width:100%;text-align:center;z-index:12;opacity:0;pointer-events:none;transition:1s;}
        .ctrl-btn{pointer-events:auto;background:rgba(0,0,0,0.8);border:1px solid #333;color:#888;padding:10px 20px;margin:0 10px;border-radius:20px;cursor:pointer;font-family:inherit;font-size:10px;}
        .ctrl-btn.active{border-color:var(--pink);color:var(--pink);box-shadow:0 0 15px var(--pink);}
    </style>
</head>
<body>
    <canvas id="viz"></canvas>
    
    <video id="keepAliveVideo" playsinline loop muted>
        <source src="data:video/mp4;base64,AAAAHGZ0eXBpc29tAAACAGlzb21pc28yYXZjMQAAAAhmcmVlAAAGF21kYXQAAAYzZ2JsbQAAAAAAAAAAAB5gbWZmYwAAAAAAAAGaAAAAAQAAAAAAAAAAAAAAA2dtZGlhAAAAIG1kaGQAAAAA1cNIQdXDSEEAyu4AAKruAAAAAAAAAAAAAAAtaGRscgAAAAAAAAAAdmlkZQAAAAAAAAAAAAAAAAAAAAB2aWRlb2hhbmRsZXIAAAACZ21pbmYAAAAUdm1oZAAAAAEAAAAAAAAAAAAAACRkaW5mAAAAHGRyZWYAAAAAAAAAAQAAAAx1cmwgAAAAAQAAAA5zdGJsAAAAp3N0c2QAAAAAAAAAAQAAAJ9hdmMxAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAEAAQABAAAAAAAZYXZjQwH0AAr/4QAZZ/QACq609jIBAAAAAwAEAAAGgu88gAAAAxBiaXRyAAAAAAAAAAAAEEdhZmcAAAAAAAAAAAACAAAABl11aWQAAAAAAAAAAAAAAAB1c210AAAAAAAAAAEAAAQAZtQAAAA4c3R0cwAAAAAAAAABAAAAAQAAABAAAAA0c3RzYwAAAAAAAAABAAAAAQAAAAEAAAABAAAAFHN0c3oAAAAAAAAAEwAAAAEAAAAUc3RjbwAAAAAAAAABAAAALAAAAGB1ZHRhAAAAWG1ldGEAAAAAAAAAIWhkbHIAAAAAAAAAAG1kaXJhcHBsAAAAAAAAAAAAAAAAK2lsc3QAAAAjqXRvbwAAABsAAABkYXRhAAAAAQAAAABMYXZmNTguMjkuMTAw" type="video/mp4">
    </video>

    <div id="fsBtn" class="fs-toggle" onclick="toggleFullScreen()">[MAXIMIZE]</div>

    <div id="claim-ui" class="ui-layer">
        <div class="claim-modal">
            <div style="font-size:12px;color:#888;">INFINITY_LOCK // V8.0</div>
            <div style="font-size:20px;margin-top:5px;color:var(--blue);">FROSTCHAIN A16 NODE</div>
            <div class="input-group">
                <input type="text" id="aliasInput" placeholder="ENTER_IDENTITY" autofocus>
            </div>
            <button class="btn-claim" onclick="activateNode()">ENGAGE LOCK & MINE</button>
        </div>
    </div>

    <div id="hud" class="hud">
        <div id="displayAlias" class="miner-id">...</div>
        <div class="stat-row" style="border-left:2px solid var(--blue);"><span>FTC [BCH]</span><span id="ftc_hash">0.0 H/s</span></div>
        <div class="stat-row" style="border-left:2px solid var(--green);"><span>FNR [XMR]</span><span id="fnr_hash">0.0 H/s</span></div>
        <div class="stat-row" style="border-left:2px solid var(--red);"><span>FRST [ACC]</span><span id="frst_cnt">0 BLK</span></div>
        
        <div style="margin-top:10px;font-size:10px;color:#888;">
            WAKE_LOCK: <span id="lockStatus" style="color:var(--red);">OFF</span><br>
            VIDEO_ANCHOR: <span id="vidStatus" style="color:var(--red);">OFF</span>
        </div>

        <div id="console" class="console">> SYSTEM_READY</div>
    </div>

    <div id="controls" class="controls">
        <button class="ctrl-btn active" id="alphaBtn" onclick="setMode('alpha')">ALPHA</button>
        <button class="ctrl-btn" id="deltaBtn" onclick="setMode('delta')">DELTA</button>
        <button class="ctrl-btn" onclick="toggleMute()">AUDIO</button>
    </div>

    <script>
        // --- VISUALS ---
        const canvas=document.getElementById('viz'), ctx=canvas.getContext('2d');
        let width,height,mouse={x:-999,y:-999}, nodes=[], mode='alpha';
        function resize(){width=window.innerWidth;height=window.innerHeight;canvas.width=width;canvas.height=height;}
        window.onresize=resize; resize();
        window.onmousemove=e=>{mouse.x=e.clientX;mouse.y=e.clientY;};
        window.ontouchmove=e=>{mouse.x=e.touches[0].clientX;mouse.y=e.touches[0].clientY;};
        for(let i=0;i<80;i++)nodes.push({x:Math.random()*width,y:Math.random()*height,vx:0,vy:0,size:Math.random()*1.5+0.5});
        function draw(){
            ctx.fillStyle='rgba(0,0,0,0.2)';ctx.fillRect(0,0,width,height);
            const color=mode==='alpha'?'0,224,255':'75,0,130';
            nodes.forEach((n,i)=>{
                let dx=mouse.x-n.x, dy=mouse.y-n.y, d=Math.sqrt(dx*dx+dy*dy);
                if(d<250){const f=(250-d)/250, p=mode==='alpha'?0.05:-0.02; n.vx+=dx*f*p; n.vy+=dy*f*p;}
                n.x+=n.vx; n.y+=n.vy; n.vx*=0.96; n.vy*=0.96;
                if(n.x<0)n.x=width;if(n.x>width)n.x=0;if(n.y<0)n.y=height;if(n.y>height)n.y=0;
                ctx.fillStyle=`rgb(${color})`;ctx.beginPath();ctx.arc(n.x,n.y,n.size,0,Math.PI*2);ctx.fill();
                nodes.forEach((n2,j)=>{if(i>j)return;let d2=Math.sqrt((n.x-n2.x)**2+(n.y-n2.y)**2);if(d2<100){ctx.strokeStyle=`rgba(${color},${1-d2/100})`;ctx.beginPath();ctx.moveTo(n.x,n.y);ctx.lineTo(n2.x,n2.y);ctx.stroke();}});
            });
            requestAnimationFrame(draw);
        }
        draw();

        // --- INFINITY LOCK ENGINE ---
        let wakeLock = null;
        async function engageInfinityLock() {
            // 1. VIDEO ANCHOR
            const vid = document.getElementById('keepAliveVideo');
            try {
                await vid.play();
                document.getElementById('vidStatus').innerText = "ACTIVE (1x1 LOOP)";
                document.getElementById('vidStatus').style.color = "var(--green)";
                log("> VIDEO_ANCHOR_ENGAGED");
            } catch (err) {
                document.getElementById('vidStatus').innerText = "FAILED";
                log("> VIDEO_ERR: " + err);
            }

            // 2. WAKE LOCK API
            if ('wakeLock' in navigator) {
                try {
                    wakeLock = await navigator.wakeLock.request('screen');
                    document.getElementById('lockStatus').innerText = "ACTIVE (SYSTEM)";
                    document.getElementById('lockStatus').style.color = "var(--green)";
                    log("> WAKE_LOCK_ACQUIRED");
                    
                    // Re-acquire if visibility changes
                    document.addEventListener('visibilitychange', async () => {
                        if (wakeLock !== null && document.visibilityState === 'visible') {
                            wakeLock = await navigator.wakeLock.request('screen');
                        }
                    });
                } catch (err) {
                    document.getElementById('lockStatus').innerText = "DENIED";
                    log("> WAKE_LOCK_ERR: " + err);
                }
            } else {
                document.getElementById('lockStatus').innerText = "UNSUPPORTED";
            }
        }

        function toggleFullScreen() {
            if (!document.fullscreenElement) {
                document.documentElement.requestFullscreen().catch(err => {
                    log(`> FS_ERR: ${err.message}`);
                });
                document.getElementById('fsBtn').innerText = "[EXIT MAX]";
            } else {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                    document.getElementById('fsBtn').innerText = "[MAXIMIZE]";
                }
            }
        }

        // --- MINING & AUDIO ---
        let audioCtx, masterGain, scriptNode, oscL, oscR;
        let ftc_h=0, fnr_h=0, frst_b=0, lastTick=Date.now();

        function activateNode(){
            const alias = document.getElementById('aliasInput').value;
            if(!alias) return;
            const bchAddr = "q" + Math.random().toString(36).substr(2, 38); 
            
            document.getElementById('claim-ui').style.display='none';
            document.getElementById('displayAlias').innerHTML = `${alias}.frostchain<br><span style='font-size:10px;color:#555;'>${bchAddr}</span>`;
            document.getElementById('hud').style.opacity='1';
            document.getElementById('controls').style.opacity='1';
            document.getElementById('fsBtn').style.opacity='1';
            
            initAudio();
            engageInfinityLock(); // <--- TRIGGERS THE LOCK
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
                    for(let i=0; i<bufSize; i++) {
                        const w = Math.random()*2-1;
                        out[i] = w * 0.1; // Simple Noise
                    }
                    // Mining Sim
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
                        ftc_h=0; fnr_h=0; lastTick=now;
                    }
                };
                const pg = audioCtx.createGain(); pg.gain.value=0.5; scriptNode.connect(pg); pg.connect(masterGain);
                
                oscL = audioCtx.createOscillator(); oscR = audioCtx.createOscillator();
                const m = audioCtx.createChannelMerger(2); oscL.connect(m,0,0); oscR.connect(m,0,1); m.connect(masterGain);
                oscL.start(); oscR.start(); updateFreqs();
            } catch(e){log("AUD: "+e);}
        }

        function updateFreqs(){
            const now = audioCtx.currentTime;
            let base = mode==='alpha'?528:174;
            let off = mode==='alpha'?11.11:3.14159;
            oscL.frequency.setTargetAtTime(base, now, 0.5);
            oscR.frequency.setTargetAtTime(base+off, now, 0.5);
        }
        function setMode(m){mode=m;updateFreqs();document.getElementById('alphaBtn').classList.toggle('active',m==='alpha');document.getElementById('deltaBtn').classList.toggle('active',m==='delta');}
        function toggleMute(){if(masterGain.gain.value>0){masterGain.gain.setTargetAtTime(0,audioCtx.currentTime,0.1);}else{masterGain.gain.setTargetAtTime(0.05,audioCtx.currentTime,0.1);}}
        function log(m){const c=document.getElementById('console');c.innerHTML+=m+"<br>";c.scrollTop=c.scrollHeight;}
    </script>
</body>
</html>
INNER

surge miracle-node miracle-node.surge.sh
