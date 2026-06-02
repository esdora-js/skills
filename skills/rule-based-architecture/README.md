# Rule Based Architecture

`rule-based-architecture` 用来设计、审查或重构 AI agent 的规则系统，包括 `CLAUDE.md`、`.claude/rules`、`CLAUDE.local.md`、memory、上下文注入层级和规则放置策略。

它关注的是“规则应该放哪里、怎么写才可验证、如何避免入口文件变成大杂烩”。

## 适合什么时候用

- 你想重写或拆分 `CLAUDE.md`。
- 你不确定一条规则应该放在 `CLAUDE.md`、`.claude/rules`、memory 还是本地文件。
- 你想设计 `MEMORY.md` 或 topic memory。
- 你的 agent 规则不生效，想审查上下文注入链路。
- 你想把已有规则系统整理成可维护的架构。

## 安装

```sh
npx skills add esdora-js/skills --skill rule-based-architecture
```

## 触发示例

```text
帮我重写 CLAUDE.md，并拆分 .claude/rules。
```

```text
这条规则应该放 CLAUDE.md 还是 memory？
```

```text
设计一个适合这个项目的 agent rule architecture。
```

```text
审查一下为什么我的 Claude Code 规则不生效。
```

## 它会怎么工作

1. 盘点现有规则来源：`CLAUDE.md`、`.claude/`、`CLAUDE.local.md`、`AGENTS.md`、`CODEX.md`、`.cursor/`、memory index 等。
2. 将内容分类为稳定规则、行为反馈、用户偏好、项目背景、外部引用、临时进度、代码事实或重复项。
3. 根据注入层级、作用域和稳定性决定放置位置。
4. 把模糊规则改写成可验证的约束。
5. 将过大的入口文件改成索引，让细节进入 topic 文件。
6. 去除 `CLAUDE.md` 与 memory 之间的重复。
7. 根据 Claude Code 的加载行为验证设计。

## 常见输出

这个 skill 通常会输出：

- 建议的文件布局。
- 每条规则或上下文的放置决策和理由。
- 改写后的规则示例。
- 仍然存在的风险或 gotchas。
- 验证 checklist。

示例：

```text
将跨项目个人偏好放入 ~/.claude/CLAUDE.md。
将项目内必须遵守的测试要求放入 .claude/rules/testing.md。
将重复行为纠正记录为 feedback memory，而不是复制到 CLAUDE.md。
```

## 核心原则

- 按注入层级放置规则，而不是按方便程度放置。
- 规则必须具体、可观察、可验证。
- `MEMORY.md` 应该是索引，不是长笔记。
- 当前代码结构、函数列表、git 历史等事实不应持久化为 memory，应该按需搜索当前代码。
- 不要把 `CLAUDE.md` 规则重复写进 memory。

## 文件结构

```text
skills/rule-based-architecture/
  SKILL.md
  README.md
  rules/
  workflows/
  references/
  routing.yaml
```

## 边界

这个 skill 只负责 agent rule / memory / context placement 架构设计。它不替代项目自身的编码规范，也不处理一般 prompt 写作任务。
