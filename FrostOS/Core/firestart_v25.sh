#!/bin/bash
# FINUX INFINITY v28.5 - SOVEREIGN ARCADE DEPLOY
echo ">> 🚀 IGNITING FIRESTART v28.5..."

mkdir -p fuel_staging/games
mkdir -p fuel_staging/assets

# 1. GENERATE BURN ASSETS (ImageMagick Fix)
magick -size 200x200 canvas:black -fill "#ff4081" -draw "circle 100,100 100,20" \
       -pointsize 25 -fill white -draw "text 45,110 'BURN 10'" fuel_staging/assets/burn_token.png

# 2. BUILD THE BURN ENGINE (Gem Merge)
cat << 'EOF' > fuel_staging/games/gem.html
<!DOCTYPE html><html><head><title>💎 GEM | BURN 10:1</title>
<style>
    body { background:#000; color:#ff4081; font-family:monospace; text-align:center; margin:0; }
    .status { background:#111; padding:15px; color:#81c784; font-size:1.2em; border-bottom:2px solid #ff4081; }
    .controls { padding:20px; display:flex; justify-content:center; gap:15px; }
    button { background:#ff4081; color:#000; border:none; padding:15px 30px; border-radius:8px; font-weight:900; cursor:pointer; }
    iframe { width:100%; height:70vh; border:none; }
</style></head><body>
    <div class="status">TREASURY: <span id="val">16000</span> USD.i</div>
    <div class="controls">
        <button onclick="burn()">🔀 SHUFFLE (-10)</button>
        <button style="background:#81c784" onclick="gas()">⛽ GAS (+1)</button>
    </div>
    <iframe src="https://vishalsingh2972.github.io/JS-CandyCrushSaga/"></iframe>
    <script>
        let t = parseInt(localStorage.getItem('frost_t')) || 16000;
        document.getElementById('val').innerText = t;
        function burn() { alert("🔥 10 TOKENS BURNED. KERNEL PULSE SENT."); }
        function gas() { 
            t += 1; document.getElementById('val').innerText = t;
            localStorage.setItem('frost_t', t);
        }
    </script>
</body></html>
EOF

# 3. BUILD THE HUB (index.html)
cat << 'EOF' > fuel_staging/index.html
<!DOCTYPE html><html><head><title>FIRESTART ⛽</title>
<style>body{background:#000;color:#fff;font-family:monospace;display:grid;place-items:center;min-height:100vh;margin:0;}
.hub{text-align:center;border:2px solid #222;padding:50px;border-radius:30px;background:#080808;}
.btn{background:#111;color:#fff;border:1px solid #444;padding:20px;margin:10px;width:260px;border-radius:15px;cursor:pointer;font-weight:900;}</style></head><body>
<div class="hub"><h1>♾️ INFINITY v28.5</h1><img src="assets/burn_token.png" width="80"><br>
<button class="btn" onclick="location.href='games/gem.html'">💎 GEM (10:1 BURN)</button><br>
<button class="btn" style="color:#81c784;border-color:#81c784;" onclick="location.href='https://finuxrc1.surge.sh'">⚖️ VAULT BRIDGE</button>
</div></body></html>
EOF

# 4. DEPLOY
surge fuel_staging frostgamesnet.surge.sh
echo ">> ✅ SOVEREIGN PLATFORM IS LIVE AT frostgamesnet.surge.sh"
