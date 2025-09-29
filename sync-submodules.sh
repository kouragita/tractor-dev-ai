#!/bin/bash
set -e

echo "🔍 Checking for .gitmodules file..."
if [ ! -f ".gitmodules" ]; then
  echo "❌ No .gitmodules file found in this repo."
  echo "   Make sure you're running this script from the root of tractor-dev-ai."
  exit 1
fi

echo "🔄 Fetching latest changes from main repo..."
git fetch origin
git pull origin master   # change to 'main' if your repo uses main

echo "📦 Initializing submodules..."
git submodule init

echo "🔗 Syncing submodule URLs to match .gitmodules..."
git submodule sync --recursive

echo "⬇️ Updating submodules to latest commit..."
git submodule update --init --recursive --remote

echo "✅ Submodules fixed. Current remotes:"
for dir in tts_coqui llm_llama stt_whisper web_ui; do
  if [ -d "$dir" ]; then
    echo "---- $dir ----"
    (cd "$dir" && git remote -v)
  fi
done

echo "🚀 Done. You now have the same submodule content as the main repo owner."
