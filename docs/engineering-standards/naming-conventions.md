# Naming Conventions

## Files and Folders

| Type | Convention | Example |
|------|------------|---------|
| Folders | kebab-case | `csv-parsers/`, `family-members/` |
| React components | kebab-case | `transaction-row.tsx` |
| Utilities | kebab-case | `format-currency.ts` |
| Types | kebab-case | `transaction.types.ts` |
| Tests | `*.test.ts(x)` | `parser.test.ts` |
| Constants | kebab-case | `category-defaults.ts` |

## Code

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `transactionCount`, `isLoading` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_FILE_SIZE`, `DEFAULT_CATEGORY` |
| Functions | camelCase | `parseStarlingCsv()`, `formatCurrency()` |
| React components | PascalCase | `TransactionRow`, `CategoryBadge` |
| Types/Interfaces | PascalCase | `Transaction`, `FamilyMember` |
| Enums | PascalCase | `AccountType`, `UploadStatus` |
| Enum values | SCREAMING_SNAKE_CASE | `AccountType.SHARED` |
| Type parameters | Single uppercase | `T`, `K`, `V` |

## React Components

```typescript
// Component file: transaction-row.tsx

// Named export (not default)
export function TransactionRow({ transaction }: TransactionRowProps) {
  // ...
}

// Props interface named [Component]Props
interface TransactionRowProps {
  transaction: Transaction;
  onSelect?: (id: string) => void;
}

// Hooks start with 'use'
function useTransactionFilters() { ... }
```

## Server Actions

```typescript
// File: actions/transactions.ts

// Verb-noun naming
export async function getTransactions(filters: TransactionFilters) { ... }
export async function updateTransactionCategory(id: string, categoryId: string) { ... }
export async function deleteTransaction(id: string) { ... }

// Prefix mutations with action verb
export async function createFamilyMember(data: FamilyMemberInput) { ... }
export async function attributeTransaction(id: string, memberIds: string[]) { ... }
```

## Database (Prisma)

| Type | Convention | Example |
|------|------------|---------|
| Models | PascalCase (singular) | `Transaction`, `FamilyMember` |
| Table names | snake_case (plural) | `transactions`, `family_members` |
| Columns | snake_case | `created_at`, `account_id` |
| Foreign keys | `{relation}_id` | `category_id`, `paid_by_id` |
| Enums | PascalCase | `AccountType`, `Bank` |
| Indexes | Implicit (Prisma handles) | — |

```prisma
model FamilyMember {
  id        String   @id @default(uuid())
  name      String   @db.VarChar(100)
  createdAt DateTime @default(now()) @map("created_at")

  @@map("family_members")  // Table name
}
```

## CSS / Tailwind

- Use Tailwind utility classes as primary styling method
- Extract repeated patterns to components, not CSS classes
- shadcn/ui component variants via `cva` (class-variance-authority)

```typescript
// Good: Tailwind utilities
<button className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600">

// Good: Component abstraction for reuse
<Button variant="primary" size="md">

// Avoid: Custom CSS classes
<button className="my-custom-button">  // No
```
