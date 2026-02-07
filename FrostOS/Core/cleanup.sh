#!/bin/bash

# RC261 // THE_FULL_ENGINE_SYNTHESIS
# OWNER: Jacob Thomas Frost
# TARGET: fpu4eva.surge.sh

echo "♊ INJECTING REMAINING GAME ENGINES..."

# 1. AUTH & SHARED LEDGER
surge login --email voluntaryistj@gmail.com
cat <<EOF > ledger.js
const Ledger = {
    init() { return JSON.parse(localStorage.getItem('sov_ledger') || '{"legacy":500,"sovereign":0,"treasury":16000}'); },
    save(d) { localStorage.setItem('sov_ledger', JSON.stringify(d)); }
};
EOF

# 2. BLOCKS.HTML (The Milestone Woodoku Grid)
cat <<EOF > blocks.html
<!DOCTYPE html><html><head><title>Blocks | Milestone Grid</title>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<style>
    body { background:#000; color:#FFD700; font-family:monospace; text-align:center; margin:0; }
    #g { display:grid; grid-template-columns:repeat(9, 1fr); gap:2px; width:90vw; max-width:380px; background:#240046; padding:5px; margin:20px auto; border:2px solid #FFD700; }
    .cell { background:#000; aspect-ratio:1/1; border:1px solid #111; cursor:pointer; }
    .cell.active { background:#FFD700; box-shadow:0 0 10px #FFD700; }
    .controls { padding:20px; background:#111; position:fixed; bottom:0; width:100%; border-top:2px solid #FFD700; }
    button { background:#FFD700; border:none; padding:15px; font-weight:900; border-radius:10px; }
</style><script src="ledger.js"></script></head>
<body onload="l=Ledger.init();update()">
    <div style="padding:15px; border-bottom:1px solid #FFD700;">LEGACY: <span id="leg">0</span></div>
    <div id="g"></div>
    <div class="controls">
        <button onclick="mine()">VALIDATE BLOCK (MINE)</button>
    </div>
    <script>
        const g = document.getElementById('g'); const cells = [];
        for(let i=0; i<81; i++) { 
            let c = document.createElement('div'); c.className='cell'; 
            g.appendChild(c); cells.push(c);
            c.onclick = () => { if(!c.classList.contains('active')) { c.classList.add('active'); checkGrid(); }};
        }
        function update() { document.getElementById('leg').innerText = l.legacy; }
        function mine() { 
            // Milestone Logic: Auto-clear active cells for Legacy
            let active = document.querySelectorAll('.active');
            if(active.length > 0) {
                l.legacy += (active.length * 5);
                active.forEach(c => c.classList.remove('active'));
                Ledger.save(l); update();
                if(navigator.vibrate) navigator.vibrate(30);
            } else { alert("SELECT CELLS ON GRID TO MINE"); }
        }
    </script>
</body></html>
EOF

# 3. GEM.HTML (The High-Stakes Animated Slots)
cat <<EOF > gem.html
<!DOCTYPE html><html><head><title>Slots | Burn Engine</title>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<style>
    body { background:#000; color:#FFD700; font-family:monospace; text-align:center; padding-top:50px; }
    .slot-machine { display:flex; justify-content:center; gap:10px; margin:30px 0; }
    .reel { width:80px; height:120px; border:4px solid #FFD700; border-radius:10px; font-size:50px; line-height:120px; background:#111; overflow:hidden; }
    .btn-spin { background:#FFD700; color:#000; border:none; padding:20px 40px; font-size:20px; font-weight:900; border-radius:50px; cursor:pointer; }
</style><script src="ledger.js"></script></head>
<body onload="l=Ledger.init();update()">
    <div style="font-size:18px;">LEGACY: <span id="leg">0</span> | SOV: <span id="sov">0</span></div>
    <div class="slot-machine">
        <div id="r1" class="reel">₿</div><div id="r2" class="reel">₿</div><div id="r3" class="reel">₿</div>
    </div>
    <button class="btn-spin" onclick="spin()">SPIN (10 LEGACY)</button>
    <script>
        const icons = ["₿", "Ξ", "❄", "💎", "7"];
        function update() { document.getElementById('leg').innerText=l.legacy; document.getElementById('sov').innerText=l.sovereign || 0; }
        function spin() {
            if(l.legacy < 10) return alert("INSUFFICIENT LEGACY");
            l.legacy -= 10; update();
            let count = 0;
            let timer = setInterval(() => {
                document.getElementById('r1').innerText = icons[Math.floor(Math.random()*5)];
                document.getElementById('r2').innerText = icons[Math.floor(Math.random()*5)];
                document.getElementById('r3').innerText = icons[Math.floor(Math.random()*5)];
                count++;
                if(count > 15) {
                    clearInterval(timer);
                    checkWin();
                }
            }, 50);
        }
        function checkWin() {
            let r1 = document.getElementById('r1').innerText;
            let r2 = document.getElementById('r2').innerText;
            let r3 = document.getElementById('r3').innerText;
            if(r1 === r2 && r2 === r3) {
                l.sovereign = (l.sovereign || 0) + 1;
                alert("🎰 JACKPOT! 1 SOVEREIGN MINTED");
            }
            Ledger.save(l); update();
        }
    </script>
</body></html>
EOF

# 4. DEPLOY
surge . fpu4eva.surge.sh
echo "✅ ALL ENGINES LIVE: https://fpu4eva.surge.sh"
