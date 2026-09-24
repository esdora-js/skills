# Execute Phase — run only after explicit plan approval

Step 4 of the flow. Preconditions: approved batches with exact file lists,
full messages, and order; staged-set accounting; approved hook policy.

## Temporary artifacts

Write every temporary artifact (message files, saved patches) under
`D="$(git rev-parse --git-dir)/commit-batcher"` — create it first — and
never in the worktree, where a stray file would corrupt the step 1/5
snapshot comparisons. Report `$D` in the final report. Clean it only after
all batches and all restorations succeed; on any stop it is the user's
recovery source, so keep it and report its full path and contents.

## Per-batch loop

For each batch in the approved order:

1. **Snapshot.** Run `git status --short` and `git diff --cached --name-status`.
   Compare with what the plan expects at this point.
2. **Make the index equal the batch.** `git commit` commits the entire
   index, not named files — the index must contain exactly this batch.
   - Stage exact paths: `git add -- path/to/file another/path`.
   - Remove unrelated staged paths only if the approved plan says so, with
     exact paths: `git restore --staged -- path/to/file`. Before unstaging a
     path that has staged content, inspect its staged patch with
     `git diff --cached -- path/to/file`; unstaging keeps the content in the
     working tree — never discard it.
   - Never run `git add` on a file in the plan's partial-staging registry
     when the scope is 仅暂存区: its approved content is already in the
     index, and re-adding would pull in unstaged hunks the user excluded.
   - When any staged path must leave the index — a partially staged file
     moving to another batch, or any "保持暂存" path before the first
     batch — first save its staged patch (`git diff --cached --binary --
     path/to/file > "$D/<batch>-<name>.patch"`) and report the path. When
     its turn comes, restore exactly those hunks with `git apply --cached
     <patch-file>`, never `git add`: `git add` stages the current worktree
     content, silently replacing what the user staged if a hook or editor
     touched the file meanwhile. This applies to fully staged files too.
   - If a partially staged file is binary (`git diff --cached --numstat`
     shows `-`), do not attempt patch save/restore — stop and ask.
   - For approved partial staging, use the approved patch workflow and verify
     hunks in step 3.
3. **Verify.** `git diff --cached --name-status` must equal the batch file
   list exactly; `git diff --cached --stat` for a sanity check. For renames,
   both old and new paths must be staged and the `name-status` line must
   match the approved `old → new` entry. For partial
   staging, inspect the staged hunks of each approved file with
   `git diff --cached -- path/to/file` and compare them against the approved
   or saved patch — file presence alone is not sufficient for partially
   staged files. Any mismatch → anomaly table.
4. **Commit.** The message shown in its own fenced block at the gate is the
   source of truth: write it verbatim to a file under `$D` (no re-wrapping,
   no rewording) and commit with `git commit -F <file>` so multi-line bodies
   survive exactly. Never amend
   except under the approved hook policy (step 5). Never add attribution.
5. **Post-commit check.** Run `git status --short`.
   - Remaining state matches the plan → continue with the next batch.
   - Verify the final message: `git log -1 --format=%B` must match the
     approved message. A deviation introduced by a `prepare-commit-msg` or
     `commit-msg` hook is not necessarily an error (project normalization
     may be intentional), but it must appear in the final report.
   - Hook modified files belonging to this batch → apply the approved hook
     policy: stage those exact paths, `git commit --amend -F <same message
     file>`, then re-verify with `git log -1 --stat`. This relies on the hook
     being idempotent (true for formatters like prettier); if the hook keeps
     changing the file on every run, treat it as an anomaly instead.
   - Anything else unexpected → anomaly table.
6. **After the last batch**, restore the user's pre-existing staging state:
   for every "保持暂存" path removed in step 2, restore with
   `git apply --cached <saved patch>` — never `git add`, which would stage
   whatever the worktree holds at that moment. Then verify: `git diff
   --cached` must equal the staged diff recorded at INVENTORY; any mismatch
   → anomaly table. Only after this verification passes may `$D` be cleaned.

## Anomalies — the only mid-execution interruptions

| Condition | Default action |
|---|---|
| Index or worktree differs from the plan at step 1 or 3 (user/IDE edit, hook side effect) | Stop; report what changed; 询问用户并等待确认 how to proceed |
| Commit command failed (`commit-msg`/`pre-commit` rejection, message lint) | Report the error verbatim; do not retry blindly; fix only within the approved plan's scope, otherwise ask |
| Hook failed after modifying files (e.g. lint-staged error path) | Stop; report; point out that lint-staged creates a backup stash by default, recoverable via `git stash list` |
| Hook modified files outside the approved batches | Leave them untouched; note them in the final report |
| Staged hunks do not match the approved partial staging | Stop; change nothing; 询问用户并等待确认 |
| Any stop with "保持暂存" or moved paths still out of the index | Before asking, either restore them per step 6, or report every saved patch's full path with its `git apply --cached <path>` recovery command — then stop |

## Resuming after an anomaly

Default: after the user resolves the cause, re-run `plan.md` INVENTORY and
rebuild (and re-approve) the plan. Continue the previously approved plan
only when the fresh snapshot verifies that nothing relevant changed since
the interruption.

## Final report

After all approved batches finish (or the loop stops), report:

- Commit hashes and subjects (`git log --oneline -<batch count>`)
- Remaining uncommitted changes, expected or not
- User-staged paths that were restored to the index (if any)
- Batches that were skipped or blocked, and why
- Hook side effects applied (amended) or left in the working tree
- Temporary artifact directory `$D`: cleaned, or retained with its full
  path and contents
