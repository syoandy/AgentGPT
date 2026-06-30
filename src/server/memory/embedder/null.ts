import type { Embedder } from "./types";

/**
 * Placeholder embedder. Semantic recall is deferred until the Postgres +
 * pgvector migration, so embed() is a typed NotImplemented stub: the seam
 * exists and type-checks, but nothing can accidentally call out to an
 * embedding model or hosted API yet.
 */
export const nullEmbedder: Embedder = {
  id: "null",
  dim: 0,
  embed: () => {
    return Promise.reject(
      new Error(
        "NotImplemented: semantic embeddings require the Postgres + pgvector " +
          "migration. See docs/horizon-ai-inhouse-build-plan.md."
      )
    );
  },
};
