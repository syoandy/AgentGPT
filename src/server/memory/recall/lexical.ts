import { Prisma, type PrismaClient } from "@prisma/client";

import { mergeRankedResults, type RankedMemory } from "../../../utils/memory";

interface RawRow {
  id: string;
  content: string;
  kind: string;
  createDate: Date;
  score: number;
}

/**
 * Lexical recall over MySQL's native FULLTEXT index (MATCH ... AGAINST), scoped
 * to a single user (the tenant boundary) and optionally a namespace.
 *
 * FULLTEXT in natural-language mode ignores very short/very common words, so it
 * can legitimately return nothing for a sparse store or a short query. We
 * therefore always supplement with a recency fallback so recall stays useful,
 * and on ANY error we degrade to recency-only (recall must never throw into the
 * agent loop). All inputs are bound as parameters — no string interpolation.
 */
export async function lexicalRecall(
  prisma: PrismaClient,
  userId: string,
  query: string,
  k: number,
  namespace?: string
): Promise<RankedMemory[]> {
  const q = query.trim();
  let primary: RankedMemory[] = [];

  if (q.length > 0) {
    const nsFilter = namespace
      ? Prisma.sql`AND namespace = ${namespace}`
      : Prisma.empty;
    try {
      const rows = await prisma.$queryRaw<RawRow[]>(Prisma.sql`
        SELECT id, content, kind, createDate,
               MATCH(content) AGAINST (${q} IN NATURAL LANGUAGE MODE) AS score
        FROM Memory
        WHERE userId = ${userId} ${nsFilter}
          AND MATCH(content) AGAINST (${q} IN NATURAL LANGUAGE MODE)
        ORDER BY score DESC
        LIMIT ${k}
      `);
      primary = rows.map((r) => ({
        id: r.id,
        content: r.content,
        kind: r.kind,
        createDate: r.createDate,
        score: Number(r.score),
      }));
    } catch {
      // FULLTEXT index missing or query rejected -> fall back to recency only.
      primary = [];
    }
  }

  if (primary.length >= k) return primary;

  const recent = await prisma.memory.findMany({
    where: { userId, ...(namespace ? { namespace } : {}) },
    orderBy: { createDate: "desc" },
    take: k,
    select: { id: true, content: true, kind: true, createDate: true },
  });
  const fallback: RankedMemory[] = recent.map((r) => ({ ...r, score: 0 }));

  return mergeRankedResults(primary, fallback, k);
}
