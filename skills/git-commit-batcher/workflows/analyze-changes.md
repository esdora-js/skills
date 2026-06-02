# Workflow - Analyze Changes

Use this workflow before drafting batches or commit messages.

## Step 1 - Inspect Git state

Run the equivalent of:

```sh
git status --short
git diff --cached --name-status
git diff --name-status
git ls-files --others --exclude-standard
```

If staged changes exist, follow [git-safety.md](../rules/git-safety.md#existing-staged-content):
询问用户并等待确认 whether to analyze only staged changes before expanding scope.

## Step 2 - Discover commit rules

Read [config-discovery.md](../references/config-discovery.md), then inspect local
commit configuration inside the current Git root only. Local configuration
overrides default rules.

## Step 3 - Inspect relevant diffs

For each candidate file, inspect the smallest useful diff:

- Staged files: `git diff --cached -- path/to/file`
- Unstaged tracked files: `git diff -- path/to/file`
- Untracked text files: read the file directly if it is safe and relevant

Do not read file contents that may contain secrets or unsafe data. For `.env*`,
credentials, private keys, certificates, token files, local secret config, large
files, or binary files, report only path, change state, and risk. For generated or
lock files, inspect metadata, nearby package manifests, or summary diffs first.

## Step 4 - Classify each file

For each file, identify:

- Change intent
- Impact scope
- Risk level
- Likely Conventional Commit `type`
- Likely `scope`
- Whether it should be committed with another file
- Whether partial staging may be needed

## Step 5 - Report analysis

Summarize the analysis before planning commits when the user asked for analysis
only. If the user asked to commit or generate batches, continue to
[plan-batches.md](plan-batches.md).
