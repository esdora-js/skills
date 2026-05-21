# Workflow — Write a Prompt

Five steps. Stop at any step if information is missing.

## Step 1 — Check you have enough information

Answer these five questions before writing. Stop and ask if any is unclear.

| Question | Why it matters | What it changes |
|---|---|---|
| Which model / assistant is this prompt for? (Claude Code, Claude.ai, ChatGPT, Cursor, Gemini, etc.) | Determines which model-specific features (@file, CLAUDE.md, Projects, etc.) are available | Vocabulary and anchors |
| What is the deliverable? (Q&A / small edit / new feature / bug fix / refactor / debug / non-code task) | Determines which template to use | Template choice |
| Can the assistant verify its own output? (tests, screenshots, lint, build, manual check by user) | Determines whether to add an iteration loop | The "run X and iterate" line |
| Is this one-shot, or should the assistant plan first? | Most non-trivial tasks benefit from a plan; pure Q&A does not | The "make a plan first" line |
| Are there existing files, patterns, or persistent-context files (`CLAUDE.md`, `.cursorrules`, etc.) the assistant should anchor on? | Determines whether to add file references or "look at how X works" | Context anchors |

## Step 2 — If anything is unclear, ask 1–3 clarifying questions

Use the `AskUserQuestion` tool. **Cap at 3 questions.** Beyond that the user feels interrogated and the skill's benefit (saving them time) disappears.

Pick questions from [references/clarify.md](../references/clarify.md) — only ask what you actually don't know.

## Step 3 — Pick a template and fill it in

See [references/templates.md](../references/templates.md) for the seven templates (A–G).

Match the deliverable:
- Codebase Q&A → A
- Small edit (one file, clear change) → B
- Medium edit needing a plan → C
- Build / UI work with verification → D
- Bigger feature needing exploration → E
- Git / GitHub operation → F
- Bug fix (root cause) → G

## Step 4 — Add the optional power-ups (when applicable)

These small additions punch above their weight:

| Add this | When |
|---|---|
| `@path/to/file.ts` | Whenever a specific file is the anchor for the task. |
| `Look through git history` | When the "why" of existing code matters. |
| `Don't change [X]` | When you want to mark a clear no-go zone (more effective than positively specifying what to change). |

## Step 5 — Output

Return two things:

1. **The final prompt**, in a fenced code block so it's copy-pasteable.
2. **A one-line note** explaining why the prompt is structured this way (which 1–2 principles you applied).

If applicable, add a brief tip:
- If the prompt references the same architecture / style facts twice or more, suggest moving them to `CLAUDE.md` (or the target's equivalent — see [references/target-models.md](../references/target-models.md)).
- If the user is about to do many similar prompts, suggest writing a `/slash-command` instead.

## Self-check before delivering

- Is the prompt **shorter** than the user's task description? If not, re-read [rules/principles.md](../rules/principles.md) §1.
- Does the prompt include a verification step when one is possible?
- Is there any architecture / style content that should be in persistent context instead?
