#!/bin/bash
echo "🚀 DEPLOYING MIRACLE_NODE_V9 [AUDIO_HARDENED]..."

mkdir -p miracle-node

cat << 'INNER' > miracle-node/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no">
    <title>MIRACLE // A16_HARDENED</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#000;--blue:#00e0ff;--gold:#ffd700;--pink:#ff69b4;--violet:#4b0082;--green:#00ff9d;--red:#ff003c;}
        body, html{margin:0;padding:0;width:100%;height:100%;background:var(--bg);color:#eee;font-family:"Share Tech Mono",monospace;overflow:hidden;touch-action:none;cursor:crosshair;}
        
        canvas{position:absolute;top:0;left:0;width:100%;height:100%;z-index:1;}
        
        /* INFINITY ANCHOR (1x1 Video) */
        #keepAliveVideo{position:absolute;opacity:0.01;width:1px;height:1px;z-index:0;pointer-events:none;}
        
        /* UI LAYERS */
        .ui-layer{position:absolute;z-index:10;width:100%;height:100%;pointer-events:none;display:flex;flex-direction:column;justify-content:center;align-items:center;}
        
        .claim-modal{
            background:rgba(0,0,0,0.95);
            border:1px solid var(--blue);
            padding:30px;
            border-radius:15px;
            text-align:center;
            box-shadow:0 0 50px rgba(0,224,255,0.15);
            pointer-events:auto;
        }
        input{background:none;border:none;border-bottom:2px solid var(--gold);color:#fff;font-family:inherit;font-size:20px;width:180px;text-align:center;outline:none;margin:20px 0;}
        .btn-claim{
            padding:15px 40px;
            background:var(--blue);
            color:#000;
            font-weight:bold;
            border:none;
            border-radius:50px;
            cursor:pointer;
            font-family:inherit;
            letter-spacing:1px;
        }
        
        /* HUD & CONTROLS */
        .hud{opacity:0;transition:0.5s;position:absolute;top:10px;right:10px;text-align:right;z-index:12;width:300px;pointer-events:none;}
        .miner-id{color:var(--gold);font-size:14px;border-bottom:1px solid #333;padding-bottom:5px;margin-bottom:5px;}
        .stat-row{display:flex;justify-content:space-between;margin-bottom:2px;font-size:10px;background:rgba(0,0,0,0.6);padding:3px;border-radius:3px;}
        
        .controls{position:absolute;bottom:30px;width:100%;text-align:center;z-index:12;opacity:0;pointer-events:none;transition:0.5s;display:flex;justify-content:center;gap:10px;}
        .ctrl-btn{pointer-events:auto;background:rgba(0,0,0,0.8);border:1px solid #333;color:#888;padding:12px 24px;border-radius:30px;cursor:pointer;font-family:inherit;font-size:11px;min-width:100px;}
        .ctrl-btn.active{border-color:var(--pink);color:var(--pink);box-shadow:0 0 15px var(--pink);}
        .ctrl-btn.audio-on{border-color:var(--green);color:var(--green);box-shadow:0 0 15px var(--green);}
        
        .fs-toggle{position:absolute;top:10px;left:10px;z-index:99;opacity:0;background:rgba(0,0,0,0.5);border:1px solid #333;color:#555;padding:8px;font-size:10px;cursor:pointer;pointer-events:auto;}

        .console{margin-top:10px;font-size:9px;color:#555;height:50px;overflow:hidden;border-top:1px solid #222;padding-top:5px;text-align:right;font-family:monospace;}
    </style>
</head>
<body>
    <canvas id="viz"></canvas>
    <video id="keepAliveVideo" playsinline loop muted><source src="data:video/mp4;base64,AAAAHGZ0eXBpc29tAAACAGlzb21pc28yYXZjMQAAAAhmcmVlAAAGF21kYXQAAAYzZ2JsbQAAAAAAAAAAAB5gbWZmYwAAAAAAAAGaAAAAAQAAAAAAAAAAAAAAA2dtZGlhAAAAIG1kaGQAAAAA1cNIQdXDSEEAyu4AAKruAAAAAAAAAAAAAAAtaGRscgAAAAAAAAAAdmlkZQAAAAAAAAAAAAAAAAAAAAB2aWRlb2hhbmRsZXIAAAACZ21pbmYAAAAUdm1oZAAAAAEAAAAAAAAAAAAAACRkaW5mAAAAHGRyZWYAAAAAAAAAAQAAAAx1cmwgAAAAAQAAAA5zdGJsAAAAp3N0c2QAAAAAAAAAAQAAAJ9hdmMxAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAEAAQABAAAAAAAZYXZjQwH0AAr/4QAZZ/QACq609jIBAAAAAwAEAAAGgu88gAAAAxBiaXRyAAAAAAAAAAAAEEdhZmcAAAAAAAAAAAACAAAABl11aWQAAAAAAAAAAAAAAAB1c210AAAAAAAAAAEAAAQAZtQAAAA4c3R0cwAAAAAAAAABAAAAAQAAABAAAAA0c3RzYwAAAAAAAAABAAAAAQAAAAEAAAABAAAAFHN0c3oAAAAAAAAAEwAAAAEAAAAUc3RjbwAAAAAAAAABAAAALAAAAGB1ZHRhAAAAWG1ldGEAAAAAAAAAIWhkbHIAAAAAAAAAAG1kaXJhcHBsAAAAAAAAAAAAAAAAK2lsc3QAAAAjqXRvbwAAABsAAABkYXRhAAAAAQAAAABMYXZmNTguMjkuMTAw" type="video/mp4"></video>

    <div id="fsBtn" class="fs-toggle" onclick="toggleFS()">[MAXIMIZE]</div>

    <div id="claim-ui" class="ui-layer">
        <div class="claim-modal">
            <div style="font-size:12px;color:#888;">FROSTCHAIN // A16_NODE</div>
            <div style="font-size:24px;color:var(--blue);margin:10px 0;">IDENTITY LOCK</div>
            <input type="text" id="aliasInput" placeholder="ENTER_NAME" autofocus>
            <br>
            <button class="btn-claim" onclick="initNode()">ENGAGE SYSTEM</button>
        </div>
    </div>

    <div id="hud" class="hud">
        <div id="dispAlias" class="miner-id">...</div>
        <div class="stat-row" style="border-left:2px solid var(--blue);"><span>FTC</span><span id="ftc_val">0.0 H/s</span></div>
        <div class="stat-row" style="border-left:2px solid var(--green);"><span>FNR</span><span id="fnr_val">0.0 H/s</span></div>
        <div class="stat-row" style="border-left:2px solid var(--red);"><span>FRST</span><span id="frst_val">0</span></div>
        <div style="margin-top:5px;font-size:9px;color:#666;">
            WAKE_LOCK: <span id="lockStat">OFF</span> | VID: <span id="vidStat">OFF</span>
        </div>
        <div id="console" class="console">> READY</div>
    </div>

    <div id="controls" class="controls">
        <button class="ctrl-btn active" id="btnAlpha" onclick="setMode('alpha')">ALPHA</button>
        <button class="ctrl-btn" id="btnDelta" onclick="setMode('delta')">DELTA</button>
        <button class="ctrl-btn" id="btnAudio" onclick="toggleAudio()">[ ENABLE AUDIO ]</button>
    </div>

    <script>
        // --- 1. VISUALS (INTERACTIVE TANGLE) ---
        const cvs=document.getElementById('viz'), ctx=cvs.getContext('2d');
        let w, h, mouse={x:-999,y:-999}, nodes=[], mode='alpha';
        function resize(){w=window.innerWidth;h=window.innerHeight;cvs.width=w;cvs.height=h;}
        window.onresize=resize; resize();
        window.onmousemove=e=>{mouse.x=e.clientX;mouse.y=e.clientY};
        window.ontouchmove=e=>{mouse.x=e.touches[0].clientX;mouse.y=e.touches[0].clientY};
        
        for(let i=0;i<80;i++)nodes.push({x:Math.random()*w,y:Math.random()*h,vx:0,vy:0,s:Math.random()*1.5+0.5});
        
        function draw(){
            ctx.fillStyle='rgba(0,0,0,0.2)';ctx.fillRect(0,0,w,h);
            const c=mode==='alpha'?'0,224,255':'75,0,130';
            nodes.forEach((n,i)=>{
                let dx=mouse.x-n.x, dy=mouse.y-n.y, d=Math.sqrt(dx*dx+dy*dy);
                if(d<200){
                    const f=(200-d)/200, p=mode==='alpha'?0.05:-0.03;
                    n.vx+=dx*f*p; n.vy+=dy*f*p;
                }
                n.x+=n.vx; n.y+=n.vy; n.vx*=0.95; n.vy*=0.95;
                if(n.x<0)n.x=w;if(n.x>w)n.x=0;if(n.y<0)n.y=h;if(n.y>h)n.y=0;
                ctx.fillStyle=`rgb(${c})`;ctx.beginPath();ctx.arc(n.x,n.y,n.s,0,Math.PI*2);ctx.fill();
                nodes.forEach((n2,j)=>{
                    if(i>j)return;
                    let d2=Math.sqrt((n.x-n2.x)**2+(n.y-n2.y)**2);
                    if(d2<100){ctx.strokeStyle=`rgba(${c},${1-d2/100})`;ctx.beginPath();ctx.moveTo(n.x,n.y);ctx.lineTo(n2.x,n2.y);ctx.stroke();}
                });
            });
            requestAnimationFrame(draw);
        }
        draw();

        // --- 2. CORE LOGIC ---
        let wakeLock = null;
        let ftc=0, fnr=0, frst=0, lastT=Date.now();

        async function initNode(){
            const alias = document.getElementById('aliasInput').value;
            if(!alias) return;

            // UI TRANSITION
            document.getElementById('claim-ui').style.display='none';
            document.getElementById('hud').style.opacity='1';
            document.getElementById('controls').style.opacity='1';
            document.getElementById('fsBtn').style.opacity='1';
            
            document.getElementById('dispAlias').innerHTML = `${alias}.frostchain<br><span style='color:#555;font-size:10px'>ACTIVE_NODE</span>`;
            
            log("> SYSTEM_INIT_COMPLETE");

            // VIDEO WAKE LOCK (Automatic)
            const vid = document.getElementById('keepAliveVideo');
            try {
                await vid.play();
                document.getElementById('vidStat').innerText="ON";
                document.getElementById('vidStat').style.color="var(--green)";
            } catch(e){ log("VID_FAIL: "+e.message); }

            // SYSTEM WAKE LOCK
            if('wakeLock' in navigator){
                try{
                    wakeLock = await navigator.wakeLock.request('screen');
                    document.getElementById('lockStat').innerText="ON";
                    document.getElementById('lockStat').style.color="var(--green)";
                    document.addEventListener('visibilitychange', async()=>{
                        if(wakeLock!==null && document.visibilityState==='visible') wakeLock = await navigator.wakeLock.request('screen');
                    });
                }catch(e){log("LOCK_FAIL: "+e.message);}
            }

            // NOTE: AUDIO IS NOT STARTED HERE. USER MUST TOGGLE IT.
        }

        // --- 3. AUDIO ENGINE (STRICT TOGGLE) ---
        let ac, gain, script, oscL, oscR;
        let isAudioInit = false;

        function toggleAudio(){
            const btn = document.getElementById('btnAudio');
            
            if(!isAudioInit){
                // FIRST CLICK: CREATE CONTEXT
                try {
                    const AC = window.AudioContext || window.webkitAudioContext;
                    ac = new AC();
                    
                    // Master Gain
                    gain = ac.createGain();
                    gain.gain.value = 0.05; // 5% Vol
                    gain.connect(ac.destination);

                    // Pink Noise Processor
                    const sz = 4096;
                    script = ac.createScriptProcessor(sz, 1, 1);
                    script.onaudioprocess = processAudio;
                    
                    const pg = ac.createGain(); pg.gain.value=0.5;
                    script.connect(pg); pg.connect(gain);

                    // Binaural
                    oscL = ac.createOscillator(); oscR = ac.createOscillator();
                    const m = ac.createChannelMerger(2);
                    oscL.connect(m,0,0); oscR.connect(m,0,1);
                    m.connect(gain);
                    oscL.start(); oscR.start();
                    updateFreqs();

                    isAudioInit = true;
                    btn.innerText = "[ MUTE AUDIO ]";
                    btn.classList.add('audio-on');
                    log("> AUDIO_ENGINE_STARTED");
                } catch(e){ log("AUD_ERR: "+e); }
            } else {
                // SUBSEQUENT CLICKS: TOGGLE MUTE / SUSPEND
                if(ac.state === 'suspended'){
                    ac.resume();
                    gain.gain.setTargetAtTime(0.05, ac.currentTime, 0.1);
                    btn.innerText = "[ MUTE AUDIO ]";
                    btn.classList.add('audio-on');
                    log("> AUDIO_RESUMED");
                } else if(gain.gain.value > 0){
                    gain.gain.setTargetAtTime(0, ac.currentTime, 0.1);
                    btn.innerText = "[ UNMUTE ]";
                    btn.classList.remove('audio-on');
                    log("> AUDIO_MUTED");
                } else {
                    gain.gain.setTargetAtTime(0.05, ac.currentTime, 0.1);
                    btn.innerText = "[ MUTE AUDIO ]";
                    btn.classList.add('audio-on');
                    log("> AUDIO_UNMUTED");
                }
            }
        }

        function processAudio(e){
            const out = e.outputBuffer.getChannelData(0);
            for(let i=0; i<out.length; i++){
                const w = Math.random()*2-1;
                out[i] = w * 0.1; 
            }
            // MINING LOGIC (Runs on Audio Loop)
            for(let i=0; i<out.length; i+=8){
                const s = Math.abs(out[i]*1000);
                if((s*432)%1 > 0.1) ftc++;
                if((s*528)%1 > 0.5) fnr++;
                if(Math.random()>0.999) frst++;
            }
            const now = Date.now();
            if(now - lastT > 1000){
                document.getElementById('ftc_val').innerText=(ftc/1000).toFixed(2)+" KH/s";
                document.getElementById('fnr_val').innerText=(fnr/1000).toFixed(2)+" KH/s";
                document.getElementById('frst_val').innerText=frst;
                ftc=0; fnr=0; lastT=now;
            }
        }

        function updateFreqs(){
            if(!ac) return;
            const now = ac.currentTime;
            let base = mode==='alpha'?528:174;
            let off = mode==='alpha'?11.11:3.14159;
            oscL.frequency.setTargetAtTime(base, now, 0.5);
            oscR.frequency.setTargetAtTime(base+off, now, 0.5);
        }
        
        function setMode(m){
            mode=m; updateFreqs();
            document.getElementById('btnAlpha').classList.toggle('active', m==='alpha');
            document.getElementById('btnDelta').classList.toggle('active', m==='delta');
            log("> MODE: "+m.toUpperCase());
        }

        function toggleFS(){
            if(!document.fullscreenElement){
                document.documentElement.requestFullscreen();
                document.getElementById('fsBtn').innerText="[ EXIT ]";
            } else {
                document.exitFullscreen();
                document.getElementById('fsBtn').innerText="[ MAXIMIZE ]";
            }
        }

        function log(m){
            const c = document.getElementById('console');
            c.innerHTML = m + "<br>" + c.innerHTML;
        }

    </script>
</body>
</html>
INNER

surge miracle-node miracle-node.surge.sh
