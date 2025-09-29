import faiss, pickle, numpy as np
from sentence_transformers import SentenceTransformer

IDX="faiss.index"
META="faiss_meta.pkl"
embedder = SentenceTransformer("all-MiniLM-L6-v2")

index = faiss.read_index(IDX)
meta = pickle.load(open(META, "rb"))

def retrieve(query, k=4):
    qemb = embedder.encode([query]).astype("float32")
    D, I = index.search(qemb, k)
    results=[]
    for idx,dist in zip(I[0], D[0]):
        results.append({"text_id": idx, "score": float(dist), "meta": meta[idx]})
    return results
