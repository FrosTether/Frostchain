const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const fs = require('fs');

const app = express();
const PORT = 3000;
const LEDGER_FILE = 'ledger.json';

app.use(cors());
app.use(bodyParser.json());

let ledger = {};
if (fs.existsSync(LEDGER_FILE)) {
    try { ledger = JSON.parse(fs.readFileSync(LEDGER_FILE)); } catch(e) {}
}

function saveLedger() {
    fs.writeFileSync(LEDGER_FILE, JSON.stringify(ledger, null, 2));
}

// --- API ENDPOINTS ---

// Handshake
app.post('/api/connect', (req, res) => {
    const { identity } = req.body;
    if (!identity) return res.status(400).json({ error: "Identity required" });
    
    if (!ledger[identity]) {
        ledger[identity] = { frst: 0.00, fnr: 0.00, ftc: 0.00, ftr: 0.00, timestamp: Date.now() };
        saveLedger();
    }
    res.json({ status: "CONNECTED", identity, contract: "4AEreX...48Ab" });
});

// Mining Loop
app.post('/api/mine', (req, res) => {
    const { identity, rate } = req.body;
    if (!ledger[identity]) return res.status(404).json({ error: "Wallet not found" });

    // Yield Logic
    ledger[identity].frst += (Math.random() * 0.05) * rate;
    ledger[identity].fnr  += (Math.random() * 0.01) * rate;
    ledger[identity].ftc  += (Math.random() * 0.20) * rate;
    ledger[identity].ftr  += (Math.random() * 0.50) * rate;
    ledger[identity].timestamp = Date.now();
    
    saveLedger();
    res.json(ledger[identity]);
});

// FROSTSCAN: Dump the full ledger
app.get('/api/frostscan', (req, res) => {
    res.json(ledger);
});

app.listen(PORT, () => {
    console.log(`❄️  GRAYSON API ACTIVE on PORT ${PORT}`);
});
