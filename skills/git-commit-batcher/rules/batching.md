# Commit Batching Rules

Split changes by the smallest unit that can be reverted independently without
breaking unrelated work.

## Primary split signals

Prefer separate commits when changes differ by:

- Independent user or developer intent
- Conventional Commit `type`
- Scope or package/module boundary
- Risk level
- Breaking-change status
- Runtime code vs tests vs documentation vs configuration
- Generated artifacts vs source files
- Mechanical formatting vs behavioral change

Do not combine unrelated changes just to reduce the number of commits.

## Risk levels

Assign each file or batch a practical risk level:

- Low: docs, comments, tests only, local examples, narrow config metadata
- Medium: implementation changes with limited scope, refactors with tests
- High: public API changes, data migrations, auth/security, build/release pipeline,
  generated lockfile churn, broad refactors, or behavior changes without tests

Breaking changes are always high risk.

## Batch proposal requirements

Each proposed batch must include:

- Batch number
- File list
- Commit message
- Split rationale
- Risk notes
- Breaking-change notes, if any

If a single file contains changes for multiple batches, state that partial staging is
required and 询问用户并等待确认 before using an interactive patch workflow.

## Minimal reversible principle

A good batch can be reverted alone while leaving the repository coherent. If
reverting one batch would also require reverting another unrelated batch, the split
is probably wrong.
