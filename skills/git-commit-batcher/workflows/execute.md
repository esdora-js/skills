# Execute Phase — run only after explicit plan approval

Step 4 of the flow. Preconditions: approved batches with exact file lists,
full messages, and order; staged-set accounting; approved hook policy.

## Per-batch loop

For each batch in the approved order:

1. **Snapshot.** Run `git status --short` and `git diff --cached --name-status`.
   Compare with what the plan expects at this point.
2. **Make the index equal the batch.**
   - Stage exact paths: `git add -- path/to/file another/path`.
   - Remove unrelated staged paths only if the approved plan says so, with
     exact paths: `git restore --staged -- path/to/file`. Before unstaging a
     path that has staged content, inspect its staged patch with
     `git diff --cached -- path/to/file`; unstaging keeps the content in the
     working tree — never discard it.
   - Never run `git add` on a file in the plan's partial-staging registry
     when the scope is 仅暂存区: its approved content is already in the
     index, and re-adding would pull in unstaged hunks the user excluded.
   - When a partially staged file must leave the index for another batch,
     first save its staged patch (`git diff --cached -- path/to/file >
     <patch-file>`); when its own batch comes, restore exactly those hunks
     with `git apply --cached <patch-file>` instead of `git add`.
   - For approved partial staging, use the approved patch workflow and verify
     hunks in step 3.
3. **Verify.** `git diff --cached --name-status` must equal the batch file
   list exactly; `git diff --cached --stat` for a sanity check. For partial
   staging, inspect the staged hunks of each approved file with
   `git diff --cached -- path/to/file` and compare them against the approved
   or saved patch — file presence alone is not sufficient for partially
   staged files. Any mismatch → anomaly table.
4. **Commit.** Write the message to a temp file and commit with
   `git commit -F <file>` so multi-line bodies survive exactly. Never amend
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
   if the plan temporarily removed user-staged paths from the index (the
   "保持暂存" list), restore them — with `git add -- path/to/file` for fully
   staged files, or with the saved patch (`git apply --cached <patch-file>`)
   for partially staged files — so the index looks as the user left it.

## Anomalies — the only mid-execution interruptions

| Condition | Default action |
|---|---|
| Index or worktree differs from the plan at step 1 or 3 (user/IDE edit, hook side effect) | Stop; report what changed; 询问用户并等待确认 how to proceed |
| Commit command failed (`commit-msg`/`pre-commit` rejection, message lint) | Report the error verbatim; do not retry blindly; fix only within the approved plan's scope, otherwise ask |
| Hook failed after modifying files (e.g. lint-staged error path) | Stop; report; point out that lint-staged creates a backup stash by default, recoverable via `git stash list` |
| Hook modified files outside the approved batches | Leave them untouched; note them in the final report |
| Staged hunks do not match the approved partial staging | Stop; change nothing; 询问用户并等待确认 |

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
