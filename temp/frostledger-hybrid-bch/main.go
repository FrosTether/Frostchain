package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"frostledger/core"
	"github.com/libp2p/go-libp2p"
	"github.com/libp2p/go-libp2p/p2p/discovery/mdns"
	"github.com/iotaledger/iota.go/v3/nodeclient" // IOTA integration
)

func main() {
	ctx := context.Background()
	node, err := libp2p.New(libp2p.ListenAddrStrings("/ip4/0.0.0.0/tcp/3000"))
	if err != nil {
		panic(err)
	}
	fmt.Printf("Node ID: %s\n", node.ID().String())
	fmt.Printf("Listen Addresses: %v\n", node.Addrs())

	mdnsService := mdns.NewMdnsService(node, "frostledger-rendezvous", &discoveryHandler{})
	if err := mdnsService.Start(); err != nil {
		panic(err)
	}

	// IOTA client for Tangle inspo
	iotaClient := nodeclient.New("https://api.testnet.shimmer.network") // Use IOTA testnet for hybrid

	chain := core.NewHybridChain(node, iotaClient)

	// Genesis with premine
	genesis := core.NewMessage("Genesis - FrostLedger Hybrid", 13370000*1e18, time.Now().Unix(), []string{}, "seed-miner")
	chain.AddMessage(genesis)
	fmt.Println("⚡ FrostLedger Hybrid Launched!")

	// Mining loop (shared rewards)
	go func() {
		for {
			time.Sleep(5 * time.Minute)
			freq := core.InitiateHyperSync(int64(len(chain.Messages)))
			msg := core.MineShared(chain, []string{"Node1", "Node2"}, freq) // Multi-miners
			if msg != nil {
				chain.AddMessage(msg)
				fmt.Printf("New Message Mined! Count: %d\n", len(chain.Messages))
			}
		}
	}()

	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
	<-sigCh
	mdnsService.Close()
	node.Close()
}

type discoveryHandler struct{}

func (h *discoveryHandler) HandlePeerFound(peerInfo libp2p.PeerInfo) {
	fmt.Printf("Discovered peer: %s\n", peerInfo.ID)
	// Connect and sync Tangle/DAG
}
