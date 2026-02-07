const Ledger = {
    state: { 
        ftc: 50, pending: 0, pool_cap: 13.37, 
        launch_date: new Date("2026-02-24T00:00:00Z").getTime(),
        connected: false, fnr: 100
    },
    init() { 
        let s = JSON.parse(localStorage.getItem('frost_rc337'));
        if(s) this.state = s;
        return this.state;
    },
    save() { localStorage.setItem('frost_rc337', JSON.stringify(this.state)); },

    spinSlots(bet) {
        if(this.state.fnr < bet) return { win: 0, symbols: ['❌','❌','❌'], hash: 'INS_FUNDS' };
        this.state.fnr -= bet;
        const seed = Math.random().toString(36).substring(2);
        const roll = Math.random();
        let res = ['💀','💀','💀']; let win = 0;
        
        if(roll < 0.1) { res=['7️⃣','7️⃣','7️⃣']; win = bet * 10; }
        else if(roll < 0.3) { res=['💎','💎','💎']; win = bet * 5; }
        else {
            const syms = ['🍒','🍋','💎','7️⃣','💀'];
            res = [syms[Math.floor(Math.random()*5)], syms[Math.floor(Math.random()*5)], syms[Math.floor(Math.random()*5)]];
        }
        
        if(win > 0) { this.state.ftc += (win * 0.1); this.sfx('jackpot'); }
        this.save();
        return { win: win, symbols: res, hash: 'genesis_pf_'+seed };
    },

    mine(amount) {
        if(this.state.pool_cap <= 0) return 0;
        let payout = amount * 2.0; // SHUFFLE BONUS PERMITTED DURING ROLLBACK
        if(payout > this.state.pool_cap) payout = this.state.pool_cap;
        this.state.pool_cap -= payout;
        this.state.pending += payout;
        this.save();
        return payout;
    },

    sfx(type) {
        const A = new (window.AudioContext || window.webkitAudioContext)();
        const now = A.currentTime;
        const o = A.createOscillator(); const g = A.createGain();
        o.connect(g).connect(A.destination);
        if(type==='jackpot'){
            o.type='square'; o.frequency.setValueAtTime(880, now);
            g.gain.setValueAtTime(0.1, now); g.gain.linearRampToValueAtTime(0, now+0.5);
            o.start(); o.stop(now+0.5);
        }
    }
};
