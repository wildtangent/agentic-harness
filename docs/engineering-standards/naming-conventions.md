# Naming Conventions

## Files and Folders

| Type | Convention | Example |
|------|------------|---------|
| Folders | kebab-case | `user-profile/`, `search-results/` |
| React components | kebab-case | `user-card.tsx` |
| Utilities | kebab-case | `format-date.ts` |
| Types | kebab-case | `user.types.ts` |
| Tests | `*.test.ts(x)` | `parser.test.ts` |
| Constants | kebab-case | `status-codes.ts` |

## Code

| Type | Convention | Example |
|------|------------|---------|
| Variables | camelCase | `userCount`, `isLoading` |
| Constants | SCREAMING_SNAKE_CASE | `MAX_FILE_SIZE`, `DEFAULT_TIMEOUT` |
| Functions | camelCase | `fetchUserById()`, `formatDate()` |
| React components | PascalCase | `UserCard`, `SearchResult` |
| Types/Interfaces | PascalCase | `User`, `SearchResult` |
| Enums | PascalCase | `UserRole`, `RequestStatus` |
| Enum values | SCREAMING_SNAKE_CASE | `UserRole.ADMIN` |
| Type parameters | Single uppercase | `T`, `K`, `V` |

## React Components

```typescript
// Component file: user-card.tsx

// Named export (not default)
export function UserCard({ user }: UserCardProps) {
  // ...
}

// Props interface named [Component]Props
interface UserCardProps {
  user: User;
  onSelect?: (id: string) => void;
}

// Hooks start with 'use'
function useUserFilters() { ... }
```

## Server Actions / Route Handlers

```typescript
// Verb-noun naming
export async function getUsers(filters: UserFilters) { ... }
export async function updateUserRole(id: string, role: UserRole) { ... }
export async function deleteUser(id: string) { ... }

// Prefix mutations with action verb
export async function createUser(data: UserInput) { ... }
export async function assignResource(userId: string, resourceId: string) { ... }
```

## Database

| Type | Convention | Example |
|------|------------|---------|
| Models | PascalCase (singular) | `User`, `Resource` |
| Table names | snake_case (plural) | `users`, `resources` |
| Columns | snake_case | `created_at`, `user_id` |
| Foreign keys | `{relation}_id` | `owner_id`, `parent_id` |
| Enums | PascalCase | `UserRole`, `ResourceStatus` |
| Indexes | Follow your ORM's conventions | — |
