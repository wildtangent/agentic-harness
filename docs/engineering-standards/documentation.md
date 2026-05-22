# Documentation Requirements

## Required Documentation

| Document | Purpose |
|----------|---------|
| **README.md** | Setup instructions, environment variables |
| **Code comments** | For non-obvious logic only (why, not what) |
| **JSDoc** | For exported utility functions |
| **ADRs** | For significant architectural decisions (in `docs/adr/`) |

## Code Comments

Comment the **why**, not the **what**:

```typescript
// Bad - describes what code does (obvious)
// Loop through users
for (const user of users) { ... }

// Good - explains why
// The external API returns IDs as strings even though our schema
// treats them as numbers, so we coerce here rather than in the schema
```

## JSDoc

Required for exported utility functions:

```typescript
/**
 * Normalises a date string from an external source into a JS Date.
 *
 * @param raw - Raw date string from the external API
 * @returns Parsed Date object in UTC
 * @throws {ParseError} If the string cannot be parsed as a valid date
 */
export function parseExternalDate(raw: string): Date {
  // ...
}
```

## Architectural Decision Records (ADRs)

For significant decisions, create an ADR in `docs/adr/`:

```markdown
# ADR-001: Use an ORM for Database Access

## Status
Accepted

## Context
We need a type-safe way to interact with the database.

## Decision
Use an ORM with generated types.

## Consequences
- Type-safe queries
- Migration management
- Learning curve for team
```

## What NOT to Document

- Self-explanatory code
- Implementation details that change frequently
- Information available in git history
