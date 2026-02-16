#!/bin/bash
echo "🚀 DEPLOYING MIRACLE_NODE_V16 [INFINITY_PROTOCOL]..."

mkdir -p miracle-node

cat << 'INNER' > miracle-node/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,user-scalable=no,maximum-scale=1.0">
    <title>MIRACLE // INFINITY_V16</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#000;--blue:#00f0ff;--gold:#ffd700;--pink:#ff00ff;--violet:#4b0082;--green:#00ff00;--red:#ff003c;}
        body, html{margin:0;padding:0;width:100%;height:100%;background:var(--bg);color:#eee;font-family:"Share Tech Mono",monospace;overflow:hidden;touch-action:none;user-select:none;}
        
        canvas{position:absolute;top:0;left:0;width:100%;height:100%;z-index:1;}
        
        /* UI LAYERS */
        .ui-layer{position:absolute;z-index:10;width:100%;height:100%;pointer-events:none;display:flex;flex-direction:column;justify-content:center;align-items:center;}
        
        /* INIT OVERLAY */
        #initOverlay{position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.98);z-index:999;display:flex;flex-direction:column;justify-content:center;align-items:center;cursor:pointer;pointer-events:auto;}
        .init-btn{width:180px;height:180px;border:2px solid var(--blue);border-radius:50%;display:flex;justify-content:center;align-items:center;color:var(--blue);font-size:12px;letter-spacing:3px;text-align:center;box-shadow:0 0 30px rgba(0,240,255,0.2);animation:pulse 2s infinite;}
        @keyframes pulse{0%{box-shadow:0 0 20px rgba(0,240,255,0.1);}50%{box-shadow:0 0 50px rgba(0,240,255,0.4);}100%{box-shadow:0 0 20px rgba(0,240,255,0.1);}}
        input{background:none;border:none;border-bottom:1px solid var(--gold);color:var(--gold);font-family:inherit;font-size:20px;width:200px;text-align:center;margin-bottom:40px;outline:none;}

        /* HUD */
        .hud{opacity:0;transition:1s;position:absolute;top:15px;right:15px;text-align:right;z-index:12;width:300px;pointer-events:none;}
        .miner-id{color:var(--gold);font-size:14px;border-bottom:1px solid #333;padding-bottom:5px;margin-bottom:10px;}
        .stat-row{display:flex;justify-content:space-between;margin-bottom:4px;font-size:11px;background:rgba(0,0,0,0.7);padding:5px;border-radius:4px;}
        
        .console{margin-top:10px;font-size:9px;color:#555;height:80px;overflow:hidden;border-top:1px solid #222;padding-top:5px;text-align:right;}

        .controls{position:absolute;bottom:30px;width:100%;text-align:center;z-index:12;opacity:0;pointer-events:none;transition:1s;}
        .ctrl-btn{pointer-events:auto;background:rgba(0,0,0,0.8);border:1px solid #333;color:#888;padding:12px 24px;margin:0 10px;border-radius:30px;cursor:pointer;font-family:inherit;font-size:10px;}
        .ctrl-btn.active{border-color:var(--pink);color:var(--pink);box-shadow:0 0 15px var(--pink);}
    </style>
</head>
<body>
    <canvas id="viz"></canvas>
    <video id="keepAliveVideo" playsinline loop muted style="display:none;"><source src="data:video/mp4;base64,AAAAHGZ0eXBpc29tAAACAGlzb21pc28yYXZjMQAAAAhmcmVlAAAGF21kYXQAAAYzZ2JsbQAAAAAAAAAAAB5gbWZmYwAAAAAAAAGaAAAAAQAAAAAAAAAAAAAAA2dtZGlhAAAAIG1kaGQAAAAA1cNIQdXDSEEAyu4AAKruAAAAAAAAAAAAAAAtaGRscgAAAAAAAAAAdmlkZQAAAAAAAAAAAAAAAAAAAAB2aWRlb2hhbmRsZXIAAAACZ21pbmYAAAAUdm1oZAAAAAEAAAAAAAAAAAAAACRkaW5mAAAAHGRyZWYAAAAAAAAAAQAAAAx1cmwgAAAAAQAAAA5zdGJsAAAAp3N0c2QAAAAAAAAAAQAAAJ9hdmMxAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAEAAQABAAAAAAAZYXZjQwH0AAr/4QAZZ/QACq609jIBAAAAAwAEAAAGgu88gAAAAxBiaXRyAAAAAAAAAAAAEEdhZmcAAAAAAAAAAAACAAAABl11aWQAAAAAAAAAAAAAAAB1c210AAAAAAAAAAEAAAQAZtQAAAA4c3R0cwAAAAAAAAABAAAAAQAAABAAAAA0c3RzYwAAAAAAAAABAAAAAQAAAAEAAAABAAAAFHN0c3oAAAAAAAAAEwAAAAEAAAAUc3RjbwAAAAAAAAABAAAALAAAAGB1ZHRhAAAAWG1ldGEAAAAAAAAAIWhkbHIAAAAAAAAAAG1kaXJhcHBsAAAAAAAAAAAAAAAAK2lsc3QAAAAjqXRvbwAAABsAAABkYXRhAAAAAQAAAABMYXZmNTguMjkuMTAw" type="video/mp4"></video>

    <div id="initOverlay" onclick="systemStart()">
        <input type="text" id="aliasIn" placeholder="IDENTITY" onclick="event.stopPropagation()">
        <div class="init-btn">INITIALIZE<br>INFINITY_V16</div>
    </div>

    <div id="hud" class="hud">
        <div id="displayAlias" class="miner-id">...</div>
        <div class="stat-row" style="border-left:2px solid var(--blue);"><span>HASHRATE</span><span id="hr_val">0.0 H/s</span></div>
        <div class="stat-row" style="border-left:2px solid var(--green);"><span>FNR_CAP</span><span>33,000,000</span></div>
        <div class="stat-row" style="border-left:2px solid var(--red);"><span>FRST_CAP</span><span>&infin; (INFINITY)</span></div>
        <div class="stat-row" style="border-left:2px solid var(--gold);"><span>BALANCE</span><span style="color:var(--red);">VIEW_KEY_REQUIRED</span></div>
        
        <div style="margin-top:10px;font-size:10px;color:#888;">
            PAYOUT_SOURCE: <span id="sourceDisp" style="color:var(--gold);">---</span><br>
            SUPPLY_REMAIN: <span id="remainDisp">86,630,000</span>
        </div>
        <div id="console" class="console">> INFINITY_PROTOCOL_ENGAGED</div>
    </div>

    <div id="controls" class="controls">
        <button class="ctrl-btn active" id="alphaBtn" onclick="setMode('alpha')">ALPHA</button>
        <button class="ctrl-btn" id="deltaBtn" onclick="setMode('delta')">DELTA</button>
        <button class="ctrl-btn" onclick="toggleMute()">AUDIO</button>
    </div>

    <script>
        const cvs=document.getElementById('viz'), ctx=cvs.getContext('2d');
        let w, h, mouse={x:-999,y:-999}, nodes=[], mode='alpha';
        function resize(){w=window.innerWidth;h=window.innerHeight;cvs.width=w;cvs.height=h;}
        window.onresize=resize; resize();
        window.onmousemove=e=>{mouse.x=e.clientX;mouse.y=e.clientY};
        window.ontouchmove=e=>{mouse.x=e.touches[0].clientX;mouse.y=e.touches[0].clientY};
        for(let i=0;i<80;i++)nodes.push({x:Math.random()*w,y:Math.random()*h,vx:0,vy:0,s:Math.random()*1.5+0.5});
        function draw(){
            ctx.fillStyle='rgba(0,0,0,0.2)';ctx.fillRect(0,0,w,h);
            const c=mode==='alpha'?'0,240,255':'75,0,130';
            nodes.forEach((n,i)=>{
                let dx=mouse.x-n.x, dy=mouse.y-n.y, d=Math.sqrt(dx*dx+dy*dy);
                if(d<250){const f=(250-d)/250, p=mode==='alpha'?0.06:-0.03; n.vx+=dx*f*p; n.vy+=dy*f*p;}
                n.x+=n.vx; n.y+=n.vy; n.vx*=0.96; n.vy*=0.96;
                if(n.x<0)n.x=w;if(n.x>w)n.x=0;if(n.y<0)n.y=h;if(n.y>h)n.y=0;
                ctx.fillStyle=`rgb(${c})`;ctx.beginPath();ctx.arc(n.x,n.y,n.s,0,Math.PI*2);ctx.fill();
                nodes.forEach((n2,j)=>{if(i>j)return;let d2=Math.sqrt((n.x-n2.x)**2+(n.y-n2.y)**2);if(d2<120){ctx.strokeStyle=`rgba(${c},${1-d2/120})`;ctx.beginPath();ctx.moveTo(n.x,n.y);ctx.lineTo(n2.x,n2.y);ctx.stroke();}});
            });
            requestAnimationFrame(draw);
        }
        draw();

        let ac, gain, script, oscL, oscR, lastT=Date.now(), hashes=0, alias="ANONYMOUS";
        const ENNEAD = [174, 285, 396, 417, 528, 639, 741, 852, 963];

        async function systemStart(){
            alias = document.getElementById('aliasIn').value || "grayson";
            document.getElementById('initOverlay').style.display='none';
            document.getElementById('hud').style.opacity='1';
            document.getElementById('controls').style.opacity='1';
            document.getElementById('displayAlias').innerText = alias + ".frostchain";
            try{ document.getElementById('keepAliveVideo').play(); }catch(e){}
            if('wakeLock' in navigator){ await navigator.wakeLock.request('screen'); }
            log(`> SYSTEM_IDENT: ${alias}`);
            log(`> FRST_STATUS: UNLIMITED_MINT`);
            initAudio();
        }

        async function initAudio(){
            const AC = window.AudioContext || window.webkitAudioContext;
            ac = new AC(); gain = ac.createGain(); gain.gain.value = 0.05; gain.connect(ac.destination);
            script = ac.createScriptProcessor(4096, 1, 1);
            script.onaudioprocess = (e) => {
                const out = e.outputBuffer.getChannelData(0);
                for(let i=0; i<out.length; i++){
                    const w = Math.random()*2-1; out[i] = w * 0.1;
                    if(i%16===0 && (Math.abs(w)*432)%1 > 0.5) hashes++;
                }
                const now = Date.now();
                if(now - lastT > 1000){
                    document.getElementById('hr_val').innerText = (hashes/10).toFixed(1) + " H/s";
                    const currentFreq = ENNEAD[Math.floor((now/150000)%9)];
                    document.getElementById('sourceDisp').innerText = currentFreq + ".frostchain";
                    if(Math.random()>0.8) log(`> ${currentFreq}.frostchain EMITTED_FRST`);
                    hashes=0; lastT=now;
                }
            };
            script.connect(gain);
            oscL=ac.createOscillator(); oscR=ac.createOscillator();
            const m=ac.createChannelMerger(2); oscL.connect(m,0,0); oscR.connect(m,0,1); m.connect(gain);
            oscL.start(); oscR.start(); updateFreqs();
        }

        function updateFreqs(){
            if(!ac) return;
            const now=ac.currentTime, base=mode==='alpha'?528:174, off=mode==='alpha'?11.11:3.14159;
            oscL.frequency.setTargetAtTime(base, now, 0.5);
            oscR.frequency.setTargetAtTime(base+off, now, 0.5);
        }
        function setMode(m){mode=m; updateFreqs(); document.getElementById('alphaBtn').classList.toggle('active',m==='alpha'); document.getElementById('deltaBtn').classList.toggle('active',m==='delta'); log(`> SYNC: ${m.toUpperCase()}`);}
        function toggleMute(){ if(gain.gain.value>0) gain.gain.setTargetAtTime(0,ac.currentTime,0.1); else gain.gain.setTargetAtTime(0.05,ac.currentTime,0.1); }
        function log(m){ const c=document.getElementById('console'); c.innerHTML=m+"<br>"+c.innerHTML; }
    </script>
</body>
</html>
INNER

surge miracle-node miracle-node.surge.sh
