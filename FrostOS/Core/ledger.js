const Ledger = {
    init() { return JSON.parse(localStorage.getItem('sov_ledger') || '{"legacy":500,"sovereign":0,"treasury":16000}'); },
    save(d) { localStorage.setItem('sov_ledger', JSON.stringify(d)); }
};
