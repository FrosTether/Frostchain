#!/bin/bash
echo "🚀 DEPLOYING V203_TOKENOMICS_HARDCODE..."

mkdir -p frostscan

cat << 'INNER' > frostscan/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>FROSTSCAN // SOVEREIGN_MATH</title>
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap");
        :root{--bg:#020202;--panel:#0a0a0a;--blue:#00f0ff;--green:#00ff9d;--gold:#ffd700;--text:#a0a0a0;--pi:#ff003c;}
        body{background:var(--bg);color:var(--text);font-family:"Share Tech Mono",monospace;margin:0;padding:0;overflow-x:hidden;}
        
        .navbar{display:flex;justify-content:space-between;align-items:center;padding:15px 30px;background:rgba(0,0,0,0.95);border-bottom:1px solid #222;position:sticky;top:0;z-index:100;}
        .logo{font-size:24px;color:var(--gold);letter-spacing:2px;font-weight:bold;}
        .search-bar{background:#111;border:1px solid #333;color:#fff;padding:8px 15px;width:300px;font-family:inherit;border-radius:4px;}
        
        .stats-grid{display:grid;grid-template-columns:repeat(auto-fit, minmax(200px, 1fr));gap:20px;padding:30px;}
        .stat-card{background:var(--panel);border:1px solid #222;padding:20px;border-radius:8px;position:relative;overflow:hidden;}
        .stat-card::after{content:'';position:absolute;top:0;left:0;width:2px;height:100%;background:var(--blue);}
        .stat-card:nth-child(2)::after{background:var(--green);} /* FNR */
        .stat-card:nth-child(3)::after{background:var(--pi);}    /* FRST */
        
        .stat-label{font-size:12px;color:#666;margin-bottom:5px;letter-spacing:1px;}
        .stat-val{font-size:18px;color:#eee;}
        .stat-sub{font-size:10px;color:var(--gold);margin-top:5px;}

        .container{display:flex;flex-wrap:wrap;gap:30px;padding:0 30px 30px 30px;}
        .panel{flex:1;min-width:300px;background:var(--panel);border:1px solid #222;border-radius:8px;padding:0 20px 20px 20px;}
        .panel-head{display:flex;justify-content:space-between;padding:15px 0;border-bottom:1px solid #222;margin-bottom:10px;color:#eee;}
        
        .row{display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px solid #151515;font-size:12px;}
        .blk-icon{background:#1a1a1a;color:#ccc;width:40px;height:40px;display:flex;align-items:center;justify-content:center;border-radius:4px;margin-right:15px;}
        .tx-hash{color:var(--blue);cursor:pointer;}
        .reward-box{text-align:right; font-size:11px;}
        .reward-ftc{color:var(--blue);}
        .reward-fnr{color:var(--green);}
        .reward-frst{color:var(--pi);}
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="logo">FROSTSCAN<span style="font-size:10px;color:#555;margin-left:10px;">[SOVEREIGN_V203]</span></div>
        <input type="text" class="search-bar" placeholder="Search Address / Block / Tx...">
    </nav>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">FTC EMISSION (5m)</div>
            <div class="stat-val">13.37 FTC</div>
            <div class="stat-sub">SOVEREIGN CONSTANT</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">FNR EMISSION (5m)</div>
            <div class="stat-val">1.50 FNR</div>
            <div class="stat-sub">XMR_TAIL_SIZE (0.6 * 2.5)</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">FRST EMISSION (5m)</div>
            <div class="stat-val">31,415.9 FRST</div>
            <div class="stat-sub">PI * DOGE_CAP</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">BLOCK TIME</div>
            <div class="stat-val" style="color:var(--gold);">300 SECONDS</div>
            <div class="stat-sub">FIXED INTERVAL</div>
        </div>
    </div>

    <div class="container">
        <div class="panel">
            <div class="panel-head"><span>LATEST BLOCKS (5m Interval)</span></div>
            <div id="blocks-list"></div>
        </div>

        <div class="panel">
            <div class="panel-head"><span>MEMPOOL STREAM</span></div>
            <div id="tx-list"></div>
        </div>
    </div>

    <script>
        const blocksList = document.getElementById('blocks-list');
        const txList = document.getElementById('tx-list');
        let blockHeight = 842300;

        function shortHash() {
            const chars = '0123456789abcdef';
            let res = '0x'; for(let i=0; i<12; i++) res += chars[Math.floor(Math.random()*16)];
            return res + '...';
        }

        function initHistory() {
            for(let i=0; i<8; i++) {
                const div = document.createElement('div');
                div.className = 'row';
                let timeLabel = i === 0 ? "5 mins ago" : `${(i*5)+5} mins ago`;
                div.innerHTML = `
                    <div style="display:flex;align-items:center;">
                        <div class="blk-icon">Bk</div>
                        <div>
                            <div class="tx-hash">${blockHeight - i}</div>
                            <div style="color:#555;font-size:10px;">${timeLabel}</div>
                        </div>
                    </div>
                    <div class="reward-box">
                        <div class="reward-ftc">+13.37 FTC</div>
                        <div class="reward-fnr">+1.50 FNR</div>
                        <div class="reward-frst">+31,415.9 FRST</div>
                    </div>
                `;
                blocksList.appendChild(div);
            }
        }

        function createTx() {
            const div = document.createElement('div');
            div.className = 'row';
            div.innerHTML = `
                <div style="display:flex;align-items:center;">
                    <div class="blk-icon" style="color:var(--green);font-size:10px;">Tx</div>
                    <div>
                        <div class="tx-hash">${shortHash()}</div>
                        <div style="color:#555;font-size:10px;">Just now</div>
                    </div>
                </div>
                <div style="text-align:right; font-size:10px; color:#aaa;">
                    Transfer: 4AEre... > 8dSsZ...
                </div>
            `;
            txList.prepend(div);
            if(txList.children.length > 8) txList.lastChild.remove();
        }

        initHistory();
        setInterval(createTx, 15000); // Slow mempool
    </script>
</body>
</html>
INNER

surge frostscan frostscan.surge.sh
