# Engineering Standards

Technical requirements for code quality, testing, and conventions.

## Documentation Index

| Document | Description |
|----------|-------------|
| [Testing](./testing.md) | Test strategy, coverage requirements, test types |
| [Code Quality](./code-quality.md) | TypeScript rules, Biome config, CI checks |
| [Naming Conventions](./naming-conventions.md) | Files, code, components, database |
| [Git Conventions](./git-conventions.md) | Branching, commits, MRs, rebase/squash |
| [Agent Guidelines](./agent-guidelines.md) | Acceptance criteria for AI agents |
| [Error Handling](./error-handling.md) | Server actions, client components |
| [Security](./security.md) | Security requirements |
| [Performance](./performance.md) | Performance guidelines |
| [Accessibility](./accessibility.md) | Accessibility requirements |
| [Documentation](./documentation.md) | Documentation standards |

## Quick Reference

### Before Committing

Run your project's quality checks in this order:

1. Type check — zero type errors
2. Lint — zero lint errors
3. Tests — all pass
4. Build — successful compilation

### Branch Naming

```
<type>/<ticket>-<description>
```

Examples: `feat/#123-user-auth`, `fix/PROJ-456-login-bug`

### Commit Format ([Conventional Commits](https://www.conventionalcommits.org/))

```
<type>[scope]: <description>

[body]

[footer]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

### Coverage Thresholds

| Scope | Minimum |
|-------|---------|
| New code | 80% |
| Critical paths | 90% |
| Overall project | 70% |

## Open Decisions

- [ ] Specific Playwright E2E test scope for MVP
- [x] Husky/lint-staged vs Biome's own git hooks — **Decided: Husky + lint-staged**
- [ ] Error monitoring service (Sentry, etc.)
- [ ] Logging strategy (structured logs, log levels)
