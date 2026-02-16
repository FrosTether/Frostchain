const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require("fs");
const crypto = require("crypto");
const EC = require('elliptic').ec;
const ec = new EC('secp256k1');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// ================= CONSTANTS & STATE =================
const BLOCK_TIME = 300; 
const FNR_MAX = 33_000_000;
const FTC_MAX = 100_000_000;
const FREQUENCIES = [174, 285, 396, 417, 528, 639, 741, 852, 963];

let state = {
    height: 0,
    totalFNR: 0,
    totalFTC: 0,
    lastBlockTime: Date.now(),
    chain: [],
    mempool: [],
    chat: [] // FrostChat Relay Storage
};

// ================= PERSISTENCE =================
function loadState() {
    if (fs.existsSync("chain.json")) {
        const data = JSON.parse(fs.readFileSync("chain.json"));
        state.chain = data.chain || [];
        state.height = data.height || 0;
        state.totalFNR = data.totalFNR || 0;
        state.totalFTC = data.totalFTC || 0;
        state.lastBlockTime = data.lastBlockTime || Date.now();
        state.chat = data.chat || [];
    }
}

function saveState() {
    fs.writeFileSync("chain.json", JSON.stringify(state, null, 2));
}

// ================= CORE LOGIC =================
function smoothEmission(maxSupply, generated) {
    const remaining = maxSupply - generated;
    if (remaining <= 0) return 0;
    return remaining / Math.pow(2, 20); // Emission speed factor
}

function calculateReward(maxSupply, generated) {
    // 1/9th Reservoir Logic implemented via Modulo in Frontend, 
    // but globally we enforce the max cap here.
    return Math.min(13.37, maxSupply - generated); // Hard cap 13.37 per block
}

function mintBlock() {
    const now = Date.now();
    // Enforce 300s Block Time (Simulated acceleration for demo if needed, currently strict)
    if ((now - state.lastBlockTime) < BLOCK_TIME * 1000) return null;

    const ftcReward = calculateReward(FTC_MAX, state.totalFTC);
    const fnrReward = 2.5; // Fixed XMR Contract Reward

    state.totalFNR += fnrReward;
    state.totalFTC += ftcReward;

    const block = {
        index: state.height + 1,
        timestamp: now,
        transactions: state.mempool,
        rewards: { ftc: ftcReward, fnr: fnrReward },
        hash: crypto.createHash('sha256').update(now + JSON.stringify(state.mempool)).digest('hex')
    };

    state.chain.push(block);
    state.height++;
    state.lastBlockTime = now;
    state.mempool = [];
    saveState();
    
    return block;
}

// ================= API ROUTES =================

// 1. Get Node Stats (Frontend Polls This)
app.get('/stats', (req, res) => {
    res.json({
        height: state.height,
        supply: { ftc: state.totalFTC, fnr: state.totalFNR },
        lastBlockTime: state.lastBlockTime,
        nextBlockIn: Math.max(0, BLOCK_TIME - Math.floor((Date.now() - state.lastBlockTime)/1000))
    });
});

// 2. FrostChat Relay
app.get('/chat', (req, res) => res.json(state.chat.slice(-50)));
app.post('/chat', (req, res) => {
    const { user, msg } = req.body;
    if(user && msg) {
        state.chat.push({ user, msg, time: Date.now() });
        if(state.chat.length > 100) state.chat.shift();
        saveState();
        res.json({ status: 'sent' });
    }
});

// 3. Trigger Mint (Frontend "Mine" button pings this)
app.post('/mine', (req, res) => {
    const block = mintBlock();
    if(block) {
        res.json({ success: true, block });
    } else {
        res.json({ success: false, msg: "Block time not met yet." });
    }
});

// 4. Submit Transaction
app.post('/tx', (req, res) => {
    const { from, to, amount, signature } = req.body;
    // (Signature validation would happen here using elliptic)
    state.mempool.push({ from, to, amount, signature, ts: Date.now() });
    res.json({ status: 'Mempool accepted' });
});

// ================= START =================
loadState();
setInterval(mintBlock, 1000); // Check for mint condition every second
app.listen(3000, () => console.log('❄️ Frostchain Core v76.0 Running on Port 3000'));
