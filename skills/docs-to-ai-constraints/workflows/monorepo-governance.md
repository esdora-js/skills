# Monorepo Governance

Use this workflow when a docs-heavy monorepo needs root and subproject AI constraints, entry files, rules, workflows, and references.

## Default Behavior

- Produce a read-only plan first.
- Do not create, overwrite, archive, or delete entry files unless the user explicitly confirms edits.
- Treat existing subproject docs and agent files as source evidence, not as automatically trusted current truth.

## Steps

1. Identify workspace topology: apps, packages, services, libraries, tools, examples, and shared configs.
2. Inventory docs and existing agent instructions at root and per subproject.
3. Classify each item using `references/classification-matrix.md`.
4. Assign scope using `references/monorepo-scope-matrix.md`: root, domain, subproject, shared package, or source-only.
5. Build inheritance: root constraints apply by default; subproject constraints add or explicitly override with rationale.
6. Propose entry files only where local rules or workflows differ from root.
7. Propose rules, workflows, and references per scope; avoid duplicating root rules in subprojects.
8. Flag conflicts, stale docs, and packages with missing governance coverage.
9. Output a migration plan and ask for confirmation before any file edits.

## Output

Return:

1. Workspace topology.
2. Root governance proposal.
3. Per-subproject entry/rule/workflow/reference proposal.
4. Inheritance and override table.
5. Conflict and stale-source list.
6. Migration plan.
7. Confirmation gate for edits.
