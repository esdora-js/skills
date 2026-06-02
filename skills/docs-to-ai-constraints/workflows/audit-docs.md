# Audit Docs

Use this workflow when starting from a docs-heavy project or monorepo.

## Steps

1. Inventory likely docs: `docs/`, `README*`, package docs, architecture docs, contribution docs, test docs, and existing agent instruction files.
2. Group sources by domain: repo-wide, frontend, backend, package-specific, testing, deployment, review, architecture, business context.
3. Extract only actionable claims and durable context. Ignore boilerplate and stale status unless it affects classification.
4. Classify each item using `references/classification-matrix.md`.
5. Mark source evidence for every item.
6. Identify conflicts, duplicates, stale docs, and missing owner areas.
7. Produce classification tables and a proposed next step: extract rules, design skills, or rescue an existing skill.

## Output

Return:

1. Doc inventory.
2. Classification table.
3. High-priority AI constraints.
4. Skill candidates.
5. Risks, conflicts, and stale-source warnings.
6. Recommended next workflow.
