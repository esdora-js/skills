# Core Principles

Apply in priority order when writing or evaluating a prompt. Straight from Boris's (Anthropic, Claude Code creator) talk.

## 1. Short beats long

A prompt that fits in two sentences usually works better than one that fills the screen. The reason isn't aesthetic — a long prompt eats the context window, repeats things the model already knows, and over-constrains the solution space. If you find yourself writing more than ~5 lines, ask whether half of it belongs in `CLAUDE.md` (or the target's equivalent persistent-context store) instead.

## 2. "Make a plan first" is the single highest-ROI addition

The most reliable upgrade to almost any non-trivial prompt is appending some form of:

> "Before you write code, make a plan and run it by me for approval."

Works because the model is genuinely good at planning when asked, and most bad results come from skipping the planning step. You do not need plan mode, a special flag, or a system prompt — the plain-English instruction is enough.

## 3. Don't spec every detail — let the model explore

If the task involves an existing codebase, the prompt should point the model at the right starting place ("look at how `X` is implemented", "check git history for why this function has 15 args") rather than describing the full solution. The model is good at finding patterns and similar code; it's wasteful to re-describe what the codebase already contains.

## 4. A feedback loop beats detailed instructions

When the deliverable is verifiable (UI matches a mock, tests pass, lint passes, screenshot is similar), give the model **a way to verify** rather than telling it how to do every step. The pattern:

> "Do X. Then run [tests / take a screenshot / lint]. Iterate until [success criterion]."

This typically beats a multi-paragraph spec because the model can self-correct using ground truth.

## 5. Persistent context goes in files / settings, not prompts

If you find yourself pasting the same architecture notes, style rules, or common commands into every prompt, that's a signal — those belong in the target's persistent-context mechanism. See [references/target-models.md](../references/target-models.md) for the mapping per assistant.

The prompt should be about *this specific task*, not background.
