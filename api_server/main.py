# api_server/main.py (very minimal)
from fastapi import FastAPI, UploadFile, File, Form
import subprocess, uuid, os, requests, json
from vector_db.retrieve import retrieve

ROOT = os.path.dirname(os.path.abspath(__file__))
app = FastAPI()

# helper to run local whisper (whisper.cpp) binary
def run_whisper(wav_path):
    # update to your whisper-cli path
    whisper_cli = os.path.expanduser("~/tractor-dev-ai/stt_whisper/build/bin/whisper-cli")
    res = subprocess.run([whisper_cli, "-m", os.path.expanduser("~/tractor-dev-ai/stt_whisper/models/ggml-base.bin"), "-f", wav_path, "--print-colors"], capture_output=True, text=True)
    return res.stdout

def call_llm(prompt):
    # call local llama/ollama server; example Ollama HTTP API on 11434
    payload = {"model": "mistral7b", "prompt": prompt}
    r = requests.post("http://localhost:11434/api/generate", json=payload, timeout=120)
    return r.json()

def synth_tts(text, out_path):
    # using coqui CLI
    subprocess.run(["/home/youruser/tractor-dev-ai/tts_coqui/venv/bin/tts", "--text", text, "--out_path", out_path], check=True)
    return out_path

@app.post("/call_process/")
async def call_process(file: UploadFile = File(...), language: str = Form("sw")):
    # save file
    tmp = f"/tmp/{uuid.uuid4().hex}.wav"
    content = await file.read()
    with open(tmp, "wb") as f:
        f.write(content)
    # 1. STT
    transcript = run_whisper(tmp)
    # 2. RAG retrieve
    retrieved = retrieve(transcript, k=4)
    # Build prompt
    context_text = "\n\n".join([f"[{r['meta']['source']}] {r['meta'].get('text','')}" for r in retrieved])
    prompt = f"SYSTEM: You are Tractor.dev AI (language={language})\nCONTEXT:\n{context_text}\nUSER: {transcript}\nAnswer in Swahili if user used Swahili."
    # 3. LLM
    llm_resp = call_llm(prompt)
    resp_text = llm_resp.get("text") or llm_resp.get("output") or str(llm_resp)
    # 4. TTS
    out_file = f"/tmp/out_{uuid.uuid4().hex}.wav"
    synth_tts(resp_text, out_file)
    return {"transcript": transcript, "response": resp_text, "audio_file": out_file}
