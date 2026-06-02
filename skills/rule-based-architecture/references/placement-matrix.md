# Placement Matrix

| Content | Put it in | Why |
|---|---|---|
| Versioned project rule | `CLAUDE.md`, `.claude/CLAUDE.md`, or `.claude/rules/*.md` | Shared rule context for the repository |
| Domain-specific project rule | `.claude/rules/<domain>/*.md` or subtree `CLAUDE.md` | Loaded with project context while keeping topics separate |
| Personal preference | `~/.claude/CLAUDE.md` | Applies across projects without polluting repository rules |
| Machine-local exception | `CLAUDE.local.md` | Highest local priority and not committed |
| Repeated behavior correction | Memory topic with `type: feedback` | Higher behavioral weight and tied to a concrete failure or success |
| Stable user profile | Memory topic with `type: user` | Helps communication and defaults across sessions |
| Non-derivable project context | Memory topic with `type: project` | Preserves background not visible in code |
| External tracker or document pointer | Memory topic with `type: reference` | Points the agent to the authoritative external source |
| Code structure, functions, file paths | Do not store as memory | Read code and search current files instead |
| Git history or PR summary | Do not store as memory | `git log` and trackers are authoritative |
| Temporary task progress | Task system, plan, or workflow state | Memory is cross-session context, not a todo list |
| Secret or credential | Nowhere in agent rules or memory | Avoid exposing sensitive data to prompts |

## Decision Questions

1. Is this a stable rule or a memory about agent behavior?
2. Should it be shared with the repo, personal to the user, or local to this machine?
3. Can the current codebase or git history answer this more reliably?
4. Will this still be true after `/clear`, `/compact`, or next week?
5. Does the entry file route to detail, or is it becoming a dumping ground?

## Feedback Memory Template

```markdown
---
name: short-behavior-name
description: One-line behavior signal that helps decide when to read this memory
type: feedback
---

State the behavior rule in concrete terms.

**Why:** Explain the prior failure or success that makes this worth preserving.
**How to apply:** Define the task scope where the rule applies.
```
