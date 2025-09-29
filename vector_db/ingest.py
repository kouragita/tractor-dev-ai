# minimal ingestion example
from sentence_transformers import SentenceTransformer
import faiss, pickle, numpy as np
import os, glob, json

MODEL="all-MiniLM-L6-v2"
embedder = SentenceTransformer(MODEL)

DATA_DIR = "../data/docs"
OUT_INDEX = "faiss.index"
META_FILE = "faiss_meta.pkl"

# read text files
docs = []
meta = []
for p in glob.glob(os.path.join(DATA_DIR, "**/*.txt"), recursive=True):
    with open(p, "r", encoding="utf8") as f:
        text = f.read()
    # naive split - you should use better chunker (200-400 tokens)
    chunks = [text[i:i+1000] for i in range(0, len(text), 1000)]
    for i,c in enumerate(chunks):
        docs.append(c)
        meta.append({"source": p, "chunk_id": i})

embs = embedder.encode(docs, show_progress_bar=True, batch_size=32)
embs = np.array(embs).astype("float32")

# FAISS index
d = embs.shape[1]
index = faiss.IndexFlatL2(d)
index.add(embs)
faiss.write_index(index, OUT_INDEX)

with open(META_FILE, "wb") as f:
    pickle.dump(meta, f)

print("Wrote:", OUT_INDEX, META_FILE, "num_docs=", len(meta))
