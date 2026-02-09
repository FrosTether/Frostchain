            document.body.classList.add('shake');
        }

        function checkLines() {
            let lines = [];
            // Rows
            for(let y=0; y<9; y++) if(grid[y].every(c => c===1)) lines.push({type:'r', i:y});
            // Cols
            for(let x=0; x<9; x++) if(grid.every(r => r[x]===1)) lines.push({type:'c', i:x});
            
            if(lines.length > 0) {
                AudioEngine.sfxMine();
                if(lines.length > 1) AudioEngine.sfxExplode();
                
                // Clear Logic
                lines.forEach(l => {
                    if(l.type === 'r') grid[l.i].fill(0);
                    else grid.forEach(r => r[l.i] = 0);
                });
                
                pool += lines.length * 0.5;
                document.getElementById('score').innerText = pool.toFixed(2);
                document.getElementById('status').innerText = "MINING_HASH_" + Math.random().toString(16).substr(2,6).toUpperCase();
            }
        }

        function drawShape(ctx, s, w, h, t_sz, color) {
            let ox = (w - s[0].length*t_sz)/2;
            let oy = (h - s.length*t_sz)/2;
            ctx.fillStyle = color;
            s.forEach((r,y) => r.forEach((c,x) => {
                if(c) {
                    ctx.shadowBlur = 10; ctx.shadowColor = color;
                    ctx.fillRect(ox + x*t_sz + 1, oy + y*t_sz + 1, t_sz-2, t_sz-2);
                    ctx.shadowBlur = 0;
                }
            }));
        }

        function loop() {
            // BG Clear
            ctx.fillStyle = 'rgba(5,0,10,0.8)'; // Trail effect
            ctx.fillRect(0,0, canvas.width, canvas.height);
            
            // Draw Grid
            grid.forEach((r,y) => r.forEach((c,x) => {
                ctx.fillStyle = c ? '#ff0055' : '#111';
                if(c) {
                    ctx.shadowBlur = 15; ctx.shadowColor = '#ff0055';
                    ctx.fillRect(x*sz+1, y*sz+1, sz-2, sz-2);
                    ctx.shadowBlur = 0;
                } else {
                    ctx.fillRect(x*sz+1, y*sz+1, sz-2, sz-2);
                }
            }));

            // Draw Dragged/Preview
            if(dragged) {
                // Draw Preview on Board (Ghost)
                if(preview && preview.valid) {
                    ctx.globalAlpha = 0.3; ctx.fillStyle = '#fff';
                    dragged.p.shape.forEach((r,y) => r.forEach((c,x) => {
                        if(c) ctx.fillRect((preview.x+x)*sz, (preview.y+y)*sz, sz, sz);
                    }));
                    ctx.globalAlpha = 1.0;
                }
                
                // Draw Floating Piece under finger
                // We handle this via CSS for performance usually, but can do canvas overlay if needed.
                // For this logic, the CSS 'drag-active' handles the visual feedback in the DOM/Tray.
            }

            requestAnimationFrame(loop);
        }

        init();
    </script>
</body>
</html>
EOF

# ============================================================================
# 5. DEPLOY
# ============================================================================
echo "🚀 DEPLOYING FIRESTART PROTOCOL..."
surge . fpu4eva.surge.sh
echo "✅ SYSTEM IGNITED. AUDIO ENGINE READY."
finux
#!/bin/bash
# FROSTOISE // BLOKIE-STYLE UI EVOLUTION
# ---------------------------------------
echo "🧊 UPGRADING TO FROSTOISE CLEAN-CORE..."
# 1. Identity
USERNAME="voluntaryistj"
EMAIL="voluntaryistj@gmail.com"
# ============================================================================
# 1. BLOCKS.HTML (FROSTOISE / BLOKIE ENGINE)
# ============================================================================
cat <<EOF > blocks.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Frostoise // Blocks</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <style>
        :root {
            --bg: #f8f9fa;
            --grid-bg: #e9ecef;
            --cell-empty: #dee2e6;
            --frost-blue: #00b4d8;
            --shadow: rgba(0, 180, 216, 0.3);
            --text: #212529;
        }
        body { 
            background: var(--bg); color: var(--text); font-family: -apple-system, system-ui, sans-serif;
            margin: 0; display: flex; flex-direction: column; align-items: center; height: 100vh; overflow: hidden; touch-action: none;
        }
        .header { width: 100%; padding: 15px; display: flex; justify-content: space-between; align-items: center; box-sizing: border-box; }
        .score-container { text-align: left; }
        .score-label { font-size: 10px; color: #6c757d; text-transform: uppercase; }
        .score-val { font-size: 24px; font-weight: 800; color: var(--frost-blue); }

        #game-board { 
            display: grid; grid-template-columns: repeat(9, 1fr); gap: 4px; 
            background: var(--grid-bg); padding: 6px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05);
        }
        .cell { background: var(--cell-empty); border-radius: 4px; transition: background 0.1s; }
        .cell.filled { background: var(--frost-blue); }
        .cell.shadow { background: var(--shadow); }

        #tray { 
            margin-top: 30px; display: flex; justify-content: space-around; width: 100%; max-width: 400px; height: 120px;
        }
        .piece-socket { width: 100px; height: 100px; display: flex; align-items: center; justify-content: center; }
        
        .drag-active { 
            position: fixed; pointer-events: none; z-index: 1000; 
            transform: scale(1.2) translateY(-60px); /* The "Finger Thing" - Offset Piece above finger */
            filter: drop-shadow(0 10px 15px rgba(0,0,0,0.2));
        }
    </style>
</head>
<body>

    <div class="header">
        <div class="score-container">
            <div class="score-label">Mined FTC</div>
            <div class="score-val" id="ftc">13.37</div>
        </div>
        <div style="text-align: right;">
            <div class="score-label">FROSTOISE KERNEL</div>
            <div style="font-size: 12px; font-weight: bold;">RC341.V2</div>
        </div>
    </div>

    <div id="game-board"></div>

    <div id="tray"></div>

    <script>
        const SHAPES = [
            [[1]], [[1,1]], [[1],[1]], [[1,1,1]], [[1,1],[1,1]], [[1,1,1],[0,1,0]], [[1,0],[1,1]]
        ];
        
        const boardEl = document.getElementById('game-board');
        const trayEl = document.getElementById('tray');
        let grid = Array(81).fill(0);
        let pieces = [];
        let dragged = null;
        let previewIdx = null;

        // Init Board
        const boardSize = Math.min(window.innerWidth - 30, 400);
        boardEl.style.width = boardSize + 'px';
        boardEl.style.height = boardSize + 'px';
        const cellSize = (boardSize - 40) / 9;

        for(let i=0; i<81; i++) {
            let cell = document.createElement('div');
            cell.className = 'cell';
            cell.id = 'c' + i;
            cell.style.width = cellSize + 'px';
            cell.style.height = cellSize + 'px';
            boardEl.appendChild(cell);
        }

        function spawn() {
            trayEl.innerHTML = ''; pieces = [];
            for(let i=0; i<3; i++) {
                let shape = SHAPES[Math.floor(Math.random() * SHAPES.length)];
                let p = { shape, used: false, id: i };
                pieces.push(p);
                
                let socket = document.createElement('div');
                socket.className = 'piece-socket';
                
                let canvas = document.createElement('canvas');
                canvas.width = 80; canvas.height = 80;
                drawPiece(canvas.getContext('2d'), shape, 80, 20);
                
                socket.onpointerdown = (e) => {
                    if(p.used) return;
                    dragged = { p, canvas, socket };
                    canvas.classList.add('drag-active');
                    movePiece(e);
                };
                
                socket.appendChild(canvas);
                trayEl.appendChild(socket);
            }
        }

        function drawPiece(ctx, s, size, sz) {
            ctx.fillStyle = '#00b4d8';
            let ox = (size - s[0].length * sz) / 2;
            let oy = (size - s.length * sz) / 2;
            s.forEach((row, y) => row.forEach((val, x) => {
                if(val) ctx.fillRect(ox + x*sz, oy + y*sz, sz-2, sz-2);
            }));
        }

        function movePiece(e) {
            if(!dragged) return;
            dragged.canvas.style.left = (e.clientX - 40) + 'px';
            dragged.canvas.style.top = (e.clientY - 40) + 'px';

            const rect = boardEl.getBoundingClientRect();
            const x = Math.floor((e.clientX - rect.left) / (boardSize / 9));
            const y = Math.floor((e.clientY - rect.top - 80) / (boardSize / 9)); // Match the offset
            
            clearShadows();
            if(canPlace(dragged.p.shape, x, y)) {
                showShadow(dragged.p.shape, x, y);
                previewIdx = {x, y};
            } else {
                previewIdx = null;
            }
        }

        function canPlace(s, gx, gy) {
            if(gx < 0 || gy < 0) return false;
            for(let y=0; y<s.length; y++) {
                for(let x=0; x<s[y].length; x++) {
                    if(s[y][x]) {
                        if(gx+x >= 9 || gy+y >= 9 || grid[(gy+y)*9 + (gx+x)]) return false;
                    }
                }
            }
            return true;
        }

        function showShadow(s, gx, gy) {
            for(let y=0; y<s.length; y++) {
                for(let x=0; x<s[y].length; x++) {
                    if(s[y][x]) document.getElementById('c' + ((gy+y)*9 + (gx+x))).classList.add('shadow');
                }
            }
        }

        function clearShadows() {
            document.querySelectorAll('.cell').forEach(c => c.classList.remove('shadow'));
        }

        function placePiece() {
            if(!dragged) return;
            if(previewIdx) {
                const s = dragged.p.shape;
                for(let y=0; y<s.length; y++) {
                    for(let x=0; x<s[y].length; x++) {
                        if(s[y][x]) {
                            grid[(previewIdx.y+y)*9 + (previewIdx.x+x)] = 1;
                            document.getElementById('c' + ((previewIdx.y+y)*9 + (previewIdx.x+x))).classList.add('filled');
                        }
                    }
                }
                dragged.p.used = true;
                dragged.canvas.style.display = 'none';
                checkLines();
                if(pieces.every(p => p.used)) spawn();
            } else {
                dragged.canvas.classList.remove('drag-active');
                dragged.canvas.style.position = 'static';
            }
            dragged = null;
            clearShadows();
        }

        function checkLines() {
            // Logic for Row/Col clearing
            let toClear = [];
            for(let i=0; i<9; i++) {
                // Rows
                let row = grid.slice(i*9, i*9+9);
                if(row.every(v => v === 1)) toClear.push({type:'r', idx:i});
                // Cols
                let col = [];
                for(let j=0; j<9; j++) col.push(grid[j*9+i]);
                if(col.every(v => v === 1)) toClear.push({type:'c', idx:i});
            }
            toClear.forEach(tc => {
                if(tc.type === 'r') for(let x=0; x<9; x++) { grid[tc.idx*9+x]=0; document.getElementById('c'+(tc.idx*9+x)).classList.remove('filled'); }
                if(tc.type === 'c') for(let y=0; y<9; y++) { grid[y*9+tc.idx]=0; document.getElementById('c'+(y*9+tc.idx)).classList.remove('filled'); }
            });
        }

        window.onpointermove = movePiece;
        window.onpointerup = placePiece;
        spawn();
    </script>
</body>
</html>
EOF

# 2. Deploy to Surge
echo "🚀 DEPLOYING TO FPU4EVA.SURGE.SH..."
surge . fpu4eva.surge.sh
echo "✅ FROSTOISE V2 IS LIVE."
git clone https://github.com/FrosTether/FINUX-FrostOS.git
cd FINUX-FrostOS
#!/data/data/com.termux/files/usr/bin/bash
# --- User Configuration ---
USER="voluntaryistj"
REPO="FrosTether/FINUX-FrostOS"
# Tip: Generate your token at github.com/settings/tokens
read -sp "Enter your GitHub Personal Access Token: " TOKEN
echo -e "\n"
# --- 1. System Updates ---
echo "[*] Updating Termux packages..."
pkg update && pkg upgrade -y
pkg install git proot wget -y
# --- 2. Clean up old attempts ---
if [ -d "FINUX-FrostOS" ]; then     echo "[!] Existing directory found. Removing...";     rm -rf FINUX-FrostOS; fi
# --- 3. Clone Repository ---
echo "[*] Cloning FINUX Kernel source as $USER..."
git clone https://$USER:$TOKEN@github.com/$REPO.git
# Check if clone succeeded
if [ $? -eq 0 ]; then     cd FINUX-FrostOS;     echo "[+] Successfully entered $(pwd)"; else     echo "[!] Clone failed. Check your token and try again.";     exit 1; fi
export ZROK_URL="https://m9jw03tx2fbl.share.zrok.io"
# Inject the stable zrok URL into the Hub
sed -i "s|https://.*.localtunnel.me|$ZROK_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.ngrok-free.app|$ZROK_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.share.zrok.io|$ZROK_URL|g" ~/Finux/dist/index.html
surge ~/Finux/dist fpu4eva.surge.sh
ps -ef | grep python
nano launch_all.py
rm launch_all.py
nano launch_all.py
bash launch_all.sh
#!/bin/bash
# --- FINUX KERNEL: EMERGENCY SB-200K RESET ---
echo -e "\033[1;36m[SYSTEM] REBOOTING SB-200K BACKEND... BRIDGING TO ZROK...\033[0m"
# 1. Kill old processes to clear the ports
pkill -f python
pkill -f zrok
# 2. Start the Validator (Backend) in the background
# This keeps the node alive while you stay in this screen
python ~/Finux/fnr_validator.py > ~/node.log 2>&1 &
sleep 2
# 3. Start zrok and grab the new URL
# We use a temp file to catch the URL output
echo "[SYSTEM] Opening Tunnel..."
zrok share public http://localhost:5000 --backend-mode proxy > ~/zrok.log 2>&1 &
# Give the tunnel 10 seconds to generate the link
sleep 10
# Extract the URL from the log file
ZROK_URL=$(grep -o 'https://[^ ]*share.zrok.io' ~/zrok.log | head -n 1)
if [ -z "$ZROK_URL" ]; then     echo -e "\033[1;31m[ERROR]\033[0m Zrok failed to give a URL. Check your internet or zrok token.";     exit 1; fi
echo -e "\033[1;32m[SYNC]\033[0m New URL Found: $ZROK_URL"
# 4. Inject the new URL into your HTML
sed -i "s|https://.*.share.zrok.io|$ZROK_URL|g" ~/Finux/dist/index.html
# 5. Push to Surge
surge ~/Finux/dist fpu4eva.surge.sh
echo -e "\033[1;35m[LIVE]\033[0m REFRESH https://fpu4eva.surge.sh NOW."
echo "--- REAL-TIME CLAIM LOG ---"
tail -f ~/node.log
#!/bin/bash
# --- FINUX KERNEL: SERVEO SB-200K BRIDGE ---
echo -e "\033[1;36m[SYSTEM] RESETTING BACKEND... INITIATING SERVEO SSH TUNNEL...\033[0m"
# 1. Kill old processes
pkill -f python
pkill -f ssh
pkill -f zrok
pkill -f lt
# 2. Start the Validator
python ~/Finux/fnr_validator.py > ~/node.log 2>&1 &
sleep 2
# 3. Create the SSH Tunnel (Serveo)
# This will request a public URL from serveo.net
echo "[SYSTEM] Requesting Public URL from Serveo..."
ssh -o StrictHostKeyChecking=no -R 80:localhost:5000 serveo.net > ~/tunnel.log 2>&1 &
# Give it time to establish
sleep 8
# 4. Extract the URL
SERVEO_URL=$(grep -o 'https://[^ ]*\.serveo\.net' ~/tunnel.log | head -n 1)
if [ -z "$SERVEO_URL" ]; then     echo -e "\033[1;31m[ERROR]\033[0m Serveo failed. Check internet connection."
    cat ~/tunnel.log;     exit 1; fi
echo -e "\033[1;32m[SYNC]\033[0m Stable URL: $SERVEO_URL"
# 5. Inject and Deploy to Surge
sed -i "s|https://.*.zrok.io|$SERVEO_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.serveo.net|$SERVEO_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.localtunnel.me|$SERVEO_URL|g" ~/Finux/dist/index.html
surge ~/Finux/dist fpu4eva.surge.sh
echo -e "\033[1;35m[LIVE]\033[0m REFRESH https://fpu4eva.surge.sh NOW."
echo "Keep Termux open. Tailing claim logs..."
tail -f ~/node.log
#!/bin/bash
# --- FINUX KERNEL: HEAVY DUTY SB-200K BRIDGE ---
echo -e "\033[1;36m[SYSTEM] NUKING GHOST JOBS... RECLAIMING PORTS...\033[0m"
# 1. Kill everything to start fresh
killall -9 python ssh zrok lt 2>/dev/null
pkill -9 -f "fnr_validator"
sleep 1
# 2. Start the Validator
echo "[1/3] Waking Masternode..."
python ~/Finux/fnr_validator.py > ~/node.log 2>&1 &
sleep 2
# 3. Create the Serveo Tunnel
echo "[2/3] Negotiating with Serveo (Waiting for URL)..."
# We use -T to disable pseudo-terminal and -o to skip host checks
ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:5000 serveo.net > ~/tunnel.log 2>&1 &
# Loop until the URL appears in the log
COUNT=0
while [ $COUNT -lt 20 ]; do     SERVEO_URL=$(grep -o 'https://[^ ]*\.serveo\.net' ~/tunnel.log | head -n 1);     if [ ! -z "$SERVEO_URL" ]; then         break;     fi;     echo -n ".";     sleep 2;     ((COUNT++)); done
if [ -z "$SERVEO_URL" ]; then     echo -e "\n\033[1;31m[ERROR]\033[0m Serveo timed out. Check: cat ~/tunnel.log";     exit 1; fi
echo -e "\n\033[1;32m[FOUND URL]\033[0m $SERVEO_URL"
# 4. Inject and Deploy
echo "[3/3] Synchronizing with fpu4eva.surge.sh..."
sed -i "s|https://.*.serveo.net|$SERVEO_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.zrok.io|$SERVEO_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.localtunnel.me|$SERVEO_URL|g" ~/Finux/dist/index.html
surge ~/Finux/dist fpu4eva.surge.sh
echo -e "\033[1;35m[LIVE]\033[0m MAGNUM OPUS IS ONLINE."
echo "Claim now at: https://fpu4eva.surge.sh"
echo "--- MONITORING CLAIMS ---"
tail -f ~/node.log
#!/bin/bash
# --- FINUX KERNEL: NUCLEAR SB-200K RESET ---
echo -e "\033[1;31m[SYSTEM] INITIATING FULL SYSTEM NUKE...\033[0m"
# 1. KILL EVERYTHING
killall -9 python ssh zrok lt node 2>/dev/null
pkill -9 -f "fnr_validator"
rm ~/tunnel.log ~/node.log ~/zrok.log 2>/dev/null
# 2. GENERATE SSH KEY (If missing)
if [ ! -f ~/.ssh/id_rsa ]; then     echo "[SYSTEM] Generating fresh RSA identity...";     ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa; fi
# 3. WAKE THE VALIDATOR (3.1337 Core / 133.7314 Apex)
echo "[SYSTEM] Rebooting Masternode..."
python ~/Finux/fnr_validator.py > ~/node.log 2>&1 &
sleep 3
# 4. BRIDGE VIA SERVEO (Auto-accepting keys)
echo "[SYSTEM] Establishing Secure Bridge..."
ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ServerAliveInterval=60 -R 80:localhost:5000 serveo.net > ~/tunnel.log 2>&1 &
# 5. WAIT AND EXTRACT URL
echo -n "[SYSTEM] Waiting for Public Uplink..."
for i in {1..15}; do     SERVEO_URL=$(grep -o 'https://[^ ]*\.serveo\.net' ~/tunnel.log | head -n 1);     if [ ! -z "$SERVEO_URL" ]; then         echo -e "\n\033[1;32m[FOUND URL]\033[0m $SERVEO_URL";         break;     fi;     echo -n ".";     sleep 2; done
if [ -z "$SERVEO_URL" ]; then     echo -e "\n\033[1;31m[FAIL]\033[0m Serveo failed to respond. Trying fallback..."
    cat ~/tunnel.log;     exit 1; fi
npm install -g localtunnel
lt --port 5000 --subdomain frost-node-sb
# REPLACE THIS URL with whatever the 'lt' command gave you!
export PUBLIC_URL="https://frost-node-sb.localtunnel.me"
sed -i "s|https://.*.localtunnel.me|$PUBLIC_URL|g" ~/Finux/dist/index.html
surge ~/Finux/dist fpu4eva.surge.sh
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc   | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null   && echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main"   | sudo tee /etc/apt/sources.list.d/ngrok.list   && sudo apt update   && sudo apt install ngrok
ngrok config add-authtoken 39PDJcznlagpUhacl8RZvv76v2z_7AqGZ6YX3PUktotdbt1qR
pkg install tur-repo -y
pkg install ngrok -y
ngrok config add-authtoken 39PDJcznlagpUhacl8RZvv76v2z_7AqGZ6YX3PUktotdbt1qR
pkg install zrok -y
zrok enable orM5OOHwY6Wk
zrok share public http://localhost:5000 --backend-mode proxy
#!/bin/bash
# --- FINUX KERNEL: PINGGY SB-200K UPLINK ---
echo -e "\033[1;36m[SYSTEM] NUKING STUCK JOBS... SWITCHING TO PINGGY UPLINK...\033[0m"
# 1. CLEANUP
killall -9 python ssh zrok lt 2>/dev/null
rm ~/node.log ~/pinggy.log 2>/dev/null
# 2. START THE VALIDATOR
echo "[1/3] Waking Masternode (3.1337 Core / 133.7314 Apex)..."
python ~/Finux/fnr_validator.py > ~/node.log 2>&1 &
sleep 2
# 3. BRIDGE VIA PINGGY (No keys required)
echo "[2/3] Establishing Public Bridge via Pinggy..."
# This command starts the tunnel and saves the output
ssh -o StrictHostKeyChecking=no -p 443 -R0:localhost:5000 a.pinggy.io > ~/pinggy.log 2>&1 &
# Give it time to generate the URL
sleep 8
# 4. EXTRACT URL AND DEPLOY
PINGGY_URL=$(grep -o 'https://[^ ]*\.a\.free\.pinggy\.link' ~/pinggy.log | head -n 1)
if [ -z "$PINGGY_URL" ]; then     echo -e "\033[1;31m[FAIL]\033[0m Pinggy failed. Let's see why:";     cat ~/pinggy.log;     exit 1; fi
echo -e "\033[1;32m[FOUND URL]\033[0m $PINGGY_URL"
# 5. SYNC AND BLAST TO SURGE
sed -i "s|https://.*.pinggy.link|$PINGGY_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.serveo.net|$PINGGY_URL|g" ~/Finux/dist/index.html
sed -i "s|https://.*.zrok.io|$PINGGY_URL|g" ~/Finux/dist/index.html
surge ~/Finux/dist fpu4eva.surge.sh
echo -e "\n\033[1;35m[LIVE]\033[0m REFRESH https://fpu4eva.surge.sh NOW."
echo "--- MONITORING CLAIMS ---"
tail -f ~/node.log
python ~/Finux/fnr_validator.py
