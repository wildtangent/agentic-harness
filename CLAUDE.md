# Claude Code Instructions

## Project Overview

Family spending analysis tool - TypeScript + Next.js 16 + React 19 + PostgreSQL (Prisma) + Vercel.

**For comprehensive agent instructions, see [AGENTS.md](./AGENTS.md)**

## Issue Tracking

**Project Board:** [GitHub Project](https://github.com/users/wildtangent/projects/2)

- Check the board for available tickets before starting work
- Reference ticket numbers in branch names: `feat/#123-description`
- Link PRs to tickets using `Closes #123` in PR description

## Documentation

| Document                                                       | Purpose                                           |
| -------------------------------------------------------------- | ------------------------------------------------- |
| [AGENTS.md](./AGENTS.md)                                       | Full agent instructions and documentation index   |
| [docs/PRODUCT_REQUIREMENTS.md](./docs/PRODUCT_REQUIREMENTS.md) | Product vision, features, user stories            |
| [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)                 | Technical architecture, data model, Prisma schema |
| [docs/USER_FLOWS.md](./docs/USER_FLOWS.md)                     | Detailed user journeys                            |
| [docs/engineering-standards/](./docs/engineering-standards/)   | Code quality, testing, **agent criteria**         |
| [docs/formats/csv/](./docs/formats/csv/)                       | Bank CSV format specifications                    |

## Commands

```bash
pnpm dev              # Development with hot reload
pnpm build            # Compile TypeScript
pnpm lint             # Biome linting
pnpm format           # Biome formatting
pnpm typecheck        # Type check only
pnpm test             # Run tests
pnpm test:watch       # Tests in watch mode
pnpm test:coverage    # Tests with coverage report
pnpm test:e2e         # Run Playwright E2E tests (self-contained: starts its own server)
pnpm test:e2e:headed  # Run E2E tests in headed browser
pnpm test:e2e:ui      # Open Playwright UI mode
```

## Code Guidelines

- TypeScript strict mode - no `any`, explicit return types on exports
- Named exports only (no default exports)
- Prefer `const` over `let`
- Handle errors explicitly, avoid swallowing exceptions
- Test files: `*.test.ts` alongside source files

## Before Committing

**Mandatory checks - see [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md) for full details**

1. `pnpm typecheck` - Zero type errors
2. `pnpm lint` - Zero lint errors
3. `pnpm test` - All tests pass
4. `pnpm build` - Successful compilation
5. `pnpm test:coverage` - Coverage thresholds met (80%+ new code)

## Git Rules

**See [Git Conventions](./docs/engineering-standards/git-conventions.md) for full details**

**Branching (Gitflow):** `<type>/<ticket>-<description>` (e.g., `feat/#123-csv-import`)

**Commits ([Conventional Commits](https://www.conventionalcommits.org/)):** `<type>[scope]: <description>`

| Rule                    | Detail                                                      |
| ----------------------- | ----------------------------------------------------------- |
| Rebase over merge       | Always rebase feature branches; no merge commits            |
| Squash before merge     | Squash all commits into one; include all ticket refs        |
| Never `--no-verify`     | Fix hook failures, don't bypass                             |
| Never `--force`         | Use `--force-with-lease` after rebasing (with verification) |
| Never force push `main` | Protected branch; always use PR                             |
| Never commit secrets    | Use environment variables                                   |

When hooks fail: fix the issue, don't bypass; if stuck, ask the user.

## Post-Feature / PR Lifecycle

**Once a feature is agreed to be pushed, agents MUST execute the following sequence autonomously — no further user prompting is required.**

**See [Git Conventions — Post-Feature PR Lifecycle](./docs/engineering-standards/git-conventions.md#post-feature-pr-lifecycle) for full details and `gh` CLI commands.**

| Step          | Action                                                                                      |
| ------------- | ------------------------------------------------------------------------------------------- |
| 1. Create PR  | Squash commits, write conventional commit message, open PR with body containing `Closes #N` |
| 2. Watch CI   | Automatically poll CI with `gh pr checks --watch` — do not wait for the user                |
| 3a. CI passes | Merge immediately with `gh pr merge --squash --delete-branch`; confirm to user              |
| 3b. CI fails  | Fetch logs, diagnose, propose fix, apply and push, then return to step 2                    |

Escalate to the user only if a CI failure cannot be diagnosed or fixed after one attempt.

## Key Directories

```
src/
├── app/                  # Next.js App Router pages
├── components/           # React components
├── lib/                  # Utilities, parsers, business logic
├── actions/              # Server Actions
prisma/
├── schema.prisma         # Database schema
docs/                     # All documentation
```

## Testing

- Test files use `*.test.ts` suffix alongside source files
- Vitest with globals (`describe`, `it`, `expect`)
- See [Testing Standards](./docs/engineering-standards/testing.md) for coverage requirements

## E2E Tests

**Every feature that adds or changes a user-facing flow MUST include Playwright E2E tests.**

- E2E tests live in `e2e/*.spec.ts`
- Use `pnpm test:e2e` to run (dev server must be running on `:3000`)
- Each spec file maps to a feature area (e.g. `family.spec.ts`, `transactions.spec.ts`)
- Cover the critical path: create, read, update, delete where applicable
- Use `getByRole`, `getByLabel`, `getByTestId` — avoid brittle CSS selectors
- Scope post-action assertions to the relevant element, not loose `getByText`, to avoid strict-mode violations from dialog remnants or duplicate text
- `CardTitle` renders as a `div`, not a heading — use `getByText()` not `getByRole("heading")` for form titles
- The CI `e2e` job seeds a fresh database; tests that require seeded data (e.g. system categories) will always run correctly in CI

## Worktrees (Parallel Agent Sessions)

When Claude Code places you in a git worktree (via `EnterWorktree`), **run the
init script before doing anything else**. Each worktree gets its own isolated
port and database so multiple agents can work in parallel without conflicts.

### Setup — once per worktree

```bash
pnpm worktree:init
```

This allocates a free port (3001+), creates an isolated PostgreSQL database, writes
`.env`, installs dependencies, applies migrations, and seeds system categories.

After init, all commands work normally:

| Command         | Notes                                     |
| --------------- | ----------------------------------------- |
| `pnpm dev`      | Starts on your allocated port             |
| `pnpm test`     | Unit tests — no DB required               |
| `pnpm test:e2e` | Uses your port and database automatically |

### Teardown — before the worktree is removed

```bash
pnpm worktree:teardown
```

Drops your isolated database. Run this before the session exits.

### Rules

- **Never** run `worktree:init` or `worktree:teardown` in the main checkout
- Docker (`family-spending-db` container) is **shared** — start it with `pnpm db:up` from the **main checkout** if it is not running
- `pnpm db:up` / `pnpm db:down` in a worktree manage the shared container, not a worktree-specific one
