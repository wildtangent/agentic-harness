# Security Requirements

## Core Requirements

| Requirement | Implementation |
|-------------|----------------|
| **No secrets in code** | Use environment variables |
| **Validate all inputs** | Zod schemas at API boundaries |
| **Sanitise file uploads** | Validate CSV structure before processing |
| **No SQL injection** | Prisma parameterises queries automatically |
| **No XSS** | React escapes by default; avoid `dangerouslySetInnerHTML` |
| **Dependency auditing** | Run `pnpm audit` in CI |

## Environment Variables

- Store all secrets in environment variables
- Never commit `.env` files (add to `.gitignore`)
- Use different values for development/staging/production
- Document required variables in `.env.example`

## Input Validation

```typescript
// Always validate at API boundaries
const TransactionCreateSchema = z.object({
  amount: z.number().finite(),
  description: z.string().min(1).max(255),
  date: z.coerce.date(),
});

export async function createTransaction(data: unknown) {
  const parsed = TransactionCreateSchema.safeParse(data);
  if (!parsed.success) {
    return { error: parsed.error.flatten() };
  }
  // Safe to use parsed.data
}
```

## File Upload Security

- Validate file type before processing
- Validate CSV structure matches expected format
- Limit file size
- Sanitise filenames
- Store uploads outside web root

## Dependency Security

```bash
# Run in CI pipeline
pnpm audit

# Fix vulnerabilities
pnpm audit --fix
```
