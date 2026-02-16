                
                <div class="stat-row" style="margin-top:20px;">
                    <span>Fuel Cost:</span>
                    <span>2.00 FsZT</span>
                </div>
                <div class="stat-row">
                    <span>Balance:</span>
                    <span id="fszt-bal" class="highlight">0.00 FsZT</span>
                </div>

                <button class="btn btn-travel" onclick="jump()">INITIATE JUMP</button>
                <p id="jump-log" style="text-align:center; color:#0f0; height:20px; margin-top:10px;"></p>
            </div>

            <div class="panel">
                <h2 style="color:#0ff; border-bottom:1px solid #0ff;">💼 PORTFOLIO</h2>
                
                <div class="stat-row">
                    <span style="color:#0ff;">FTC (Frostcoin)</span>
                    <span class="val">11,870,000.01</span>
                </div>
                <div style="font-size:0.7em; color:#666; margin-bottom:10px;">> Premine: 13.37% of 100M</div>

                <div class="stat-row">
                    <span style="color:#0f0;">FNR (Reserve)</span>
                    <span class="val">4,412,100.00</span>
                </div>
                <div style="font-size:0.7em; color:#666; margin-bottom:10px;">> Premine: 13.37% of 33M</div>

                <div class="stat-row">
                    <span style="color:#f0f;">AMD (Amiah)</span>
                    <span class="val">404,400,000.00</span>
                </div>
                <div style="font-size:0.7em; color:#666; margin-bottom:10px;">> 3.37% of 12B (Non-Minable)</div>
            </div>

            <div class="panel">
                <h2 style="color:#ffd700; border-bottom:1px solid #ffd700;">⚖️ GOVERNANCE</h2>
                
                <div class="stat-row">
                    <span>FRST Supply</span>
                    <span class="val">♾️ UNLIMITED</span>
                </div>
                <div class="stat-row">
                    <span>DOGE Live</span>
                    <span id="doge-price" class="val">$0.38</span>
                </div>
                <div class="stat-row" style="background:rgba(255,215,0,0.1); padding:5px;">
                    <span>FRST Price (DOGE × π)</span>
                    <span id="frst-price" class="val highlight">$1.19</span>
                </div>
                
                <div style="margin-top:20px; border-top:1px solid #333; padding-top:10px;">
                    <button class="btn" onclick="buyFrst()">💰 BUY FRST</button>
                    <button class="btn" onclick="wrap()">🔄 WRAP TO FsZT</button>
                </div>
            </div>
        </div>
    </div>

<script>
    // CONFIG
    const GOD_USERS = ['voluntaryistj@gmail.com', 'drfrost.frostchain'];
    let currentUser = null;
    let fsztBalance = 0;
    
    function login() {
        const id = document.getElementById('loginId').value.trim();
        if(!id) return alert("Enter Identity");

        if (GOD_USERS.includes(id)) {
            currentUser = id;
            fsztBalance = 999999999; // UNLIMITED
            document.getElementById('user-display').innerText = id + " [GOD MODE]";
            document.getElementById('user-display').style.color = "#0f0";
        } else {
            currentUser = id;
            fsztBalance = 10; // Starter pack
            document.getElementById('user-display').innerText = id;
        }

        document.getElementById('loginScreen').style.display = 'none';
        document.getElementById('dashboard').style.display = 'block';
        updateUI();
    }

    function updateUI() {
        document.getElementById('fszt-bal').innerText = (fsztBalance > 900000 ? "♾️ INFINITE" : fsztBalance.toFixed(2)) + " FsZT";
        
        // Sim Price
        let doge = 0.35 + (Math.random() * 0.05);
        let frst = doge * 3.14159;
        document.getElementById('doge-price').innerText = "$" + doge.toFixed(4);
        document.getElementById('frst-price').innerText = "$" + frst.toFixed(4);
    }

    function jump() {
        const target = document.getElementById('time-target').value;
        if(!target) return alert("Select Destination Date");
        
        const log = document.getElementById('jump-log');
        log.innerText = "⚡ FLUX CAPACITOR CHARGING...";
        
        setTimeout(() => {
            log.innerText = "🚀 JUMPING TO " + target + "...";
            document.getElementById('dest-display').innerText = target.replace('T', ' ');
            document.getElementById('dest-display').style.color = "#fff";
            
            // Deduct? No, if God Mode
            if (!GOD_USERS.includes(currentUser)) {
                fsztBalance -= 2;
                if(fsztBalance < 0) fsztBalance = 0;
            }
            updateUI();
        }, 1500);
    }

    function buyFrst() { alert("Simulated: Purchased 1000 FRST via Grayson API"); }
    function wrap() { alert("Simulated: Wrapped FRST into FsZT Fuel"); }

    // Live Ticker
    setInterval(updateUI, 3000);

</script>
</body>
</html>
EOF

# 3. Deploy to Surge
surge ./temporal_machine FrostTime.surge.sh
# 1. Create directory
mkdir -p temporal_v2
# 2. Write the Integrated Temporal Machine (v2.0)
cat <<EOF > temporal_v2/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finux Temporal | Real Time Machine | Grayson's Wallet API</title>
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@300;400;500&family=Orbitron:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        :root { --neon-cyan: #00f3ff; --neon-gold: #ffd700; --neon-pink: #ff00ff; --bg-dark: #000; --glass: rgba(0, 30, 40, 0.85); }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Fira Code', monospace;
            background: radial-gradient(ellipse at center, #001a33 0%, #000 100%);
            color: var(--neon-cyan);
            overflow-x: hidden;
            min-height: 100vh;
        }
        
        /* --- FLUX CAPACITOR ANIMATION --- */
        .flux-capacitor {
            position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
            width: 400px; height: 400px; opacity: 0.08; pointer-events: none; z-index: 0;
        }
        .flux-glow {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
            width: 100%; height: 100%; border-radius: 50%; border: 4px solid var(--neon-cyan);
            animation: fluxPulse 2s infinite;
        }
        .flux-glow:nth-child(2) { width: 70%; height: 70%; animation-delay: 0.5s; }
        .flux-glow:nth-child(3) { width: 40%; height: 40%; animation-delay: 1s; }
        
        @keyframes fluxPulse {
            0%, 100% { box-shadow: 0 0 20px var(--neon-cyan), inset 0 0 20px var(--neon-cyan); opacity: 0.5; }
            50% { box-shadow: 0 0 60px var(--neon-cyan), inset 0 0 60px var(--neon-cyan); opacity: 1; }
        }

        /* --- LOGIN SCREEN --- */
        .login-screen {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.96); z-index: 9999;
            display: flex; align-items: center; justify-content: center; flex-direction: column;
        }
        .login-panel {
            background: rgba(0, 20, 30, 0.95); border: 2px solid var(--neon-cyan);
            border-radius: 15px; padding: 40px; width: 90%; max-width: 500px;
            box-shadow: 0 0 50px rgba(0, 243, 255, 0.2); text-align: center;
        }
        .login-input {
            width: 100%; padding: 15px; background: #000; border: 1px solid var(--neon-cyan);
            color: var(--neon-cyan); font-family: inherit; margin: 20px 0; text-align: center; font-size: 1.2em;
        }
        .login-btn {
            width: 100%; padding: 15px; background: linear-gradient(135deg, var(--neon-cyan), #0088aa);
            border: none; color: #000; font-size: 1.2em; font-weight: bold; cursor: pointer;
            transition: 0.3s; text-transform: uppercase; letter-spacing: 2px;
        }
        .login-btn:hover { box-shadow: 0 0 30px var(--neon-cyan); transform: scale(1.02); }

        /* --- MAIN DASHBOARD --- */
        .container {
            max-width: 1800px; margin: 0 auto; padding: 20px;
            display: none; position: relative; z-index: 10;
        }
        
        .header {
            text-align: center; border-bottom: 2px solid var(--neon-cyan);
            padding-bottom: 20px; margin-bottom: 25px;
            background: rgba(0, 243, 255, 0.05); border-radius: 10px;
        }
        .logo {
            font-family: 'Orbitron', sans-serif; font-size: 2.5em; font-weight: 900;
            text-shadow: 0 0 20px var(--neon-cyan); animation: textFlicker 4s infinite;
        }
        @keyframes textFlicker { 0%, 100% { opacity: 1; } 50% { opacity: 0.8; } 52% { opacity: 0.4; } 54% { opacity: 1; } }

        .grid {
            display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px;
            height: 75vh;
        }
        @media (max-width: 900px) { .grid { grid-template-columns: 1fr; height: auto; } }

        .panel {
            background: var(--glass); border: 1px solid rgba(0, 243, 255, 0.3);
            border-radius: 10px; padding: 20px; backdrop-filter: blur(10px);
            display: flex; flex-direction: column; transition: 0.3s;
            box-shadow: 0 0 15px rgba(0,0,0,0.5);
        }
        .panel:hover { border-color: var(--neon-cyan); box-shadow: 0 0 30px rgba(0, 243, 255, 0.1); }
        
        .panel-title {
            font-family: 'Orbitron', sans-serif; font-size: 1.2em; color: #fff;
            border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px; margin-bottom: 15px;
            display: flex; justify-content: space-between;
        }

        /* --- TERMINAL (LEFT) --- */
        #terminal-window {
            flex: 1; background: rgba(0,0,0,0.6); border: 1px solid #333;
            border-radius: 5px; padding: 15px; overflow-y: auto;
            font-size: 0.9em; margin-bottom: 15px;
        }
        .msg { margin-bottom: 10px; padding: 8px 12px; border-radius: 4px; max-width: 85%; line-height: 1.4; }
        .msg-sys { color: #888; text-align: center; font-size: 0.8em; border-bottom: 1px dashed #333; margin: 15px 0; }
        .msg-ai { background: rgba(0, 243, 255, 0.1); border-left: 3px solid var(--neon-cyan); color: #fff; align-self: flex-start; }
        .msg-user { background: rgba(255, 0, 255, 0.1); border-right: 3px solid var(--neon-pink); color: #fff; align-self: flex-end; margin-left: auto; text-align: right; }
        
        .controls-area { border-top: 1px solid #333; padding-top: 15px; }
        .input-group { display: flex; gap: 10px; }
        .cmd-input {
            flex: 1; background: #111; border: 1px solid #444; color: #fff;
            padding: 10px; font-family: inherit;
        }
        .btn-cmd {
            background: var(--neon-cyan); color: #000; border: none; padding: 0 20px;
            font-weight: bold; cursor: pointer; transition: 0.2s;
        }
        .btn-cmd:hover { background: #fff; box-shadow: 0 0 15px var(--neon-cyan); }

        .choices-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; margin-top: 10px; }
        .btn-choice {
            background: rgba(0,0,0,0.5); border: 1px solid #555; color: #aaa;
            padding: 10px; cursor: pointer; font-size: 0.8em; transition: 0.2s;
        }
        .btn-choice:hover { border-color: var(--neon-gold); color: var(--neon-gold); }

        /* --- STATS (RIGHT) --- */
        .stat-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid rgba(255,255,255,0.05); font-size: 0.9em; }
        .stat-label { color: #aaa; }
        .stat-val { color: #fff; font-weight: bold; }
        .highlight-blue { color: var(--neon-cyan); }
        .highlight-gold { color: var(--neon-gold); }
        .highlight-pink { color: var(--neon-pink); }

        .price-badge {
            background: rgba(255, 215, 0, 0.1); border: 1px solid var(--neon-gold);
            padding: 15px; border-radius: 8px; text-align: center; margin-bottom: 15px;
        }
        .btn-action {
            width: 100%; background: rgba(255,255,255,0.1); border: 1px solid var(--neon-cyan);
            color: var(--neon-cyan); padding: 10px; margin-top: 5px; cursor: pointer; transition: 0.2s;
        }
        .btn-action:hover { background: var(--neon-cyan); color: #000; }

        /* --- SCROLLBAR --- */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-thumb { background: #333; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--neon-cyan); }
    </style>
</head>
<body>

    <div class="flux-capacitor">
        <div class="flux-glow"></div>
        <div class="flux-glow"></div>
        <div class="flux-glow"></div>
    </div>

    <div class="login-screen" id="loginScreen">
        <div class="login-panel">
            <h1 style="font-family:'Orbitron'; margin-bottom:10px;">🔐 TEMPORAL ACCESS</h1>
            <p style="color:#aaa; font-size:0.9em;">GRAYSON'S NODE RELAY // V2.4</p>
            <input type="text" class="login-input" id="loginId" placeholder="Enter Identity (e.g., .frostchain)">
            <button class="login-btn" onclick="authenticate()">INITIALIZE</button>
            <div style="margin-top:20px; font-size:0.8em; color:#555;">
                > GOD MODES: voluntaryistj@gmail.com | drfrost.frostchain<br>
                > PUBLIC ACCESS: ENABLED
            </div>
        </div>
    </div>

    <div class="container" id="dashboard">
        <div class="header">
            <div class="logo">⚡ FINUX TIME MACHINE</div>
            <div style="font-size:0.8em; letter-spacing:2px; color:#aaa;">GRAYSON API • FROST SUB ZERO • SIGNAL LINK</div>
            <div id="user-badge" style="margin-top:5px; color:var(--neon-gold);"></div>
        </div>

        <div class="grid">
            <div class="panel">
                <div class="panel-title">
                    <span>📡 TEMPORAL SIGNAL</span>
                    <span id="date-display" style="color:var(--neon-gold)">PRESENT DAY</span>
                </div>
                
                <div id="terminal-window">
                    <div class="msg-sys">> SYSTEM ONLINE. FLUX CAPACITOR CHARGING...<br>> GRAYSON API: CONNECTED (12ms)</div>
                    <div class="msg msg-ai">Welcome, Pilot. The timeline is stable. Enter a target year to initiate displacement or engage with the current signal.</div>
                </div>

                <div class="controls-area">
                    <div class="input-group">
                        <input type="text" id="cmd-input" class="cmd-input" placeholder="Enter Year (e.g. 2010) or Message...">
                        <button class="btn-cmd" onclick="handleCommand()">SEND</button>
                    </div>
                    <div class="choices-grid" id="choices-area">
                        </div>
                </div>
            </div>

            <div style="display:flex; flex-direction:column; gap:20px;">
                
                <div class="panel">
                    <div class="panel-title">❄️ FROST SUB ZERO (FUEL)</div>
                    
                    <div class="price-badge">
                        <div style="color:var(--neon-gold); font-size:0.8em;">FRST GOVERNANCE PRICE</div>
                        <div style="font-size:1.8em; font-weight:bold;" id="frst-price">$1.19</div>
                        <div style="font-size:0.7em; color:#aaa;">PEG: DOGE * PI (3.14159)</div>
                    </div>

                    <div class="stat-row">
                        <span class="stat-label">FsZT Balance</span>
                        <span class="stat-val highlight-blue" id="fszt-bal">0.00</span>
                    </div>
                    <div class="stat-row">
                        <span class="stat-label">Cost per Jump</span>
                        <span class="stat-val">2.00 FsZT</span>
                    </div>
                    
                    <button class="btn-action" onclick="wrapTokens()">🔄 WRAP FRST → FsZT</button>
                </div>

                <div class="panel" style="flex:1;">
                    <div class="panel-title">💼 TOKEN PORTFOLIO</div>
                    
                    <div class="stat-row">
                        <span class="stat-label" style="color:var(--neon-cyan)">FTC (Frostcoin)</span>
                        <span class="stat-val">11,870,000.01</span>
                    </div>
                    <div style="font-size:0.7em; color:#666; margin-bottom:5px; text-align:right;">13.37% of 100M Cap</div>

                    <div class="stat-row">
                        <span class="stat-label" style="color:#0f0">FNR (Reserve)</span>
                        <span class="stat-val">4,412,100.00</span>
                    </div>
                    <div style="font-size:0.7em; color:#666; margin-bottom:5px; text-align:right;">13.37% of 33M Cap</div>

                    <div class="stat-row">
                        <span class="stat-label" style="color:var(--neon-pink)">AMD (Amiah)</span>
                        <span class="stat-val">404,400,000.00</span>
                    </div>
                    <div style="font-size:0.7em; color:#666; margin-bottom:5px; text-align:right;">3.37% of 12B (Non-Minable)</div>

                    <div class="stat-row" style="margin-top:15px; border-top:1px solid #333; padding-top:10px;">
                        <span class="stat-label" style="color:var(--neon-gold)">FRST (Gov)</span>
                        <span class="stat-val" id="frst-bal">3,145,900.00</span>
                    </div>
                </div>

            </div>
        </div>
    </div>

<script>
    // --- CORE LOGIC ---
    const GOD_USERS = ['voluntaryistj@gmail.com', 'drfrost.frostchain'];
    let user = { id: 'Guest', fszt: 0, role: 'passenger' };
    let currentYear = 2026;

    // DATA API
    const scenarios = {
        "2010": { text: "ARRIVAL: 2010. The Eminem 'Recovery' era. You are at the Fremont Fair.", choices: [ {l:"TEXT SHELLY", r:"You sent the text. No reply yet."}, {l:"WALK AWAY", r:"You left the fairgrounds."}, {l:"BUY TICKET", r:"You bought a ride ticket. Paradox avoided."} ] },
        "1985": { text: "ARRIVAL: 1985. The air smells like ozone and hairspray. No internet signal.", choices: [ {l:"FIND DOC", r:"Doc isn't here."}, {l:"INVEST APPLE", r:"Smart move. Ledger updated."}, {l:"DANCE", r:"Enchantment Under the Sea."} ] },
        "2026": { text: "PRESENT DAY. Frostchain Mainnet is live. System nominal.", choices: [ {l:"MINING", r:"Hashrate increased."}, {l:"TRADING", r:"Order placed on Dex."}, {l:"SLEEP", r:"Resting mode engaged."} ] }
    };

    function authenticate() {
        const id = document.getElementById('loginId').value.trim();
        if(!id) return alert("IDENTITY REQUIRED");
        
        user.id = id;
        
        // GOD MODE CHECK
        if(GOD_USERS.includes(id)) {
            user.fszt = 999999999;
            user.role = 'ARCHITECT';
            document.getElementById('user-badge').innerHTML = `IDENTITY: ${id} <span style="color:#0f0">[GOD MODE]</span>`;
        } else {
            user.fszt = 5.00;
            user.role = 'PILOT';
            document.getElementById('user-badge').innerText = `IDENTITY: ${id}`;
        }

        document.getElementById('loginScreen').style.display = 'none';
        document.getElementById('dashboard').style.display = 'block';
        updateUI();
        log("Identity Verified. Welcome, " + user.role + ".");
        
        // Start Price Ticker
        setInterval(() => {
            let doge = 0.35 + (Math.random() * 0.02);
            document.getElementById('frst-price').innerText = "$" + (doge * 3.14159).toFixed(4);
        }, 3000);
    }

    function updateUI() {
        let displayBal = user.fszt > 900000 ? "♾️ INFINITE" : user.fszt.toFixed(2) + " FsZT";
        document.getElementById('fszt-bal').innerText = displayBal;
    }

    function log(msg, type='sys') {
        const win = document.getElementById('terminal-window');
        win.innerHTML += `<div class="msg msg-${type}">${msg}</div>`;
        win.scrollTop = win.scrollHeight;
    }

    function handleCommand() {
        const input = document.getElementById('cmd-input');
        const cmd = input.value.trim();
        if(!cmd) return;
        
        log(cmd, 'user');
        input.value = '';

        // Check if Year
        if(parseInt(cmd) > 1000 && parseInt(cmd) < 3000) {
            jump(cmd);
        } else {
            setTimeout(() => log("Command processed: " + cmd, 'ai'), 500);
        }
    }

    function jump(year) {
        if(user.fszt < 2 && user.fszt !== 999999999) return log("INSUFFICIENT FUEL (FsZT).", 'sys');
        
        log(`INITIATING JUMP TO ${year}...`, 'sys');
        
        setTimeout(() => {
            if(user.fszt !== 999999999) user.fszt -= 2;
            updateUI();
            
            currentYear = year;
            document.getElementById('date-display').innerText = year;
            
            let scene = scenarios[year] || { text: `ARRIVAL: ${year}. Data sparse. Scanning environment...`, choices: [{l:"SCAN", r:"Scan complete. Nothing found."}, {l:"ABORT", r:"Returning to 2026."}] };
            
            log(scene.text, 'ai');
            renderChoices(scene.choices);
        }, 1500);
    }

    function renderChoices(opts) {
        const area = document.getElementById('choices-area');
        area.innerHTML = '';
        opts.forEach(o => {
            let btn = document.createElement('button');
            btn.className = 'btn-choice';
            btn.innerText = o.l;
            btn.onclick = () => {
                log(`CHOICE: ${o.l}`, 'user');
                setTimeout(() => log(o.r, 'ai'), 600);
            };
            area.appendChild(btn);
        });
    }

    function wrapTokens() {
        alert("Grayson API: Converting FRST to FsZT...");
    }

</script>
</body>
</html>
EOF

