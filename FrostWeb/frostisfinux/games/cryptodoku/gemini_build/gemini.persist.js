const DB_NAME = "gemini_state";
const STORE = "state";

function openDB() {
  return new Promise((res, rej) => {
    const req = indexedDB.open(DB_NAME, 1);
    req.onupgradeneeded = e => e.target.result.createObjectStore(STORE);
    req.onsuccess = e => res(e.target.result);
    req.onerror = rej;
  });
}

export async function saveState(state) {
  const db = await openDB();
  const tx = db.transaction(STORE, "readwrite");
  tx.objectStore(STORE).put(state, "main");
}

export async function loadState() {
  const db = await openDB();
  return new Promise(res => {
    const tx = db.transaction(STORE, "readonly");
    const req = tx.objectStore(STORE).get("main");
    req.onsuccess = () => res(req.result || null);
  });
}
