# Intake

Use this workflow when the user asks for docs governance but has not specified goal, scope, or output mode.

## Default Behavior

- Ask before scanning when the request is broad or ambiguous.
- Ask at most 3 questions.
- Default to read-only report mode unless the user explicitly asks for edits.
- Do not modify, delete, archive, or generate skill files during intake.

## Questions

Ask only the missing questions:

1. Goal: complete governance, classify selected docs, design migration plan, or rescue an oversized skill?
2. Scope: entire repository, `docs/`, a package/app, selected files, or an existing skill?
3. Output mode: read-only report, migration plan, or edits after confirmation?

## Route Selection

- Complete governance -> `workflows/audit-docs.md`, then `workflows/classify-content.md`, then `workflows/design-governance.md`.
- Monorepo governance or per-package entry/rule split -> `workflows/monorepo-governance.md`.
- Classify selected docs -> `workflows/classify-content.md`.
- Design from existing classification -> `workflows/design-governance.md`.
- Rescue oversized skill -> `workflows/rescue-oversized-skill.md`.

## Output

After answers are known, state:

1. Selected route.
2. Scope.
3. Output mode.
4. Whether user confirmation is required before edits.
5. Next workflow to run.
