#!/usr/bin/env bash

# WorktreeRemove hook — called by agents when a worktree session exits.

# Reads JSON from stdin with worktree_path, runs pnpm worktree:teardown (drops
# isolated DB), then removes the git worktree. Failures are non-fatal.

set -euo pipefail

INPUT=$(cat)
WORKTREE_PATH=$(echo "$INPUT" | jq -r .worktree_path)

echo "[worktree-remove] tearing down $WORKTREE_PATH" >&2

# Drop the isolated database
if [ -d "$WORKTREE_PATH" ]; then
  cd "$WORKTREE_PATH"
  pnpm worktree:teardown >&2 || echo "[worktree-remove] teardown failed (continuing)" >&2
fi

# Remove the git worktree. The worktree lives at <repo>/.claude/worktrees/<name>,
# so the main repo is three directories up.
MAIN_REPO=$(dirname "$(dirname "$(dirname "$WORKTREE_PATH")")")
git -C "$MAIN_REPO" worktree remove --force "$WORKTREE_PATH" >&2 || echo "[worktree-remove] git worktree remove failed (continuing)" >&2
