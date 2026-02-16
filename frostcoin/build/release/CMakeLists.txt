# --- FROSTCHAIN IDENTITY INJECTION ---
# Target: CMake Build System
# Action: Rename Binaries to frostchaind / frost-wallet

echo "❄️  REBRANDING BINARIES..."

# 1. Rename the Daemon (monerod -> frostchaind)
sed -i 's/OUTPUT_NAME monerod/OUTPUT_NAME frostchaind/g' src/daemon/CMakeLists.txt

# 2. Rename the Wallet CLI (monero-wallet-cli -> frostchain-wallet-cli)
sed -i 's/OUTPUT_NAME monero-wallet-cli/OUTPUT_NAME frostchain-wallet-cli/g' src/simplewallet/CMakeLists.txt

# 3. Rename the Wallet RPC (monero-wallet-rpc -> frostchain-wallet-rpc)
sed -i 's/OUTPUT_NAME monero-wallet-rpc/OUTPUT_NAME frostchain-wallet-rpc/g' src/wallet/CMakeLists.txt

# 4. Inject Project Name
sed -i 's/project(frostchain)/project(frostchain)/g' CMakeLists.txt

echo "❄️  IDENTITY ESTABLISHED. BINARIES WILL COMPILE AS FROSTCHAIN."
