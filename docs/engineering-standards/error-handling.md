# Error Handling

## Server Actions

```typescript
// Return structured results, don't throw
export async function createTransaction(data: unknown) {
  const parsed = TransactionCreateSchema.safeParse(data);

  if (!parsed.success) {
    return { success: false, error: parsed.error.flatten() };
  }

  try {
    const transaction = await prisma.transaction.create({
      data: parsed.data
    });
    return { success: true, data: transaction };
  } catch (error) {
    // Log for debugging, return user-friendly message
    console.error('Failed to create transaction:', error);
    return { success: false, error: { message: 'Failed to save transaction' } };
  }
}
```

## Client Components

```typescript
// Use error boundaries for unexpected errors
// Handle expected errors in component state

function TransactionForm() {
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(data: FormData) {
    const result = await createTransaction(data);

    if (!result.success) {
      setError(result.error.message);
      return;
    }

    // Success handling
  }
}
```

## Client Components — Toast Feedback

Use **Sonner** (`import { toast } from "sonner"`) for all user-facing mutation feedback in page client components. Never use inline error banner `<div>` elements.

```typescript
import { toast } from "sonner";

async function handleCreate(data: FormData) {
  const result = await createItem(data);

  if (!result.success) {
    toast.error(result.error);
    return;
  }

  toast.success("Item created.");
  // update local state...
}
```

The `<Toaster richColors closeButton />` is mounted once in the root layout inside `<ThemeProvider>`.

## Guidelines

- **Server Actions**: Return structured `{ success, data?, error? }` objects
- **Don't throw**: Avoid throwing errors that propagate to the client
- **Log errors**: Log full error details server-side for debugging
- **User-friendly messages**: Return sanitised, helpful error messages to users
- **Error boundaries**: Use React error boundaries for unexpected UI errors
- **Toast for mutations**: Use `toast.error()` / `toast.success()` from Sonner — never inline error banners
