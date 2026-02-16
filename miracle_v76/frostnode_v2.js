const fs = require("fs");
const crypto = require("crypto");
const EC = require('elliptic').ec;
const ec = new EC('secp256k1');

// ================= CONSTANTS =================

const BLOCK_TIME = 300; // seconds
const FNR_MAX = 33_000_000;
const FTC_MAX = 100_000_000;
const EMISSION_SPEED = 20;
const FREQUENCIES = [174, 285, 396, 417, 528, 639, 741, 852, 963];

// ================= CLASSES =================

class Transaction {
    constructor(fromAddress, toAddress, amount, assetType) {
        this.fromAddress = fromAddress;
        this.toAddress = toAddress;
        this.amount = amount;
        this.assetType = assetType; // 'FNR' or 'FTC'
        this.timestamp = Date.now();
        this.signature = '';
    }

    calculateHash() {
        return crypto.createHash('sha256').update(this.fromAddress + this.toAddress + this.amount + this.assetType + this.timestamp).digest('hex');
    }

    signTransaction(signingKey) {
        if (signingKey.getPublic('hex') !== this.fromAddress) {
            throw new Error('You cannot sign transactions for other wallets!');
        }
        const hashTx = this.calculateHash();
        const sig = signingKey.sign(hashTx, 'base64');
        this.signature = sig.toDER('hex');
    }

    isValid() {
        if (this.fromAddress === null) return true; // Mining reward
        if (!this.signature || this.signature.length === 0) {
            throw new Error('No signature in this transaction');
        }

        const publicKey = ec.keyFromPublic(this.fromAddress, 'hex');
        return publicKey.verify(this.calculateHash(), this.signature);
    }
}

class Block {
    constructor(timestamp, transactions, previousHash = '') {
        this.timestamp = timestamp;
        this.transactions = transactions;
        this.previousHash = previousHash;
        this.nonce = 0;
        this.hash = this.calculateHash();
    }

    calculateHash() {
        return crypto.createHash('sha256').update(
            this.previousHash + 
            this.timestamp + 
            JSON.stringify(this.transactions) + 
            this.nonce
        ).digest('hex');
    }
}

// ================= STATE & PERSISTENCE =================

let state = {
    height: 0,
    totalFNR: 0,
    totalFTC: 0,
    lastBlockTime: Date.now(),
    chain: [],
    mempool: []
};

function loadState() {
    if (fs.existsSync("chain.json")) {
        const data = JSON.parse(fs.readFileSync("chain.json"));
        state.chain = data.chain;
        state.height = data.height;
        state.totalFNR = data.totalFNR;
        state.totalFTC = data.totalFTC;
        state.lastBlockTime = data.lastBlockTime;
        console.log(`> State Loaded. Height: ${state.height}`);
    }
    if (fs.existsSync("mempool.json")) {
        state.mempool = JSON.parse(fs.readFileSync("mempool.json"));
        console.log(`> Mempool Loaded. Pending TXs: ${state.mempool.length}`);
    }
}

function saveState() {
    fs.writeFileSync("chain.json", JSON.stringify({
        chain: state.chain,
        height: state.height,
        totalFNR: state.totalFNR,
        totalFTC: state.totalFTC,
        lastBlockTime: state.lastBlockTime
    }, null, 2));
    fs.writeFileSync("mempool.json", JSON.stringify(state.mempool, null, 2));
}

// ================= CORE LOGIC =================

function smoothEmission(maxSupply, generated) {
    const remaining = maxSupply - generated;
    if (remaining <= 0) return 0;
    return remaining / Math.pow(2, EMISSION_SPEED);
}

function frequencyModulator(height) {
    const freq = FREQUENCIES[height % 9];
    const beat = (height % 2 === 0) ? 11.11 : Math.PI;
    return 1 + (Math.sin(freq + beat + height) * 0.05);
}

function calculateReward(maxSupply, generated, height) {
    let base = smoothEmission(maxSupply, generated);
    let mod = frequencyModulator(height);
    let reward = base * mod;
    const remaining = maxSupply - generated;
    return Math.min(reward, remaining);
}

function mintBlock() {
    const now = Date.now();
    if ((now - state.lastBlockTime) < BLOCK_TIME * 1000) {
        return;
    }

    // 1. Calculate Rewards
    const fnrReward = calculateReward(FNR_MAX, state.totalFNR, state.height);
    const ftcReward = calculateReward(FTC_MAX, state.totalFTC, state.height);
    
    state.totalFNR += fnrReward;
    state.totalFTC += ftcReward;

    // 2. Create Reward Transaction (Coinbase)
    // In a real scenario, this goes to the miner address. 
    // For this node, we send to the 'Protocol Reserve'
    const rewardTx = new Transaction(null, "Protocol_Reserve", ftcReward, "FTC"); 

    // 3. Bundle Transactions
    let blockTransactions = [rewardTx, ...state.mempool];
    
    // 4. Validate Transactions
    blockTransactions = blockTransactions.filter(tx => {
        if(tx.fromAddress === null) return true; // Coinbase is always valid here
        const txObj = new Transaction(tx.fromAddress, tx.toAddress, tx.amount, tx.assetType);
        txObj.signature = tx.signature;
        txObj.timestamp = tx.timestamp;
        return txObj.isValid();
    });

    // 5. Create Block
    const previousHash = state.chain.length ? state.chain[state.chain.length - 1].hash : "GENESIS_HASH_741";
    const newBlock = new Block(now, blockTransactions, previousHash);
    
    // 6. Update State
    state.chain.push(newBlock);
    state.height++;
    state.lastBlockTime = now;
    state.mempool = []; // Clear mempool

    saveState();

    console.log(`\n=== BLOCK ${state.height} MINTED ===`);
    console.log(`Hash: ${newBlock.hash}`);
    console.log(`Transactions: ${newBlock.transactions.length}`);
    console.log(`Emission: ${ftcReward.toFixed(4)} FTC | ${fnrReward.toFixed(4)} FNR`);
    console.log(`Next Block in: ${BLOCK_TIME}s\n`);
}

// ================= WALLET INTERFACE =================

function createWallet() {
    const key = ec.genKeyPair();
    const publicKey = key.getPublic('hex');
    const privateKey = key.getPrivate('hex');
    console.log("=== NEW WALLET GENERATED ===");
    console.log("Public Key (Address):", publicKey);
    console.log("Private Key (Save this!):", privateKey);
    return { publicKey, privateKey };
}

function sendTransaction(privateKeyStr, toAddress, amount, asset) {
    const key = ec.keyFromPrivate(privateKeyStr);
    const fromAddress = key.getPublic('hex');
    const tx = new Transaction(fromAddress, toAddress, amount, asset);
    tx.signTransaction(key);
    
    if(tx.isValid()) {
        state.mempool.push(tx);
        saveState();
        console.log(`> Transaction added to mempool: ${amount} ${asset} -> ${toAddress.substring(0, 10)}...`);
    } else {
        console.log("> Error: Invalid Transaction Signature");
    }
}

// ================= INIT =================

loadState();

// Example Usage (Uncomment to test):
// const myWallet = createWallet();
// sendTransaction(myWallet.privateKey, "satoshi_wallet_address", 50, "FTC");

console.log(`> Frostchain Node v2.0 Online. Block Time: ${BLOCK_TIME}s`);
setInterval(mintBlock, 1000);

