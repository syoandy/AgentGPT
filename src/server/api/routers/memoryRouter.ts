import { z } from "zod";

import { TRPCError } from "@trpc/server";
import { createTRPCRouter, protectedProcedure } from "../trpc";
import { writeMemory } from "../../memory/write";
import { recallMemories } from "../../memory/read";
import {
  MEMORY_MAX_CONTENT_CHARS,
  MEMORY_MAX_RECALL_K,
  MEMORY_NAMESPACE_MAX_CHARS,
} from "../../../utils/memory";

const rememberInput = z.object({
  namespace: z.string().min(1).max(MEMORY_NAMESPACE_MAX_CHARS),
  kind: z.enum(["task_result", "note", "fact"]),
  // Server still truncates to MEMORY_MAX_CONTENT_CHARS; this is just an
  // up-front abuse bound on the request body.
  content: z.string().min(1).max(MEMORY_MAX_CONTENT_CHARS * 4),
  agentId: z.string().optional(),
  metadata: z.record(z.unknown()).optional(),
});

const recallInput = z.object({
  namespace: z.string().max(MEMORY_NAMESPACE_MAX_CHARS).optional(),
  query: z.string().max(2000),
  k: z.number().int().min(1).max(MEMORY_MAX_RECALL_K).optional(),
});

/**
 * Authenticated memory API. Every procedure derives the user id from the
 * session (never the request body); a client-supplied agentId is only accepted
 * after verifying the caller owns that agent.
 */
export const memoryRouter = createTRPCRouter({
  remember: protectedProcedure
    .input(rememberInput)
    .mutation(async ({ ctx, input }) => {
      const userId = ctx.session.user.id;

      if (input.agentId) {
        const owned = await ctx.prisma.agent.findFirst({
          where: { id: input.agentId, userId },
          select: { id: true },
        });
        if (!owned) {
          throw new TRPCError({
            code: "FORBIDDEN",
            message: "Agent not found for this user.",
          });
        }
      }

      await writeMemory(ctx.prisma, userId, input);
      return { ok: true };
    }),

  recall: protectedProcedure.input(recallInput).query(async ({ ctx, input }) => {
    const userId = ctx.session.user.id;
    return recallMemories(ctx.prisma, userId, input);
  }),

  forget: protectedProcedure
    .input(z.object({ namespace: z.string().min(1).max(MEMORY_NAMESPACE_MAX_CHARS) }))
    .mutation(async ({ ctx, input }) => {
      const userId = ctx.session.user.id;
      const { count } = await ctx.prisma.memory.deleteMany({
        where: { userId, namespace: input.namespace.trim().toLowerCase() },
      });
      return { deleted: count };
    }),
});
