#!/usr/bin/env bash
# Stop Ollama, WebUI, or both (default = all)

set -e
SERVICE=${1:-all}
ROOT="$HOME/tractor-dev-ai"

case "$SERVICE" in
  ollama)
    echo "Stopping Ollama..."
    docker stop ollama || true
    docker rm ollama || true
    ;;
  webui)
    echo "Stopping OpenWebUI..."
    docker stop open-webui || true
    docker rm open-webui || true
    ;;
  all)
    echo "Stopping all services..."
    docker stop ollama open-webui || true
    docker rm ollama open-webui || true
    ;;
  *)
    echo "Usage: $0 [ollama|webui|all]"
    exit 1
    ;;
esac
