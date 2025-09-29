#!/usr/bin/env bash
ROOT="$HOME/tractor-dev-ai"
echo "Docker containers:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""
if [ -d "$ROOT/api_server" ]; then
  echo "FastAPI process (if running):"
  ps aux | grep uvicorn | grep -v grep || echo "No uvicorn process found"
fi

echo ""
echo "Disk usage (project):"
du -sh "$ROOT" || true
