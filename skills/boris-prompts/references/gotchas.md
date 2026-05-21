# Gotchas & Handoff

Anti-patterns that defeat the purpose of this skill, and how the skill ends.

## Anti-patterns (don't do these)

- **Polite filler** ("Please could you help me with...") — wastes context, the model doesn't care. Use a direct verb.
- **Pasting the same architecture / style notes into every prompt** — put them in `CLAUDE.md` (or the target's equivalent) once. See [target-models.md](target-models.md).
- **Long lists of step-by-step instructions for tasks that have a verification signal** — give the verification signal instead and let the model iterate.
- **Asking for a 3000-line feature in one shot** — ask for a plan, review, then implement in stages.
- **Generating a 200-line "perfect prompt" to save the user time** — the whole point of the skill is *shorter* prompts. If your output is longer than the user's question, you're doing it wrong.

## Common misfires

- **Adding `@file` for non-Claude-Code targets** — `@file` only works in Claude Code and editor-integrated tools (Cursor, Windsurf). For ChatGPT/Gemini, either paste content or describe it. See [target-models.md](target-models.md).
- **Adding "make a plan first" to a Q&A prompt** — planning is wasted on questions. Apply Template A.
- **Adding "iterate until tests pass" when there are no tests** — confirm verification capability via [clarify.md](clarify.md) before adding feedback loops.
- **Skipping the clarifying questions even when target/scope is unclear** — you'll write the wrong template.
- **Restating Boris's principles in the output** — the user wants a prompt, not a lecture on prompt design.

## When this skill should hand off

This skill writes the prompt — it doesn't run it. After producing the prompt:

- The user usually copies it into Claude Code (or other target) themselves.
- If they ask "now run it", that becomes a separate task and this skill is done.
