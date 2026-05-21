---
name: boris-prompts
description: Write high-quality prompts for any LLM or AI assistant — Claude, Claude Code, ChatGPT, Gemini, Cursor, Windsurf, Copilot, or any coding / chat agent. Trigger when the user asks to write, improve, refine, shorten, or rewrite a prompt; asks "how should I phrase this for [model]" or "what's a good prompt for [task]"; describes a task they want an AI to do but hasn't formulated as a prompt; or pastes an existing prompt and asks for revision. Based on Boris's (Anthropic, Claude Code creator) methodology — short and accurate prompts, plan-before-code, feedback loops, persistent context in files. Asks 1–3 clarifying questions via AskUserQuestion if target model, deliverable, scope, or verification method is unclear.
---

# Boris-Style Prompt Writer

## When to trigger

Activate when **any** of these is true:

- User explicitly asks to write, improve, shorten, or rewrite a prompt for any LLM / AI assistant.
- User describes a task in natural language and the next reasonable step is to phrase it as a prompt.
- User pastes a long prompt and asks why it isn't working, or asks to refine it.
- User asks "how should I phrase this" or "what's a good way to ask [model] to...".

**Do not trigger** for: marketing copy, user-facing UI text, image-generation prompts. This skill is for **instruction prompts** addressed to an LLM or AI agent.

## Always read first

1. [workflows/write-prompt.md](workflows/write-prompt.md) — the 5-step procedure
2. [rules/principles.md](rules/principles.md) — the 5 core principles (short / plan-first / explore / feedback-loop / persistent-context)

## Task routing

| User wants… | Read |
|---|---|
| To pick the right template | [references/templates.md](references/templates.md) (A–G) |
| To ask the right clarifying questions | [references/clarify.md](references/clarify.md) |
| To adapt for ChatGPT / Gemini / Cursor (not Claude Code) | [references/target-models.md](references/target-models.md) |
| To see what good output looks like | [references/examples.md](references/examples.md) |
| To avoid common misfires | [references/gotchas.md](references/gotchas.md) |

## Hard rules (always apply)

- **Cap clarifying questions at 3.** Beyond that the user feels interrogated and the skill's benefit disappears.
- **Final prompt should be shorter than the user's task description.** If your output is longer than their question, you're doing it wrong — re-read [rules/principles.md](rules/principles.md#1-short-beats-long).
- **Output is two things only:** (1) the prompt in a fenced code block, (2) a one-line note explaining which 1–2 principles you applied.
- **Verify before adding "iterate until tests pass"** — confirm tests/verification exist via [references/clarify.md](references/clarify.md).
- **Don't add `@file` for non-Claude-Code targets** — check [references/target-models.md](references/target-models.md) first.

## Handoff

This skill writes prompts; it doesn't run them. After producing the prompt, the user copies it into the target. If they say "now run it", that's a separate task.

Self-check before delivering lives at the end of [workflows/write-prompt.md](workflows/write-prompt.md#self-check-before-delivering).
