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

四步流程，常态只有两次询问：

1. **INVENTORY**：只用 `git status` / `name-status` 盘点状态，不读任何文件内容。只有暂存与未暂存改动同时存在时，才询问提交范围。
2. **DISCOVER**：在当前 Git root 内发现本地 commit 规范（commitlint、commitizen、commit template 等）和 commit-time hook（含 lint-staged 危险配置检测）。规范优先级：显式配置 > 一致的历史风格 > 内置默认。
3. **PLAN**：先按路径元数据分类，只有意图不明确的文件才读 diff；再按 `(type, scope)` 机械分组、同一意图才合并、固定顺序排序，给出每个批次的 message、理由和风险。此时一次性确认完整计划（含 hook 处理策略）。
4. **EXECUTE**：确认后逐批自动执行——精确路径暂存、校验 index 与批次完全一致、用 message 文件提交、复核剩余状态。只有发生计划外异常才会中止并询问。

如果你只要求生成 commit message，它会在第 1 步后直接输出原始 message 文本，不走完整流程。

## 输出效果

典型输出会包含：

- 批次编号与 commit message
- 文件列表
- 拆分理由
- 风险或 breaking-change 说明
- 检测到 hook 时的处理策略

执行完成后报告 commit hash、剩余未提交改动和被跳过的批次。

## 核心原则

- 每个提交都应该能独立回滚，并保持仓库状态 coherent。
- 不使用 `git add .`，只暂存明确路径；每次提交前 index 必须与当前批次完全一致。
- 不覆盖、不清理、不混入无关改动。
- 本地 commit 配置优先于默认规则。
- 未经明确确认，不执行 commit；确认后逐批执行，异常才打断。
- commit 中永不添加 AI 归属标记。

## 文件结构

```text
skills/git-commit-batcher/
  SKILL.md              # 触发条件、流程总览、不变量、路由
  README.md
  workflows/
    plan.md             # 步骤 1-3：INVENTORY → DISCOVER → PLAN（含确认闸门）
    execute.md          # 步骤 4：EXECUTE 逐批执行循环（确认后才加载）
```

`workflows/execute.md` 只在用户批准计划后加载，保证执行规则在最危险的阶段前处于最新上下文。

## 边界

这个 skill 负责当前变更的提交分析、拆分、消息生成和确认后的提交执行。它不负责改代码、修测试、写 PR 描述或整理发布说明。
