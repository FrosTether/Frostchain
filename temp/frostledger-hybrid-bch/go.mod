module frostledger

go 1.21

require (
	github.com/iotaledger/iota.go v1.0.0 // IOTA Tangle lib
	github.com/libp2p/go-libp2p v0.32.0 // P2P
	github.com/multiformats/go-multiaddr v0.11.0
	github.com/monero-ecosystem/go-monero-rpc v0.0.0-20230101000000-000000000000 // XMR RPC for ring sig inspo (placeholder; use custom)
	github.com/gcash/bchd v0.18.0 // BCH UTXO inspo (gcash/bchd fork of btcd)
)
