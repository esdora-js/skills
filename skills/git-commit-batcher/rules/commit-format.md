# Commit Format Rules

Discover and follow local project commit rules first. If no local rule exists, use
standard Conventional Commits with the Chinese message constraints below.

## Required structure

Subject format:

```text
<type>(<scope>): <subject>
```

Breaking-change subject format:

```text
<type>(<scope>)!: <subject>
```

Use the local configuration to determine allowed `type`, `scope`, subject case, max
length, or body rules. If local configuration is absent or silent, apply these
defaults:

- Common types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`,
  `ci`, `chore`, `revert`.
- Scope should be short, stable, and tied to the affected module, package, feature,
  or config area.
- If local configuration allows omitting `scope`, follow the local configuration.
  Otherwise, include `scope` and use the required `<type>(<scope>): <subject>`
  format.
- Subject must be Chinese.
- Subject must use imperative wording, such as "添加", "修复", "更新", "调整",
  "重构", "移除".
- Do not use completed wording such as "添加了", "修复了", "更新了".
- Do not capitalize for English title style.
- Do not end the subject with a period.
- Keep the subject near 50 characters when possible.

## Body rules

Use a body when the change is non-trivial, risky, cross-cutting, or needs rationale.

- Explain what changed and why it changed.
- Do not describe only how the implementation works.
- Use `-` bullet points.
- Keep each line within 72 characters.
- Chinese category labels are allowed, for example `【新增】`, `【修复】`,
  `【优化】`, `【重构】`.

Example:

```text
feat(auth): 添加会话过期提示

- 【新增】在登录态失效时展示重新登录提示
- 【优化】减少用户在提交表单后才发现会话失效的情况
```

## Breaking changes

If the subject contains `!`, the body must start with `BREAKING CHANGE:` and explain
both impact and migration path.

Example:

```text
refactor(api)!: 调整用户查询响应结构

BREAKING CHANGE: `user.name` 拆分为 `firstName` 和 `lastName`。
迁移时需要更新读取用户名的调用方，并处理旧字段缺失的情况。
```

## Message-only requests

When the user asks to output only a commit message, output only the raw commit
message text:

- No greeting.
- No explanation.
- No Markdown fence.
- No surrounding commentary.
