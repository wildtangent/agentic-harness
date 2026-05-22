---
inclusion: always
---

# Git Workflow

Full reference: [docs/engineering-standards/git-conventions.md](../../docs/engineering-standards/git-conventions.md)

## Branching

Format: `<type>/<ticket>-<description>` — e.g. `feat/#42-user-auth`, `fix/#99-login-bug`

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `ci`

## Commits

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>[scope]: <description>

[optional body]
```

## Key Rules

| Rule | Detail |
| ---- | ------ |
| Rebase over merge | Always rebase feature branches; no merge commits |
| Squash before merge | Squash all commits into one before opening an MR |
| Never `--no-verify` | Fix hook failures, don't bypass |
| Never `--force` | Use `--force-with-lease` after rebasing |
| Never force push `main` | Protected branch; always use MR |

## Post-Feature MR Lifecycle

Once a feature is agreed to be pushed, execute autonomously:

1. Squash commits and open MR: `glab mr create --squash --remove-source-branch`
2. Watch CI: `glab ci status --watch`
3. CI passes → merge: `glab mr merge --squash --remove-source-branch`
4. CI fails → fetch logs, diagnose, fix, push, return to step 2

Escalate to the user only if a failure cannot be diagnosed after one attempt.
