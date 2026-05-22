# Git Conventions

## Branching Strategy (Gitflow)

This project follows a modified [Gitflow](https://nvie.com/posts/a-successful-git-branching-model/) workflow.

### Branch Types

```
main                    # Production-ready code, protected
├── develop             # Integration branch (optional, for larger teams)
├── feat/<ticket>-<desc>    # New features
├── fix/<ticket>-<desc>     # Bug fixes
├── hotfix/<ticket>-<desc>  # Urgent production fixes
├── release/<version>       # Release preparation
├── chore/<ticket>-<desc>   # Maintenance tasks
├── docs/<ticket>-<desc>    # Documentation only
├── refactor/<ticket>-<desc># Code restructuring
├── test/<ticket>-<desc>    # Test additions/fixes
├── perf/<ticket>-<desc>    # Performance improvements
├── ci/<ticket>-<desc>      # CI/CD changes
└── build/<ticket>-<desc>   # Build system changes
```

### Branch Naming Format

```
<type>/<ticket-reference>-<short-description>
```

| Component | Required | Format | Example |
|-----------|----------|--------|---------|
| Type | Yes | Lowercase, from allowed list | `feat`, `fix`, `hotfix` |
| Ticket reference | Preferred | Ticket ID or issue number | `#123`, `PROJ-456` |
| Description | Yes | Kebab-case, concise | `csv-import`, `auth-flow` |

**With ticket reference (preferred):**
```
feat/#123-csv-import
fix/PROJ-456-duplicate-detection
hotfix/#789-critical-auth-bug
chore/#101-update-dependencies
```

**Without ticket (when no ticket exists):**
```
feat/csv-import-starling
fix/handle-empty-csv
docs/api-documentation
refactor/categorisation-pipeline
```

### Branch Lifecycle

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              BRANCH LIFECYCLE                                │
└─────────────────────────────────────────────────────────────────────────────┘

  main (protected)
    │
    ├──► feat/#123-new-feature ──► PR ──► squash ──► merge to main
    │         │
    │         ├── commit: "wip: initial implementation"
    │         ├── commit: "feat: add validation"
    │         ├── commit: "fix: handle edge case"
    │         └── squash all ──► "feat: add new feature (#123)"
    │
    ├──► fix/#456-bug-fix ──► PR ──► squash ──► merge to main
    │
    └──► hotfix/#789-critical ──► PR ──► squash ──► merge to main (expedited)
```

### Hotfix Process

Hotfixes bypass normal workflow for critical production issues:

1. Branch from `main`: `git checkout -b hotfix/#789-critical-bug main`
2. Implement minimal fix with tests
3. Create PR with `[HOTFIX]` prefix in title
4. Expedited review (single approval sufficient)
5. Squash and merge to `main`
6. Deploy immediately

### Branch Protection Rules

| Branch | Protection |
|--------|------------|
| `main` | Require PR, require approval, require status checks, no force push |
| `develop` (if used) | Require PR, require status checks |
| Feature branches | No protection (developer owns) |

---

## Commit Messages (Conventional Commits)

This project follows the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

### Format

```
<type>[optional scope][!]: <description>

[optional body]

[optional footer(s)]
```

### Commit Types

| Type | Description | Triggers |
|------|-------------|----------|
| `feat` | New feature | MINOR version bump |
| `fix` | Bug fix | PATCH version bump |
| `docs` | Documentation only | No version bump |
| `style` | Formatting, whitespace (no code change) | No version bump |
| `refactor` | Code restructuring (no feature/fix) | No version bump |
| `perf` | Performance improvement | PATCH version bump |
| `test` | Adding/updating tests | No version bump |
| `build` | Build system, dependencies | No version bump |
| `ci` | CI/CD configuration | No version bump |
| `chore` | Maintenance, tooling | No version bump |
| `revert` | Reverts a previous commit | Depends on reverted commit |

### Breaking Changes

Indicate breaking changes with:

1. **`!` after type/scope:** `feat!: remove deprecated API`
2. **Footer:** `BREAKING CHANGE: description of what breaks`

Breaking changes trigger a MAJOR version bump.

```
feat!: change authentication to OAuth2

BREAKING CHANGE: The previous session-based auth is removed.
Users must re-authenticate using the new OAuth2 flow.

Migration guide: docs/migration/auth-v2.md
```

### Scope (Optional)

Scope indicates the area of the codebase affected:

```
feat(parser): add Starling CSV support
fix(ui): correct date picker timezone
refactor(db): optimise transaction queries
test(api): add integration tests for upload
```

Common scopes for this project:
- `parser` - CSV parsers
- `ui` - React components
- `api` - Server actions/routes
- `db` - Database/Prisma
- `auth` - Authentication
- `config` - Configuration

### Description Rules

- Use imperative mood: "add feature" not "added feature" or "adds feature"
- No capitalisation at start
- No period at end
- Maximum 72 characters

```
# CORRECT
feat: add CSV import for Lloyds Bank
fix: handle negative amounts in parser
refactor: extract validation into shared module

# INCORRECT
feat: Added CSV import for Lloyds Bank.    # Past tense, period
fix: Handles negative amounts              # Third person
refactor: Extract validation               # Capitalised
```

### Body

- Separate from description with blank line
- Explain **what** and **why**, not **how**
- Wrap at 72 characters

### Footer

Standard footers:

| Footer | Purpose | Example |
|--------|---------|---------|
| `Closes #N` | Closes issue when merged | `Closes #123` |
| `Fixes #N` | Fixes issue when merged | `Fixes #456` |
| `Refs #N` | References related issue | `Refs #789` |
| `BREAKING CHANGE:` | Describes breaking change | See above |
| `Co-authored-by:` | Credit co-authors | `Co-authored-by: Name <email>` |
| `Reviewed-by:` | Credit reviewers | `Reviewed-by: Name <email>` |

### Complete Examples

**Simple feature:**
```
feat: add transaction search functionality
```

**Feature with scope and body:**
```
feat(parser): add Starling CSV support

Implements parsing for Starling Bank CSV exports including:
- Column mapping for Starling's format
- Category preservation from bank data
- Balance tracking per transaction

Closes #45
```

**Bug fix with breaking change:**
```
fix(api)!: change transaction amount to signed decimal

Previously amounts were stored as absolute values with a separate
'direction' field. Now using signed decimals for consistency.

BREAKING CHANGE: API responses now return signed amounts.
Clients expecting positive amounts with direction field will break.

Migration: Update clients to handle signed 'amount' field.

Fixes #234
```

**Chore with multiple issues:**
```
chore(deps): update dependencies to latest versions

- Update Next.js to 16.1.0
- Update Prisma to 6.2.0
- Update TypeScript to 5.9.1
- Update Biome to 2.4.0

Closes #301, #302
Refs #298
```

---

## Pull Request Requirements

**Before opening PR:**
- [ ] All CI checks pass locally (`pnpm typecheck && pnpm lint && pnpm test && pnpm build`)
- [ ] Tests added for new functionality
- [ ] No decrease in code coverage
- [ ] Self-reviewed diff

**PR description must include:**
- Summary of changes
- Link to related issue (`Closes #N`)
- Test plan (how to verify)
- Screenshots (for UI changes)

**Merge requirements:**
- All CI checks green
- No unresolved comments
- Branch up to date with main

---

## Post-Feature PR Lifecycle

**Once a feature is agreed to be pushed, agents MUST execute this sequence autonomously — no further user prompting is required until completion or an unresolvable failure.**

### Step 1 — Squash and Push

Squash all feature branch commits into one, then push:

```bash
# Rebase onto latest main first
git fetch origin
git rebase origin/main

# IMPORTANT: after rebasing, regenerate any generated files that may
# have changed on main (new deps, schema changes, etc.)
pnpm install
pnpm db:generate   # regenerates Prisma client + Zod schemas

# Verify the rebase result compiles cleanly before squashing
pnpm typecheck

# Soft-reset to squash all commits since branching
# NOTE: origin/main must be fetched (above) before this step —
# otherwise git resets to a stale base and captures unintended diffs
git reset --soft origin/main

# Write a single conventional commit with all ticket refs
git commit -m "$(cat <<'EOF'
feat(#scope): concise summary of the feature

- Change 1
- Change 2
- Change 3

Closes #123
EOF
)"

# Verify everything passes
pnpm typecheck && pnpm lint && pnpm test && pnpm build

# Push (force-with-lease is safe here — we just rebased)
git push --force-with-lease
```

### Step 2 — Create PR

Create the PR using `gh pr create`. The body **must** include `Closes #N` so GitHub auto-closes the issue on merge:

```bash
gh pr create \
  --title "feat(#123): concise summary" \
  --body "$(cat <<'EOF'
## Summary
- Change 1
- Change 2
- Change 3

## Test plan
- [ ] Unit tests pass (`pnpm test`)
- [ ] Build succeeds (`pnpm build`)
- [ ] Manually verified <key behaviour>

Closes #123
EOF
)"
```

### Step 3 — Watch CI

After the PR is created, **immediately** watch CI — do not wait for the user:

```bash
gh pr checks --watch
```

This blocks until all checks complete and prints a final pass/fail summary.

### Step 4a — CI Passes → Merge and Delete Branch

```bash
gh pr merge --squash --delete-branch
```

- `--squash` keeps `main` history clean
- `--delete-branch` removes the remote branch automatically
- `Closes #N` in the PR body causes GitHub to close the linked issue

Confirm to the user: PR merged, issue closed, branch deleted.

### Step 4b — CI Fails → Diagnose, Fix, Re-watch

If any check fails, **automatically**:

1. **Fetch failure logs:**

```bash
# List checks and find the failed run ID
gh pr checks

# View the failed run's logs
gh run view <run-id> --log-failed
```

2. **Diagnose** the root cause from the logs.

3. **Propose the fix** to the user (one sentence: what failed and why).

4. **Apply the fix**, commit, and push:

```bash
# Fix the issue, then:
git add <files>
git commit -m "fix: <what was fixed>"
git push
```

5. **Return to Step 3** — watch CI again:

```bash
gh pr checks --watch
```

Repeat until CI passes. **Escalate to the user only if** the failure cannot be diagnosed or a second fix attempt also fails.

---

## Git Rules for Agents

Agents MUST follow these git rules:

| Rule | Rationale |
|------|-----------|
| **Never use `--no-verify`** | Pre-commit hooks enforce quality; bypassing defeats the purpose |
| **Never use `--force`** | Use `--force-with-lease` if force push is necessary |
| **Never force push to `main` or `master`** | Protected branches; always requires PR |
| **Never use `git reset --hard` on shared branches** | Can destroy others' work |
| **Never commit secrets or credentials** | Security risk; use environment variables |
| **Prefer rebase over merge** | Maintains linear history |

### Rebase Strategy

**Always rebase feature branches onto the target branch instead of merging:**

```bash
# CORRECT - Rebase to update feature branch
git fetch origin
git rebase origin/main

# INCORRECT - Merge commits clutter history
git merge origin/main    # ❌ Creates merge commits
```

**Why rebase:**
- Maintains clean, linear commit history
- Makes `git log` and `git bisect` more useful
- Each commit represents a logical change
- Easier to review and understand project evolution

**Rebase workflow for feature branches:**

```bash
# 1. Ensure working directory is clean
git status

# 2. Fetch latest changes
git fetch origin

# 3. Rebase onto target branch
git rebase origin/main

# 4. Resolve any conflicts, then continue
git rebase --continue

# 5. Verify the rebase result
git log --oneline -10
pnpm typecheck && pnpm lint && pnpm test

# 6. Force push to update remote branch (see below)
git push --force-with-lease
```

### Squash Strategy

**Squash all commits on a feature branch into a single commit before merging to main.**

This ensures:
- Clean, readable history on `main`
- Each commit on `main` represents a complete, working feature
- Easier to revert entire features if needed
- Bisect remains effective for finding regressions

**When to squash:**
- Before creating a PR (preferred)
- Before merging to main
- After addressing PR review feedback

**Squash workflow:**

```bash
# 1. Ensure branch is up to date with main
git fetch origin
git rebase origin/main

# 2. Count commits to squash (commits since branching from main)
git log --oneline origin/main..HEAD

# 3. Interactive rebase to squash (N = number of commits)
git rebase -i HEAD~N

# 4. In the editor:
#    - Keep first commit as "pick"
#    - Change all others to "squash" or "s"
#    - Save and close

# 5. Edit the combined commit message (see format below)

# 6. Verify and force push
pnpm typecheck && pnpm lint && pnpm test
git push --force-with-lease
```

**Alternative - squash using reset:**

```bash
# 1. Note the commit to reset to (usually origin/main)
git fetch origin

# 2. Soft reset to keep changes staged
git reset --soft origin/main

# 3. Create single commit with comprehensive message
git commit -m "feat: add user authentication

- Implement login/logout flow
- Add JWT token handling
- Create auth middleware
- Add password hashing with bcrypt

Closes #123, #124"

# 4. Verify and force push
pnpm typecheck && pnpm lint && pnpm test
git push --force-with-lease
```

**Squashed commit message format:**

The final squashed commit MUST include:

1. **Type and summary** - Conventional commit format (`feat:`, `fix:`, etc.)
2. **Detailed changes** - Bullet list of all significant changes made
3. **Ticket references** - ALL ticket/issue references from original commits

```
<type>: <concise summary of the feature/fix>

<Optional longer description of the change>

- <Change 1>
- <Change 2>
- <Change 3>

Closes #<issue1>, #<issue2>
Refs #<related-issue>
```

**Example squashed commit message:**

```
feat: add CSV import for Starling Bank

Implements full CSV import pipeline for Starling Bank statements:

- Add CSV parser with column mapping for Starling format
- Implement transaction normalisation (amounts, dates, categories)
- Add duplicate detection based on date + description + amount
- Create upload UI with drag-and-drop support
- Add progress indicator for large files
- Write unit tests for parser edge cases
- Add integration tests for import flow

Closes #45, #46
Refs #12
```

**Collecting ticket references:**

Before squashing, agents MUST:

1. Run `git log --oneline origin/main..HEAD` to see all commits
2. Extract ALL ticket references (e.g., `#123`, `JIRA-456`, `Closes #789`)
3. Include all references in the final squashed commit message
4. Use appropriate keywords (`Closes`, `Fixes`, `Refs`) based on original context

```bash
# Find all ticket references in commits being squashed
git log origin/main..HEAD --format="%B" | grep -oE "(Closes|Fixes|Refs|See|Related to)?\s*#[0-9]+" | sort -u
```

### Force Push Policy

**`--force-with-lease` is permitted ONLY in these scenarios:**

| Scenario | Permitted | Verification Required |
|----------|-----------|----------------------|
| After rebasing a feature branch | ✓ Yes | Run all checks first |
| After amending an unpushed commit | ✓ Yes | Verify with `git log` |
| To `main` or `master` | ✗ Never | N/A |
| Without running checks first | ✗ Never | N/A |
| Using `--force` instead | ✗ Never | Use `--force-with-lease` |

**Before any force push, agents MUST:**

1. **Verify branch** - Confirm NOT on `main` or `master`
2. **Run all checks** - `pnpm typecheck && pnpm lint && pnpm test`
3. **Review changes** - `git log --oneline -10` to verify commit history
4. **Use `--force-with-lease`** - Never use `--force`

```bash
# CORRECT - Force push after rebase with verification
git fetch origin
git rebase origin/main
pnpm typecheck && pnpm lint && pnpm test  # All must pass
git log --oneline -5                            # Verify history
git push --force-with-lease                     # Safe force push

# FORBIDDEN
git push --force                    # ❌ Use --force-with-lease
git push --force-with-lease main    # ❌ Never force push main
git push -f                         # ❌ Alias for --force
```

**Why `--force-with-lease` over `--force`:**
- Fails if remote has commits you haven't fetched
- Prevents accidentally overwriting others' work
- Safer for collaborative branches

### Handling Hook Failures

When pre-commit hooks fail:

1. **Read the error message** - Understand what check failed
2. **Fix the underlying issue** - Don't bypass the hook
3. **Re-run the commit** - Let hooks verify the fix
4. **If stuck, ask the user** - Never force through

```bash
# FORBIDDEN - Agents must NEVER do this
git commit --no-verify -m "message"    # ❌ Bypasses hooks

# CORRECT - Fix issues, don't bypass
pnpm lint --fix                  # Fix lint errors
pnpm format                         # Fix formatting
git commit -m "message"                # Let hooks run
```

### GPG Signing

- Commits should be GPG signed when configured
- If GPG signing fails, notify the user - don't use `--no-gpg-sign` without permission
- Exception: User may explicitly request `--no-gpg-sign` for temporary issues
