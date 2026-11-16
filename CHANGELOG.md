# Changelog

## 9.14.0-1 (2026-11-16)

First release of this template.

- txtai 9.14.0, official image `neuml/txtai-cpu:9.14.0@sha256:199b05d8bd4edd9cd63c6579ba929787dd9bc8421db9ad11a4584714c271eba9`.
- Bearer token required on every route and on MCP (`API_TOKEN`, generated at deploy); the service refuses to start without it.
- Index, content store, graph, config and model cache on the `/data` volume.
- Embeddings with `sentence-transformers/all-MiniLM-L6-v2` on CPU, semantic graph and MCP on. RAG turns on when `LLM_MODEL` is set.
- Dual-stack listener on `PORT` (IPv4 public domain and IPv6 private network).
