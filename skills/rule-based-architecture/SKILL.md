---
name: rule-based-architecture
description: >
  This skill should be used when the user asks to design or refactor agent rule
  systems, such as "重写 CLAUDE.md", "规则应该放 CLAUDE.md 还是 Memory",
  "设计上下文注入链路", "整理 Claude Code 规则", or "build a rule-based
  architecture for agent instructions". Activate when the task concerns
  CLAUDE.md, MEMORY.md, .claude/rules, persistent memory, instruction priority,
  context injection, or rule placement decisions.
---

# Rule-Based Architecture

Design maintainable agent-rule systems using Claude Code's real loading model:
rules are concrete and routed, memory is indexed and high-signal, and every
piece of context has a deliberate injection layer.

## Always Read

These files apply to every task. Read them first:
1. `rules/context-layers.md`
2. `rules/rule-writing.md`

## Common Tasks

Each entry lists the exact files to read. Do not read unrelated files.

- Decide where a rule belongs / 规则放置决策 (`place-rule`) -> follow `workflows/design-rule-system.md`; ref `references/placement-matrix.md`; triggers: "放 CLAUDE.md 还是 Memory", "这条规则应该放哪", "where should this instruction live"
- Refactor CLAUDE.md / .claude/rules (`refactor-claude`) -> follow `workflows/design-rule-system.md`; ref `references/claude-code-loading.md`; triggers: "重写 CLAUDE.md", "拆分 .claude/rules", "整理 Claude Code 配置"
- Design MEMORY.md / topic memories (`design-memory`) -> follow `workflows/design-rule-system.md`; ref `references/placement-matrix.md`; triggers: "设计 MEMORY.md", "记录到 memory", "persistent memory strategy"
- Audit an existing rule architecture (`audit-rules`) -> follow `workflows/design-rule-system.md`; read both references; triggers: "规则不生效", "审查上下文注入", "audit agent instructions"
- Other / unlisted task (`other`) -> use the Always Read files, then choose the closest reference by filename.

## Known Gotchas

- CLAUDE.md is not system prompt: it is injected as an early user-context reminder. Use concrete, verifiable instructions.
- MEMORY.md is an index, not a notebook. Keep detail in topic files and route by one-line descriptions.
- Do not duplicate CLAUDE.md rules into memory. Use `feedback` memories only to reinforce repeated behavior failures or successes.

## Core Principles

1. **Place by injection layer** — choose the storage location by priority, scope, and volatility, not by convenience.
   Check: can you explain why this rule belongs in CLAUDE.md, `.claude/rules`, `CLAUDE.local.md`, or memory?

2. **Rules must be testable** — vague style wishes decay; write observable constraints.
   Check: can another agent verify compliance without guessing intent?

3. **Indexes stay small** — entry files route to detail files instead of carrying the detail themselves.
   Check: would this still survive line and byte limits if the project doubled?

4. **No stale facts without verification** — memory and generated rule docs are point-in-time observations.
   Check: if a file path, function, or current-state claim appears, did you verify it against the present codebase?

## Rule Priority

1. `skills/rule-based-architecture/SKILL.md`
2. `skills/rule-based-architecture/rules/`
3. `skills/rule-based-architecture/workflows/`
4. `skills/rule-based-architecture/references/`
5. Source documents provided by the user

## Boundaries

- This skill designs rule and memory architecture for agent behavior.
- It decides context placement: `CLAUDE.md`, `.claude/rules`, `CLAUDE.local.md`, memory, or no persistent record.
- It does not replace project-specific coding standards or general prompt writing.
- It does not store secrets, transient task progress, git history summaries, or facts that the codebase can answer directly.
