# Workflow - Plan Batches

Use this workflow after change analysis.

## Step 1 - Group by intent

Start with one group per independent intent. Then refine using:

- Type
- Scope
- Risk
- Breaking-change status
- Runtime/test/doc/config boundaries
- Source/generated boundaries

Do not optimize for fewer commits unless the grouped changes are genuinely one
reversible unit.

## Step 2 - Draft messages

For each group, draft a Conventional Commit message using:

1. Local commit configuration, if present
2. [commit-format.md](../rules/commit-format.md), when local configuration is absent
   or incomplete

Use Chinese subjects unless local configuration explicitly requires otherwise.

## Step 3 - Check partial-file conflicts

If one file contains multiple independent intents:

- Mark the batch as requiring partial staging.
- Explain which hunks belong to each batch.
- 询问用户并等待确认 before any interactive staging.

## Step 4 - Present the full plan

Show all batches before any commit action.

Recommended format:

```text
Batch 1
Files:
- path/to/file

Commit message:
type(scope): 中文 subject

- body line

Split rationale:
- why these files belong together

Risk:
- Low/Medium/High and reason

Breaking change:
- None, or impact and migration path
```

## Step 5 - Confirm next action

询问用户并等待确认 whether to:

- Commit these batches as proposed
- Revise specific batches or messages
- Only output the messages
- Stop without committing

If the user gives feedback, revise the batches and ask again.
