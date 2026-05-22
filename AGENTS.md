# Agent Instructions

Comprehensive guide for AI agents working on this codebase. Read this file first, then reference linked documentation as needed.

## Project Overview

**{{PROJECT_NAME}}**

{{PROJECT_DESCRIPTION}}

**Stack:** {{TECH_STACK}}

## Issue & Project Tracking

All work on this project is tracked via the **[GitLab Project Board]({{GITLAB_PROJECT_URL}})**.

### Before Starting Work

1. **Check the project board** for available tickets in the "Todo" column
2. **Claim a ticket** by assigning yourself and moving it to "In Progress"
3. **Reference the ticket** in your branch name (e.g., `feat/#123-user-auth`)
4. **Link your MR** to the ticket when complete

### ⚠️ CRITICAL: Issue Tracking Requirement

**AGENTS MUST ALWAYS mark a GitLab issue as:**

- **"In Progress"** — When starting work on an issue
- **"Assigned"** — When claiming an issue to work on it

**This is MANDATORY for proper project tracking and preventing duplicate work.**

#### Required Workflow:

1. **Before starting ANY code work:**
   - Find the appropriate issue in the project board
   - Assign yourself to the issue
   - Move issue status to "In Progress"
   - Create feature branch referencing the issue

2. **While working:**
   - Keep the issue status as "In Progress"
   - Update issue comments with progress updates if needed

3. **When complete:**
   - Follow the [Post-Feature MR Lifecycle](./docs/engineering-standards/git-conventions.md#post-feature-mr-lifecycle) autonomously
   - Squash commits → create MR with `Closes #N` → watch CI → merge with `--remove-source-branch`
   - The MR merge will auto-close the issue and delete the branch
   - Only escalate to the user if CI fails and cannot be diagnosed

**Failure to follow this workflow may result in:**

- Duplicate work by multiple agents
- Lost visibility of work in progress
- Poor project coordination and tracking

### Creating New Issues

If you identify work that needs to be done:

1. Create an issue in the [repository]({{GITLAB_ISSUES_URL}})
2. Use clear titles following the pattern: `<type>: <description>` (e.g., `feat: add user export`)
3. Include acceptance criteria in the issue body
4. The issue will automatically appear on the project board

### Issue Labels

| Label           | Use                   |
| --------------- | --------------------- |
| `enhancement`   | New features          |
| `bug`           | Bug fixes             |
| `documentation` | Documentation updates |
| `chore`         | Maintenance tasks     |

## Documentation Index

### Core Documentation

| Document                                                     | Purpose                                                | When to Read                                 |
| ------------------------------------------------------------ | ------------------------------------------------------ | -------------------------------------------- |
| `docs/PRODUCT_REQUIREMENTS.md`                               | Product vision, features, user stories                 | Understanding what to build                  |
| `docs/ARCHITECTURE.md`                                       | Technical architecture and data model                  | Designing components, database work          |
| `docs/USER_FLOWS.md`                                         | Detailed user journeys with diagrams                   | Building UI, understanding user interactions |
| [docs/engineering-standards/](./docs/engineering-standards/) | Code quality, testing, conventions, **agent criteria** | Before writing any code                      |

### Engineering Standards

| Document                                                                 | Purpose                                          |
| ------------------------------------------------------------------------ | ------------------------------------------------ |
| [Testing](./docs/engineering-standards/testing.md)                       | Test strategy, coverage requirements, test types |
| [Code Quality](./docs/engineering-standards/code-quality.md)             | Language rules, linter config, CI checks         |
| [Naming Conventions](./docs/engineering-standards/naming-conventions.md) | Files, code, components                          |
| [Git Conventions](./docs/engineering-standards/git-conventions.md)       | Branching, commits, MRs, rebase/squash           |
| [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md)     | Acceptance criteria for AI agents                |
| [Error Handling](./docs/engineering-standards/error-handling.md)         | Error handling patterns                          |
| [Security](./docs/engineering-standards/security.md)                     | Security requirements                            |
| [Performance](./docs/engineering-standards/performance.md)               | Performance guidelines                           |
| [Accessibility](./docs/engineering-standards/accessibility.md)           | Accessibility requirements                       |
| [Documentation](./docs/engineering-standards/documentation.md)           | Documentation standards                          |

## Quick Start for Agents

> **Working in a worktree?** Run `{{WORKTREE_INIT_COMMAND}}` immediately after entering
> the worktree. See the [Worktrees section in CLAUDE.md](./CLAUDE.md#worktrees-parallel-agent-sessions)
> for full instructions and teardown steps.
>
> **Spawning parallel sub-agents?** Pass `isolation: "worktree"` to the `Agent`
> tool — Claude Code will automatically create an isolated git worktree for that
> sub-agent. The sub-agent must still run `{{WORKTREE_INIT_COMMAND}}` as its first step.
>
> ```
> // Interactive session  →  EnterWorktree tool, then {{WORKTREE_INIT_COMMAND}}
> // Sub-agent            →  Agent({ isolation: "worktree" }), then {{WORKTREE_INIT_COMMAND}}
> ```

### Sandbox Secrets (Fresh Machine Setup)

Claude Code agents running in sandbox mode (worktrees, sub-agents) need credentials
injected via `.claude/settings.local.json`. This file is gitignored — each contributor
must create it locally.

#### Required Secrets

| Variable        | Purpose                                                    | Handled elsewhere? |
| --------------- | ---------------------------------------------------------- | ------------------ |
| `GITLAB_TOKEN`  | GitLab personal access token — enables `glab` CLI in sandbox | No — must be set here |

Add any additional project-specific secrets required by your stack.

#### Setup

1. Copy the template:

   ```bash
   cp .claude/settings.local.json.example .claude/settings.local.json
   ```

2. Fill in your credentials:
   - **`GITLAB_TOKEN`**: Generate at `{{GITLAB_URL}}/-/user_settings/personal_access_tokens` — needs `api` and `read_repository` scopes

Once `settings.local.json` is in place, all agent subprocesses will automatically
receive these credentials without manual `export` commands.

### Before Writing Code

1. **Read** [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md) — Mandatory acceptance criteria
2. **Understand** the data model in `docs/ARCHITECTURE.md`
3. **Check** existing patterns in the codebase

### Git Branching Requirements

**ALWAYS follow the git branching conventions defined in** [docs/engineering-standards/git-conventions.md](./docs/engineering-standards/git-conventions.md) **before making ANY code changes:**

- **Create proper feature branches** using format: `<type>/<ticket>-<description>`
- **Reference tickets in branch names** when available (e.g., `feat/#123-user-auth`)
- **Follow conventional commit format** for all commits
- **Use rebase over merge** to maintain clean history
- **Squash commits** before merging to main
- **Never bypass hooks** with `--no-verify` or force push without `--force-with-lease`

Every code change MUST be made on a properly named branch following the Gitflow strategy. No direct commits to `main`.

## Agent Acceptance Criteria (Summary)

**Full details in [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md)**

Before delivering code, agents MUST run all quality checks and confirm they pass. Refer to [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md) for the commands configured for this project.

### Test Requirements by Change Type

| Change                 | Required Tests                        |
| ---------------------- | ------------------------------------- |
| New utility function   | Unit tests with edge cases            |
| New component          | Component tests (render, interaction) |
| New API route/action   | Integration tests                     |
| Bug fix                | Regression test proving fix           |
| Refactor               | Existing tests must pass              |

## Git Rules for Agents

**Full details in [Git Conventions](./docs/engineering-standards/git-conventions.md)**

### Branching (Gitflow)

```
<type>/<ticket>-<description>
```

| Type        | Use                     |
| ----------- | ----------------------- |
| `feat/`     | New features            |
| `fix/`      | Bug fixes               |
| `hotfix/`   | Urgent production fixes |
| `chore/`    | Maintenance             |
| `docs/`     | Documentation           |
| `refactor/` | Code restructuring      |

**Examples:** `feat/#123-user-auth`, `fix/PROJ-456-login-bug`, `docs/api-reference`

### Commits ([Conventional Commits](https://www.conventionalcommits.org/))

```
<type>[scope][!]: <description>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

### Workflow Rules

| Rule                        | Detail                                             |
| --------------------------- | -------------------------------------------------- |
| **Rebase over merge**       | Always rebase feature branches; no merge commits   |
| **Squash before merge**     | Squash all commits into one before merging to main |
| **Never `--no-verify`**     | Fix hook failures, don't bypass                    |
| **Never `--force`**         | Use `--force-with-lease` if force push needed      |
| **Never force push `main`** | Protected branch; always use MR                    |
| **No secrets in commits**   | Use environment variables                          |

**Squash policy:** Before merging, squash all commits with:

- Clear summary of all changes (bullet list)
- ALL ticket references (`Closes #123`, `Refs #456`)

**Force push policy:** `--force-with-lease` permitted ONLY after rebasing/squashing, and only after running all checks.

**When hooks fail:** Fix the issue, don't bypass. If stuck, ask the user.

**Post-feature lifecycle:** Once a feature is agreed to be pushed, follow the full autonomous sequence in [Post-Feature MR Lifecycle](./docs/engineering-standards/git-conventions.md#post-feature-mr-lifecycle): squash → MR (`Closes #N`) → watch CI → merge with `--squash --remove-source-branch`. No user prompting needed until completion.

## Delivery Report Template

When completing tasks, provide this summary:

```markdown
## Delivery Summary

### Changes Made

- [List of changes]

### Verification Results

| Check      | Status | Details              |
| ---------- | ------ | -------------------- |
| Type check | ✓/✗    | [result]             |
| Lint       | ✓/✗    | [result]             |
| Tests      | ✓/✗    | [X passed, Y failed] |
| Build      | ✓/✗    | [result]             |
| Coverage   | ✓/✗    | [percentages]        |

### Test Coverage

- [file]: [X]% lines
- Overall: [X]% lines

### Notes

- [Any relevant context]
```
