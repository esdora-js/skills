# Prompt Templates (A–G)

Pick the closest match. These mirror the patterns Boris uses in his own daily work.

## Template A — Codebase Q&A

```
[Question]. Look through git history if it helps.
```

Examples:
- `Why does parseConfig take 12 arguments? Look through git history.`
- `How is the RateLimiter class actually used? Show me real call sites, not just text matches.`
- `What did I ship this week? Use my git username from the log.`

## Template B — Small edit (1 file, clear change)

```
[Task]. Make the change, then [verify].
```

Examples:
- `Rename the env var DB_URL to DATABASE_URL everywhere it's used. After changing files, run the test suite.`
- `Add a "Cancel" button next to "Save" in @components/UserForm.tsx. Match the existing button styles.`

## Template C — Medium edit, plan-first

```
[Task]. Make a plan and run it by me before writing code.
```

Examples:
- `Replace the in-memory rate limiter with Redis. Plan first, then ask before changing files.`
- `The auth middleware is leaking session tokens in logs — fix it. Make a plan first.`

## Template D — Build / UI work with feedback loop

```
[Task]. Use [feedback tool] to check after each change. Iterate until [success criterion].
```

Examples:
- `Implement the dark theme to match @design/dark-mock.png. Use puppeteer to screenshot the page, diff against the mock, iterate until visually close.`
- `Build the /pricing page from @design/pricing.fig export. Screenshot at desktop + mobile widths after each change. Iterate until both match.`
- `Make the failing tests in @tests/checkout.test.ts pass. Run the test suite after each change.`

## Template E — Bigger feature, explore + plan

```
[Feature]. First explore the codebase to find similar patterns. Then make a plan and ask for approval. After implementing, run [verification].
```

Example:
- `Add an audit log for all admin actions. First look at how existing logging works in the codebase, then propose a plan, ask before writing code. Once implemented, run the test suite.`

## Template F — Git / GitHub operation

```
commit, push, PR
```

Literally those words. The model reads `git log` to match the project's commit format, creates a branch if needed, pushes, and opens a PR. Don't over-specify.

## Template G — Bug fix (root cause, not symptom)

```
[Bug description, including how to reproduce]. Find the root cause, don't just patch the symptom. Make a plan first.
```
