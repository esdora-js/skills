# Commit Configuration Discovery

Local repository rules take priority over the default rules in this skill.

## Repository boundary

Before searching for commit configuration, determine the current repository root
with:

```sh
git rev-parse --show-toplevel
```

Only inspect files inside that Git root. Do not search parent directories or
sibling repositories, because their commit rules may belong to unrelated projects.

## Discovery order

Check for these files and settings before drafting commit messages:

- `.commitlintrc`
- `.commitlintrc.json`
- `.commitlintrc.yaml`
- `.commitlintrc.yml`
- `.commitlintrc.js`
- `.commitlintrc.cjs`
- `.commitlintrc.mjs`
- `commitlint.config.js`
- `commitlint.config.cjs`
- `commitlint.config.mjs`
- `commitlint.config.ts`
- `package.json` fields:
  - `commitlint`
  - `config`
  - `config.commitizen`
  - `commitizen`
- `.czrc`
- `.cz.json`
- `.gitmessage`
- Git commit template config from `git config --get commit.template`
- repository docs that clearly define commit conventions, such as `CONTRIBUTING.md`

Prefer static reading. Do not execute repository configuration files such as
`.commitlintrc.js`, `commitlint.config.js`, or `commitlint.config.ts` just to
discover rules. If running a project command is necessary to validate commit
configuration, explain the command and 询问用户并等待确认 first.

When `git config --get commit.template` returns a path, resolve it relative to the
Git root when it is not absolute. Read the template only if the resolved path is
inside the current Git root. If it points outside the Git root, report the path and
risk, but do not read it unless the user explicitly confirms.

## What to extract

When configuration exists, extract:

- Allowed commit types
- Scope restrictions
- Subject length limits
- Subject case rules
- Body/footer requirements
- Breaking-change syntax
- Commitizen adapter hints
- Commit template path and relevant template instructions
- Project-specific examples

If configuration conflicts with this skill, follow the local configuration and call
out the difference in the proposed plan unless the user requested only raw commit
messages.

## Fallback

If no local configuration exists, use standard Conventional Commits plus the Chinese
message rules in [commit-format.md](../rules/commit-format.md).
