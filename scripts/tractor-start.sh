#!/usr/bin/env bash
# Start Ollama, WebUI, or both (default = all)

set -e
SERVICE=${1:-all}
ROOT="$HOME/tractor-dev-ai"

case "$SERVICE" in
  ollama)
    echo "Starting Ollama..."
    cd "$ROOT"
    docker compose up -d ollama
    ;;
  webui)
    echo "Starting OpenWebUI..."
    cd "$ROOT/web_ui"
    docker compose up -d open-webui
    ;;
  all)
    echo "Starting all services (Ollama + WebUI)..."
    cd "$ROOT/web_ui"
    docker compose up -d
    ;;
  *)
    echo "Usage: $0 [ollama|webui|all]"
    exit 1
    ;;
esac

echo "Services started:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
