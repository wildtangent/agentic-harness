---
name: start-issue
description: Prepare to work on a new feature or bug fix. Looks up the GitHub issue, claims it, creates a git worktree, and initialises the isolated dev environment. Use when starting work on a ticket.
argument-hint: "[issue-number]"
---

# Start Feature

Prepare to work on a new feature or bug fix. Runs the full pre-work checklist autonomously.

## Steps

Follow these steps in order. Do not skip any step.

### 1. Identify the issue

If the user provided an issue number (e.g. `$ARGUMENTS`), use that. Otherwise:

- List open issues on the project board (Todo column) with `gh issue list --state open --limit 20`
- Ask the user which issue they want to work on

### 2. Read the issue

Fetch the full issue body:

```
gh issue view <number>
```

Summarise the problem, proposed solution, and acceptance criteria for the user. Confirm this is the right issue before proceeding.

### 3. Claim the issue

Assign the issue to the authenticated user and move it to "In Progress":

```
gh issue edit <number> --add-assignee @me
gh issue comment <number> --body "Starting work on this issue."
```

### 4. Determine branch type and name

From the issue title and labels, choose the correct branch type:

- `feat/` for enhancements / new features
- `fix/` for bugs
- `docs/` for documentation only
- `refactor/` for refactoring
- `chore/` for maintenance

Format: `<type>/<number>-<short-kebab-description>`

Example: `feat/123-add-hsbc-parser`

> **Important:** Do **not** include `#` in the branch name or worktree path. The `#` character breaks Vite/Tailwind CSS PostCSS processing (null-byte error), causing `pnpm build` and `pnpm dev` to fail in the worktree.

### 5. Create a git worktree for the feature

Identify the main checkout root (the repo root, not any existing worktree). From there, create a new worktree:

```bash
# Ensure main is up to date
git -C <main-checkout> fetch origin main
git -C <main-checkout> checkout main
git -C <main-checkout> pull --rebase

# Create the worktree
pnpm --prefix <main-checkout> worktree:new <branch-name>

# Push the branch and set the upstream tracking ref
git -C <worktree-path> push -u origin <branch-name>
```

### 6. Initialise the worktree

`cd` into the new worktree directory and run:

```bash
pnpm worktree:init
```

This allocates a port, creates an isolated database, installs dependencies, runs migrations, and seeds system categories.

### 7. Use EnterWorktree to switch context

Use the `EnterWorktree` tool to move into the new worktree so all subsequent work runs in the isolated environment.

### 8. Report ready state

Tell the user:

- The issue number and title being worked on
- The branch name created
- The worktree path and allocated port
- The next step (start implementing)

> **After the feature is implemented and the user confirms the work is complete**, summarise what was delivered (files changed, acceptance criteria met) and ask:
>
> "Ready to ship? Run `/ship-feature` to run quality checks, open the PR, and prepare it for review."
>
> **Never invoke `/ship-feature` automatically** — always wait for the user to trigger it.
