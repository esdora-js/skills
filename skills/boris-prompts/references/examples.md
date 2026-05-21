# Output Examples

These show what the skill produces. Notice the prompts are short and the explanation is one sentence.

## Example 1 — User input was complete

**User:** "I want Claude Code to add JWT auth to my Express app. There are tests."

**Skill output:**

```
Add JWT auth to the Express app. Look at how existing middleware is structured first, then make a plan and run it by me. After implementing, run the test suite and iterate until it passes.
```

> Uses Template E (medium-size feature, explore + plan + feedback loop) because there's a test suite to verify against.

## Example 2 — User input was vague, skill asked

**User:** "help me prompt Claude to fix my CSS"

**Skill asks:**
- "What's broken in the CSS?" — options: Layout is off / Colors wrong / Responsive issues / I don't know — let the model figure it out
- "Can the model check the result visually?" — options: Yes, screenshot it / Yes, I'll eyeball it / I have visual regression tests

After user answers (e.g., "layout is off on mobile" + "yes screenshot it"):

```
The mobile layout on @pages/Home.tsx is broken. Screenshot it at 375px wide using puppeteer, find what's off, fix it, and re-screenshot. Iterate until the layout looks right.
```

> Uses Template D (feedback loop) because puppeteer gives the model a way to self-verify.

## Example 3 — Existing prompt, asked to improve

**User:** *pastes a 30-line prompt full of architecture details and style rules*

**Skill response:** identify the parts that are reusable context (architecture, style, common commands) and suggest moving them to `CLAUDE.md` (or target's equivalent), leaving the prompt itself focused on the task.

```
Implement the payment retry logic described in @docs/retry-spec.md. Plan first, ask before writing code, then run the test suite.
```

> Original prompt was 30 lines; 25 of them were repeated architecture / style context that should live in `CLAUDE.md`. Kept only the task-specific part.
