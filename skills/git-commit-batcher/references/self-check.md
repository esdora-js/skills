# Self-Check

Run this check before finalizing a plan, creating files, or reporting completion.

## Architecture

- Does `SKILL.md` describe natural trigger language such as "帮我提交",
  "生成提交批次", "commit changes", and "拆分 commit"?
- Are long rules kept in `rules/`, procedures in `workflows/`, and background
  references in `references/`?
- Are agent-specific entry files absent or thin shells only?
- Is the skill usable by any agent tool without relying on one product's feature
  names?

## Git safety

- Did the workflow inspect staged, unstaged, and untracked changes?
- If staged changes exist, did it ask whether to analyze only staged changes?
- Did it avoid committing before 询问用户并等待确认?
- Does every staging instruction use exact paths with `--` instead of `git add .`?
- Before committing, does the index contain only the approved current batch?
- For partial staging, did it inspect staged hunks with
  `git diff --cached -- path/to/file`?
- If existing staged content was present, did it preserve the user's staged patch
  before changing the index?
- Did it avoid reading or displaying sensitive file contents?
- Did it preserve unrelated changes and avoid destructive commands?

## Commit quality

- Did local commit configuration override defaults when present?
- Did configuration discovery stay inside the current Git root?
- Did it inspect commit templates from `git config --get commit.template` when
  present?
- Did it avoid executing repository JS/TS configuration files during discovery?
- Is each batch the smallest practical reversible unit?
- Does each batch include files, message, rationale, risk, and breaking-change notes?
- Are Chinese subject rules complete?
- Does every breaking-change subject with `!` start the body with
  `BREAKING CHANGE:` and explain impact and migration?
- For "only commit message" requests, is the output raw text only?
