# Performance Guidelines

## Server Components

- **Server Components by default** - Only use `'use client'` when needed
- Server Components reduce client bundle size
- Fetch data directly in Server Components

## Code Splitting

- **Lazy load heavy components** - Use `dynamic()` for charts, modals
- Split large pages into smaller chunks
- Preload critical resources

```typescript
import dynamic from 'next/dynamic';

const Chart = dynamic(() => import('@/components/chart'), {
  loading: () => <ChartSkeleton />,
});
```

## Images

- **Optimise images** - Use `next/image`
- Automatic WebP/AVIF conversion
- Lazy loading by default
- Responsive sizing

```typescript
import Image from 'next/image';

<Image
  src="/hero.jpg"
  alt="Description"
  width={800}
  height={600}
  priority // For above-the-fold images
/>
```

## Bundle Size

- **Limit bundle size** - Monitor with `@next/bundle-analyzer`
- Avoid importing entire libraries when only using a few functions
- Tree-shake unused code

```bash
# Analyse bundle
ANALYZE=true pnpm build
```

## Database

- **Use `select`** - Limit returned fields in Prisma queries
- **Pagination** - All list endpoints must support pagination
- **Indexes** - Ensure frequently queried fields are indexed

```typescript
// Good - select only needed fields
const transactions = await prisma.transaction.findMany({
  select: {
    id: true,
    amount: true,
    description: true,
  },
  take: 50,
  skip: offset,
});

// Avoid - fetching all fields
const transactions = await prisma.transaction.findMany();
```
