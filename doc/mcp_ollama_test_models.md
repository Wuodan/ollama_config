# MCP-Ollama Test Model Kit

This document records which free models I pulled into Ollama to test **FastMCP capabilities**.  
Goal: cover all major feature areas (tool calling, vision, embeddings, optional speech).  
Priority: **small-ish, free models** — quality doesn’t matter, functionality does.

---

## 1) Tool Calling (Function Calling)

- **Llama 3.1 8B Instruct**  
  `ollama pull llama3.1:8b`  
  → Reliable tools support, small enough for RTX 3070.  

- **Qwen 2.5 7B Instruct**  
  `ollama pull qwen2.5:7b`  
  → Good at JSON-style outputs, solid tool support.  

- **Qwen 2.5 Coder Tools 0.5B / 1.5B**  
  ```
  ollama pull hhao/qwen2.5-coder-tools:0.5b
  ollama pull hhao/qwen2.5-coder-tools:1.5b
  ```  
  → Ultra-small, good to test weak/edge-case behavior.  

- **Llama 3.2 3B (negative test)**  
  `ollama pull llama3.2:3b`  
  → Claims tool use, but often flaky at this size.

---

## 2) Vision (Image Input)

- **Qwen2.5-VL 7B**  
  `ollama pull qwen2.5-vl:7b`  
  → Small VLM, good for image inputs/resources.  

- **LLaVA-Phi3 (≈3.8B)**  
  `ollama pull llava-phi3:3.8b`  
  → Lightweight VLM, minimal VRAM use.  

- **MiniCPM-V 8B** (alternative)  
  `ollama pull minicpm-v:8b`  
  → Another option for quick VLM checks.

---

## 3) Embeddings (RAG / Semantic Tests)

- **nomic-embed-text (≈274 MB)**  
  `ollama pull nomic-embed-text`  
  → Very small, fast smoke-test model.  

- **mxbai-embed-large (≈670 MB)**  
  `ollama pull mxbai-embed-large`  
  → Widely used, good baseline for RAG.  

- **Alternatives:**  
  - `ollama pull embeddinggemma` (~300 MB)  
  - `ollama pull snowflake-arctic-embed:110m` (22–335 MB variants)

---

## 4) Audio (Optional, outside Ollama)

- **ASR:** Whisper (tiny/base) → run via [whisper.cpp](https://github.com/ggerganov/whisper.cpp) or wrappers.  
- **TTS:** Piper → small, fast local TTS engine.  

*(Ollama itself doesn’t support audio natively yet.)*

---

### Notes
- Models chosen for **breadth of features**, not quality.  
- Expect to use multiple models to cover all FastMCP functions (tools, vision, embeddings).  
- Negative tests (e.g. Llama 3.2 3B) are useful for checking how the system fails.  
- Audio handled separately from Ollama.

---
