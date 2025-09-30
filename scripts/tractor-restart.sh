#!/usr/bin/env bash
# Restart Ollama, WebUI, or both (default = all)

set -e
SERVICE=${1:-all}
ROOT="$HOME/tractor-dev-ai"

"$ROOT/scripts/tractor-stop.sh" "$SERVICE"
sleep 2
"$ROOT/scripts/tractor-start.sh" "$SERVICE"
