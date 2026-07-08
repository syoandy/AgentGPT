# Horizon AI — GitHub Repositories to Enhance the Platform

> A curated "library" of open-source GitHub projects that can extend Horizon AI,
> which is built on the AgentGPT stack (Next.js 13 + TypeScript, LangChain.js,
> tRPC, Prisma, Supabase/Postgres).

## How this was scoped

Horizon AI inherits AgentGPT's architecture:

- **Frontend/app:** Next.js + TypeScript (`src/`)
- **Agent loop:** `src/services/agent-service.ts` using **LangChain.js `^0.0.57`** (old — a prime upgrade target)
- **API:** tRPC + Zod
- **Persistence:** Prisma ORM over Supabase/Postgres (so **`pgvector` is already one migration away**)
- **No long-term memory / vector store yet** — this is roadmap item #1

> ⚠️ **Note:** The upstream `reworkd/AgentGPT` repo is now **archived** (read-only).
> It will not ship new features, so Horizon AI has to pull in modern building
> blocks itself. The repos below are the most useful, actively-maintained pieces
> for doing that. They are grouped by the capability they add and mapped to the
> AgentGPT roadmap.

---

## 1. Long-term memory & vector storage  *(Roadmap: "Long term memory via a vector DB 🧠")*

Give agents persistent memory across runs instead of forgetting after each goal.

| Repo | What it adds | Fit for Horizon AI |
|------|--------------|--------------------|
| **[mem0ai/mem0](https://github.com/mem0ai/mem0)** | Universal "memory layer" for agents — stores, scores, and recalls per-user/long-term memories. | Has a JS/TS SDK + hosted option; drop in front of the agent loop to persist memory per user/agent run. Best single starting point. |
| **[topoteretes/cognee](https://github.com/topoteretes/cognee)** | Self-hosted **knowledge-graph + vector** memory engine for agents. | When you need *relational* memory (e.g. "this tenant → this unit → this lease"), not just similarity recall. |
| **[memodb-io/memobase](https://github.com/memodb-io/memobase)** | User-profile-based long-term memory for chat apps. | Lightweight option if Horizon AI is primarily conversational. |
| **[qdrant/qdrant](https://github.com/qdrant/qdrant)** | High-performance vector database (Rust) with a clean JS client. | Production vector store if you outgrow pgvector. |
| **[weaviate/weaviate](https://github.com/weaviate/weaviate)** | Vector DB with built-in hybrid (keyword + vector) search. | Good when you need filtering + semantic search together. |
| **[milvus-io/milvus](https://github.com/milvus-io/milvus)** | Cloud-native vector DB built for very large scale. | Reach for this only at high volume. |

**Lowest-friction path:** enable **`pgvector` on the existing Supabase Postgres** and add a `Memory` table via Prisma — no new infra. Graduate to mem0/Qdrant when recall quality or scale demands it.

---

## 2. Web browsing & data ingestion  *(Roadmap: "Web browsing capabilities via LangChain 🌐")*

Let agents read the live web and turn pages/docs into clean, LLM-ready text.

| Repo | What it adds | Fit for Horizon AI |
|------|--------------|--------------------|
| **[firecrawl/firecrawl](https://github.com/firecrawl/firecrawl)** | API to crawl/scrape any site and return clean Markdown for LLMs. | TypeScript-native, has a hosted API and SDK — the fastest way to add real web-reading as an agent tool. |
| **[browser-use/browser-use](https://github.com/browser-use/browser-use)** | Drives a real browser (Playwright) so agents can click, type, and complete tasks on websites. | Enables "do things on the web," not just read — e.g. fill portals/forms. |
| **[nanobrowser/nanobrowser](https://github.com/nanobrowser/nanobrowser)** | Open-source Chrome extension running multi-agent web automation with your own API key. | A self-hostable alternative pattern to OpenAI "Operator." |
| **[assafelovic/gpt-researcher](https://github.com/assafelovic/gpt-researcher)** | Autonomous agent that researches a topic across many sources and writes a cited report. | A ready-made "deep research" skill you can expose as a Horizon AI task type. |

---

## 3. Agent orchestration & multi-agent  *(Upgrade the core reasoning loop)*

AgentGPT's loop is a single agent on an old LangChain. These modernize planning, tool-use, and let multiple specialized agents collaborate.

| Repo | What it adds | Fit for Horizon AI |
|------|--------------|--------------------|
| **[langchain-ai/langchain](https://github.com/langchain-ai/langchain)** (incl. **LangGraph**) | The framework Horizon already depends on — current versions add tool-calling, structured output, and **LangGraph** stateful agent graphs. | Highest-leverage upgrade: bump LangChain.js and move the agent loop to LangGraph for reliable planning + retries. |
| **[crewAIInc/crewAI](https://github.com/crewAIInc/crewAI)** | Orchestrates role-playing collaborating agents (researcher → planner → executor). | Model Horizon "teams" of agents for multi-step workflows. (Python — runs as a sidecar service.) |
| **[google/adk-python](https://github.com/google/adk-python)** | Google's code-first Agent Development Kit for building/evaluating/deploying agents. | Strong evaluation + deployment tooling if you standardize the agent layer. |
| **[agentscope-ai/agentscope](https://github.com/agentscope-ai/agentscope)** | Transparent, debuggable multi-agent runtime. | Good observability into what each agent did. |
| **[FoundationAgents/MetaGPT](https://github.com/FoundationAgents/MetaGPT)** | Multi-agent "software company" pattern with explicit roles/SOPs. | Reference for structuring role-based agent pipelines. |

---

## 4. RAG & document / writing capabilities  *(Roadmap: "Writing capabilities via a document API 📄")*

Ground answers in Horizon AI's own documents (leases, policies, manuals) and generate documents back.

| Repo | What it adds | Fit for Horizon AI |
|------|--------------|--------------------|
| **[run-llama/llama_index](https://github.com/run-llama/llama_index)** | Leading framework for indexing documents and building RAG/query pipelines (has a **TypeScript** port: LlamaIndex.TS). | Ingest PDFs/contracts and let agents answer over them. TS port fits the codebase directly. |
| **[infiniflow/ragflow](https://github.com/infiniflow/ragflow)** | Full RAG engine with deep document parsing (tables, scans, layouts). | Best when documents are messy (scanned leases, statements). Deploy as a service. |
| **[Mintplex-Labs/anything-llm](https://github.com/Mintplex-Labs/anything-llm)** | Self-hostable, all-in-one RAG + agent app with a built-in vector DB. | Useful as a reference implementation, or a self-hosted RAG backend. |
| **[NirDiamant/RAG_Techniques](https://github.com/NirDiamant/RAG_Techniques)** | Tutorial repo of advanced RAG patterns (re-ranking, query expansion, etc.). | Learning resource to improve retrieval quality once basic RAG works. |

---

## 5. Tools & integration ecosystem (MCP)

Standardize how Horizon AI agents call external systems (calendars, CRMs, email, accounting, property systems).

| Repo | What it adds | Fit for Horizon AI |
|------|--------------|--------------------|
| **[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)** | Large index of Model Context Protocol servers (ready-made tool integrations). | Adopt MCP as the tool interface so you can plug in integrations instead of hand-coding each one. |
| **[firecrawl/firecrawl](https://github.com/firecrawl/firecrawl)** | (Also exposes an MCP server.) | Web access as a standardized tool. |

---

## 6. Cost control & model flexibility

AgentGPT's README flags infra/API cost as a real concern. These reduce per-run cost and remove single-vendor lock-in.

| Repo | What it adds | Fit for Horizon AI |
|------|--------------|--------------------|
| **[ollama/ollama](https://github.com/ollama/ollama)** | Run open models (Llama, Qwen, Mistral, gpt-oss…) locally/self-hosted. | Route cheap/bulk tasks to local models; reserve frontier APIs for hard reasoning. |
| **[khoj-ai/khoj](https://github.com/khoj-ai/khoj)** | Self-hostable "second brain" that works with any local or cloud LLM. | Reference for a provider-agnostic, self-hosted assistant architecture. |

---

## 7. Keep mining these curated "libraries"

Awesome-lists to revisit as the space moves fast:

- **[e2b-dev/awesome-ai-agents](https://github.com/e2b-dev/awesome-ai-agents)** — directory of autonomous agents.
- **[Shubhamsaboo/awesome-llm-apps](https://github.com/Shubhamsaboo/awesome-llm-apps)** — 100+ runnable agent/RAG app examples.
- **[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)** — tool/integration servers.
- **[IAAR-Shanghai/Awesome-AI-Memory](https://github.com/IAAR-Shanghai/Awesome-AI-Memory)** — memory-system research & frameworks.

---

## Recommended starter stack (highest ROI first)

For a TypeScript/Next.js + Supabase codebase like Horizon AI, in order:

1. **Upgrade LangChain.js** (currently `^0.0.57`) and move `agent-service.ts` to **LangGraph** for reliable planning/retries. *(No new infra.)*
2. **Add memory with `pgvector` on Supabase** (Prisma migration) — or **mem0** for a turnkey memory layer.
3. **Add web reading via Firecrawl** as the first real agent tool (TS SDK, hosted API).
4. **Add document RAG with LlamaIndex.TS** over Supabase/pgvector for grounding on your own files.
5. **Adopt MCP** (awesome-mcp-servers) as the standard tool interface for future integrations.
6. **Add Ollama** as a cheap model route once volume grows.

### Integration note: TypeScript vs Python

Several top tools (crewAI, RAGFlow, cognee) are **Python**. For a TS app, prefer
the TS-native options where they exist — **LangChain.js, LlamaIndex.TS, Firecrawl
SDK, mem0, Qdrant/Weaviate JS clients, pgvector** — and run any Python-only
engine as a **separate microservice** behind a small HTTP/MCP boundary rather
than embedding it in the Next.js app.

---

*No established open-source "property-management AI" project exists to fork — the
practical path is to assemble the building blocks above (memory + web + RAG +
MCP tools) on top of Horizon AI's existing AgentGPT base.*
