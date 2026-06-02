# Design Rule System

Follow this workflow for new designs, refactors, and audits.

## Steps

1. Inventory existing sources: `CLAUDE.md`, `.claude/`, `CLAUDE.local.md`, `AGENTS.md`, `CODEX.md`, `.cursor/`, memory indexes, and any user-provided docs.
2. Classify each item by purpose: stable rule, behavior feedback, user profile, project background, external reference, task progress, code fact, or duplicate.
3. Place each item using `references/placement-matrix.md`.
4. Rewrite vague rules into concrete constraints with scope, reason, and verification.
5. Turn large entry files into indexes that include or route to topic files.
6. Remove duplicates across CLAUDE.md and memory; keep memory for reinforcement or non-derivable context.
7. Validate the design against Claude Code loading behavior in `references/claude-code-loading.md`.

## Output Format

For design or audit responses, return:

1. Proposed file layout.
2. Placement decisions with rationale.
3. Rewritten rule examples.
4. Risks or gotchas that remain.
5. Validation checklist.

## Validation Checklist

- Every rule has a clear owner file.
- `MEMORY.md` remains an index, not a long note.
- Project rules are versionable unless intentionally local.
- Repeated behavior corrections are modeled as `feedback`, not duplicate project rules.
- Stale facts are either removed or marked for verification against current code.
