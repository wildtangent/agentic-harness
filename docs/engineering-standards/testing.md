# Testing Strategy

## Test Pyramid

```
          ┌───────────┐
          │   E2E     │  Few, slow, high confidence
          │  Tests    │
          ├───────────┤
          │Integration│  Some, medium speed
          │  Tests    │
          ├───────────┤
          │   Unit    │  Many, fast, isolated
          │  Tests    │
          └───────────┘
```

## Test Types

| Type | Scope | Tools | Location |
|------|-------|-------|----------|
| Unit | Single function/component | Vitest | `*.test.ts` alongside source |
| Integration | Multiple modules, database | Vitest | `*.integration.test.ts` |
| Component | React components | Vitest + Testing Library | `*.test.tsx` |
| E2E | Full user flows | Playwright | `e2e/*.spec.ts` |

## Coverage Requirements

| Metric | Minimum | Target |
|--------|---------|--------|
| Line coverage | 70% | 85% |
| Branch coverage | 65% | 80% |
| Function coverage | 70% | 85% |

Coverage enforced via CI pipeline. New code should not decrease overall coverage.

## What to Test

**Unit Tests (required):**
- Utility functions
- Data transformations
- Parsers and validators
- Business rules

**Integration Tests (required):**
- Database operations
- Server actions / route handlers
- External API integrations

**Component Tests (required for complex components):**
- Interactive components (forms, modals)
- Components with conditional rendering
- Components with state

**E2E Tests (required for critical paths):**
- Primary user flows
- Core navigation
- Key create / read / update / delete operations

## Test File Naming

```
src/
├── lib/
│   ├── services/
│   │   ├── user-service.ts
│   │   ├── user-service.test.ts        # Unit tests
│   │   └── user-service.integration.test.ts  # Integration tests
│   └── utils/
│       ├── date.ts
│       └── date.test.ts
├── components/
│   ├── users/
│   │   ├── user-card.tsx
│   │   └── user-card.test.tsx
e2e/
├── auth.spec.ts
├── users.spec.ts
└── settings.spec.ts
```

## Async Assertions

When testing async functions that return result objects (e.g., `ActionResult<T>`), use the `await expect().resolves` pattern instead of `if/else` branching. This ensures assertions always run consistently.

**Do this:**
```typescript
// Exact match
await expect(getCategory("non-existent")).resolves.toStrictEqual({
  success: false,
  error: "Category not found.",
});

// Partial match on success data
await expect(createCategory(data)).resolves.toMatchObject({
  success: true,
  data: expect.objectContaining({
    name: "New Category",
    isSystem: false,
  }),
});

// Error message substring matching
await expect(createCategory(duplicate)).resolves.toMatchObject({
  success: false,
  error: expect.stringContaining("already exists"),
});

// Expecting a promise to reject (throws an error)
await expect(fetchData("invalid")).rejects.toThrow("Network error");

// Reject with specific error type
await expect(validateInput(null)).rejects.toThrow(ValidationError);

// Reject with error message matching
await expect(connectToDb()).rejects.toThrow(
  expect.objectContaining({ message: expect.stringContaining("connection") }),
);
```

**Don't do this:**
```typescript
// Avoid if/else - assertions may not run if condition fails unexpectedly
const result = await getCategory(id);
if (result.success) {
  expect(result.data.name).toBe("Test");
} else {
  throw new Error(`Expected success: ${result.error}`);
}
```

### Pattern Summary

| Scenario | Matcher |
|----------|---------|
| Exact result match | `resolves.toStrictEqual({ success: true, data: ... })` |
| Partial object match | `resolves.toMatchObject({ data: expect.objectContaining({...}) })` |
| Error substring | `resolves.toMatchObject({ error: expect.stringContaining("...") })` |
| Array contents | `resolves.toMatchObject({ data: expect.arrayContaining([...]) })` |
| Promise rejects | `rejects.toThrow("error message")` |
| Rejects with error type | `rejects.toThrow(ErrorClass)` |
