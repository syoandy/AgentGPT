/**
 * Embedder seam for the future SEMANTIC (vector) memory upgrade.
 *
 * Phase 1 memory is lexical (MySQL FULLTEXT) and does not use embeddings, so
 * there is intentionally no concrete embedder yet. This interface fixes the
 * contract now so that swapping in a self-hosted ONNX model (or an isolated
 * hosted API) after the Postgres + pgvector migration is a one-file change.
 * See docs/horizon-ai-inhouse-build-plan.md (Area 1, forced decision #1).
 */
export interface Embedder {
  /** Stable identifier stored alongside each vector (e.g. "bge-small-en-v1.5"). */
  readonly id: string;
  /** Output dimensionality; the pgvector column must match this. */
  readonly dim: number;
  /** Map texts to vectors. */
  embed(texts: string[]): Promise<number[][]>;
}
