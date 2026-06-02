---
name: docs-to-ai-constraints
description: >
  This skill should be used when the user wants to convert many project docs
  into AI development constraints, such as "从 docs 提取 AI 开发规范",
  "文档太多, 帮我整理成 AI 约束", "rule 还是 skill 我不清楚",
  "把项目交给 AI 开发需要遵守哪些规范", "使用 docs-to-ai-constraints",
  or "挽救被做成一个大 skill 的文档".
  Activate when a docs-heavy project, monorepo, or existing oversized skill
  needs classification into rules, workflows, references, memory candidates,
  discard items, and possible skills.
---

# Docs To AI Constraints

Turn docs-heavy projects into an AI development governance system. The core
sequence is: inventory docs, classify content, extract enforceable constraints,
then decide what becomes rules, workflows, references, memory candidates, or
separate skills.

## Always Read

Read these files first for every task:
1. `rules/classification-principles.md`
2. `rules/output-discipline.md`

## Common Tasks

Each route lists the exact files to read.

- Clarify governance intent (`intake`) -> follow `workflows/intake.md`; triggers: "使用 docs-to-ai-constraints", "帮我整理 docs", "我不确定该怎么做"
- Audit docs for AI development constraints (`audit-docs`) -> follow `workflows/audit-docs.md`; ref `references/classification-matrix.md`; triggers: "从 docs 提取 AI 开发规范", "整理项目文档给 AI 用", "audit docs for agent rules"
- Decide rule vs workflow vs reference vs skill (`classify-content`) -> follow `workflows/classify-content.md`; ref `references/classification-matrix.md`; triggers: "rule 还是 skill", "这类文档应该放哪", "classify these docs"
- Design monorepo AI governance (`monorepo-governance`) -> follow `workflows/monorepo-governance.md`; ref `references/monorepo-scope-matrix.md`; triggers: "monorepo 项目怎么拆 AI 规则", "每个子项目拆入口文件", "按 package 拆 rules"
- Design AI governance output (`design-governance`) -> follow `workflows/design-governance.md`; ref `references/migration-checklist.md`; triggers: "设计 AI 开发约束体系", "项目交给 AI 开发", "agent development governance"
- Rescue an oversized docs skill (`rescue-oversized-skill`) -> follow `workflows/rescue-oversized-skill.md`; ref `references/rescue-patterns.md`; triggers: "所有文档做成了一个大 skill", "挽救大 skill", "split this huge skill"
- Other / unlisted task (`other`) -> follow `workflows/intake.md` when goal, scope, or output mode is unclear; otherwise choose the closest workflow by filename.

## Core Principles

1. **Classify before packaging** — never turn all docs into one skill before deciding what each item actually is.
   Check: does every extracted item have a category and destination before any file structure is proposed?

2. **Rules are obligations** — only content AI must obey during development becomes a rule.
   Check: can a reviewer mark the rule as pass or fail?

3. **Workflows are repeated procedures** — only step-by-step recurring tasks become workflows.
   Check: would an agent need these steps for a specific task, not every task?

4. **References are context, not commands** — background docs help understanding but do not become mandatory constraints.
   Check: would violating this text be a defect, or just a lack of background?

5. **Oversized skills are source artifacts** — rescue by reclassifying content, not by adding more folders around the same blob.
   Check: is the old large skill frozen while the new structure is derived from it?

## Boundaries

- This skill orchestrates docs-to-AI governance extraction.
- It does not own the internal rules of other skills.
- It does not add editor-specific registration files unless the user asks.
- It does not persist secrets, transient progress, code facts, or git history summaries as AI constraints.
