import { api } from "../utils/api";
import type { MemoryKind, RankedMemory } from "../utils/memory";
import { useAuth } from "./useAuth";

export interface RecallArgs {
  namespace: string;
  query: string;
  k?: number;
}

export interface RememberArgs {
  namespace: string;
  kind: MemoryKind;
  content: string;
}

export type RecallFn = (args: RecallArgs) => Promise<RankedMemory[]>;
export type RememberFn = (args: RememberArgs) => Promise<unknown>;

/**
 * Long-term memory hook for the agent loop.
 *
 * Returns recall/remember functions ONLY for authenticated users; otherwise
 * both are undefined so the agent loop transparently runs with no memory
 * (anonymous/demo behavior is unchanged). All memory I/O is best-effort — the
 * loop wraps these calls so a failure is never fatal.
 */
export function useMemory(): { recall?: RecallFn; remember?: RememberFn } {
  const { status } = useAuth();
  const utils = api.useContext();
  const rememberMutation = api.memory.remember.useMutation();

  if (status !== "authenticated") return {};

  return {
    recall: (args) => utils.memory.recall.fetch(args),
    remember: (args) => rememberMutation.mutateAsync(args),
  };
}
