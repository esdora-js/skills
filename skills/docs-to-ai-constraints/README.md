# Docs To AI Constraints

`docs-to-ai-constraints` 用来把文档很多的项目整理成 AI agent 能实际遵守的开发治理体系。

它不会把所有文档粗暴塞进一个大 skill，而是先分类：哪些是强约束 rules，哪些是重复流程 workflows，哪些只是背景 references，哪些适合变成 memory，哪些值得拆成新的 skill。

## 适合什么时候用

- 项目里有大量 `docs/`、README、架构文档、贡献指南、测试说明或已有 agent 指令文件。
- 你想从这些文档中提取 AI 开发规范。
- 你不确定某段内容应该变成 rule、workflow、reference、memory 还是 skill。
- 你已经把很多内容做成了一个过大的 skill，想拆分和挽救。
- 你在 monorepo 中想按 package、领域或子项目拆分 AI 规则。

## 安装

```sh
npx skills add esdora-js/skills --skill docs-to-ai-constraints
```

## 触发示例

```text
使用 docs-to-ai-constraints，帮我把 docs 里的内容整理成 AI 开发约束。
```

```text
这个项目文档太多了，帮我判断哪些应该做成 rules，哪些只是 references。
```

```text
我把所有文档做成了一个大 skill，帮我拆开。
```

```text
monorepo 项目怎么拆 AI 规则和入口文件？
```

## 它会怎么工作

1. 先明确目标、范围和输出模式。
2. 扫描或读取相关文档，按 repo-wide、frontend、backend、testing、deployment、architecture 等领域分组。
3. 提取可执行、稳定、对开发有影响的内容。
4. 使用分类矩阵判断每条内容应该进入 rules、workflows、references、memory candidates、discard items 或 skill candidates。
5. 标注每条结论的来源证据。
6. 输出分类表、风险、冲突、过期来源提醒和下一步建议。

## 常见输出

这个 skill 可能输出：

- 文档 inventory。
- AI 约束分类表。
- 高优先级 rules 候选。
- workflow 和 skill 候选。
- 冲突、重复、过期文档或缺少 owner 的风险。
- 后续迁移计划或治理结构建议。

分类表通常类似：

| Source | Extracted item | Primary category | Destination | Rationale | Rewrite / next action |
|---|---|---|---|---|---|
| `docs/testing.md` | PR 前必须运行集成测试 | Rule | `.claude/rules/testing.md` | 可验证的开发义务 | 改写为具体检查项 |

## 核心判断

- **Rules**：必须遵守，能被 reviewer 判断 pass / fail。
- **Workflows**：重复出现的步骤化任务。
- **References**：帮助理解背景，但不是强制命令。
- **Memory candidates**：稳定偏好或重复行为纠正。
- **Skill candidates**：有独立触发语、独立任务边界和多类支持材料。
- **Discard / source-only**：临时状态、代码事实、git 历史、秘密或过期内容。

## 文件结构

```text
skills/docs-to-ai-constraints/
  SKILL.md
  README.md
  rules/
  workflows/
  references/
  routing.yaml
```

## 边界

这个 skill 负责文档到 AI 治理体系的提取与分类。它不替其他 skill 决定内部规则，也不会在未确认时删除、归档或迁移项目文件。
