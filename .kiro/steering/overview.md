---
description: Project overview, issue tracking workflow, and documentation index
alwaysApply: true
---

# Project Overview

**{{PROJECT_NAME}}** — {{TECH_STACK}}

For full agent instructions see [AGENTS.md](../../AGENTS.md).

## Issue Tracking

- **Project board**: [{{GITLAB_PROJECT_URL}}]({{GITLAB_PROJECT_URL}})
- Check the board for available tickets before starting work
- Reference ticket numbers in branch names: `feat/#123-description`
- Link MRs to tickets using `Closes #123` in the MR description
- Use `glab issue list` to query open issues from the terminal

## Documentation Index

| Document | Purpose |
| -------- | ------- |
| [AGENTS.md](../../AGENTS.md) | Full agent instructions |
| `docs/PRODUCT_REQUIREMENTS.md` | Product vision and user stories |
| `docs/ARCHITECTURE.md` | Technical architecture and data model |
| `docs/USER_FLOWS.md` | Detailed user journeys |
| [docs/engineering-standards/](../../docs/engineering-standards/) | Code quality, testing, agent criteria |
