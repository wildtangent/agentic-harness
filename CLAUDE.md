# Claude Code Instructions

@AGENTS.md

---

## Sandbox Secrets (Fresh Machine Setup)

Claude Code agents running in sandbox mode (worktrees, sub-agents) need credentials
injected via `.claude/settings.local.json`. This file is gitignored — each contributor
must create it locally.

### Required Secrets

| Variable        | Purpose                                                          | Handled elsewhere?    |
| --------------- | ---------------------------------------------------------------- | --------------------- |
| `GITLAB_TOKEN`  | GitLab personal access token — enables `glab` CLI in sandbox     | No — must be set here |

Add any additional project-specific secrets required by your stack.

### Setup

1. Copy the template:

   ```bash
   cp .claude/settings.local.json.example .claude/settings.local.json
   ```

2. Fill in your credentials:
   - **`GITLAB_TOKEN`**: Generate at `{{GITLAB_URL}}/-/user_settings/personal_access_tokens` — needs `api` and `read_repository` scopes

Once `settings.local.json` is in place, all agent subprocesses will automatically
receive these credentials without manual `export` commands.

---

## Worktrees (Parallel Agent Sessions)

When Claude Code places you in a git worktree (via `EnterWorktree`), **run the
init script before doing anything else**. Each worktree gets its own isolated
environment so multiple agents can work in parallel without conflicts.

**Spawning parallel sub-agents?** Pass `isolation: "worktree"` to the `Agent`
tool — Claude Code will automatically create an isolated git worktree for that
sub-agent. The sub-agent must still run `{{WORKTREE_INIT_COMMAND}}` as its first step.

```
// Interactive session  →  EnterWorktree tool, then {{WORKTREE_INIT_COMMAND}}
// Sub-agent            →  Agent({ isolation: "worktree" }), then {{WORKTREE_INIT_COMMAND}}
```

### Setup — once per worktree

```bash
{{WORKTREE_INIT_COMMAND}}
```

Configure `{{WORKTREE_INIT_COMMAND}}` to allocate an isolated port and any per-worktree
resources (database, env file, etc.).

After init, all commands work normally:

| Command                    | Notes                                                   |
| -------------------------- | ------------------------------------------------------- |
| `{{DEV_COMMAND}}`          | Starts the dev server on the allocated port             |
| `{{TEST_COMMAND}}`         | Unit tests                                              |
| `{{E2E_COMMAND}}`          | Uses the allocated port and environment automatically   |

### Teardown — before the worktree is removed

```bash
{{WORKTREE_TEARDOWN_COMMAND}}
```

Run this before the session exits to clean up any isolated resources.

### Rules

- **Never** run the init or teardown commands in the main checkout
- Shared services should be started from the **main checkout** only

---

## Skills

Custom skills extend agent capabilities for specific workflows. Skills live in
`.agents/skills/` and are invoked via `/skill-name` in Claude Code chat.

| Skill           | Purpose                                    |
| --------------- | ------------------------------------------ |
| `create-issue`  | Scaffold and file a new GitLab issue       |
| `start-issue`   | Pick up a ticket and begin implementation  |
| `next-issues`   | List and triage the next candidate tickets |
