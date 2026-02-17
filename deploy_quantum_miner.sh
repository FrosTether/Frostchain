#!/bin/bash

echo "❄️  INITIALIZING FROSTCHAIN QUANTUM AUDIO MINER..."

# 1. Environment Setup
if ! command -v node &> /dev/null; then
    echo "🔧 Installing Node.js..."
    if [ -x "$(command -v pkg)" ]; then pkg install nodejs -y; fi
    if [ -x "$(command -v apt)" ]; then sudo apt update && sudo apt install nodejs -y; fi
fi

if ! command -v surge &> /dev/null; then
    echo "🔧 Installing Surge..."
    npm install -g surge
fi

# 2. Directory Setup
mkdir -p frostchain-quantum-miner/public
cd frostchain-quantum-miner/public
echo "📂 Setting up public directory..."

# 3. WRITE THE MINER HTML/JS
cat <<'HTML' > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>❄️ Frostchain Quantum Audio Miner</title>
    <style>
        body { font-family: monospace; background: #000; color: #0f0; }
        canvas { border: 1px solid #0f0; }
        select, button, input { background: #111; color: #0f0; border: 1px solid #0f0; }
    </style>
</head>
<body>
    <h1>❄️ FROSTCHAIN: QUANTUM AUDIO MINER</h1>
    <p><strong>The First Bio-Digital Consensus Engine</strong></p>
    <p><em>Mining via Proof-of-Resonance (PoR)</em></p>

    <h2>Identity Gating</h2>
    <input type="text" id="identity" placeholder="Enter your .frostchain or .base.eth name">
    <button onclick="gateIdentity()">Enter</button>
    <p id="walletStatus"></p>

    <h2>Brainwave Mode</h2>
    <select id="mode">
        <option value="DELTA">DELTA (π Hz - Deep Sleep / Healing)</option>
        <option value="THETA">THETA (7.83 Hz - Dreaming / Creation)</option>
        <option value="ALPHA" selected>ALPHA (11.11 Hz - Relaxed Focus)</option>
        <option value="GAMMA">GAMMA (40 Hz - Peak Cognition)</option>
    </select>

    <h2>Solfeggio Carrier Wave</h2>
    <p>Current Frequency: <span id="carrier">528 Hz (MIRACLE)</span></p>

    <button onclick="startMining()">Start Mining</button>
    <button onclick="stopMining()">Stop Mining</button>
    <button onclick="withdraw()">Withdraw</button>

    <h2>The Tangle Visualizer</h2>
    <canvas id="tangle" width="800" height="400"></canvas>

    <h2>Mining Log</h2>
    <pre id="log"></pre>

    <script>
        // --- CONFIGURATION ---
        const NewkirkKey = "KELSEE_NEWKIRK_GENESIS_KEY_0824";
        const PseudoXMRContract = "4AEreXjDoq8AThWXzWz1Vu4nt7PNL6wPf6sWpsLFgR9b1srgqFDQTsvP6tCwQQ17NeAtMaRwZ5CymSSTqy8dSsZMEVV48Ab";
        const GenesisIdentity = PseudoXMRContract;
        const BlockTime = 300 * 1000; // 5 minutes in ms
        const SolfeggioFrequencies = [174, 285, 396, 417, 528, 639, 741, 852, 963];
        const BrainwaveOffsets = { DELTA: Math.PI, THETA: 7.83, ALPHA: 11.11, GAMMA: 40 };

        let audioCtx, oscA, oscB, noise, gainNode, pannerA, pannerB, miningInterval;
        let minerID = "";
        let walletPassword = "";
        let carrierFreq = 528; // Default MIRACLE
        let blockchain = { chain: [], pendingTx: [] }; // Simulated blockchain

        // --- IDENTITY GATING ---
        function gateIdentity() {
            const input = document.getElementById('identity').value.trim();
            if (input.endsWith('.frostchain') || input.endsWith('.base.eth')) {
                const password = prompt('Set a password for your wallet:');
                if (password && password.trim() !== '') {
                    minerID = input;
                    walletPassword = password;
                    createWallet();
                    logMessage(`✅ Access Granted: ${minerID} [Verified via ${NewkirkKey}]`);
                } else {
                    logMessage('❌ Password required to create wallet.');
                }
            } else {
                logMessage('❌ Invalid Identity. Must end with .frostchain or .base.eth');
            }
        }

        function createWallet() {
            // Simulate creating wallet.dat with password (note: in real apps, hash the password)
            const walletContent = `Frostchain Wallet\nOwner: ${minerID}\nPassword: ${walletPassword}\nCreated: ${new Date().toISOString()}\n`;
            const blob = new Blob([walletContent], { type: 'text/plain' });
            const a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = 'wallet.dat';
            a.click();
            document.getElementById('walletStatus').textContent = '✅ wallet.dat created and downloaded.';
        }

        // --- AUDIO SETUP (Proof-of-Resonance) ---
        function initAudio() {
            audioCtx = new (window.AudioContext || window.webkitAudioContext)();
            gainNode = audioCtx.createGain();
            gainNode.gain.value = 0.1; // Low volume

            // Oscillator A (Left)
            oscA = audioCtx.createOscillator();
            oscA.type = 'sine';
            pannerA = audioCtx.createStereoPanner();
            pannerA.pan.value = -1; // Left ear
            oscA.connect(pannerA).connect(gainNode).connect(audioCtx.destination);

            // Oscillator B (Right)
            oscB = audioCtx.createOscillator();
            oscB.type = 'sine';
            pannerB = audioCtx.createStereoPanner();
            pannerB.pan.value = 1; // Right ear
            oscB.connect(pannerB).connect(gainNode).connect(audioCtx.destination);

            // Pink Noise Floor
            noise = audioCtx.createBufferSource();
            const bufferSize = audioCtx.sampleRate * 2;
            const buffer = audioCtx.createBuffer(1, bufferSize, audioCtx.sampleRate);
            const data = buffer.getChannelData(0);
            let lastOut = 0.0;
            for (let i = 0; i < bufferSize; i++) {
                const white = Math.random() * 2 - 1;
                data[i] = (lastOut + (0.02 * white)) / 1.02;
                lastOut = data[i];
                data[i] *= 3.5; // Roughly normalize
            }
            noise.buffer = buffer;
            noise.loop = true;
            const noiseGain = audioCtx.createGain();
            noiseGain.gain.value = 0.005; // Very low
            noise.connect(noiseGain).connect(audioCtx.destination);
        }

        function startAudio() {
            if (!audioCtx) initAudio();
            const mode = document.getElementById('mode').value;
            const offset = BrainwaveOffsets[mode];
            oscA.frequency.value = carrierFreq;
            oscB.frequency.value = carrierFreq + offset;
            oscA.start();
            oscB.start();
            noise.start();
            logMessage(`🎵 Audio Started: Left ${carrierFreq} Hz, Right \( {carrierFreq + offset} Hz ( \){mode} Mode)`);
        }

        function stopAudio() {
            if (audioCtx) {
                oscA.stop();
                oscB.stop();
                noise.stop();
                audioCtx.close();
                audioCtx = null;
                logMessage('🔇 Audio Stopped');
            }
        }

        // --- TANGLE VISUALIZER ---
        const canvas = document.getElementById('tangle');
        const ctx = canvas.getContext('2d');
        let particles = [];
        for (let i = 0; i < 150; i++) {
            particles.push({
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                vx: (Math.random() - 0.5) * 2,
                vy: (Math.random() - 0.5) * 2
            });
        }

        function drawTangle() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            const mode = document.getElementById('mode').value;
            const speed = { DELTA: 0.5, THETA: 1, ALPHA: 1.5, GAMMA: 3 }[mode];

            particles.forEach(p => {
                p.x += p.vx * speed;
                p.y += p.vy * speed;
                if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
                if (p.y < 0 || p.y > canvas.height) p.vy *= -1;

                ctx.beginPath();
                ctx.arc(p.x, p.y, 3, 0, 2 * Math.PI);
                ctx.fillStyle = '#0f0';
                ctx.fill();
            });

            // Connect nearby particles
            for (let i = 0; i < particles.length; i++) {
                for (let j = i + 1; j < particles.length; j++) {
                    const dist = Math.hypot(particles[i].x - particles[j].x, particles[i].y - particles[j].y);
                    if (dist < 50) {
                        ctx.beginPath();
                        ctx.moveTo(particles[i].x, particles[i].y);
                        ctx.lineTo(particles[j].x, particles[j].y);
                        ctx.strokeStyle = `rgba(0,255,0,${1 - dist/50})`;
                        ctx.stroke();
                    }
                }
            }

            requestAnimationFrame(drawTangle);
        }
        drawTangle();

        // Mouse interaction
        canvas.addEventListener('mousemove', e => {
            const rect = canvas.getBoundingClientRect();
            const mx = e.clientX - rect.left;
            const my = e.clientY - rect.top;
            particles.forEach(p => {
                const dx = mx - p.x;
                const dy = my - p.y;
                const dist = Math.hypot(dx, dy);
                if (dist < 100) {
                    p.vx += dx / dist * 0.1;
                    p.vy += dy / dist * 0.1;
                }
            });
        });

        // --- MINING LOGIC ---
        function createGenesisBlock() {
            return { index: 0, timestamp: Date.now(), prevHash: '0000', hash: 'genesis', validator: GenesisIdentity };
        }

        function mineBlock() {
            if (!minerID) {
                logMessage('❌ Identity Required to Mine');
                return;
            }
            // Roll Quantum Dice for new carrier
            carrierFreq = SolfeggioFrequencies[Math.floor(Math.random() * SolfeggioFrequencies.length)];
            document.getElementById('carrier').textContent = `${carrierFreq} Hz`;

            // Simulate Hyper-Sync and Mine
            logMessage('⚡ Hyper-Sync Initiated...');
            setTimeout(() => {
                const prev = blockchain.chain[blockchain.chain.length - 1];
                const newBlock = {
                    index: prev.index + 1,
                    timestamp: Date.now(),
                    prevHash: prev.hash,
                    hash: Math.random().toString(36).substring(2), // Simulated hash
                    validator: minerID,
                    carrier: carrierFreq
                };
                blockchain.chain.push(newBlock);
                logMessage(`❄️ BLOCK #${newBlock.index} MINED\n   - Hash: ${newBlock.hash.substring(0,16)}...\n   - Carrier: ${carrierFreq} Hz\n   - Auth: ${NewkirkKey}`);
            }, 4000); // 4s sync
        }

        function startMining() {
            if (!minerID) return;
            startAudio();
            mineBlock(); // Initial mine
            miningInterval = setInterval(mineBlock, BlockTime);
            logMessage('🚀 Mining Started');
        }

        function stopMining() {
            stopAudio();
            clearInterval(miningInterval);
            logMessage('🛑 Mining Stopped');
        }

        // --- WITHDRAWAL (Graysons API) ---
        function withdraw() {
            if (!minerID) return;
            const amount = prompt('Enter amount to withdraw:');
            const to = prompt('Enter destination address:');
            if (amount && to) {
                logMessage(`🔄 Using Graysons Wallet API to withdraw ${amount} to ${to}...`);
                setTimeout(() => {
                    logMessage('✅ Withdrawal processed via Graysons API.');
                }, 2000); // Simulate API call
            }
        }

        // --- UTILS ---
        function logMessage(msg) {
            document.getElementById('log').textContent += msg + '\n';
        }

        // Init Blockchain
        blockchain.chain.push(createGenesisBlock());
        logMessage(`🔑 Newkirk Key Injected: ${NewkirkKey}`);
        logMessage(`🆔 Pseudo XMR Contract: ${PseudoXMRContract}`);
    </script>
</body>
</html>
HTML

# 4. DEPLOY TO SURGE
echo "🚀 Deploying Frontend to Surge..."
surge . frost-miner.surge.sh

