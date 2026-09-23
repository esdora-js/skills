# Plan Phase — INVENTORY → DISCOVER → TRIAGE/GROUP → confirm

Steps 1-3 of the flow. Load `execute.md` only after the user explicitly approves
the plan produced here.

## Step 1 — INVENTORY (no content reads)

Run:

```sh
git rev-parse --show-toplevel
git status --short
git diff --cached --name-status
git diff --name-status
git ls-files --others --exclude-standard
```

Rules:

- Empty state: if the staged, unstaged, and untracked sets are all empty,
  report "工作区干净，无改动可提交" and stop.
- Repository transaction guard: if `git status --short` shows unmerged paths
  (`UU`, `AA`, `DD`, `AU`, `UA`, `DU`, `UD`) or a merge, rebase, or
  cherry-pick is in progress (check `git rev-parse --git-path MERGE_HEAD` /
  `REBASE_HEAD` / `CHERRY_PICK_HEAD`), stop and report the in-progress
  operation; never plan or execute commits until the user finishes or aborts
  it. If HEAD is detached (`git symbolic-ref -q HEAD` fails), warn in the
  plan that commits will land on a detached HEAD.
- Partial-staging registry: files appearing in both
  `git diff --cached --name-status` and `git diff --name-status` are
  partially staged — record them. Under 仅暂存区 scope their in-scope
  content is exactly the staged hunks; never re-add them, and use the patch
  save/restore procedure in `execute.md` when they must move between batches.
- Record the exact staged set. In the final plan every staged file must be
  accounted for: assigned to a batch, or explicitly listed as
  "保持暂存，本次不提交". No staged file may be silently merged into a batch.
- Scope question: ask only when staged changes coexist with unstaged or
  untracked changes. 询问用户并等待确认: 仅暂存区 / 全部改动 / 指定子集.
  Until answered: do not alter the index, stage additional files, or commit.
- If only staged changes exist, the scope is the staged set; state it in the
  plan without asking. Untracked files count as the "not added" side.

### Message-only exit

If the user asked only for commit message text: fix the scope (staged set by
default; if nothing is staged, 询问用户并等待确认 which changes), read Step 2
and the FORMAT rules in Step 3, draft the message, and output only the raw
commit message text — no greeting, no explanation, no Markdown fence. Skip
triage, grouping, and the confirmation gate. If the chosen scope spans
multiple intents, suggest the full batched flow instead, unless the user
confirms one message should cover everything.

## Step 2 — DISCOVER (inside the Git root only)

Never search parent directories or sibling repositories; their rules may belong
to unrelated projects.

### Commit conventions

Check, in order, with static reads only — never execute repository JS/TS
configuration files:

- `.commitlintrc`, `.commitlintrc.{json,yaml,yml,js,cjs,mjs}`,
  `commitlint.config.{js,cjs,mjs,ts}`
- `package.json` fields: `commitlint`, `config.commitizen`, `commitizen`;
  `.czrc`, `.cz.json`
- `.gitmessage`; `git config --get commit.template` — resolve a relative path
  against the Git root and read it only if it resolves inside the root;
  otherwise report the path and risk without reading it
- Repository docs that clearly define commit conventions, e.g. `CONTRIBUTING.md`

Extract when present: allowed types, scope restrictions or enums, subject
length/case rules, body/footer requirements, breaking-change syntax, examples.
If configuration conflicts with this skill, follow the local configuration and
call out the difference in the plan.

Precedence when drafting messages and scopes:

1. Explicit local configuration.
2. Consistent history — only when no explicit config exists: sample recent
   subjects with `git log --format=%s -20`. Adopt the observed pattern
   (format, language, scope style) only if the sample is clearly consistent;
   if history is mixed, fall through and note "历史风格不一致，使用默认规则"
   in the plan.
3. Built-in defaults (FORMAT below).

### Commit-time hooks

Detect:

- `.husky/` directory; non-sample `pre-commit`, `prepare-commit-msg`, and
  `commit-msg` under `"$(git rev-parse --git-common-dir)/hooks"` (this
  resolves correctly in worktrees and submodules, where `.git` is a file)
- `package.json` fields or scripts using `lint-staged`, `simple-git-hooks`,
  `precommit-hook`; `.pre-commit-config.yaml`
- For lint-staged, also flag risky options in config or scripts: `--no-stash`,
  `--no-hide-partially-staged`, `--all`, `--diff`. `--no-hide-partially-staged`
  can commit unstaged hunks of partially staged files; `--no-stash` leaves
  hook modifications in the index when aborting.

If any hook exists, the plan must state the hook policy (Step 3) so it is
approved together with the batches.

## Step 3 — TRIAGE → GROUP → GATE

### Triage (metadata first)

- Classify each in-scope file by path: docs, tests, config/CI,
  generated/lockfiles, source. Aggregate by directory into candidate scopes,
  constrained by any discovered scope enum.
- Read diffs only to disambiguate intent, using the smallest useful diff:
  staged `git diff --cached -- path/to/file`; unstaged
  `git diff -- path/to/file`; untracked text files read directly when safe.
- Generated or lock files: inspect nearby manifests or `--stat`, not content.
- Do not alter the index during this phase.

### Group (deterministic procedure)

1. Mechanical grouping by `(type, scope)`. Default types: `feat`, `fix`,
   `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`,
   `revert`; narrow to the local enum when one exists.
2. Merge only groups that share one user intent (same feature, fix, or
   mechanical change). Never merge just to reduce the commit count.
3. One file spanning multiple groups → default recommendation: assign the
   whole file to the dominant group and note it in the plan. Offer hunk-level
   split only as an explicit option the user must choose at the gate; never
   run interactive staging before approval.
4. Tests belong in the same batch as the change they cover; a test batch
   that would fail after reverting its change batch violates independent
   revertibility and must be merged with it. Only independently meaningful
   tests (e.g. covering pre-existing behavior) may form their own batch.
5. Order independent batches: `chore`/`build` → `refactor` → `fix`/`feat` →
   `perf` → `test` → `docs`/`style`. Every batch must be independently
   revertible: if reverting batch N would require reverting batch M, the
   split is wrong.
6. Risk per batch: low (docs, tests, narrow config metadata), medium (scoped
   implementation, tested refactors), high (public API changes, data
   migrations, auth/security, build/release pipeline, lockfile churn, behavior
   changes without tests). Breaking changes are always high.

### FORMAT (defaults; local rules win)

Subject: `<type>(<scope>): <subject>`; breaking: `<type>(<scope>)!: <subject>`.

- Include `scope` unless local config allows omitting it; keep it short,
  stable, and tied to the affected module or area.
- Subject in Chinese, imperative wording ("添加", "修复", "重构"), never
  completed wording ("添加了"); no trailing period; near 50 characters.
- Body only for non-trivial, risky, or cross-cutting changes: explain what and
  why, not how; `-` bullets, lines within 72 characters; Chinese category
  labels like `【新增】` are allowed.
- A `!` subject must start the body with `BREAKING CHANGE:` plus impact and
  migration path.

### GATE — one confirmation

Present the full plan compactly, every batch with:

```text
Batch N — type(scope): 中文 subject
Files: <count> — <path list>
Message:
<full commit message including body>
Risk: low/medium/high — one-line reason
Rationale: one line
```

Append when applicable:

- Hook policy, e.g.: "检测到 commit-time hook（lint-staged 等）。若 hook
  修改了属于当前批次的文件，将把这些修改一并暂存并 amend 进当前批次的
  commit；其余文件不动。hook 失败时中止并报告，备份可从 `git stash list`
  恢复。"
- 保持暂存，本次不提交: <paths>（执行时临时移出 index，全部批次完成后恢复暂存原状）
- 历史风格不一致，使用默认规则

Then 询问用户并等待确认 — exactly one question. The question is valid only
after the complete plan is visible in the conversation: every batch's file
list and full message text must appear in the presentation above. Never ask
"是否按此计划提交" when the plan was only narrated or summarized — if in
doubt, present it again before asking.

- 按此提交全部批次 / 修改指定批次或 message / 只输出 message / 停止

Support targeted revisions (合并批次 2 和 3、把文件 X 挪到批次 1、改批次 2
的 type) and re-present the plan. If the revision loop exceeds one round, or
the user returns after stepping away, re-run the INVENTORY snapshot before
re-presenting so the plan never rests on stale state. On approval, read
`execute.md` and execute all batches without further confirmation; interrupt
only for the anomalies defined there.
