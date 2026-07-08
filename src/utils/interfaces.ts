import type { ModelSettings } from "./types";

export interface RequestBody {
  modelSettings: ModelSettings;
  goal: string;
  task?: string;
  /** Optional delimited long-term memory block injected into task execution. */
  memory?: string;
  tasks?: string[];
  lastTask?: string;
  result?: string;
  completedTasks?: string[];
}
