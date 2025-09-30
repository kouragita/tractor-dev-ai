#!/bin/sh
set -e

MODEL_PATH="/models/mistral-7b-instruct-v0.2.Q4_K_M.gguf"
MODEL_URL="https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q4_K_M.gguf"

# Check if model exists
if [ ! -f "$MODEL_PATH" ]; then
  echo "⚡ Model not found, downloading..."
  mkdir -p /models
  curl -L -o "$MODEL_PATH" "$MODEL_URL"
  echo "✅ Model downloaded: $MODEL_PATH"
else
  echo "✅ Model already exists, skipping download."
fi

echo "📦 Registering model with Ollama..."
ollama create mistral7b -f /models/Modelfile || true

echo "🚀 Starting Ollama..."
exec ollama serve
