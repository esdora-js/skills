# Context Layers

Use the layer with the right priority, scope, and lifetime.

## Layer Order

1. System prompt and managed policy outrank all user/project rule files.
2. Memory is loaded into the dynamic system-prompt area and has higher behavioral weight than CLAUDE.md.
3. CLAUDE.md content is injected as an early user-context reminder, not as system prompt.
4. More local project files usually matter more because later-loaded and closer context receives more attention.

## CLAUDE.md Family

- Use root `CLAUDE.md` or `.claude/CLAUDE.md` for project-level rules that should be versioned.
- Use `.claude/rules/*.md` for modular project rules; subdirectories are discovered recursively.
- Use subdirectory `CLAUDE.md` for rules that only apply under that subtree.
- Use `CLAUDE.local.md` for local, uncommitted rules; treat it as highest-priority and non-shared.
- Use `@` includes to split large files, but remember missing files are ignored and external includes may require approval.

## Memory Family

- Use `feedback` memory for repeated behavior corrections or validated user preferences about how the agent should behave.
- Use `user` memory for stable user profile information.
- Use `project` memory for non-code project context that cannot be derived from repository files.
- Use `reference` memory for pointers to external systems.
- Never store secrets, transient task progress, git history, code facts, or duplicate CLAUDE.md content in memory.

## Cache And Freshness

- Avoid frequent churn in CLAUDE.md because changing it invalidates cached user-context content.
- `/clear` and `/compact` reload memory and dynamic prompt sections.
- Memory older than the current work should be treated as a point-in-time observation; verify current-state claims before using them.
