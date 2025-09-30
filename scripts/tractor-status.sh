#!/usr/bin/env bash
# Show status of Ollama, WebUI, or both (default = all)

set -e
SERVICE=${1:-all}

echo "Checking container status..."

case "$SERVICE" in
  ollama)
    docker ps -a --filter "name=ollama" \
      --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
    ;;
  webui)
    docker ps -a --filter "name=open-webui" \
      --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
    ;;
  all)
    docker ps -a --filter "name=ollama" --filter "name=open-webui" \
      --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
    ;;
  *)
    echo "Usage: $0 [ollama|webui|all]"
    exit 1
    ;;
esac
