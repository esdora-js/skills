# Claude Code Loading Notes

These notes summarize the source documents used to derive this skill.

## CLAUDE.md Loading

- CLAUDE.md is injected through user-context wrapping, not as system prompt.
- The wrapper tells the model the context may or may not be relevant, so vague rules lose force.
- Claude Code also adds strong wording that project instructions must be followed, so concrete rules still work well.
- Loading walks from broader sources toward more local sources; later and closer files tend to win attention.
- Project `.claude/rules/*.md` files are discovered recursively.
- `@` includes can modularize files; code blocks are not parsed as includes.
- Missing includes are ignored. External includes may require approval.
- `--bare`, environment flags, settings, or feature flags can disable some CLAUDE.md sources.
- Nested git worktrees may be deduplicated to avoid loading identical project files twice.

## Memory Loading

- Memory is loaded in the dynamic system-prompt area, so it is stronger behavioral context than CLAUDE.md.
- `MEMORY.md` has entrypoint limits: 200 lines and 25 KB. Treat it as an index.
- Topic files carry the detailed content and are read when the index row is relevant.
- Memory types are `feedback`, `user`, `project`, and `reference`.
- Feedback should record both failures and validated successes; include `Why` for edge-case judgment.
- Memory can become stale. Verify mentioned files, functions, and current-state claims before asserting them.

## Architecture Implication

Use CLAUDE.md and `.claude/rules` for shared, versioned operating rules. Use memory for high-signal behavior reinforcement and non-derivable context. Use entry files as indexes, not dumping grounds.
