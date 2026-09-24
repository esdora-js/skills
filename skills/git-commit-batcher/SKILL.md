---
name: git-commit-batcher
description: Analyze current Git changes, split them into minimal reversible commit batches, and draft or execute Conventional Commits after one explicit confirmation. Trigger when the user wants to inspect Git changes, generate commit messages, split commits by intent, commit staged or unstaged work, or says phrases like "帮我提交", "生成提交批次", "commit changes", "split commits", "拆分 commit", "按 Conventional Commits 提交", or "生成 commit message". Works for any agent tool; agent-specific entry files must stay thin shells that route here instead of copying these rules.
---

# Git Commit Batcher

## When to trigger

Activate when the user wants any of these:

- Analyze the current Git working tree or staged changes.
- Generate one or more commit messages.
- Split current changes into the smallest reversible commit batches.
- Commit changes using Conventional Commits.

Do not trigger for Git history analysis, branch management, release tagging, or pull
request writing unless the immediate task is to form or execute commits.

## Flow

```text
1. INVENTORY  Git state with zero content reads; ask commit scope only when
              staged and unstaged/untracked changes coexist
2. DISCOVER   Local commit rules and commit-time hooks inside the Git root
              Precedence: explicit config > consistent history > built-in defaults
3. PLAN       Metadata-first triage, deterministic (type, scope) grouping,
              per-batch messages, one confirmation gate
4. EXECUTE    Per-batch loop: exact staging -> index check -> commit -> re-check
```

Message-only requests exit early: run step 1 with a scope, apply the discovered
and default format rules, then output only the raw commit message text.

## Routing

| Situation | Read |
|---|---|
| Any request: analyze, message, split, or commit | [workflows/plan.md](workflows/plan.md) (steps 1-3) |
| The user has explicitly approved the plan | [workflows/execute.md](workflows/execute.md) (step 4) |

## Invariants

These always apply. Detailed procedures live in the phase files; do not restate
them there.

- Never commit before the user explicitly approves the full plan.
- Stage only exact paths (`git add -- path/to/file`); never `git add .`,
  `git add -A`, or broad globs.
- Before each commit, the index must contain exactly the approved content of
  the current batch — file membership and, for partially staged files, the
  approved hunks only.
- Treat every pre-existing uncommitted change as intentional user work: no
  destructive Git commands, no cleanup of untracked files, no broad reformatting.
- Never read or display contents of files likely to contain secrets (`.env*`,
  credentials, private keys, certificates, token files) or of large/binary
  files; report only path, change state, and risk.
- Local commit configuration overrides this skill's built-in defaults.
- Never add AI attribution to commits: no "Generated with" trailers, no
  `Co-Authored-By` for the agent, no tool-name markers in message or committer.
- Never bypass hooks or signing: no `--no-verify`, no `--no-gpg-sign`, no
  hook-disabling flags — a failing hook is an anomaly, not an obstacle.
- The user's pre-existing staging state is sacred: on any stop — completed
  run, anomaly, or abort — either restore it exactly or report every saved
  patch's full path and its recovery command.
- Write all temporary artifacts (message files, saved patches) under
  `"$(git rev-parse --git-dir)/commit-batcher/"`, never in the worktree.
- Every commit message must be grounded in the actual diff: read the diff
  before drafting; filler subjects that stay true after deleting the file
  names are forbidden.
- Describe every confirmation loop as "询问用户并等待确认"; never name one
  agent tool's interaction feature.
