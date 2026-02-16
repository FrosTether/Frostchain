#!/bin/bash

# CONFIGURATION
REPO_URL="https://github.com/FrosTether/Frostchain.git"
COMMIT_MSG="feat: Frostchain Quantum Miner V7 + Ledger Core [Auto-Deploy]"

echo "❄️  INITIATING FROST PROTOCOL GITHUB SYNC..."

# 1. Initialize Git if missing
if [ ! -d ".git" ]; then
    echo "📂 Initializing new Git repository..."
    git init
    git branch -M main
fi

# 2. Set Remote (Force Update)
echo "🔗 Linking to FrosTether/Frostchain..."
git remote remove origin 2>/dev/null
git remote add origin $REPO_URL

# 3. Stage All Files
echo "📦 Staging Source Code..."
git add .

# 4. Commit
echo "💾 Committing: $COMMIT_MSG"
# Configure dummy user if not set (for CI/Replit environments)
if [ -z "$(git config --global user.email)" ]; then
    git config --global user.email "bot@finux.tech"
    git config --global user.name "Frostchain Bot"
fi
git commit -m "$COMMIT_MSG"

# 5. Push
echo "🚀 Pushing to Mainnet (GitHub)..."
git push -u origin main --force

echo "✅ SUCCESS: Codebase locked at $REPO_URL"
