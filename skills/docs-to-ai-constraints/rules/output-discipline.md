# Output Discipline

Every output must be traceable, actionable, and small enough to maintain.

## Required Evidence

- Cite source document paths for every extracted rule, workflow, or reference.
- Mark confidence when the source is ambiguous.
- Separate observed source text from inferred recommendations.
- Flag stale, duplicated, or conflicting docs instead of silently merging them.

## Required Tables

For audits and migrations, include:

1. Source inventory: path, title or section, short summary.
2. Classification table: source, extracted item, category, destination, rationale.
3. Action plan: keep, rewrite, move, split, archive, discard.
4. Validation checklist: what an AI agent must read or verify before development.

## Hard Limits

- Do not create one giant skill for all docs.
- Do not copy whole documents into rules.
- Do not convert background descriptions into mandatory constraints.
- Do not persist secrets, temporary project status, or facts already discoverable from code.
