# Boris Prompts

`boris-prompts` 用来把一个模糊、冗长或不够稳定的任务描述，改写成适合 LLM / AI agent 执行的高质量 instruction prompt。

它参考 Boris 的提示词方法：短、准确、先计划、能验证、必要时把长期上下文放进文件，而不是每次都塞进 prompt。

## 适合什么时候用

- 你想让 Claude Code、ChatGPT、Gemini、Cursor、Windsurf、Copilot 等模型完成一个任务，但不知道怎么表达。
- 你已经写了一个 prompt，觉得太长、不稳定、模型经常误解，想压缩或重写。
- 你描述了一个开发任务，希望得到一段可以直接复制给 AI agent 的 prompt。
- 你想知道“这个任务应该怎么问模型”。

不适合用于营销文案、用户界面文案或 image generation prompt。这个 skill 只处理发给 LLM / AI agent 的 instruction prompt。

## 安装

```sh
npx skills add esdora-js/skills --skill boris-prompts
```

## 触发示例

你可以直接对 agent 说：

```text
帮我写一个 prompt，让 Claude Code 修复这个测试失败问题。
```

```text
把下面这段 prompt 改短一点，但保留验证步骤。
```

```text
我想让 Cursor 重构这个组件，应该怎么问？
```

## 它会怎么工作

1. 判断目标模型：Claude Code、ChatGPT、Gemini、Cursor 等。
2. 判断交付物：问答、小改动、中等改动、新功能、UI 构建、Git 操作或 bug 修复。
3. 如果关键信息缺失，最多问 3 个澄清问题。
4. 选择合适模板，并加入必要的文件锚点、计划步骤或验证步骤。
5. 输出一段可复制的最终 prompt，并用一行说明应用了哪些原则。

## 输出效果

典型输出包含两部分：

```text
[一段可直接复制给目标模型的 prompt]
```

然后附上一行说明，例如：

```text
说明：这里使用了 plan-first 和 verification loop，避免模型直接改代码且无法验证结果。
```

## 核心原则

- Prompt 应该比原始任务描述更短、更明确。
- 非平凡任务先让模型计划，再执行。
- 能验证的任务必须写清验证方式，例如测试、截图、lint 或 build。
- 文件上下文只在目标模型支持时使用，例如 Claude Code 的 `@path/to/file`。
- 如果同类上下文反复出现，应该考虑放进 `CLAUDE.md` 或目标工具的持久上下文中。

## 文件结构

```text
skills/boris-prompts/
  SKILL.md
  README.md
  workflows/write-prompt.md
  rules/principles.md
  references/
    clarify.md
    target-models.md
    templates.md
    examples.md
    gotchas.md
```

## 边界

这个 skill 只负责写 prompt，不负责执行 prompt。如果你要求“现在运行它”，那会变成另一个独立任务。
