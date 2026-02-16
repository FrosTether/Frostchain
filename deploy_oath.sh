#!/bin/bash
echo "🚀 DEPLOYING THE_OATH_V303..."

# --- 1. ADMIN PANEL (THE LAW) ---
mkdir -p admin-panel
cat << 'INNER' > admin-panel/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>ADMIN // THE_OATH</title>
    <style>
        body{background:#000;color:#ff003c;font-family:monospace;padding:20px;text-align:center;}
        .box{border:2px solid #ff003c;padding:20px;max-width:600px;margin:0 auto;}
        h1{border-bottom:1px solid #333;padding-bottom:10px;}
        .param{display:flex;justify-content:space-between;border-bottom:1px solid #222;padding:10px 0;color:#eee;}
        .val{color:#ffd700;font-weight:bold;}
    </style>
</head>
<body>
    <div class="box">
        <h1>THE IMMUTABLE OATH</h1>
        <p>THESE PARAMETERS ARE HARD-CODED. NO AI VARIANCE.</p>
        
        <div class="param"><span>BLOCK TIME</span><span class="val">300 SECONDS (5m)</span></div>
        <div class="param"><span>BCH RATIO</span><span class="val">1 BCH = 2 FTC BLOCKS</span></div>
        <div class="param"><span>FTC REWARD</span><span class="val">13.37 CONSTANT</span></div>
        <div class="param"><span>FNR REWARD</span><span class="val">1.50 (XMR TAIL)</span></div>
        <div class="param"><span>FRST REWARD</span><span class="val">31,415.9 (PI_DOGE)</span></div>
        
        <br><div style="color:#0f0;">STATUS: LOCKED FOREVER</div>
    </div>
</body>
</html>
INNER

# --- 2. FROSTSCAN (THE EVIDENCE) ---
mkdir -p frostscan
cat << 'INNER' > frostscan/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>FROSTSCAN // 5_MIN_HARDCODE</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#020202;--panel:#0a0a0a;--blue:#00f0ff;--green:#00ff9d;--gold:#ffd700;--text:#a0a0a0;--red:#ff003c;}
        body{background:var(--bg);color:var(--text);font-family:"Share Tech Mono",monospace;margin:0;padding:0;}
        .navbar{padding:15px;background:#111;border-bottom:1px solid #333;color:var(--gold);font-weight:bold;}
        .stats{display:grid;grid-template-columns:repeat(auto-fit, minmax(200px, 1fr));gap:10px;padding:20px;}
        .card{background:#0a0a0a;border:1px solid #333;padding:15px;border-left:3px solid var(--blue);}
        .row{display:flex;justify-content:space-between;padding:10px;border-bottom:1px solid #222;font-size:12px;}
    </style>
</head>
<body>
    <div class="navbar">FROSTSCAN [HARDCODED_V303]</div>
    
    <div class="stats">
        <div class="card">
            <div style="font-size:10px;color:#888;">BLOCK TIME</div>
            <div style="font-size:18px;color:#eee;">300s <span style="font-size:10px;color:var(--gold);">(1/2 BCH)</span></div>
        </div>
        <div class="card">
            <div style="font-size:10px;color:#888;">FTC REWARD</div>
            <div style="font-size:18px;color:var(--blue);">13.37</div>
        </div>
        <div class="card">
            <div style="font-size:10px;color:#888;">FNR REWARD</div>
            <div style="font-size:18px;color:var(--green);">1.50</div>
        </div>
        <div class="card">
            <div style="font-size:10px;color:#888;">FRST REWARD</div>
            <div style="font-size:18px;color:var(--red);">31,415.9</div>
        </div>
    </div>

    <div style="padding:20px;">
        <div style="margin-bottom:10px;color:#eee;">CHAIN HISTORY (5m INTERVALS)</div>
        <div id="chain"></div>
    </div>

    <script>
        const chain = document.getElementById('chain');
        let height = 842500;
        
        // HARD-CODED GENERATOR: 300s INTERVALS ONLY
        function render() {
            chain.innerHTML = '';
            for(let i=0; i<10; i++) {
                let div = document.createElement('div');
                div.className = 'row';
                let time = i===0 ? "PENDING" : `${i*5} mins ago`;
                div.innerHTML = `
                    <div>BLK #${height-i} <span style="color:#555;">[${time}]</span></div>
                    <div style="text-align:right;">
                        <span style="color:var(--blue);">13.37 FTC</span> | 
                        <span style="color:var(--green);">1.50 FNR</span> | 
                        <span style="color:var(--red);">31,415.9 FRST</span>
                    </div>
                `;
                chain.appendChild(div);
            }
        }
        render();
        // UPDATE ONLY VISUALLY, NO LOGIC CHANGE
        setInterval(() => { render(); }, 300000); 
    </script>
</body>
</html>
INNER

surge admin-panel admin-frostchain.surge.sh
surge frostscan frostscan.surge.sh
