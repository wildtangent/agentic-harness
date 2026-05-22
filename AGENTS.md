# Agent Instructions

Comprehensive guide for AI agents working on this codebase. Read this file first, then reference linked documentation as needed.

## Project Overview

A family spending analysis tool with a web UI that helps families understand their finances by importing, categorising, and analysing bank statement data from multiple sources.

**Stack:** Next.js 16 + React 19 + TypeScript + PostgreSQL (Prisma) + Vercel

## Issue & Project Tracking

All work on this project is tracked via the **[GitHub Project Board](https://github.com/users/wildtangent/projects/2)**.

### Before Starting Work

1. **Check the project board** for available tickets in the "Todo" column
2. **Claim a ticket** by assigning yourself and moving it to "In Progress"
3. **Reference the ticket** in your branch name (e.g., `feat/#123-csv-import`)
4. **Link your PR** to the ticket when complete

### ⚠️ CRITICAL: Issue Tracking Requirement

**AGENTS MUST ALWAYS mark a GitHub issue or sub-issue as:**

- **"In Progress"** - When starting work on an issue
- **"Assigned"** - When claiming an issue to work on it

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
   - Follow the [Post-Feature PR Lifecycle](./docs/engineering-standards/git-conventions.md#post-feature-pr-lifecycle) autonomously
   - Squash commits → create PR with `Closes #N` → watch CI → merge with `--delete-branch`
   - The PR merge will auto-close the issue and delete the branch
   - Only escalate to the user if CI fails and cannot be diagnosed

**Failure to follow this workflow may result in:**

- Duplicate work by multiple agents
- Lost visibility of work in progress
- Poor project coordination and tracking

### Creating New Issues

If you identify work that needs to be done:

1. Create an issue in the [repository](https://github.com/wildtangent/claude-experiment/issues)
2. Use clear titles following the pattern: `<type>: <description>` (e.g., `feat: add CSV export`)
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

| Document                                                       | Purpose                                                | When to Read                                 |
| -------------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------- |
| [docs/PRODUCT_REQUIREMENTS.md](./docs/PRODUCT_REQUIREMENTS.md) | Product vision, features, user stories                 | Understanding what to build                  |
| [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)                 | Technical architecture, data model, Prisma schema      | Designing components, database work          |
| [docs/USER_FLOWS.md](./docs/USER_FLOWS.md)                     | Detailed user journeys with diagrams                   | Building UI, understanding user interactions |
| [docs/engineering-standards/](./docs/engineering-standards/)   | Code quality, testing, conventions, **agent criteria** | Before writing any code                      |

### Engineering Standards

| Document                                                                 | Purpose                                          |
| ------------------------------------------------------------------------ | ------------------------------------------------ |
| [Testing](./docs/engineering-standards/testing.md)                       | Test strategy, coverage requirements, test types |
| [Code Quality](./docs/engineering-standards/code-quality.md)             | TypeScript rules, Biome config, CI checks        |
| [Naming Conventions](./docs/engineering-standards/naming-conventions.md) | Files, code, components, database                |
| [Git Conventions](./docs/engineering-standards/git-conventions.md)       | Branching, commits, PRs, rebase/squash           |
| [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md)     | Acceptance criteria for AI agents                |
| [Error Handling](./docs/engineering-standards/error-handling.md)         | Server actions, client components                |
| [Security](./docs/engineering-standards/security.md)                     | Security requirements                            |
| [Performance](./docs/engineering-standards/performance.md)               | Performance guidelines                           |
| [Accessibility](./docs/engineering-standards/accessibility.md)           | Accessibility requirements                       |
| [Documentation](./docs/engineering-standards/documentation.md)           | Documentation standards                          |

### Reference Documentation

| Document                                                       | Purpose                          |
| -------------------------------------------------------------- | -------------------------------- |
| [docs/formats/csv/README.md](./docs/formats/csv/README.md)     | Supported bank CSV formats index |
| [docs/formats/csv/starling.md](./docs/formats/csv/starling.md) | Starling Bank CSV specification  |
| [docs/formats/csv/lloyds.md](./docs/formats/csv/lloyds.md)     | Lloyds Bank CSV specification    |

## Quick Start for Agents

> **Working in a worktree?** Run `pnpm worktree:init` immediately after entering
> the worktree. See the [Worktrees section in CLAUDE.md](./CLAUDE.md#worktrees-parallel-agent-sessions)
> for full instructions and teardown steps.
>
> **Spawning parallel sub-agents?** Pass `isolation: "worktree"` to the `Agent`
> tool — Claude Code will automatically create an isolated git worktree for that
> sub-agent. The sub-agent must still run `pnpm worktree:init` as its first step.
>
> ```
> // Interactive session  →  EnterWorktree tool, then pnpm worktree:init
> // Sub-agent            →  Agent({ isolation: "worktree" }), then pnpm worktree:init
> ```

### Sandbox Secrets (Fresh Machine Setup)

Claude Code agents running in sandbox mode (worktrees, sub-agents) need credentials
injected via `.claude/settings.local.json`. This file is gitignored — each contributor
must create it locally.

#### Required Secrets

| Variable               | Purpose                                                          | Handled elsewhere?                                                                                                                    |
| ---------------------- | ---------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `GH_TOKEN`             | GitHub personal access token — enables `gh` CLI in sandbox       | No — must be set here                                                                                                                 |
| `VERCEL_TOKEN`         | Vercel personal access token — enables all `vercel` CLI commands | No — must be set here                                                                                                                 |
| `DATABASE_URL`         | PostgreSQL connection string                                     | **Yes** — `worktree:init` generates a per-worktree URL automatically; do **not** set this here or it will override worktree isolation |
| `FIELD_ENCRYPTION_KEY` | AES-256-GCM key for field-level encryption                       | **Yes** — `worktree:init` inherits it from the main `.env.local`, or auto-generates one                                               |

#### Setup

1. Copy the template:

   ```bash
   cp .claude/settings.local.json.example .claude/settings.local.json
   ```

2. Fill in your credentials:
   - **`GH_TOKEN`**: Generate at <https://github.com/settings/tokens> — needs `repo` and `read:org` scopes
   - **`VERCEL_TOKEN`**: Generate at <https://vercel.com/account/tokens>

3. Verify Docker is reachable — `localhost:5432` (the `family-spending-db` container)
   must be accessible. Start it from the **main checkout** if needed:
   ```bash
   pnpm db:up
   ```
   > Worktrees share the Docker container — do not run `db:up` / `db:down` from inside
   > a worktree to start/stop it for isolated work.

Once `settings.local.json` is in place, all agent subprocesses will automatically
receive these credentials without manual `export` commands.

### Before Writing Code

1. **Read** [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md) - Mandatory acceptance criteria
2. **Understand** the data model in [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)
3. **Check** existing patterns in the codebase

### Git Branching Requirements

**ALWAYS follow the git branching conventions defined in** [docs/engineering-standards/git-conventions.md](./docs/engineering-standards/git-conventions.md) **before making ANY code changes:**

- **Create proper feature branches** using format: `<type>/<ticket>-<description>`
- **Reference tickets in branch names** when available (e.g., `feat/#123-csv-import`)
- **Follow conventional commit format** for all commits
- **Use rebase over merge** to maintain clean history
- **Squash commits** before merging to main
- **Never bypass hooks** with `--no-verify` or force push without `--force-with-lease`

Every code change MUST be made on a properly named branch following the Gitflow strategy. No direct commits to `main`.

### Key Directories

```
src/
├── app/                  # Next.js App Router pages
├── components/           # React components (shadcn/ui + custom)
├── lib/                  # Utilities, parsers, business logic
├── actions/              # Server Actions
prisma/
├── schema.prisma         # Database schema (source of truth)
├── generated/zod/        # Generated Zod schemas
docs/                     # All documentation
```

### Commands

```bash
pnpm dev              # Development with hot reload
pnpm build            # Compile TypeScript
pnpm lint             # Biome linting
pnpm format           # Biome formatting
pnpm typecheck        # Type check only
pnpm test             # Run tests
pnpm test:watch       # Tests in watch mode
pnpm test:coverage    # Tests with coverage report
```

## Agent Acceptance Criteria (Summary)

**Full details in [Agent Guidelines](./docs/engineering-standards/agent-guidelines.md)**

Before delivering code, agents MUST:

| Check    | Command              | Requirement                          |
| -------- | -------------------- | ------------------------------------ |
| Types    | `pnpm typecheck`     | Zero errors                          |
| Lint     | `pnpm lint`          | Zero errors                          |
| Tests    | `pnpm test`          | All pass                             |
| Build    | `pnpm build`         | Successful                           |
| Coverage | `pnpm test:coverage` | New code: 80%+, Critical paths: 90%+ |

### Test Requirements by Change Type

| Change                 | Required Tests                        |
| ---------------------- | ------------------------------------- |
| New utility function   | Unit tests with edge cases            |
| New React component    | Component tests (render, interaction) |
| New API route/action   | Integration tests                     |
| Bug fix                | Regression test proving fix           |
| Refactor               | Existing tests must pass              |
| Database schema change | Schema validation + generation tests  |

## Prisma Database Workflow

This section is **MANDATORY** for any work involving database changes or Prisma operations.

### Before Making Database Changes

1. **Check Current Schema**: Always run `pnpm db:validate` before making changes
2. **Start Database**: Ensure local database is running with `pnpm db:up`
3. **Backup Data**: Consider existing data before making destructive changes

### Schema Change Workflow

**When modifying `prisma/schema.prisma`:**

1. **Edit Schema**: Make your changes to `prisma/schema.prisma`
2. **Validate Syntax**: Run `pnpm db:validate` to check syntax
3. **Format Schema**: Run `pnpm db:format` to ensure consistent formatting
4. **Generate Types**: Run `pnpm db:generate` to update:
   - Prisma Client types
   - Generated Zod schemas (`prisma/generated/zod/`)
   - TypeScript definitions

5. **Run Tests**: Execute `pnpm test` to ensure no breaking changes
6. **Commit Changes**: Include both schema changes and generated files

### Database Development Commands

| Command                  | Purpose                                | When to Use                   |
| ------------------------ | -------------------------------------- | ----------------------------- |
| `pnpm db:up`             | Start local database (PostgreSQL 18.1) | Beginning development session |
| `pnpm db:down`           | Stop local database                    | Ending development session    |
| `pnpm db:reset`          | Reset database (destructive)           | Fresh start needed            |
| `pnpm db:validate`       | Validate schema syntax                 | After schema changes          |
| `pnpm db:format`         | Format schema file                     | After schema changes          |
| `pnpm db:generate`       | Generate client and types              | After schema changes          |
| `pnpm db:migrate:dev`    | Create development migration           | Adding schema changes         |
| `pnpm db:migrate:deploy` | Apply migrations to production         | Production deployment         |
| `pnpm db:studio`         | Open Prisma Studio                     | Visual database inspection    |
| `pnpm db:seed`           | Seed database with initial data        | Fresh database setup          |

### Generation Requirements

**MANDATORY AFTER ANY SCHEMA CHANGE:**

1. **Always run `pnpm db:generate`** after modifying `prisma/schema.prisma`
2. **Include generated files** in commits when schema changes are made
3. **Validate types** with `pnpm typecheck` after generation
4. **Test database operations** to ensure generation was successful

### Generated Files to Track

After running `pnpm db:generate`, these files are updated:

- `node_modules/.prisma/client/` - Prisma Client
- `prisma/generated/zod/` - Zod schemas for validation
- TypeScript types are embedded in the generated output

### Testing Database Changes

When modifying database schema:

1. **Unit Tests**: Test new models/fields with generated Zod schemas
2. **Integration Tests**: Test database operations through client
3. **Migration Tests**: Verify migrations apply correctly
4. **Type Safety**: Ensure TypeScript compilation succeeds

### Common Issues and Solutions

| Issue                         | Cause                   | Solution                           |
| ----------------------------- | ----------------------- | ---------------------------------- |
| TypeScript errors with Prisma | Missing generation      | Run `pnpm db:generate`             |
| Zod validation errors         | Schema mismatch         | Regenerate with `pnpm db:generate` |
| Migration conflicts           | Multiple schema changes | Reset with `pnpm db:reset`         |
| Connection errors             | Database not running    | Run `pnpm db:up`                   |

### Best Practices

- **Never edit generated files** - always modify `prisma/schema.prisma`
- **Commit both schema and migrations** - keep history complete
- **Use descriptive migration names** - explain what changed
- **Test in development** before deploying migrations
- **Keep database access in server actions** - maintain security model

### ⛔ Never Use psql (or Raw SQL Tools) for Migrations

**AGENTS MUST NOT use `psql`, `docker exec … psql`, or any raw SQL tool to apply schema changes or migrations.**

Use the Prisma CLI commands exclusively:

| Instead of…                           | Use…                                                                      |
| ------------------------------------- | ------------------------------------------------------------------------- |
| `psql -c "ALTER TABLE …"`             | `pnpm db:migrate:dev` (dev) or `pnpm db:migrate:deploy` (production)      |
| `docker exec … psql -f migration.sql` | `pnpm db:migrate:deploy`                                                  |
| Any hand-rolled SQL DDL               | Edit `prisma/schema.prisma`, then follow the Schema Change Workflow above |

**Why this rule exists:**

1. **Migration history is not tracked** — Prisma will not know the change happened, causing `migrate deploy` to fail or re-apply conflicting SQL in CI and production.
2. **Prisma Client becomes stale** — TypeScript types and the generated Zod schemas will no longer match the live database until `pnpm db:generate` is run.
3. **Schema drift** — `prisma/schema.prisma` diverges from the actual database, breaking type safety and making future migrations unpredictable.

If you need to inspect or query the database interactively, use `pnpm db:studio` (Prisma Studio) — never apply structural changes there either.

### Git Rules for Agents

**Full details in [Git Conventions](./docs/engineering-standards/git-conventions.md)**

#### Branching (Gitflow)

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

**Examples:** `feat/#123-csv-import`, `fix/PROJ-456-auth-bug`, `docs/api-reference`

#### Commits ([Conventional Commits](https://www.conventionalcommits.org/))

```
<type>[scope][!]: <description>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

**Examples:**

- `feat(parser): add Starling CSV support`
- `fix!: change amount to signed decimal` (breaking change)
- `chore(deps): update dependencies`

#### Workflow Rules

| Rule                        | Detail                                             |
| --------------------------- | -------------------------------------------------- |
| **Rebase over merge**       | Always rebase feature branches; no merge commits   |
| **Squash before merge**     | Squash all commits into one before merging to main |
| **Never `--no-verify`**     | Fix hook failures, don't bypass                    |
| **Never `--force`**         | Use `--force-with-lease` if force push needed      |
| **Never force push `main`** | Protected branch; always use PR                    |
| **No secrets in commits**   | Use environment variables                          |

**Squash policy:** Before merging, squash all commits with:

- Clear summary of all changes (bullet list)
- ALL ticket references (`Closes #123`, `Refs #456`)

**Force push policy:** `--force-with-lease` permitted ONLY after rebasing/squashing, and only after running all checks.

**When hooks fail:** Fix the issue, don't bypass. If stuck, ask the user.

**Post-feature lifecycle:** Once a feature is agreed to be pushed, follow the full autonomous sequence in [Post-Feature PR Lifecycle](./docs/engineering-standards/git-conventions.md#post-feature-pr-lifecycle): squash → PR (`Closes #N`) → watch CI → merge with `--squash --delete-branch`. No user prompting needed until completion.

## Code Style

- **TypeScript strict mode** - No `any`, explicit return types on exports
- **Named exports** - No default exports
- **Biome** - Handles linting and formatting (tabs, single quotes)
- **Test files** - `*.test.ts` alongside source files

### Naming Conventions

| Type                | Convention           | Example               |
| ------------------- | -------------------- | --------------------- |
| Files/folders       | kebab-case           | `transaction-row.tsx` |
| Components          | PascalCase           | `TransactionRow`      |
| Functions/variables | camelCase            | `parseStarlingCsv`    |
| Constants           | SCREAMING_SNAKE_CASE | `MAX_FILE_SIZE`       |
| Types/interfaces    | PascalCase           | `Transaction`         |

## Key Concepts

### Family Finance Model

The application tracks spending across a household:

- **Family Members** - Adults and children in the household
- **Account Types** - `shared` (joint) or `personal` (individual)
- **Transaction Attribution** - Who the spending was _for_ (can differ from payer)
- **Activities** - Grouping transactions (e.g., "Holiday 2025")

See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md#family-finance-model) for the full data model.

### CSV Import Pipeline

```
Upload → Detect Format → Parse → Dedupe → Store → Categorise
```

Bank-specific parsers normalise data to a common format. See [docs/formats/csv/](./docs/formats/csv/) for specifications.

### Categorisation Pipeline

```
Uncategorised → Apply Rules → AI Batch Categorise → Store Results
```

Uses GenAI API (OpenAI/Claude/Bedrock) for transactions not matched by rules.

## Technology Decisions

| Choice     | Technology                         | Rationale                           |
| ---------- | ---------------------------------- | ----------------------------------- |
| Framework  | Next.js 16                         | Full-stack React, Server Components |
| Components | shadcn/ui                          | Accessible, customisable            |
| Styling    | Tailwind CSS                       | Utility-first (required by shadcn)  |
| ORM        | Prisma                             | Type-safe, schema-first             |
| Validation | Zod (generated from Prisma)        | Single source of truth              |
| State      | Server Components + Server Actions | Minimal client state                |
| Forms      | React Hook Form + Zod              | Validated forms                     |

## When to Reference Each Document

| Task                        | Primary Document                                          |
| --------------------------- | --------------------------------------------------------- |
| Building a new feature      | PRODUCT_REQUIREMENTS.md → USER_FLOWS.md → ARCHITECTURE.md |
| Adding a component          | ARCHITECTURE.md → engineering-standards/                  |
| Database changes            | ARCHITECTURE.md (Prisma schema)                           |
| Writing tests               | engineering-standards/testing.md                          |
| Git workflow                | engineering-standards/git-conventions.md                  |
| CSV parser work             | docs/formats/csv/\*.md                                    |
| Understanding user journeys | USER_FLOWS.md                                             |
| Code review                 | engineering-standards/                                    |
| Before committing           | engineering-standards/agent-guidelines.md                 |

## Delivery Report Template

When completing tasks, provide this summary:

```markdown
## Delivery Summary

### Changes Made

- [List of changes]

### Verification Results

| Check      | Status | Details              |
| ---------- | ------ | -------------------- |
| TypeScript | ✓/✗    | [result]             |
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
