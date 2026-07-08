import { type PrismaClient } from "@prisma/client";

import {
  MEMORY_DEFAULT_RECALL_K,
  MEMORY_MAX_RECALL_K,
  normalizeNamespace,
  type RankedMemory,
} from "../../utils/memory";
import { lexicalRecall } from "./recall/lexical";

export interface RecallInput {
  namespace?: string;
  query: string;
  k?: number;
}

/**
 * Recall the top-k relevant memories for a user. The user id comes from the
 * server session; callers never pass a client-supplied identity here.
 */
export async function recallMemories(
  prisma: PrismaClient,
  userId: string,
  input: RecallInput
): Promise<RankedMemory[]> {
  const k = Math.min(
    Math.max(input.k ?? MEMORY_DEFAULT_RECALL_K, 1),
    MEMORY_MAX_RECALL_K
  );
  const namespace = input.namespace
    ? normalizeNamespace(input.namespace)
    : undefined;
  return lexicalRecall(prisma, userId, input.query, k, namespace);
}
