package core

import (
	"math/rand"
	"time"
	"fmt"
)

const MINING_INTERVAL = 300

var SolfeggioPools = []float64{174.0, 285.0, 396.0, 417.0, 528.0, 639.0, 741.0, 852.0, 963.0}

func InitiateHyperSync(height int64) float64 {
	seed := time.Now().UnixNano() + height
	rand.Seed(seed)
	dice := rand.Intn(9)
	freq := SolfeggioPools[dice]
	fmt.Printf("🎲 DICE: %d | TARGET: %.1f Hz\n", dice+1, freq)
	return freq
}

func MineShared(hc *HybridChain, miners []string, freq float64) *Message {
	now := time.Now().Unix()
	if now < hc.LastMineTime + MINING_INTERVAL {
		return nil
	}
	baseReward := BLOCK_REWARD / (1 << uint(len(hc.Messages)/14904000)) // Halving
	shared := make(map[string]uint64)
	perMiner := baseReward / uint64(len(miners))
	for _, m := range miners {
		multi := hc.SubZeroVaultTime[m]
		share := perMiner + (perMiner * multi / 10000)
		shared[m] = share
	}
	parents := []string{} // Tip selection (IOTA)
	if len(hc.Messages) > 0 {
		parents = append(parents, hc.Messages[len(hc.Messages)-1].Data)
	}
	msg := NewMessage(fmt.Sprintf("Shared Mine @ %.1f Hz", freq), baseReward, now, parents, "shared")
	msg.SharedRewards = shared
	msg.Frequency = freq
	return msg
}
