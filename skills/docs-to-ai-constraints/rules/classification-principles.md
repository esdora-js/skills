# Classification Principles

Classify content by how an AI agent should use it, not by the document title.

## Categories

- **Rule**: mandatory constraint for development behavior or code output.
- **Workflow**: repeatable task procedure with steps.
- **Reference**: background context, domain knowledge, glossary, architecture notes, or examples.
- **Skill candidate**: recurring capability with its own trigger language, routes, rules, workflows, and references.
- **Memory candidate**: user preference, behavior feedback, or non-derivable project context that should persist across sessions.
- **Discard / source-only**: transient status, duplicated text, stale facts, secrets, code facts, or git-history summaries.

## Decision Tests

- If violating it is a defect, classify it as a rule.
- If it says how to perform a recurring task, classify it as a workflow.
- If it helps understanding but is not mandatory, classify it as a reference.
- If it spans multiple recurring tasks with distinct trigger phrases, classify it as a skill candidate.
- If it corrects or reinforces agent behavior across sessions, classify it as a memory candidate.
- If current code, tests, git, or docs can answer it better, keep it as source-only.

## Monorepo Scope

- Root rules apply to every package only when genuinely universal.
- Package-specific constraints should stay scoped to that package or domain.
- Shared workflows should name their applicable package types.
- Do not force unrelated apps, services, or libraries into one universal skill.
- Subproject entry files should summarize local scope and route to local rules; they should not duplicate root rules.
- Conflicts between root and subproject constraints require an explicit override rationale.
