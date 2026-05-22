# Performance Guidelines

## Rendering Strategy

- **Prefer server-side rendering** where possible — reduces client bundle size and improves initial load
- Use client-side interactivity only when genuinely needed
- Fetch data as close to where it's needed as possible to avoid prop drilling and unnecessary re-renders

## Code Splitting

- **Lazy-load heavy components** — defer anything not needed on initial paint
- Split large pages into smaller chunks
- Preload resources critical to the primary user flow only

```typescript
// Example: dynamic/lazy import pattern
const HeavyChart = lazy(() => import('./heavy-chart'));
```

## Images

- Always specify explicit `width` and `height` to prevent layout shift
- Use modern formats (WebP, AVIF) with fallbacks
- Lazy-load below-the-fold images; eager-load above-the-fold hero images
- Never ship images at dimensions far larger than their rendered size

## Bundle Size

- Monitor bundle size in CI — set a budget and fail if exceeded
- Avoid importing entire libraries when only a few functions are needed
- Tree-shake unused code; prefer named imports

```bash
# Analyse bundle — use your framework's analyser
# Webpack:  ANALYZE=true <build-command>
# Vite:     vite-bundle-visualizer
# Next.js:  ANALYZE=true next build
```

## Database / API Queries

- **Select only needed fields** — avoid fetching entire records when a projection suffices
- **Always paginate list endpoints** — never return unbounded result sets
- **Index frequently queried fields** — review query plans for slow queries
- **Batch related queries** — avoid N+1 patterns by joining or batching requests

```typescript
// Good — select only what's needed, with pagination
const items = await db.item.findMany({
  select: { id: true, name: true, status: true },
  take: 50,
  skip: offset,
});

// Avoid — fetches all fields, no pagination
const items = await db.item.findMany();
```

## Caching

- Cache expensive computations and external API responses at an appropriate layer
- Invalidate caches on mutation — never serve stale data silently
- Use HTTP cache headers (`Cache-Control`, `ETag`) for static or rarely-changing resources
