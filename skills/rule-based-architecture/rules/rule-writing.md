# Rule Writing

Write rules so another agent can apply and verify them under context pressure.

## Good Rule Shape

- Use concrete, observable wording.
- Prefer "do X when Y" over broad values like "be concise" or "write clean code".
- Include the reason when edge cases matter.
- Include an application scope: all tasks, only commits, only frontend files, only when editing tests, etc.
- Split independent topics into separate files once an entry file becomes an index.

## Memory Entry Shape

- `MEMORY.md` is an index. Keep each row short and descriptive enough to decide whether to open the topic file.
- Topic files should use frontmatter with `name`, `description`, and `type`.
- Feedback memories should include the rule, `Why`, and `How to apply`.
- Convert relative dates into absolute dates before storing them.

## Do Not Write

- Do not encode facts that can be read from code or git history.
- Do not store one-off task state as memory.
- Do not bury costly gotchas only in references; surface them on the route that needs them.
- Do not solve a missed rule by copying the same sentence everywhere. Increase activation or use targeted feedback.
