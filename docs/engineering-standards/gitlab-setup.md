# GitLab Setup Guide

This document explains how to configure this steering repository for a new GitLab project.

For the multi-tool harness architecture (Claude Code, Kiro, OpenCode) see
[docs/multi-tool-setup.md](../multi-tool-setup.md).

## Prerequisites

### 1. Install the GitLab CLI (`glab`)

```bash
# macOS
brew install glab

# Linux (via curl)
curl -s https://raw.githubusercontent.com/cli/cli/trunk/scripts/bootstrap.sh | sudo bash

# Or download from: https://gitlab.com/gitlab-org/cli/-/releases
```

### 2. Authenticate

```bash
glab auth login
```

Follow the prompts. For a self-hosted instance, pass `--hostname`:

```bash
glab auth login --hostname gitlab.example.com
```

Verify authentication:

```bash
glab auth status
```

---

## Placeholder Substitution

When adopting this repository for a new project, replace the following placeholder tokens across all files.

| Placeholder | Replace with | Files affected |
| --- | --- | --- |
| `{{PROJECT_NAME}}` | Your project's name | `CLAUDE.md`, `AGENTS.md`, `.kiro/steering/overview.md` |
| `{{PROJECT_DESCRIPTION}}` | One-paragraph project description | `AGENTS.md` |
| `{{TECH_STACK}}` | Technology stack (e.g. `Node.js + TypeScript + PostgreSQL`) | `CLAUDE.md`, `AGENTS.md`, `.kiro/steering/overview.md` |
| `{{GITLAB_URL}}` | Your GitLab base URL (e.g. `https://gitlab.com` or `https://gitlab.mycompany.com`) | `AGENTS.md`, `CLAUDE.md` |
| `{{GITLAB_PROJECT_URL}}` | Full URL to your GitLab project board | `CLAUDE.md`, `AGENTS.md`, `.kiro/steering/overview.md` |
| `{{GITLAB_ISSUES_URL}}` | Full URL to your project's issues list | `AGENTS.md` |
| `{{WORKTREE_INIT_COMMAND}}` | Command to initialise a git worktree environment | `CLAUDE.md`, `AGENTS.md`, `start-issue` skill |
| `{{WORKTREE_TEARDOWN_COMMAND}}` | Command to tear down a worktree environment | `CLAUDE.md` |
| `{{DEV_COMMAND}}` | Command to start the dev server | `CLAUDE.md`, `AGENTS.md` |
| `{{TEST_COMMAND}}` | Command to run unit tests | `CLAUDE.md`, `AGENTS.md` |
| `{{E2E_COMMAND}}` | Command to run end-to-end tests | `CLAUDE.md`, `AGENTS.md` |
| `{{BUILD_COMMAND}}` | Command to build / compile the project | `AGENTS.md` |
| `{{LINT_COMMAND}}` | Command to run the linter | `AGENTS.md` |
| `{{TYPECHECK_COMMAND}}` | Command to run the type checker | `AGENTS.md` |

### Example substitution (Node.js project on gitlab.com)

```
{{PROJECT_NAME}}             → My SaaS App
{{TECH_STACK}}               → Node.js + TypeScript + React + PostgreSQL
{{GITLAB_URL}}               → https://gitlab.com
{{GITLAB_PROJECT_URL}}       → https://gitlab.com/my-org/my-saas-app/-/boards
{{GITLAB_ISSUES_URL}}        → https://gitlab.com/my-org/my-saas-app/-/issues
{{WORKTREE_INIT_COMMAND}}    → pnpm worktree:init
{{WORKTREE_TEARDOWN_COMMAND}} → pnpm worktree:teardown
{{DEV_COMMAND}}              → pnpm dev
{{TEST_COMMAND}}             → pnpm test
{{E2E_COMMAND}}              → pnpm test:e2e
{{BUILD_COMMAND}}            → pnpm build
{{LINT_COMMAND}}             → pnpm lint
{{TYPECHECK_COMMAND}}        → pnpm typecheck
```

---

## Credentials Setup

Agents need a `GITLAB_TOKEN` to call `glab` inside sandbox sessions (worktrees, sub-agents).

### Create a GitLab personal access token

1. Navigate to `{{GITLAB_URL}}/-/user_settings/personal_access_tokens`
2. Create a token with the following scopes:
   - `api` — read/write access to all endpoints
   - `read_repository` — read repository content
3. Copy the token value (it is only shown once)

### Inject the token into Claude Code

Add to `.claude/settings.local.json` in your project (this file is gitignored):

```json
{
  "env": {
    "GITLAB_TOKEN": "glpat-xxxxxxxxxxxxxxxxxxxx"
  }
}
```

Once in place, all agent subprocesses receive the token automatically.

---

## GitLab-Specific Notes

### Merge Requests vs Pull Requests

GitLab uses **Merge Requests (MRs)** instead of Pull Requests. All scripts and documentation in this repository use the correct GitLab terminology.

### Auto-closing issues

Including `Closes #N` in an MR description automatically closes the linked issue when the MR is merged. This is the same behaviour as GitHub and is supported natively in GitLab.

### CI/CD

This repository does not include a `.gitlab-ci.yml` file — CI/CD is defined in your project repository. The `glab ci status --watch` command used in the [Post-Feature MR Lifecycle](./git-conventions.md#post-feature-mr-lifecycle) polls the pipeline attached to your branch's open MR.

### Issue boards

GitLab issue boards are at `{{GITLAB_PROJECT_URL}}/-/boards`. The expected columns are:
- **Open** / **Todo** — available work
- **In Progress** — claimed by an agent or developer
- **Closed** — completed (auto-populated when issues are closed via MR merge)

---

## Verifying the Setup

Run the following to confirm `glab` is configured correctly:

```bash
# Confirm authentication
glab auth status

# List open issues in the project
glab issue list --state opened

# List recent MRs
glab mr list --state opened
```

If any command fails with an authentication error, re-run `glab auth login`.
