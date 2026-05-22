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
// Loop through transactions
for (const txn of transactions) { ... }

// Good - explains why
// Lloyds uses separate debit/credit columns, so we need to
// determine direction by checking which column has a value
```

## JSDoc

Required for exported utility functions:

```typescript
/**
 * Parses a Lloyds Bank CSV export into normalised transactions.
 *
 * @param csvContent - Raw CSV string content
 * @returns Parsed transactions in internal format
 * @throws {ParseError} If CSV structure is invalid
 */
export function parseLloydsCsv(csvContent: string): Transaction[] {
  // ...
}
```

## Architectural Decision Records (ADRs)

For significant decisions, create an ADR in `docs/adr/`:

```markdown
# ADR-001: Use Prisma for Database Access

## Status
Accepted

## Context
We need a type-safe way to interact with PostgreSQL.

## Decision
Use Prisma ORM with generated types.

## Consequences
- Type-safe queries
- Migration management
- Learning curve for team
```

## What NOT to Document

- Self-explanatory code
- Implementation details that change frequently
- Information available in git history
