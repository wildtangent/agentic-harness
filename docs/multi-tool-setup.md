# Multi-Tool Agent Harness

This repository's agent harness is designed to work across three agentic tools:
**Claude Code**, **Kiro**, and **OpenCode**. Each tool loads instructions differently;
this document explains the design and what each tool sees.

## Architecture

```
AGENTS.md                          ← single source of truth (cross-tool)
CLAUDE.md                          ← Claude Code wrapper (@AGENTS.md + CC-specific sections)
opencode.json                      ← OpenCode instruction manifest
.kiro/steering/*.md                ← Kiro steering files (brief summaries + links)
docs/engineering-standards/        ← detailed reference docs (linked from all tools)
```

`AGENTS.md` is the authoritative instruction file. The other entry points are thin
adapters that either pull in AGENTS.md directly or summarise it for their tool's format.

---

## Claude Code

**Entry point:** `CLAUDE.md`

Claude Code reads `CLAUDE.md` automatically from the project root. The file uses the
`@path/to/file` syntax to inline content from other files at load time.

```markdown
# Claude Code Instructions

@AGENTS.md        ← expands AGENTS.md content inline

---

## Sandbox Secrets  ← Claude Code-only section
## Worktrees        ← Claude Code-only section
## Skills           ← Claude Code-only section
```

### @-Reference Syntax

`@path/to/file` works **only in Claude Code** (CLAUDE.md and interactive chat). It does
not work in AGENTS.md or any other tool's configuration files. Use plain Markdown links
(`[title](path)`) everywhere else.

| Context | Syntax | Works in |
| ------- | ------ | -------- |
| Inline file expansion | `@docs/foo.md` | Claude Code only |
| Clickable link | `[title](docs/foo.md)` | All tools |
| Relative reference | `./docs/foo.md` | All tools |

### Skills

Custom skills extend Claude Code with slash commands. They live in `.agents/skills/`
and are invoked as `/skill-name` in chat.

---

## Kiro

**Entry point:** `.kiro/steering/*.md`

Kiro loads steering files from `.kiro/steering/`. Each file has YAML frontmatter
controlling when it is injected:

```yaml
---
inclusion: always          # inject on every request
---
```

```yaml
---
inclusion: fileMatch                              # inject only when matching files are in context
fileMatchPattern: ["src/**/*", "lib/**/*"]
---
```

```yaml
---
inclusion: manual          # only when user references via #steering-file-name
---
```

```yaml
---
inclusion: auto            # injected when the request matches the description
name: api-design
description: REST API design patterns. Use when creating or modifying API endpoints.
---
```

### Steering Files in This Project

| File | `inclusion` | `fileMatchPattern` | Purpose |
| ---- | ----------- | ------------------ | ------- |
| `overview.md` | `always` | — | Project context, issue tracking, doc index |
| `git-workflow.md` | `always` | — | Branching, commits, MR lifecycle |
| `engineering.md` | `fileMatch` | `src/**/*`, `lib/**/*`, `test/**/*`, `e2e/**/*` | Quality gates, testing, standards |

Each steering file is a brief summary with links to the detailed docs in
`docs/engineering-standards/`. Do not duplicate content — edit the source docs and
the links will stay correct.

### What Kiro Does NOT Support

- `@file` inline expansion — use Markdown links instead
- MCP server config is handled separately (out of scope for this harness)

---

## OpenCode

**Entry point:** `opencode.json`

OpenCode reads `opencode.json` from the project root. The `instructions` array lists
files (or glob patterns) that are loaded as system-level instructions for every session.

```json
{
  "instructions": [
    "AGENTS.md",
    "docs/engineering-standards/git-conventions.md",
    "docs/engineering-standards/agent-guidelines.md"
  ]
}
```

OpenCode loads `AGENTS.md` directly — no wrapper needed. If `opencode.json` is absent,
OpenCode falls back to `CLAUDE.md`, but `CLAUDE.md` contains Claude Code-specific
`@` directives that OpenCode does not understand, so `opencode.json` should always be
present.

### Instruction Files vs Skill Files

Only instruction files go in `opencode.json`. Skill/workflow files (`.agents/skills/`)
are not loaded here — they are Claude Code-specific slash commands.

---

## Adding New Shared Documentation

When adding new engineering-standards docs:

1. Create the file in `docs/engineering-standards/`
2. Add a row to the documentation index in `AGENTS.md`
3. Add a link in the relevant `.kiro/steering/*.md` file
4. No changes needed in `CLAUDE.md` (it inherits from `@AGENTS.md`) or `opencode.json`
   unless the new doc is critical enough to warrant direct loading

---

## Placeholder Reference

All `{{TOKEN}}` placeholders must be substituted when adopting this harness.
See [docs/engineering-standards/gitlab-setup.md](./engineering-standards/gitlab-setup.md)
for the full substitution guide.
