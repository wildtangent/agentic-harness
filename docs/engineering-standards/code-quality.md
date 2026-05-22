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
import { db } from '../../lib/db';

// 3. Internal aliases (@/)
import { Button } from '@/components/ui/button';
import { formatDate } from '@/lib/utils/date';

// 4. Relative imports
import { UserCard } from './user-card';
import type { User } from './types';

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

All MRs must pass:

1. Type check — zero type errors
2. Lint — zero lint errors
3. Test suite — all tests pass
4. Build — successful compilation
5. Coverage threshold met
