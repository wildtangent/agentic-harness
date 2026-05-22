# Security Requirements

## Core Requirements

| Requirement | Implementation |
|-------------|----------------|
| **No secrets in code** | Use environment variables |
| **Validate all inputs** | Schema validation at API boundaries |
| **Sanitise file uploads** | Validate file type, size, and structure before processing |
| **No SQL injection** | Use parameterised queries or an ORM |
| **No XSS** | Escape user-supplied content; avoid raw HTML injection |
| **Dependency auditing** | Run dependency audit in CI |

## Environment Variables

- Store all secrets in environment variables
- Never commit `.env` files (add to `.gitignore`)
- Use different values for development/staging/production
- Document required variables in `.env.example`

## Input Validation

```typescript
// Always validate at API boundaries
const CreateItemSchema = z.object({
  name: z.string().min(1).max(255),
  quantity: z.number().int().positive(),
  publishedAt: z.coerce.date(),
});

export async function createItem(data: unknown) {
  const parsed = CreateItemSchema.safeParse(data);
  if (!parsed.success) {
    return { error: parsed.error.flatten() };
  }
  // Safe to use parsed.data
}
```

## File Upload Security

- Validate file type (MIME type and extension) before processing
- Validate file structure matches expected format
- Limit file size
- Sanitise filenames
- Store uploads outside the web root

## Dependency Security

```bash
# Run in CI pipeline — use your package manager's audit command
# npm:  npm audit
# yarn: yarn audit
# pnpm: pnpm audit

# Fix vulnerabilities
# npm:  npm audit fix
# pnpm: pnpm audit --fix
```
