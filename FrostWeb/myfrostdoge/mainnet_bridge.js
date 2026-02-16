// FAI ♍ RPC BRIDGE v1.0
const BLOCKCYPHER_API = "https://api.blockcypher.com/v1/doge/main";

async function broadcastToMainnet(signedTx) {
    console.log("> INJECTING_TO_RPC_NODE...");
    try {
        const response = await fetch(`${BLOCKCYPHER_API}/txs/push`, {
            method: 'POST',
            body: JSON.stringify({ tx: signedTx }),
            headers: { 'Content-Type': 'application/json' }
        });
        const data = await response.json();
        return data.tx.hash;
    } catch (error) {
        console.error("> RPC_INJECTION_FAILED:", error);
        return null;
    }
}
