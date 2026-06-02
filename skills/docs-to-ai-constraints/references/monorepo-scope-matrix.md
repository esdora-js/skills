# Monorepo Scope Matrix

| Signal | Scope | Destination pattern |
|---|---|---|
| Applies to every app, package, service, and tool | Root | Root-level rule or governance output |
| Applies to one product area such as frontend or backend | Domain | Domain rule or workflow output |
| Applies only under one app or package | Subproject | Local entry file plus local rules or workflows |
| Defines shared library dependency boundaries | Shared package | Shared package rule plus import/dependency checks |
| Explains a package API or business terms | Reference | Scoped reference with source link |
| Conflicts with a root rule | Override candidate | Requires rationale and user confirmation |
| Duplicates a root rule | Duplicate | Do not copy; route to root rule instead |
| Describes current implementation details | Source-only | Verify from code when needed |

## Entry File Decision

Create or propose a subproject entry file only when at least one condition is true:

- The subproject has local constraints that differ from root.
- The subproject has recurring local workflows.
- The subproject needs local references for AI development.
- The subproject overrides a root rule with documented rationale.

Do not create an entry file just because a directory exists.

## Inheritance Rule

Root rules are inherited by default. Subproject rules should add local constraints or document explicit overrides. If a local rule repeats a root rule without adding scope-specific detail, keep it at root.
