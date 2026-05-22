#!/usr/bin/env bash

# WorktreeCreate hook — called by the agent instead of default git worktree creation.
# Reads JSON from stdin, creates an isolated git worktree, runs pnpm worktree:init,
# then prints the worktree path to stdout (required by Claude Code).

set -euo pipefail

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r .name)
CWD=$(echo "$INPUT" | jq -r .cwd)

# Strip '#' — Vite/Node treat it as a URL fragment, breaking module resolution

SAFE_NAME="$(echo "$NAME" | tr -d '#')"
WORKTREE_DIR="$CWD/.agents/worktrees/$SAFE_NAME"

echo "[worktree-create] creating worktree '$NAME' (safe: '$SAFE_NAME') at $WORKTREE_DIR" >&2

# Create the git worktree on a new branch
git -C "$CWD" worktree add -b "worktree/$SAFE_NAME" "$WORKTREE_DIR" HEAD >&2

# Run project init: allocates port, creates isolated DB, writes .env, runs migrations
cd "$WORKTREE_DIR"
pnpm worktree:init >&2

# Required: print the worktree path so Claude Code knows where to open the session
echo "$WORKTREE_DIR"

