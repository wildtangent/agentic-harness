# Code Quality

## TypeScript

- **Strict mode enabled** - All strict flags on
- **No `any`** - Use `unknown` and type guards instead
- **Explicit return types** - Required on exported functions
- **No non-null assertions** - Avoid `!` operator; handle null explicitly

```typescript
// Bad
function getUser(id: string): any { ... }
const name = user!.name;

// Good
function getUser(id: string): User | null { ... }
const name = user?.name ?? 'Unknown';
```

## Biome Rules

Biome enforces linting and formatting. Key rules:

| Rule | Setting | Rationale |
|------|---------|-----------|
| `noExplicitAny` | error | Type safety |
| `useConst` | error | Immutability preference |
| `noUnusedVariables` | error | Clean code |
| `noConsoleLog` | warn | Use proper logging |
| `organizeImports` | enabled | Consistent ordering |
| `indentStyle` | tab | Accessibility |
| `lineWidth` | 100 | Readability |
| `quoteStyle` | single | Consistency |
| `semicolons` | always | Explicitness |

## Import Order

Imports organised in groups (enforced by Biome):

```typescript
// 1. Node built-ins
import { readFile } from 'node:fs/promises';

// 2. External packages
import { z } from 'zod';
import { prisma } from '../../generated/prisma/client';

// 3. Internal aliases (@/)
import { Button } from '@/components/ui/button';
import { formatCurrency } from '@/lib/utils/currency';

// 4. Relative imports
import { TransactionRow } from './transaction-row';
import type { Transaction } from './types';

// 5. Type-only imports last
import type { ComponentProps } from 'react';
```

## Pre-commit Hooks

Enforced via Husky + lint-staged:

```bash
# On commit:
- Run Biome lint on staged files
- Run Biome format on staged files
- Run TypeScript type check
- Run affected tests
```

## CI Pipeline Checks

All PRs must pass:

1. `pnpm typecheck` - No type errors
2. `pnpm lint` - No lint errors
3. `pnpm test` - All tests pass
4. `pnpm build` - Successful build
5. Coverage threshold met
