# Horizon AI — In-House Build Master Plan

> Goal: own Horizon AI's core capabilities (memory, web, agent loop, RAG, tools,
> model routing) as first-party code instead of depending on opaque third-party
> packages — without naively "rewriting everything from scratch," which the
> review below shows would *increase* risk in several places.
>
> This plan was produced by a multi-agent design + adversarial-review pass that
> read the actual repository. Findings that contradict the README are noted.

---

## TL;DR — three honest postures (not "trust nobody")

1. **Own the logic** *(build-from-scratch, standard-library only)*: the agent loop, planner, model router, tool registry + permission gate, retrieval/chunking/citation logic, retry/backoff, token+cost metering, and every *interface seam* (`Provider`, `Embedder`, `Tool`, `MemoryPort`, `VectorStore`). This is the code that defines Horizon's behavior and trust boundaries — it must be readable line-by-line.
2. **Self-host the heavy engines** *(pinned + vendored open source you run yourself)*: Postgres + pgvector, an OSS PDF text extractor, an OSS HTML sanitizer, a self-hosted OSS inference server (vLLM/Ollama) + embedding model, and a self-hosted headless browser — *if/when* needed. Run known, widely-audited code yourself; don't write a worse version.
3. **Audit the unavoidable few** *(isolated behind one adapter each)*: hosted frontier LLM APIs (OpenAI/Anthropic), an optional hosted embeddings API, an optional hosted web-search index. One file each, server-side only, key never reaching the browser, pinned and scanned.

**The correction the security review forced:** "build from scratch" is *not* always safer. Hand-rolling an HTML sanitizer, a PDF parser, an SSRF/DNS-rebind guard's IP logic, a tokenizer, a vector index, or AES key management is the **more dangerous** choice (long CVE tails, silent failures). For those, the safe in-house move is **self-host audited OSS, pinned, behind a thin first-party interface**.

---

## Two repo realities that reshape everything (verified against the code)

1. **Datasource is MySQL, not Postgres.** `prisma/schema.prisma` is `provider="mysql"`. pgvector is Postgres-only, so **all semantic/vector features are blocked on a real MySQL→Postgres migration** that touches every table (User/Account/Session/Agent/AgentTask), auth, and deploy. This is its own scoped project — not a feature add-on.
2. **The task endpoints (`start.ts`/`create.ts`/`execute.ts`) run on the Next.js *edge* runtime and are *unauthenticated*** (no session, no Prisma, no `node:dns`). And the loop runs **client-side in the browser** whenever a custom API key is set (`shouldRunClientSide()`) — which is also the highest-privilege tier. Therefore memory scope, billing caps, tool permissions, and SSRF defense **cannot be enforced where the agent currently runs**. A small **Phase 0** moves enforced operations onto an authenticated Node path (a tRPC procedure, which already runs on Node here). This is a hard prerequisite shared by memory, RAG, tools, and model-routing.

---

## Area 1 — Long-term memory & vector storage

| Component | Classification | Why |
|---|---|---|
| `Memory` Prisma model + relations (userId/agentId, cascade, FK indexes) | build-from-scratch | Pure schema. Under `relationMode="prisma"` cascade is *emulated* → FK indexes + a deletion test are mandatory. |
| Lexical recall (Phase 1 default) | **self-host-oss: MySQL `FULLTEXT` `MATCH…AGAINST`** *(corrected from hand-rolled BM25)* | A from-scratch BM25 ships as an unindexed "SELECT-all then score in Node" scan — a DoS/cost footgun. Use the DB's own indexed full-text engine. |
| Embedder interface + adapters | build-from-scratch (interface) / self-host-oss (local ONNX) / unavoidable (hosted) | The seam is first-party; the *model* is borrowed OSS or one isolated hosted call. |
| pgvector store (semantic, later) | self-host-oss | Can't hand-write an ANN index; pgvector is a small pinned extension. **Blocked on the Postgres migration.** |
| Write/read/recall orchestration, RRF fusion, recency decay | build-from-scratch | Application logic over std primitives + Prisma. |

**Key interfaces:** `MemoryPort { appendStep; saveRun; recentContext; recall? }`, `Embedder { id; dim; embed(texts) }`.

**Security notes:** verify the client-supplied `agentId` belongs to `session.user.id` before any query (the real cross-tenant boundary); ship a two-user isolation test as a CI gate; cap writes (chunks/bytes per write, per-user row cap with LRU/TTL eviction); make memory I/O non-fatal (recall→empty on error, remember→fire-and-forget); inject recalled text as **delimited untrusted content** (test that an injected "ignore previous instructions" memory changes nothing); store `embeddingModel + dim` per row and filter recall to the active embedder.

---

## Area 2 — Web browsing, fetching & content extraction

| Component | Classification | Why |
|---|---|---|
| SSRF / egress guard (resolve→pin→connect, redirect re-validation, IPv6/mapped/CGNAT/metadata) | **build-from-scratch, security-critical** | Policy must be owned line-by-line, but the hard part is DNS-rebind pinning (Node `fetch` can't do it alone) → custom `undici` dispatcher + an **adversarial rebind test** as proof. |
| Fetch + HTML→text/markdown extraction | unavoidable-dependency | One pinned pure-JS parser (`node-html-parser`) on already-fetched bytes (no network/eval). |
| HTML **sanitization** for UI-rendered output | **self-host-oss: pinned DOMPurify** *(corrected from hand-rolled)* | Sanitization has a 15-year mXSS CVE tail; hand-rolling *increases* risk. |
| Node browse route + `browse` tool adapter | build-from-scratch | Must be Node (DNS), **authenticated**, rate-limited. |
| Self-hosted headless browser | self-host-oss (deferred) | Pinned Playwright/Chromium in an isolated container; "pinned" = security-patched revision, not frozen. |
| Web search (URL discovery) | unavoidable-dependency (deferred) | One isolated server-side adapter; re-validate every result through the guard. |

**Security notes:** ship the rate limiter + global concurrency cap with v1 (an unbounded browse endpoint is an internal-network scanner); re-validate the guard on every redirect/navigation; cap **bytes before decode/parse** and decompressed size (gzip bomb); return opaque errors for denied-internal targets while logging the real reason server-side.

---

## Area 3 — Agent loop, planning & multi-agent

| Component | Classification | Why |
|---|---|---|
| Core type model (Agent/Task/Tool/Step/Plan/Run) | build-from-scratch | Zod (already a dep) + discriminated unions; replaces `string[]` tasks and the `extractArray` regex. |
| Provider interface + OpenAI adapter | build-from-scratch | LangChain 0.0.57 is only an HTTP wrapper; a ~150-line fetch adapter removes the whole transitive tree. |
| Tool registry/invoker | build-from-scratch | The single audited chokepoint for tool calls. |
| Planner (typed plan/replan) | build-from-scratch | Zod-parsed structured plans replace the brittle regex. |
| Runtime loop (retries, AbortController cancel, step/token/wall-clock caps, events) | build-from-scratch | A real state machine replaces the recursive `setTimeout` loop. |
| Model router + token/cost meter | build-from-scratch | Lookup table + arithmetic; real budget caps replace `maxLoops()`. |
| Multi-agent supervisor + blackboard | build-from-scratch (optional, flagged) | Scheduler over role-scoped agents; no framework. |

**Security notes:** hard server-side caps generalize today's `maxLoops()`; AbortController must propagate to provider + tool calls so a stopped run actually halts in-flight work (today `isRunning` only stops UI messages); parse all model JSON through Zod; keep the `AgentService` facade stable so deleting LangChain is one reversible PR.

---

## Area 4 — Document ingestion & RAG

| Component | Classification | Why |
|---|---|---|
| Document + Chunk Prisma models | self-host-oss (shares the memory vector store) | One store for Memory + RAG; never a second/hosted vector DB. Vector **dimension follows the embedder decision**. |
| Chunker / section-aware splitter | build-from-scratch | Pure string logic; use the **real tokenizer** at the embed boundary, not chars/4 (lease/statement numerics break the heuristic). |
| PDF byte→text extraction | **self-host-oss, isolated as untrusted-input execution** | `pdfjs-dist` is ~15MB with a CVE history — run it in a child process/worker with byte/page/wall-clock/memory caps, JS disabled → `status=failed` instead of OOM/hang. Plain `.txt/.md` is build-from-scratch. |
| Vector store / retrieval | build-from-scratch (code) over self-host-oss (pgvector) | Parameterized `$queryRaw` cosine with **mandatory `WHERE userId=`**. |
| Ingestion pipeline + Node route | build-from-scratch | `runtime:'nodejs'`, authenticated, size/mime/quota caps, sha256 dedupe. |
| **Retrieval Node route** (`/api/documents/retrieve`) | build-from-scratch *(critique-added fix)* | Retrieval is injected into `executeTaskAgent`, which runs on edge **and** in the browser — neither can reach Prisma/pgvector, so retrieval **must** be an authenticated HTTP call. |

**Security notes:** per-tenant isolation test first, as a CI gate (both pgvector and any fallback); bind query vector + userId as parameters (no string interpolation); enforce "answer only from context, else say you don't know," cite only chunks retrieved this turn, test against an adversarial injected chunk. **If memory slips, RAG owns the whole MySQL→Postgres migration** — gate explicitly or ship Phase 1 on a MySQL blob fallback.

---

## Area 5 — Tool / plugin interface (MCP-style)

| Component | Classification | Why |
|---|---|---|
| ToolSpec contract (Zod I/O + capability manifest) | build-from-scratch | Replaces LangChain Tool/StructuredTool. |
| Registry / invoker / policy gate | build-from-scratch | One audited chokepoint, building on existing `protectedProcedure` session + subscription. |
| Node tool-runner route + egress-gated fetch | build-from-scratch (egress guard security-critical) | Edge can't sandbox; network/isolated tools run on Node. |
| Audit trail + encrypted credentials | build-from-scratch over Prisma | **Key-version the ciphertext + bind AAD to userId+toolId from day one**; store **redacted args**, not blanket hashes. |
| zod→JSON-Schema | **vendor pinned `zod-to-json-schema`** *(corrected)* | A hand-rolled walker silently mis-emits schemas the model then violates. |
| MCP client/bridge + `isolated` tier | self-host-oss (deferred / cut from v1) | Out-of-process servers; cut from v1 to halve the security-review surface. |

**Security notes (two are blockers):** (1) custom-key sessions run the loop in the browser and never hit the server, yet are the "all tools" tier — tool calls above `pure` **must** be forced through the Node `/api/tools/run` route even for those users. (2) A manifest is **not** a sandbox for in-process tools (they can ignore `ctx.fetch` and call global `fetch`) — real egress enforcement exists only out-of-process. Also: OpenAI vs Anthropic tool-use share JSON Schema but not the message envelope; budget must use measured post-hoc cost, not a static estimate.

---

## Area 6 — Model routing, provider abstraction & cost/local models

| Component | Classification | Why |
|---|---|---|
| Provider interface + shared types | build-from-scratch | The unblocking seam for every other area. |
| OpenAI adapter (fetch + **buffered** SSE) | build-from-scratch | Drops LangChain + the transitive `openai` client. SSE must buffer partial frames across chunk boundaries + handle `[DONE]`. |
| Anthropic (Claude) adapter | unavoidable-dependency | Pinned `@anthropic-ai/sdk`, single-file blast radius, server-key only; meter from provider-reported `usage`. |
| Self-hosted OSS model adapter | self-host-oss (deferred, flagged) | vLLM/Ollama OpenAI-compatible endpoint; **pin image digest + weight hash**. |
| Router, retry/backoff, meter, budget guard | build-from-scratch | Std-lib logic; real USD caps replace `maxLoops()`. |

**Security notes (blockers):** the meter (`prisma.runUsage.create`) is called from edge where Prisma can't run and there's no session → forces Phase 0; budget caps are server-enforceable only on the non-BYO path (advisory for custom-key — say so); **constrain `customModelName` against a server-side known-models registry** (today it flows straight into `new OpenAI()` — a live cost/abuse hole pointing the *server* key at arbitrary models).

---

## Cross-cutting Phase 0 (shared prerequisite)

Move `start.ts`/`create.ts`/`execute.ts` **off edge to Node** (or route their persistence/enforcement through Node tRPC) and add `getServerAuthSession`, so `userId`, verified subscription tier, and Prisma are available at the call site. Derive `runId`/`userId`/tier **server-side** from the session + persisted `Agent` row — never from the request body. Without this, every per-user guarantee is unenforceable and the highest-tier (custom-key/browser) users bypass all of it.

---

## Dependency doctrine (the rules)

1. **Pin exact versions** for every new dependency (no `^`/`~`) and commit the lockfile — a caret range is an unreviewed future code change.
2. **Vendor + SHA-256** any non-npm artifact (ONNX weights, Chromium revision, vLLM/Ollama image); pin container images by **digest**, never tag.
3. **Scan in CI as a merge gate:** `npm audit` + a Socket/SCA scan + a "no new transitive deps without review" check on the agent/tool/web subtrees.
4. **Isolate each unavoidable dependency behind exactly one first-party adapter file** — server-side only, key from env schema, never crossing to browser/edge or into prompts.
5. **Self-host audited OSS over any hosted API** wherever avoidable (pgvector, embedding model, inference server, browser, PDF parser).
6. **Do not hand-roll the known footguns:** HTML sanitization, PDF parsing, vector ANN index, tokenizer, zod→JSON-Schema, embedding model, LLM, browser engine, AES key management. For these, "in-house" = pinned self-hosted OSS behind a thin interface.
7. **Treat parsers + the SSRF guard as untrusted-input execution:** cap input size before parsing, run PDF/HTML parsing under wall-clock + memory limits in a worker, prove the SSRF rebind pin with an adversarial test.
8. **Minimize npm surface:** prefer Web/Node std APIs (fetch, ReadableStream, crypto, URL, AbortController, undici dispatcher, Worker, Prisma) over new packages.
9. **Key-version all encrypted-at-rest credentials** and bind ciphertext to a context AAD (userId+toolId) from the first migration.
10. **Secrets never reach edge/browser/prompts/logs;** decryption happens only inside the authenticated Node tool-runner. Audit rows are append-only with redacted args.
11. **Every cross-tenant boundary ships with a two-user isolation test as a CI gate;** authorization derives identity from the server session and verifies ownership of any client-supplied id.

---

## Phased roadmap (highest-ROI + most self-contained first)

- **Phase 0 — Authenticated Node seam (shared prerequisite).** Move the three task endpoints to Node + add `getServerAuthSession`; derive `runId`/`userId`/tier server-side. Decide how custom-key (browser) sessions route enforced operations through the server.
- **Phase 1 — In-house memory (first slice).** Persistent, session-scoped, explainable memory on the **current MySQL** datasource, zero new deps. (Details below.)
- **Phase 2 — Provider seam + delete LangChain.** First-party `LLMProvider` + OpenAI fetch adapter (buffered SSE); port the three agent functions; persisted token/cost meter; remove `langchain`.
- **Phase 3 — Typed loop, tools, retries, budget.** `AgentRuntime` state machine with caps + AbortController; ToolSpec/registry/policy gate; Node tool-runner with the egress guard (adversarial rebind test); `web.fetch` behind a per-agent grant + rate limiter; budget guard; constrain `customModelName`; Anthropic adapter.
- **Phase 4 — Postgres + pgvector migration + semantic memory.** Migrate the datasource once (its own reviewed project); add the vector column + index; switch the `Embedder` per your decision; hybrid (lexical + cosine) recall + backfill.
- **Phase 5 — RAG on the shared store.** Ingest → chunk → embed → retrieve → grounded answers with citations; isolated PDF parser; authenticated retrieve route; per-tenant isolation gate + injection test.
- **Phase 6 — Optional self-host + JS browsing + MCP.** Stand up vLLM/Ollama (pinned digest + weight hash), the headless-browser tier (patched, egress-pinned container), and the MCP bridge — only when a concrete need exists.

---

## First slice to build now

**In-house long-term memory (lexical, MySQL, zero new deps).**

A first-party, session-scoped memory layer on the **existing MySQL** datasource: add a `Memory` Prisma model; an `Embedder` interface whose Phase-1 implementation uses MySQL native `FULLTEXT` (`MATCH…AGAINST`) instead of a hand-rolled scan; `remember()`/`recall()` through a new authenticated tRPC `memoryRouter` (Node); and recall-before-execute / remember-after-result wired into the loop. Every call verifies the client `agentId` belongs to `session.user.id`. Memory is injected as delimited **untrusted** content, and all memory I/O is non-fatal. This removes the "no memory" gap entirely with **no datasource migration**.

**Files to touch:** `prisma/schema.prisma` (+ migration), `src/server/memory/{types,embedder/types,recall/lexical,write,read}.ts`, `src/server/api/routers/memoryRouter.ts`, `src/server/api/root.ts`, `src/components/AutonomousAgent.ts`, `src/utils/prompts.ts`, `src/services/agent-service.ts`, plus `__tests__/{isolation,cascade}.test.ts`.

**New dependencies:** none. `embed()` for semantic vectors stays a typed `NotImplemented` stub behind the `Embedder` interface.

**Acceptance criteria:** persists `(task,result)` scoped to the authenticated user + verified-owned agent; recall returns top-k via indexed `MATCH…AGAINST` injected as delimited untrusted content; two-user isolation test passes as a CI gate; cascade test proves user/agent deletion purges memory; write-boundary caps + LRU/TTL eviction enforced; an "ignore previous instructions" memory does not alter behavior; recall/remember failures are non-fatal; no new npm dependency.

---

## Decisions only you can make

These four are recorded here and asked directly. Recommended answers in **bold**.

1. **Where do embeddings come from?** (shared by memory + RAG)
   - **No model — MySQL FULLTEXT lexical recall (ships now, zero network/weights)** ✅ recommended first
   - Self-host OSS model (vendored ONNX e.g. MiniLM/BGE/E5, pinned by hash; needs Postgres+pgvector + CPU)
   - Hosted API (best quality, simplest, but your text — incl. lease/PII — leaves your infrastructure)
2. **When to migrate MySQL → Postgres + pgvector?**
   - **Defer — ship lexical memory now, migrate later as its own reviewed project** ✅ recommended
   - Migrate now to Supabase Postgres and build semantic features directly
   - Two datasources (rejected — doubles ops, breaks cross-table FKs)
3. **Self-hosted OSS inference server (vLLM/Ollama) now, or later?**
   - **Defer — ship OpenAI+Anthropic routing now with the self-hosted adapter coded but flagged off** ✅ recommended
   - vLLM on your own GPU host now / Ollama on a small host now
4. **Custom-key (browser) tier — budget + tool enforcement?**
   - **Accept advisory budget for BYO (their wallet) + loop backstop, but force network/isolated tool calls through the Node route even for BYO** ✅ recommended
   - Force all model calls (incl. BYO) through the server (full enforcement, removes the browser fast-path)
   - Leave BYO fully client-side and ungated (simplest, but the "all tools" tier has no server enforcement)
