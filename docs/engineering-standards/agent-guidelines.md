# Agent Acceptance Criteria

Requirements that AI agents must satisfy before delivering code. Agents should treat these as mandatory gates—code is not complete until all criteria pass.

## Pre-Delivery Checklist

Before marking any code task as complete, agents MUST verify:

| Check | Command | Required Result |
|-------|---------|-----------------|
| Type check | _(project typecheck command)_ | Zero errors |
| Lint | _(project lint command)_ | Zero errors |
| Tests | _(project test command)_ | All tests pass |
| Build | _(project build command)_ | Successful compilation |
| Coverage | _(project coverage command)_ | Meets thresholds |

**Agents must run ALL checks and report results.** Do not assume a check passes—execute and verify.

## Pre-PR: Rebase onto Main

Before opening a PR, agents MUST rebase the feature branch onto the latest `main`:

```bash
git fetch origin main
git rebase origin/main
git push --force-with-lease
```

**This is mandatory every time, even if the branch was recently created.** Main moves fast; opening a PR from a stale branch causes merge conflicts and CI failures that waste review cycles.

If the rebase produces conflicts, resolve them, then run all quality checks before pushing.

## MR CI Checks

After opening an MR, agents MUST watch CI checks to confirm they pass before declaring the task complete:

```bash
glab ci status --watch
```

All jobs must be green. If any job fails:
1. Read the failure output — `glab ci view`
2. Fix the issue on the same branch
3. Push the fix and re-watch until all checks pass

**Do not consider a task delivered until remote CI passes.** Local checks are necessary but not sufficient.

## Code Coverage Gates

| Scope | Minimum | Blocking Threshold |
|-------|---------|-------------------|
| New code | 80% line coverage | < 80% blocks delivery |
| Modified files | No decrease | Any decrease blocks delivery |
| Overall project | 70% line coverage | < 70% blocks delivery |
| Critical paths* | 90% line coverage | < 90% blocks delivery |

*Critical paths include: authentication, data parsing, financial calculations, database operations.

### Coverage Verification

Agents must:
1. Run the project's coverage command after writing tests
2. Check the coverage report for new/modified files specifically
3. Report coverage percentages in the task completion summary
4. If coverage is below threshold, write additional tests before delivery

```bash
# Expected output format in agent response
Coverage Report:
- src/lib/feature-a/service.ts: 85% lines (✓ passes)
- src/lib/utils/helpers.ts: 92% lines (✓ passes)
- Overall: 78% lines (✓ passes 70% minimum)
```

## Test Suite Requirements

### Mandatory Test Coverage by Change Type

| Change Type | Required Tests |
|-------------|----------------|
| New utility function | Unit tests with edge cases |
| New React component | Component tests (render, interaction) |
| New API route/action | Integration tests |
| Bug fix | Regression test proving fix |
| Refactor | Existing tests must pass; add if gaps found |
| Database schema change | Migration tests + integration tests |

### Test Quality Standards

Agents must ensure tests:

- **Are deterministic** - No flaky tests; avoid timing dependencies
- **Test behaviour, not implementation** - Assert outcomes, not internal state
- **Include edge cases** - Empty inputs, null values, boundary conditions
- **Have descriptive names** - Test name should explain what's being verified

```typescript
// Good test names
it('returns empty array when CSV contains only headers')
it('throws ParseError when amount column is missing')
it('correctly handles negative amounts with parentheses notation')

// Bad test names
it('works')
it('test1')
it('handles edge case')
```

### Minimum Test Scenarios

For each new function/component, agents must test:

1. **Happy path** - Normal expected usage
2. **Empty/null inputs** - Graceful handling
3. **Invalid inputs** - Proper error responses
4. **Boundary conditions** - Min/max values, limits

## Build Verification

Agents must verify the full build pipeline. All of the following must succeed before delivery:

- Type check — zero type errors
- Lint — zero lint errors
- Build — successful compilation
- Test suite — all tests pass

**Build-breaking changes are never acceptable.** If a build fails:
1. Fix the issue immediately
2. Do not deliver partial work
3. Document what broke and why in task notes

## Documentation Requirements for Agents

When delivering code, agents must:

| Deliverable | Documentation Required |
|-------------|----------------------|
| New exported function | JSDoc with `@param`, `@returns`, `@throws` |
| New component | Props interface with comments for non-obvious props |
| New API endpoint | Brief inline comment explaining purpose |
| Complex logic | Inline comment explaining "why" (not "what") |
| Bug fix | Comment referencing issue number if applicable |

**Do NOT over-document.** Self-explanatory code needs no comments.

## Delivery Report Format

When completing a task, agents should provide a structured summary:

```markdown
## Delivery Summary

### Changes Made
- Added `calculateTotal()` function in `src/lib/utils/math.ts`
- Added unit tests in `src/lib/utils/math.test.ts`

### Verification Results
| Check | Status | Details |
|-------|--------|---------|
| Type check | ✓ Pass | No errors |
| Lint | ✓ Pass | No errors |
| Tests | ✓ Pass | 24 passed, 0 failed |
| Build | ✓ Pass | Compiled successfully |
| Coverage | ✓ Pass | New code: 87% lines |

### Test Coverage
- `src/lib/utils/math.ts`: 87% lines, 82% branches
- Overall project: 76% lines (no decrease)

### Notes
- [Any relevant context, decisions made, or follow-up items]
```

## Failure Handling

If any acceptance criteria fails:

1. **Do not mark task as complete**
2. **Fix the issue** - Write missing tests, fix type errors, resolve lint issues
3. **Re-run all checks** - Verify fix didn't break something else
4. **Document blockers** - If genuinely blocked, explain why and what's needed

### Acceptable Exceptions

Agents may deliver with failing checks ONLY if:

| Situation | Required Action |
|-----------|-----------------|
| Pre-existing failures | Document in delivery notes; do not fix unrelated issues |
| Intentional test skip | `it.skip()` with TODO comment and issue reference |
| Known flaky test | Document and create follow-up issue |

**Never hide or ignore failures.** Transparency is mandatory.

## Agent-Specific Guidelines

### Incremental Verification

For large tasks, agents should verify incrementally:

1. After each logical unit of work, run type check
2. After writing tests, run test suite
3. Before final delivery, run full verification suite

### Parallel Safety

When working on code that may affect other areas:

1. Run full test suite, not just new tests
2. Check for type errors across the entire project
3. Verify no unintended side effects in coverage report

### Rollback Protocol

If delivery criteria cannot be met:

1. Revert changes that broke the build
2. Preserve working partial progress in a separate branch (if applicable)
3. Report what was accomplished and what blocked completion
