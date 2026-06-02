# Workflow - Confirm and Commit

Use this workflow only after the user explicitly confirms the proposed batches.
The confirmation loop is always described as "询问用户并等待确认" and must not
reference a specific agent tool's interaction feature.

## Step 1 - Re-check state

Before each batch, re-run:

```sh
git status --short
git diff --cached --name-status
```

Confirm the current state still matches the approved plan. If it changed in a way
that affects batching, stop and 询问用户并等待确认 how to proceed.

The index must contain only the files approved for the current batch before the
commit is created. If unrelated staged files are present, stop and 询问用户并等待确认
before changing the index. Before unstaging an unrelated path, inspect its staged
patch with `git diff --cached -- path/to/file`. If it contains partial staging,
preserve the patch or 询问用户并等待确认 how to proceed before changing the index.
After confirmation, remove only exact unrelated paths from the index, for example:

```sh
git restore --staged -- path/to/file
```

## Step 2 - Stage exact paths

Stage only files approved for the current batch:

```sh
git add -- path/to/file another/path
```

Never use broad staging commands.

If the batch needs partial staging, use the approved patch workflow and verify the
staged diff afterward.

## Step 3 - Verify staged content

Run:

```sh
git diff --cached --name-status
git diff --cached --stat
git diff --cached -- path/to/approved-file
```

If staged files differ from the approved batch, stop and correct the plan by
询问用户并等待确认. For each approved text file, inspect the staged patch with
`git diff --cached -- path/to/file` and confirm that the staged hunks match the
approved batch exactly. This check is required for partial staging.

## Step 4 - Commit

Commit with the approved message. Prefer a message file for multi-line messages so
line breaks and body content are preserved.

After each commit, run:

```sh
git status --short
```

Continue with the next approved batch only if the remaining state still matches the
plan.

## Step 5 - Final report

After all approved commits finish, report:

- Commit hashes and subjects
- Any remaining uncommitted changes
- Any batches that were skipped or blocked
