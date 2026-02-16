const fs = require('fs');
const crypto = require('crypto');

// CONFIGURATION
const KANES_KEY = process.env.KANES_KEY || "FROST_MASTER_KEY_0x99"; 
const SURGE_DOMAIN = 'frostofthings.surge.sh';
const VERSION = '4.2.0-FROST-OTA';

console.log(`\n> INITIALIZING FROST AIRGAP INJECTOR...`);
console.log(`> TARGET: ${SURGE_DOMAIN}`);

// 1. Generate Firmware
const firmwarePayload = `FROST_OS_BINARY_v${VERSION}::[MINER_ACTIVE]`;
const firmwareHash = crypto.createHash('sha256').update(firmwarePayload).digest('hex');

// 2. Sign with Kane's Key
const signature = crypto.createHmac('sha256', KANES_KEY).update(firmwareHash).digest('hex');

// 3. Create Manifest
const manifest = {
    protocol: "FROST_V4",
    version: VERSION,
    download_url: `https://${SURGE_DOMAIN}/firmware.bin`,
    checksum: firmwareHash,
    signature: signature,
    force_update: true
};

// 4. Write Files
if (!fs.existsSync('./dist')) fs.mkdirSync('./dist');
fs.writeFileSync('./dist/firmware.bin', firmwarePayload);
fs.writeFileSync('./dist/frost_manifest.json', JSON.stringify(manifest, null, 2));

// 5. Index Page
const html = `<html><body style="background:#000;color:#0f0;font-family:monospace">
<h1>FROST // OTA NODE</h1><p>STATUS: BROADCASTING</p><p>SIG: ${signature}</p>
</body></html>`;
fs.writeFileSync('./dist/index.html', html);

console.log(`> PAYLOAD SIGNED & COMPILED.`);
