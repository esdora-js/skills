# Target Model Adaptation

Before writing, identify what the user is prompting. The universal principles (short, plan-first, feedback-loop, no padding) apply everywhere; the anchors and persistent-context mechanisms differ.

## Per-assistant capabilities

| Target | `@file` | Persistent context | Notes |
|---|---|---|---|
| **Claude Code** | ✓ | `CLAUDE.md` (project), `CLAUDE.local.md` (personal), `~/.claude/CLAUDE.md` (global), nested `CLAUDE.md` | Full toolkit: slash commands, `commit, push, PR` shorthand, plan mode by natural language. |
| **Claude (claude.ai, API)** | ✗ | Projects, system prompts | Most principles apply; no `@file` or `CLAUDE.md`. |
| **ChatGPT** | ✗ | Custom Instructions, Projects, system prompt | Universal principles apply. "Explore the codebase" only works if the model has tools to do so. |
| **Gemini** | ✗ | Gems, system instructions | Universal principles apply. |
| **Cursor / Windsurf / Copilot Chat** | ✓ (different syntax) | `.cursorrules`, `.windsurfrules`, per-project rules | Editor-integrated; plan-first works. |
| **Agent frameworks (autonomous tools)** | varies | varies | Emphasize the feedback loop heavily — these run without supervision. |

## When to ask

If the target isn't obvious from context **and it materially changes the prompt** (e.g. you'd use `@file` for Claude Code but not for ChatGPT), ask via `AskUserQuestion` — see [clarify.md](clarify.md).

## Quick swap map

When taking a Claude-Code prompt to another model:

- `@file.ts` → paste the file contents, or describe what's in it
- `CLAUDE.md` → Custom Instructions / Project context / Gem / `.cursorrules`
- `commit, push, PR` → spell it out; only Claude Code parses this shorthand
- "look at how X is implemented" → only works if the target has codebase access tools
