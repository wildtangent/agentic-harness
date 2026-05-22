# Accessibility Requirements

## Core Requirements

| Requirement | Standard |
|-------------|----------|
| **Semantic HTML** | Use correct elements (`button`, `nav`, `main`) |
| **ARIA labels** | For interactive elements without visible text |
| **Keyboard navigation** | All interactive elements focusable |
| **Colour contrast** | Meet WCAG AA (4.5:1 for text) |
| **Screen reader testing** | Test critical flows with VoiceOver/NVDA |

## Semantic HTML

```typescript
// Good - semantic elements
<nav>
  <ul>
    <li><a href="/dashboard">Dashboard</a></li>
  </ul>
</nav>

<main>
  <article>
    <h1>Transaction Details</h1>
  </article>
</main>

// Avoid - div soup
<div class="nav">
  <div class="link">Dashboard</div>
</div>
```

## ARIA Labels

```typescript
// Icon button needs aria-label
<button aria-label="Close modal">
  <XIcon />
</button>

// Form inputs need labels
<label htmlFor="amount">Amount</label>
<input id="amount" type="number" />
```

## Keyboard Navigation

- All interactive elements must be focusable
- Tab order should be logical
- Focus indicators must be visible
- Escape key should close modals

## shadcn/ui

shadcn/ui components provide accessible defaults:

- Proper ARIA attributes
- Keyboard navigation
- Focus management

**Don't override these without consideration.**

## Testing

- Test with keyboard only (no mouse)
- Test with screen reader (VoiceOver on Mac, NVDA on Windows)
- Use browser accessibility tools (Lighthouse, axe)
