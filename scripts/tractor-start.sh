#!/usr/bin/env bash
# Start the Docker compose stack and local services.
set -e

ROOT="$HOME/tractor-dev-ai"
cd "$ROOT/web_ui"

echo "Starting docker-compose (open-webui + ollama)..."
docker compose up -d

# Wait a few seconds for containers to boot
sleep 3

# Optionally start local api_server (FastAPI) if it exists and you want it outside docker.
if [ -d "$ROOT/api_server" ]; then
  echo "Starting local FastAPI (api_server) if not already running..."
  # Activate venv if exists and start uvicorn in background
  if [ -f "$ROOT/api_server/venv/bin/activate" ]; then
    source "$ROOT/api_server/venv/bin/activate"
    # Use nohup so it stays in background
    nohup uvicorn api_server.main:app --host 0.0.0.0 --port 8000 --log-level info > "$ROOT/logs/api_server.out" 2>&1 &
    echo "FastAPI started on port 8000 (logs: $ROOT/logs/api_server.out)"
  else
    echo "No api_server venv found, skip local FastAPI start."
  fi
fi

echo "All requested services started."
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
