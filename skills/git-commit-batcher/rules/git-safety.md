# Git Safety Rules

These rules always apply when analyzing, batching, staging, or committing changes.

## Working tree inspection

Always inspect all three Git states before planning:

- Staged changes: `git diff --cached --name-status` and relevant staged diffs
- Unstaged tracked changes: `git diff --name-status` and relevant diffs
- Untracked files: `git ls-files --others --exclude-standard`

Also inspect `git status --short` to understand the combined state.

## Existing staged content

If the index already contains staged files, 询问用户并等待确认 whether to analyze only
the staged changes before considering the full working tree.

Until the user answers:

- Do not alter the index.
- Do not stage additional files.
- Do not commit.

If the user chooses all changes, keep staged-state awareness throughout planning.
Existing staged files may belong to a separate batch, or they may need to be
unstaged and restaged only after explicit user approval. Never silently mix staged
content with unstaged or untracked content.

When existing staged files are present, inspect and preserve their staged patch
before changing the index:

- Record staged paths with `git diff --cached --name-status`.
- Inspect the staged patch for affected text files with
  `git diff --cached -- path/to/file`.
- Do not discard a user's partial staging selection with file-level unstaging unless
  the user explicitly approves that loss or a concrete restore plan exists.

## No unrelated changes

Treat every pre-existing uncommitted change as intentional user work.

- Do not overwrite unrelated changes.
- Do not run cleanup commands that remove untracked files.
- Do not reformat broad file sets to make commits look cleaner.
- Do not use destructive Git commands unless the user explicitly requested them.

If a requested batch cannot be committed without disturbing unrelated changes,
stop and explain the conflict.

## Staging and committing

Before committing, show the proposed batches and wait for explicit user
confirmation.

When staging a batch:

- The index must contain only the approved current batch before committing.
- If unrelated staged files are already present, stop and 询问用户并等待确认
  before changing the index.
- To remove unrelated paths from the index after confirmation, use exact paths such
  as `git restore --staged -- path/to/file`; never unstage broad pathsets.
- Before unstaging an unrelated path, inspect its staged patch with
  `git diff --cached -- path/to/file`. If it contains partial staging, preserve the
  patch or 询问用户并等待确认 how to proceed before changing the index.
- Use exact file paths and a path separator: `git add -- path/to/file another/path`.
- Never use `git add .`, `git add -A`, or broad path globs.
- If only part of a file belongs in a batch, 询问用户并等待确认 how to proceed or use
  an interactive patch workflow only after confirmation.
- Re-check staged files before each commit with `git diff --cached --name-status`.
- Re-check staged content for each approved path with
  `git diff --cached -- path/to/file`.

Use commit commands that preserve the planned message exactly. Prefer a message
file when the body is multi-line.

## Sensitive file handling

Do not read or display content from files likely to contain secrets unless the user
explicitly asks and confirms. This includes `.env*`, credentials, private keys,
certificates, token files, local config with secrets, and large or binary files.

For sensitive or unsafe files, report only the path, change state, and risk.
