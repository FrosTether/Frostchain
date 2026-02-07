#!/bin/bash
# ♾️ INFINITY v28.5 PHOENIX RESTORE
echo ">> ⛽ REFUELING ENGINE... REBUILDING HUB..."

mkdir -p fuel_staging/games

# Re-inject Gem.html (Burn Logic)
cat << 'EOF' > fuel_staging/games/gem.html
<!DOCTYPE html><html><head><title>💎 GEM | BURN ENGINE</title>
<style>body{background:#000;color:#ff4081;font-family:monospace;text-align:center;margin:0;}.controls{padding:20px;background:#111;display:flex;justify-content:center;gap:10px;}button{background:#ff4081;color:#000;border:none;padding:10px 20px;border-radius:5px;font-weight:900;cursor:pointer;}.gas{background:#81c784;}iframe{width:100%;height:70vh;border:none;}</style></head><body>
<div class="controls"><button onclick="burn(10)">🔀 SHUFFLE (-10 BURN)</button><button class="gas" onclick="gasUp()">⛽ GAS (+1 PROFIT)</button></div>
<iframe src="https://vishalsingh2972.github.io/JS-CandyCrushSaga/"></iframe>
<script>let treasury=16000;function burn(amt){alert("🔥 10 TOKENS BURNED.");}function gasUp(){treasury+=1;alert("⛽ GASSED UP: +1 SOVEREIGN PROFIT.");}</script></body></html>
EOF

# Re-inject Index.html
cat << 'EOF' > fuel_staging/index.html
<!DOCTYPE html><html><head><title>FROST | FIRESTART ⛽</title>
<style>body{background:#000;color:#fff;font-family:monospace;display:grid;place-items:center;min-height:100vh;margin:0;}.hub{text-align:center;border:2px solid #111;padding:40px;border-radius:30px;background:#050505;}.btn{background:#222;color:#fff;border:1px solid #444;padding:20px;margin:10px;width:240px;border-radius:15px;cursor:pointer;}</style></head><body><div class="hub"><h1 style="letter-spacing:10px;">FIRESTART ⛽ RESTORED</h1>
<button class="btn" onclick="location.href='games/gem.html'">💎 GEM (10:1 BURN)</button><br>
<button class="btn" style="background:#81c784;color:#000;" onclick="location.href='https://finuxrc1.surge.sh'">⚖️ VAULT BRIDGE</button></div></body></html>
EOF

# Redeploy
surge fuel_staging frostgamesnet.surge.sh
echo ">> ✅ PHOENIX RESTORE COMPLETE. ENGINE IS HOT."
