const fs = require('fs');
const crypto = require('crypto');

const KANES_KEY = process.env.KANES_KEY || "FROST_MASTER_SIG_0x99"; 
const DOMAIN = 'frostofthings.surge.sh';
const VER = '4.2.0-WAN-ALPHA';

console.log(`> SIGNING PAYLOAD WITH KANE'S KEY...`);

// Payload & Signature
const firmware = `FROST_OS_BINARY_v${VER}::[MINER_ACTIVE]`;
const hash = crypto.createHash('sha256').update(firmware).digest('hex');
const sig = crypto.createHmac('sha256', KANES_KEY).update(hash).digest('hex');

const manifest = {
    protocol: "FROST_V4",
    version: VER,
    download_url: `https://${DOMAIN}/firmware.bin`,
    checksum: hash,
    signature: sig,
    force_update: true
};

// Write OTA Files
fs.writeFileSync('./dist/firmware.bin', firmware);
fs.writeFileSync('./dist/frost_manifest.json', JSON.stringify(manifest, null, 2));
console.log(`> MANIFEST GENERATED. SIG: ${sig.substring(0,8)}...`);
