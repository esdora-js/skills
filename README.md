# Esdora Skills

这是一个 AI agent skills 集合仓库。仓库中的每个目录都是一个可独立安装的 skill，用来把某类高频任务沉淀成可复用的工作流、规则和参考材料。

这些 skills 主要面向支持 `npx skills add` 安装方式的 agent 环境。安装后，agent 会根据用户请求和 skill 的 `description` 自动触发对应能力。

## 安装

安装单个 skill：

```sh
npx skills add esdora-js/skills --skill <skill-name>
```

例如：

```sh
npx skills add esdora-js/skills --skill boris-prompts
npx skills add esdora-js/skills --skill docs-to-ai-constraints
npx skills add esdora-js/skills --skill rule-based-architecture
```

## Skills

| Skill | 用途 | 适合场景 |
|---|---|---|
| [`boris-prompts`](skills/boris-prompts/README.md) | 编写、改写、压缩高质量 LLM / AI agent instruction prompt | 你想把一个任务交给 Claude Code、ChatGPT、Gemini、Cursor 等模型，但不知道怎么写提示词 |
| [`docs-to-ai-constraints`](skills/docs-to-ai-constraints/README.md) | 从大量项目文档中提取 AI 开发约束，并分类为 rules、workflows、references、memory candidates 或 skills | 项目文档很多，想整理成 AI 可执行、可遵守、可维护的开发治理体系 |
| [`rule-based-architecture`](skills/rule-based-architecture/README.md) | 设计或重构 agent rule / memory / context injection 架构 | 你在整理 `CLAUDE.md`、`.claude/rules`、memory 或类似 agent 指令体系 |

## 如何选择

如果你要写给模型的 prompt，选择 `boris-prompts`。

如果你手上是一堆项目文档，想知道哪些应该变成 AI 开发规范、哪些只是背景资料，选择 `docs-to-ai-constraints`。

如果你已经在设计 agent 规则系统，想决定规则放在 `CLAUDE.md`、`.claude/rules`、memory 还是本地文件，选择 `rule-based-architecture`。

## 仓库结构

```text
skills/
  <skill-name>/
    SKILL.md        # agent 读取的入口说明
    README.md       # 面向人类的功能、用法和效果说明
    rules/          # 每次触发都应遵守的约束
    workflows/      # 具体任务流程
    references/     # 只在相关任务中读取的参考材料
```

不是每个 skill 都必须包含所有子目录。实际结构以该 skill 的任务复杂度为准。

## 使用建议

- 先安装与你当前任务最接近的单个 skill，避免一次性安装无关能力。
- 对 agent 说出自然语言目标即可，例如“帮我把这个任务改写成 Claude Code prompt”。
- 如果 skill 需要更多上下文，它通常只会问 1–3 个澄清问题。
- 每个 skill 的详细说明见对应目录下的 `README.md`。

## 维护约定

- `SKILL.md` 面向 agent，应该保持触发条件、读取顺序、硬规则和边界清晰。
- `README.md` 面向人类，应该说明该 skill 是什么、何时使用、如何触发、会产出什么。
- `rules/` 放必须遵守且可验证的规则。
- `workflows/` 放可重复执行的任务步骤。
- `references/` 放辅助判断的背景、矩阵、示例和 gotchas。
