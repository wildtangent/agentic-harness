#!/usr/bin/env bash

# Auto-format files edited by agents with Biome

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only run on supported file types
case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css)
    ;;
  *)
    exit 0
    ;;
esac

cd "$(dirname "$FILE_PATH")"
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

if [ -n "$PROJECT_ROOT" ]; then
  cd "$PROJECT_ROOT"
  pnpm biome check --write "$FILE_PATH" 2>/dev/null
fi

exit 0
