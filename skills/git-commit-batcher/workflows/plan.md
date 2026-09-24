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
  cherry-pick is in progress, stop and report the in-progress operation;
  never plan or execute commits until the user finishes or aborts it.
  Detect with existence tests: `test -f "$(git rev-parse --git-path
  MERGE_HEAD)"` and likewise `CHERRY_PICK_HEAD`; for rebase, `test -d` on
  `rebase-merge` / `rebase-apply` under the same base — `REBASE_HEAD` is
  unreliable and can be absent mid-rebase. If HEAD is detached
  (`git symbolic-ref -q HEAD` fails), warn in the plan that commits will
  land on a detached HEAD.
- Partial-staging registry: files appearing in both
  `git diff --cached --name-status` and `git diff --name-status` are
  partially staged — record them. Under 仅暂存区 scope their in-scope
  content is exactly the staged hunks; never re-add them, and use the patch
  save/restore procedure in `execute.md` when they must move between batches.
  Check `git diff --cached --numstat`: a partially staged file showing `-`
  (binary) cannot round-trip through patch save/restore — if it must leave
  the index, that is a stop-and-ask case, not a patch case.
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
default; if nothing is staged, 询问用户并等待确认 which changes), read the
full diff of the scoped changes (the grounding rule in Step 3 applies —
never draft from paths alone), read Step 2 and the FORMAT rules in Step 3,
draft the message, and output only the raw commit message text — no
greeting, no explanation, no Markdown fence. Skip
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
   subjects with exactly `git log --format=%s -20` — never `git log` full
   format, never `-p`; 20 subject lines cost ~1 KB of context, the full
   formats cost orders of magnitude more. One sample serves both style and
   scope: the subjects already carry the `(scope)` values to reuse. Adopt
   the observed pattern (format, language, scope style) only if the sample
   is clearly consistent; if history is mixed, fall through and note
   "历史风格不一致，使用默认规则" in the plan.
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
- Renames (`R` status): record as `old → new`; staging, verification, and
  batch file lists must carry both exact paths.
- Do not alter the index during this phase.
- Message grounding: before finalizing any batch's message you must have
  read the full diff of every file in that batch (using the diff commands
  above); generated/lockfiles may use `--stat` plus nearby manifests
  instead. Triage may be metadata-first, but message drafting never is.

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

Structure: `<type>(<scope>)!: <subject>`, blank line, body, blank line,
footer. Per-part rules:

- **type** — the industry Conventional Commits enum: `feat`, `fix`, `docs`,
  `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
  When local config declares a narrower enum, use it. Never invent types.
- **scope** — a noun naming the affected module or area; never a file name,
  never the change type; lowercase kebab-case. Resolution order: local
  `scope-enum` > reuse scopes already present in the sampled history (no
  synonym drift — if history uses `git-commit-batcher`, do not write
  `commit-batcher`) > derive from structure (monorepo: package name; single
  package: top-level module; a skills collection: the skill name). Omit
  only for repo-wide changes or new top-level entities, and say so in the
  plan.
- **!** — breaking changes only; must pair with a body starting
  `BREAKING CHANGE:` plus impact and migration path.
- **subject** — Chinese, imperative wording ("添加", "修复", "重构"), never
  completed wording ("添加了"); no trailing period; near 50 characters.
  Every claim must trace to an inspected diff hunk; filler subjects that
  remain true after deleting the file names are forbidden ("更新相关代码",
  "调整配置", "优化逻辑", "重构核心模块").
- **body** — only for non-trivial, risky, or cross-cutting changes: explain
  what and why, not how; `-` bullets, lines within 72 characters. Order
  bullets by reader impact: behavior-visible fixes or changes first,
  internal refactors next, tests/docs/tooling last. Category labels
  (【新增】/【修复】) only when bullets in one body have mixed natures and
  the label disambiguates; in a single-nature body they repeat the commit
  type and are forbidden as decoration.
- **footer** — issue references only when history already uses them.

### GATE — one confirmation

Present the full plan as one Markdown section per batch. The commit message
is an objective artifact, commentary is not: keep them visually separate so
the user approves exactly what will be committed.

Rules:

- The message gets its own fenced block, byte-identical to what execution
  will write to the message file — same subject, same body, same line
  breaks. Never abbreviate, re-wrap, or "polish" it during presentation;
  the approved block is the single source of truth for step 4.
- File lists are exhaustive: one path per line, no `...`, no "等 N 个文件".
- Never pack batches into one shared code block — it blurs which bytes are
  the message and invites ellipsis-style summarization.

````markdown
### Batch N — `type(scope): 中文 subject`

**Files** (2):

- path/to/one
- path/to/two → renamed/to/two

**Message**（逐字提交，与写入 message 文件的内容完全一致）:

```text
type(scope): 中文 subject

body line 1
body line 2
```

**Risk**: low/medium/high — one-line reason
**Rationale**: one line citing the concrete change point (which function,
config key, or behavior changed) — not a restatement of intent
````

Append when applicable:

- Hook policy, e.g.: "检测到 commit-time hook（lint-staged 等）。若 hook
  修改了属于当前批次的文件，将把这些修改一并暂存并 amend 进当前批次的
  commit；其余文件不动。hook 失败时中止并报告，备份可从 `git stash list`
  恢复。"
- 保持暂存，本次不提交: <paths>（执行时临时移出 index，全部批次完成后恢复暂存原状）
- 历史风格不一致，使用默认规则

Then 询问用户并等待确认 — exactly one question. The question is valid only
after the complete plan is visible in the conversation: every batch's
exhaustive file list and full message text must appear in their own
sections and fenced blocks as specified above. Never ask
"是否按此计划提交" when the plan was only narrated or summarized — if in
doubt, present it again before asking.

- 按此提交全部批次 / 修改指定批次或 message / 只输出 message / 停止

Support targeted revisions (合并批次 2 和 3、把文件 X 挪到批次 1、改批次 2
的 type) and re-present the plan. If the revision loop exceeds one round, or
the user returns after stepping away, re-run the INVENTORY snapshot before
re-presenting so the plan never rests on stale state. On approval, read
`execute.md` and execute all batches without further confirmation; interrupt
only for the anomalies defined there.
