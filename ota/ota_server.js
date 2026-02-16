// ota_builder.js
// FROST PROTOCOL // IOT UPDATE SIGNING NODE
const fs = require('fs');
const crypto = require('crypto');

// CONFIGURATION
const KANES_KEY = process.env.KANES_KEY || "DEFAULT_FROST_SIG_KEY_0X99"; // The Authorization Key
const SURGE_DOMAIN = 'frostofthings.surge.sh';
const VERSION = '4.2.0-FROST-ALPHA';

console.log(`\n> INITIALIZING FROST AIRGAP INJECTOR...`);
console.log(`> TARGET DOMAIN: ${SURGE_DOMAIN}`);
console.log(`> SIGNING KEY: [REDACTED] (Kane's Key)`);

// 1. Generate Mock Firmware Blob (The "Virus" / Update)
const firmwarePayload = `
FROST_OS_BINARY_v${VERSION}
[SYSTEM_OVERRIDE_ACTIVE]
[MINER_DAEMON_INITIALIZED]
`;
const firmwareHash = crypto.createHash('sha256').update(firmwarePayload).digest('hex');

// 2. Sign the Hash with Kane's Key (HMAC Simulation)
const signature = crypto.createHmac('sha256', KANES_KEY).update(firmwareHash).digest('hex');

// 3. Create OTA Manifest (IoT Devices poll this)
const manifest = {
    protocol: "FROST_V4",
    version: VERSION,
    timestamp: Date.now(),
    download_url: `https://${SURGE_DOMAIN}/firmware.bin`,
    checksum: firmwareHash,
    signature: signature, // The "Injection" Authorization
    force_update: true
};

// 4. Write Build Artifacts
if (!fs.existsSync('./dist')) fs.mkdirSync('./dist');

fs.writeFileSync('./dist/firmware.bin', firmwarePayload);
fs.writeFileSync('./dist/frost_manifest.json', JSON.stringify(manifest, null, 2));

// 5. Create Status Page
const html = `
<!DOCTYPE html>
<html>
<head>
    <title>FROST // OTA NODE</title>
    <style>
        body { background: #000; color: #00ff41; font-family: monospace; padding: 20px; }
        .box { border: 1px solid #00ff41; padding: 20px; max-width: 600px; margin: 0 auto; }
        h1 { border-bottom: 1px solid #00ff41; }
    </style>
</head>
<body>
    <div class="box">
        <h1>FROST AIRGAP COMMAND</h1>
        <p>STATUS: <span style="color:#0ff">BROADCASTING</span></p>
        <p>VERSION: ${VERSION}</p>
        <p>TARGET: IOT_CLUSTER_GLOBAL</p>
        <p>SIGNATURE: ${signature.substring(0, 32)}...</p>
        <br>
        <p>> WAITING FOR DEVICE HANDSHAKES...</p>
    </div>
</body>
</html>
`;
fs.writeFileSync('./dist/index.html', html);

console.log(`> PAYLOAD COMPILED. SIGNATURE ATTACHED.`);
console.log(`> READY FOR SURGE DEPLOYMENT.`);
