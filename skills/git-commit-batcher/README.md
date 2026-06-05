# Git Commit Batcher

`git-commit-batcher` 用来分析当前 Git 工作区和暂存区，把改动拆成最小、清晰、可独立回滚的提交批次，并在用户明确确认后生成或执行 Conventional Commits。

它适合把混杂的 staged / unstaged 变更整理成可审查的提交计划，避免无意提交无关文件或把多个意图塞进同一个 commit。

## 适合什么时候用

- 你想提交当前改动，但希望 agent 先检查变更边界。
- 你想把多个文件改动拆成多个 commit。
- 你只想生成一个或多个 commit message。
- 你已经有 staged 内容，需要确认是否只处理暂存区。
- 你想按项目本地规范或默认 Conventional Commits 提交。

不适合用于 Git 历史分析、分支管理、release tag 或 pull request 撰写，除非当前目标是形成或执行 commit。

## 安装

```sh
npx skills add esdora-js/skills --skill git-commit-batcher
```

## 触发示例

你可以直接对 agent 说：

```text
帮我分析当前改动，并拆成 commit 批次。
```

```text
为这些变更生成 Conventional Commits message，先不要提交。
```

```text
帮我提交，但先列出每个批次让我确认。
```

## 它会怎么工作

1. 检查 `git status`、staged diff、unstaged diff 和 untracked 文件。
2. 如果已有 staged 内容，先确认是否只分析暂存区。
3. 读取项目本地 commit 规则，优先使用本地配置。
4. 按改动意图、scope、风险、文件边界和 Conventional Commit type 拆分批次。
5. 展示每个批次的文件、commit message、拆分理由和风险说明。
6. 只有在用户明确确认后，才会执行 `git add -- <path>` 和 `git commit`。

## 输出效果

典型输出会包含：

- 批次编号
- 文件列表
- commit message
- 拆分理由
- 风险或 breaking-change 说明

如果你只要求生成 commit message，它会只输出原始 commit message 文本。

## 核心原则

- 每个提交都应该能独立回滚，并保持仓库状态 coherent。
- 不使用 `git add .`，只暂存明确路径。
- 不覆盖、不清理、不混入无关改动。
- 本地 commit 配置优先于默认 Conventional Commits。
- 未经明确确认，不执行 commit。

## 文件结构

```text
skills/git-commit-batcher/
  SKILL.md
  README.md
  rules/
    batching.md
    commit-format.md
    git-safety.md
  workflows/
    analyze-changes.md
    confirm-and-commit.md
    plan-batches.md
  references/
    config-discovery.md
    self-check.md
```

## 边界

这个 skill 负责当前变更的提交分析、拆分、消息生成和确认后的提交执行。它不负责改代码、修测试、写 PR 描述或整理发布说明。
