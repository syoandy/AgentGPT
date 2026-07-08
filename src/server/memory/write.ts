import { Prisma, type PrismaClient } from "@prisma/client";

import {
  MEMORY_MAX_ROWS_PER_NAMESPACE,
  normalizeNamespace,
  prepareMemoryContent,
  type MemoryKind,
} from "../../utils/memory";

export interface RememberInput {
  /** Grouping key (e.g. the agent goal). */
  namespace: string;
  kind: MemoryKind;
  content: string;
  /** Optional link to a saved Agent (caller must verify ownership first). */
  agentId?: string | null;
  metadata?: Record<string, unknown>;
}

/**
 * Persist one memory for a user, then evict overflow.
 *
 * Identity (userId) is supplied by the caller from the server session — never
 * from the client. Content is capped, oversize is truncated (flagged in
 * metadata) rather than rejected so a write can never break a run.
 */
export async function writeMemory(
  prisma: PrismaClient,
  userId: string,
  input: RememberInput
): Promise<void> {
  const { content, truncated } = prepareMemoryContent(input.content);
  if (content.length === 0) return;

  const namespace = normalizeNamespace(input.namespace);
  const metadata = truncated
    ? { ...(input.metadata ?? {}), truncated: true }
    : input.metadata;

  await prisma.memory.create({
    data: {
      userId,
      agentId: input.agentId ?? null,
      namespace,
      kind: input.kind,
      content,
      ...(metadata ? { metadata: metadata as Prisma.InputJsonValue } : {}),
    },
  });

  await evictOverflow(prisma, userId, namespace);
}

/** LRU eviction: keep only the most recent N rows per (user, namespace). */
async function evictOverflow(
  prisma: PrismaClient,
  userId: string,
  namespace: string
): Promise<void> {
  const overflow = await prisma.memory.findMany({
    where: { userId, namespace },
    orderBy: { createDate: "desc" },
    skip: MEMORY_MAX_ROWS_PER_NAMESPACE,
    select: { id: true },
  });
  if (overflow.length === 0) return;
  await prisma.memory.deleteMany({
    where: { id: { in: overflow.map((m) => m.id) } },
  });
}
