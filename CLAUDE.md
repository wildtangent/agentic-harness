# Claude Code Instructions

## Project Overview

{{PROJECT_NAME}} — {{TECH_STACK}}

**For comprehensive agent instructions, see [AGENTS.md](./AGENTS.md)**

## Issue Tracking

**Project Board:** [GitLab Project Board]({{GITLAB_PROJECT_URL}})

- Check the board for available tickets before starting work
- Reference ticket numbers in branch names: `feat/#123-description`
- Link MRs to tickets using `Closes #123` in MR description

## Documentation

| Document                                                     | Purpose                                   |
| ------------------------------------------------------------ | ----------------------------------------- |
| [AGENTS.md](./AGENTS.md)                                     | Full agent instructions and documentation index |
| `docs/PRODUCT_REQUIREMENTS.md`                               | Product vision, features, user stories    |
| `docs/ARCHITECTURE.md`                                       | Technical architecture and data model     |
| `docs/USER_FLOWS.md`                                         | Detailed user journeys                    |
| [docs/engineering-standards/](./docs/engineering-standards/) | Code quality, testing, **agent criteria** |

## Before Committing

**Mandatory checks — see [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md) for full details**

1. Type check — zero type errors
2. Lint — zero lint errors
3. Tests — all pass
4. Build — successful compilation
5. Coverage — thresholds met (80%+ new code)

## Git Rules

**See [Git Conventions](./docs/engineering-standards/git-conventions.md) for full details**

**Branching (Gitflow):** `<type>/<ticket>-<description>` (e.g., `feat/#123-user-auth`)

**Commits ([Conventional Commits](https://www.conventionalcommits.org/)):** `<type>[scope]: <description>`

| Rule                    | Detail                                                      |
| ----------------------- | ----------------------------------------------------------- |
| Rebase over merge       | Always rebase feature branches; no merge commits            |
| Squash before merge     | Squash all commits into one; include all ticket refs        |
| Never `--no-verify`     | Fix hook failures, don't bypass                             |
| Never `--force`         | Use `--force-with-lease` after rebasing (with verification) |
| Never force push `main` | Protected branch; always use MR                             |
| Never commit secrets    | Use environment variables                                   |

When hooks fail: fix the issue, don't bypass; if stuck, ask the user.

## Post-Feature / MR Lifecycle

**Once a feature is agreed to be pushed, agents MUST execute the following sequence autonomously — no further user prompting is required.**

**See [Git Conventions — Post-Feature MR Lifecycle](./docs/engineering-standards/git-conventions.md#post-feature-mr-lifecycle) for full details and `glab` CLI commands.**

| Step          | Action                                                                                       |
| ------------- | -------------------------------------------------------------------------------------------- |
| 1. Create MR  | Squash commits, write conventional commit message, open MR with body containing `Closes #N` |
| 2. Watch CI   | Automatically poll CI with `glab ci status --watch` — do not wait for the user              |
| 3a. CI passes | Merge immediately with `glab mr merge --squash --remove-source-branch`; confirm to user     |
| 3b. CI fails  | Fetch logs, diagnose, propose fix, apply and push, then return to step 2                    |

Escalate to the user only if a CI failure cannot be diagnosed or fixed after one attempt.

## Worktrees (Parallel Agent Sessions)

When Claude Code places you in a git worktree (via `EnterWorktree`), **run the
init script before doing anything else**. Each worktree gets its own isolated
environment so multiple agents can work in parallel without conflicts.

### Setup — once per worktree

```bash
{{WORKTREE_INIT_COMMAND}}
```

Configure `{{WORKTREE_INIT_COMMAND}}` to allocate an isolated port and any per-worktree
resources (database, env file, etc.).

After init, all commands work normally:

| Command                    | Notes                                               |
| -------------------------- | --------------------------------------------------- |
| `{{DEV_COMMAND}}`          | Starts the dev server on the allocated port         |
| `{{TEST_COMMAND}}`         | Unit tests                                          |
| `{{E2E_COMMAND}}`          | Uses the allocated port and environment automatically |

### Teardown — before the worktree is removed

```bash
{{WORKTREE_TEARDOWN_COMMAND}}
```

Run this before the session exits to clean up any isolated resources.

### Rules

- **Never** run the init or teardown commands in the main checkout
- Shared services should be started from the **main checkout** only
