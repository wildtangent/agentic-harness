---
description: Engineering quality gates, testing requirements, and code standards
alwaysApply: false
include:
  - "src/**/*"
  - "lib/**/*"
  - "test/**/*"
  - "e2e/**/*"
---

# Engineering Standards

Full reference: [docs/engineering-standards/](../../docs/engineering-standards/)

## Quality Gates (must pass before every commit)

1. Type check — zero errors
2. Lint — zero errors
3. Tests — all pass
4. Build — compiles successfully
5. Coverage — 80%+ on new code

## Testing

| Type | Scope | Location |
| ---- | ----- | -------- |
| Unit | Single function / component | `*.test.ts` alongside source |
| Integration | Multiple modules, database | `*.integration.test.ts` |
| E2E | Full user flows | `e2e/*.spec.ts` |

Full requirements: [docs/engineering-standards/testing.md](../../docs/engineering-standards/testing.md)

## Agent Acceptance Criteria

Before marking any task done, verify all criteria in
[docs/engineering-standards/agent-guidelines.md](../../docs/engineering-standards/agent-guidelines.md).

## Key Standards

- [Code Quality](../../docs/engineering-standards/code-quality.md) — TypeScript rules, linting config
- [Naming Conventions](../../docs/engineering-standards/naming-conventions.md) — files, variables, database
- [Error Handling](../../docs/engineering-standards/error-handling.md) — server actions, client components
- [Security](../../docs/engineering-standards/security.md) — input validation, secrets, dependencies
- [Performance](../../docs/engineering-standards/performance.md) — rendering, queries, bundle size
- [Accessibility](../../docs/engineering-standards/accessibility.md) — WCAG requirements
