# Classification Matrix

| Signal | Category | Destination pattern |
|---|---|---|
| "must", "never", "always", pass/fail development constraint | Rule | Project or domain rule file |
| Step-by-step recurring task | Workflow | Task workflow |
| Glossary, business context, architecture explanation | Reference | Reference file with source link |
| Multiple recurring tasks with distinct triggers | Skill candidate | Separate skill design |
| User preference or repeated AI behavior correction | Memory candidate | User / feedback / project memory, if supported |
| Current file paths, function lists, code facts | Source-only | Search code when needed |
| Release status, temporary plan, temporary task list | Discard or task state | Do not persist as AI constraint |
| Secret, token, private credential | Discard | Never persist in agent context |
| Duplicated or conflicting docs | Review item | Require owner decision before migration |

## Destination Examples

- Coding style: rule.
- "How to add a service": workflow.
- Domain glossary: reference.
- "Frontend feature development" with rules, routes, workflows, gotchas: skill candidate.
- "AI keeps writing English commit messages after being told Chinese only": memory candidate or reinforced rule.

## Rewrite Pattern For Rules

```text
Original: Code should be clean.
Rule: Functions introduced or modified by this task should have one responsibility; split when a function mixes validation, persistence, and presentation.
Check: can the reviewer point to one responsibility for each modified function?
```
