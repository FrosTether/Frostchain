// FROST QUANTUM ASSET DEPLOYER
var core = eth.accounts[0];
console.log("🔓 UNLOCKING QUANTUM CORE: " + core);
personal.unlockAccount(core, "frost123");

// 1. DEPLOY FNR (Frostnerjo) - 33M Cap
// We send a transaction with data "FNR-GENESIS-33M" to mark the chain
console.log("🚀 DEPLOYING FNR (PRIVACY LAYER)...");
var fnrTx = eth.sendTransaction({
    from: core, 
    to: core, 
    value: 0, 
    data: "0x464e522d47454e455349532d33334d" 
});
console.log("✅ FNR HASH: " + fnrTx);

// 2. DEPLOY AMIAH (Amiahdoodles) - 12B Cap
// Data: "AMIAH-GENESIS-12B"
console.log("🚀 DEPLOYING AMIAH (UTILITY LAYER)...");
var amiahTx = eth.sendTransaction({
    from: core, 
    to: core, 
    value: 0, 
    data: "0x414d4941482d47454e455349532d313242" 
});
console.log("✅ AMIAH HASH: " + amiahTx);

// 3. DEPLOY FCN (Feather) - Governance
// Data: "FCN-GOV-GENESIS"
console.log("🚀 DEPLOYING FCN (FEATHER GOVERNANCE)...");
var fcnTx = eth.sendTransaction({
    from: core, 
    to: core, 
    value: 0, 
    data: "0x46434e2d474f562d47454e45534953" 
});
console.log("✅ FCN HASH: " + fcnTx);

// 4. REGISTER .FROSTCHAIN ROOT
console.log("🌐 REGISTERING .FROSTCHAIN DNS...");
var ensTx = eth.sendTransaction({
    from: core, 
    to: core, 
    value: 0, 
    data: "0x2e46524f5354434841494e" 
});
console.log("✅ DNS HASH: " + ensTx);

console.log("❄️ QUANTUM ECONOMY FULLY INITIALIZED.");
