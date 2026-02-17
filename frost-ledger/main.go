package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"log"
	"math/rand"
	"net"
	"sync"
	"time"
)

// --- CONFIGURATION ---
const (
	NetworkPort     = ":1337"
	BlockTime       = 5 * time.Second // Fast blocks for demo (Use 300s for Prod)
	TotalSupply     = 100_000_000.0
	PremineAmount   = 13_370_000.0
	GenesisIdentity = "drfrost.frostchain" // 🔒 LOCKED PREMINE
)

// --- SOLFEGGIO FREQUENCY MAP ---
var SolfeggioMap = map[int]float64{
	1: 174.0, // Security
	2: 285.0, // Restoration
	3: 396.0, // Liberation
	4: 417.0, // Change
	5: 528.0, // Miracle (DNA Repair)
	6: 639.0, // Connection
	7: 741.0, // Expression
	8: 852.0, // Intuition
	9: 963.0, // Oneness
}

// --- DATA STRUCTURES ---
type Transaction struct {
	ID        string  `json:"id"`
	Sender    string  `json:"sender"`
	Receiver  string  `json:"receiver"`
	Amount    float64 `json:"amount"`
	Timestamp int64   `json:"timestamp"`
}

type Block struct {
	Index     int     `json:"index"`
	Timestamp int64   `json:"timestamp"`
	PrevHash  string  `json:"prev_hash"`
	Hash      string  `json:"hash"`
	Frequency float64 `json:"frequency"` // 🎵 The Consensus Rule
	Validator string  `json:"validator"`
}

type Blockchain struct {
	Chain       []Block
	CurrentFreq float64
	mu          sync.Mutex
}

// --- CORE FUNCTIONS ---

func CalculateHash(b Block) string {
	record := fmt.Sprintf("%d%d%s%f%s", b.Index, b.Timestamp, b.PrevHash, b.Frequency, b.Validator)
	h := sha256.New()
	h.Write([]byte(record))
	return hex.EncodeToString(h.Sum(nil))
}

func CreateGenesisBlock() Block {
	// 💰 PREMINE INJECTION
	fmt.Printf("💰 INJECTING PREMINE: %.2f FTC -> %s\n", PremineAmount, GenesisIdentity)
	
	b := Block{
		Index:     0,
		Timestamp: time.Now().Unix(),
		PrevHash:  "0000000000000000000000000000000000000000000000000000000000000000",
		Frequency: 528.0, // Start with Miracle Tone
		Validator: "GENESIS_NODE",
	}
	b.Hash = CalculateHash(b)
	return b
}

func (bc *Blockchain) RollQuantumDice() {
	rand.Seed(time.Now().UnixNano())
	roll := rand.Intn(9) + 1
	bc.CurrentFreq = SolfeggioMap[roll]
	fmt.Printf("\n🎲 QUANTUM DICE: %d -> TARGET FREQ: %.1f Hz\n", roll, bc.CurrentFreq)
}

func (bc *Blockchain) MineBlock(minerID string) {
	bc.mu.Lock()
	defer bc.mu.Unlock()

	prevBlock := bc.Chain[len(bc.Chain)-1]
	newBlock := Block{
		Index:     prevBlock.Index + 1,
		Timestamp: time.Now().Unix(),
		PrevHash:  prevBlock.Hash,
		Frequency: bc.CurrentFreq, // Must match Quantum Dice
		Validator: minerID,
	}
	newBlock.Hash = CalculateHash(newBlock)
	bc.Chain = append(bc.Chain, newBlock)
	
	fmt.Printf("❄️  BLOCK #%d MINED | FREQ: %.1f Hz | VALIDATOR: %s\n", newBlock.Index, newBlock.Frequency, newBlock.Validator)
}

func StartServer() {
	ln, err := net.Listen("tcp", NetworkPort)
	if err != nil { log.Fatal(err) }
	fmt.Printf("📡 LISTENING ON PORT %s\n", NetworkPort)
	for {
		conn, err := ln.Accept()
		if err != nil { continue }
		conn.Close()
	}
}

func main() {
	fmt.Println("❄️  FROSTLEDGER V7: SOLFEGGIO EDITION INITIALIZED")
	
	bc := Blockchain{}
	bc.Chain = append(bc.Chain, CreateGenesisBlock())
	bc.CurrentFreq = 528.0

	// MINING LOOP
	go func() {
		for {
			time.Sleep(BlockTime)
			bc.RollQuantumDice()
			bc.MineBlock("ORACLE_VPS_MINER_01")
		}
	}()

	StartServer()
}
