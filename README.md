# txtai on Railway

One-click Railway template for [txtai](https://github.com/neuml/txtai), the open-source all-in-one embeddings database from NeuML: semantic search, a semantic graph, optional RAG and an MCP server behind one REST API.

**Version:** txtai 9.14.0, official image `neuml/txtai-cpu:9.14.0`, pinned by digest in the [`Dockerfile`](Dockerfile).

## What it deploys

One service built from this repo:

- The official txtai CPU image plus a small start script ([`start.py`](start.py)).
- A volume at `/data` with the index (`/data/index`), its SQLite content store and graph, the generated config and the Hugging Face model cache (`/data/hf`).
- A public Railway domain. The health check is `/openapi.json`, which answers without a token.

Every API route and the MCP endpoint need a bearer token. The service refuses to start without `API_TOKEN`, so the API is never public without auth.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `API_TOKEN` | generated (48 chars) | Bearer token for every route and `/mcp`. The start script hashes it into txtai's `TOKEN` |
| `EMBEDDINGS_MODEL` | `sentence-transformers/all-MiniLM-L6-v2` | Hugging Face model that embeds documents, run on CPU in the service. Changing it means re-indexing |
| `PORT` | `8000` | Port the API listens on |

Optional, add them yourself when needed:

- `LLM_MODEL` plus a provider key turns on `GET /rag` (answers from your documents). `LLM_MODEL` is any [LiteLLM](https://docs.litellm.ai/docs/providers) model, for example `openai/gpt-4o-mini` with `OPENAI_API_KEY`, or `anthropic/claude-3-5-haiku-latest` with `ANTHROPIC_API_KEY`.
- `CONFIG`: your own txtai YAML (inline or a file path) instead of the generated one. See the [configuration reference](https://neuml.github.io/txtai/api/configuration/). Keep `path:` under `/data` so the index persists.
- `HF_TOKEN`: a Hugging Face token for gated models or higher download rate limits.

## Use it

```bash
URL=https://YOUR-DOMAIN; AUTH="Authorization: Bearer YOUR-API-TOKEN"

curl -X POST "$URL/add" -H "$AUTH" -H "Content-Type: application/json" \
  -d '[{"id": "ada", "text": "Ada Lovelace wrote the first program for the Analytical Engine."}]'
curl "$URL/upsert" -H "$AUTH"          # build and save the index on the volume
curl "$URL/search?query=who+programmed+the+engine&limit=3" -H "$AUTH"
curl "$URL/search?query=early+computers&graph=true" -H "$AUTH"   # results as a graph
```

MCP (SSE transport) is at `https://YOUR-DOMAIN/mcp` with the same header, for example in Claude Code:

```bash
claude mcp add --transport sse txtai https://YOUR-DOMAIN/mcp --header "Authorization: Bearer YOUR-API-TOKEN"
```

Interactive API docs: `https://YOUR-DOMAIN/docs` (the page loads without a token; the calls need it).

## Updates

The image is pinned in the `Dockerfile`. New txtai releases land here as a pin bump with a [`CHANGELOG.md`](CHANGELOG.md) entry. Railway then shows deployers of this template an "update available" notice, and each deployer chooses when to apply it. Read the changelog first: a new default embeddings model would mean re-indexing.

## Local run

```bash
docker build -t txtai-railway .
docker run --rm -p 8000:8000 -e API_TOKEN=$(openssl rand -hex 24) -v txtai-data:/data txtai-railway
```
