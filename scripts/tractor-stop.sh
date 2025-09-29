#!/usr/bin/env bash
# Stop Docker compose and local services.
set -e
ROOT="$HOME/tractor-dev-ai"
cd "$ROOT/web_ui"

echo "Stopping docker-compose services..."
docker compose down

# Try killing local uvicorn if started with the pattern above
PIDS=$(pgrep -f "uvicorn api_server.main")
if [ -n "$PIDS" ]; then
  echo "Stopping local FastAPI (pid(s): $PIDS)"
  kill $PIDS || true
fi

echo "Stopped services."
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
