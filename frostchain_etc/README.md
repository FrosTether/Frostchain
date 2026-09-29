# Frostchain ETC: Ethereum Classic based proof-of-work chain

Frostchain running on the Ethereum Classic protocol. It uses
[core-geth](https://github.com/etclabscore/core-geth), the main ETC client, so
blocks are mined with real **Etchash** proof of work, not Clique or
proof of stake.

| Setting            | Value                                                    |
|--------------------|----------------------------------------------------------|
| Coin               | FROST                                                    |
| Chain ID / Network | 13370                                                    |
| Consensus          | Etchash PoW (ECIP-1099)                                  |
| Block reward       | 5 FROST, cut by 20% every 5,000,000 blocks (ECIP-1017)   |
| Difficulty bomb    | Disabled (ECIP-1041)                                     |
| EVM                | Up to ETC "Spiral" (Shanghai-level, no EIP-1559)         |
| RPC                | http://127.0.0.1:8545                                    |

The genesis keeps the existing premine to
`0xfa70f673357d6bb0408171322546001d0bbeaf4e` (100,000,000 FROST). Remove it
from `alloc` in `genesis.json` before the first `setup.sh` if you want a fair
launch like ETC.

## Run it

```bash
# Termux: pkg install golang git make
./setup.sh      # builds core-geth, creates a wallet, and initializes the chain
./mine.sh       # starts the node and mines with all CPU cores
```

Options for `mine.sh`:

- `THREADS=2`: the number of CPU mining threads
- `MY_ADDR=0x...`: pay rewards to a different address
- `HTTP_ADDR=0.0.0.0`: expose RPC on your network (only do this behind a firewall)

The first start builds the Etchash DAG, which takes about 1 GB of RAM and disk
and a few minutes. Blocks start after that.

## GPU mining

The node serves `eth_getWork` and `eth_submitWork` on RPC, so any Etchash GPU
miner that supports getwork (solo) mode can mine against
`http://127.0.0.1:8545`. To keep the node running without CPU mining:

```bash
THREADS=-1 ./mine.sh
```

## Wallets

In MetaMask, add a custom network with RPC `http://<node-ip>:8545`, chain ID
`13370`, and symbol `FROST`.

## Notes

- `data/` holds your keystore and wallet password. It is gitignored. Never commit it.
- Chain ID 13370 is not registered. Check https://chainlist.org before you
  launch publicly, and change `chainId` and `networkId` in `genesis.json` and
  `--networkid` in `mine.sh` if it is taken.
- If you change `genesis.json` after setup, run `rm -rf data/geth` and then
  `./setup.sh` again. This starts a new chain.
