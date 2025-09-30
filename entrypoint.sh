#!/bin/sh
set -e

echo "Registering mistral7b..."
ollama create mistral7b -f /models/Modelfile || true

echo "Starting Ollama..."
exec ollama serve
