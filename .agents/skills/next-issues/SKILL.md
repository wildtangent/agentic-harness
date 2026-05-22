---
name: next-issues
description: List the next most effective issues to tackle from GitHub. Fetches open issues, scores them by impact vs effort, and presents a prioritised shortlist with reasoning.
argument-hint: "[limit]"
---

# Next Issues

Fetch open GitHub issues and rank them by how effective they are to tackle next. Present a prioritised shortlist so the user can pick up work immediately.

## Steps

Follow these steps in order.

### 1. Determine the shortlist size

If `$ARGUMENTS` is a number, use it as the maximum number of issues to show. Default to **5**.

### 2. Fetch open issues

Run both commands in parallel:

```bash
# All open, unassigned issues (up to 50)
gh issue list --state open --assignee "" --limit 50 --json number,title,labels,milestone,createdAt,updatedAt,body,comments

# All open issues already assigned (to detect in-progress work)
gh issue list --state open --limit 50 --json number,title,assignees,labels
```

### 3. Score each issue

For each **unassigned** issue, compute a priority score using the signals below. Higher score = tackle sooner.

| Signal                                                                                          | Points        |
| ----------------------------------------------------------------------------------------------- | ------------- |
| Label `bug` or `fix`                                                                            | +4            |
| Label `enhancement` or `feat`                                                                   | +2            |
| Label `chore`, `refactor`, `docs`                                                               | +1            |
| Label `blocked` or `wont-fix`                                                                   | −10 (exclude) |
| Linked to a milestone                                                                           | +2            |
| Body contains clear Acceptance Criteria (`- [ ]`)                                               | +2            |
| Issue is older than 14 days (staleness penalty removed)                                         | +1            |
| Issue mentions another open issue it is **blocked by** (cross-ref `#N` in body where N is open) | −5            |
| Issue has 5+ comments (community interest)                                                      | +1            |

**Effort estimate** (lower is better, used as tiebreaker):

- "Work Required" list has ≤ 3 items → low effort (+1)
- "Work Required" list has 4–7 items → medium effort (0)
- "Work Required" list has 8+ items, or body mentions schema migration → high effort (−1)

Compute a final score per issue. Sort descending.

### 4. Present the ranked shortlist

Show a markdown table of the top N issues, with one sentence of reasoning per row:

```
## Recommended next issues

| # | Title | Score | Why now |
|---|-------|-------|---------|
| #123 | Add HSBC parser | 9 | Bug fix with clear ACs, no blockers, small scope |
| #87  | Export to CSV    | 7 | High-demand enhancement, milestone-linked |
...
```

Below the table, note any issues that were excluded (e.g. labelled `blocked`, or blocked by an open issue).

### 5. Offer to start work

Ask the user:

> "Which one would you like to start? I can kick off `/start-feature <number>` for you."

If the user picks one (by number or title), invoke the `start-feature` skill with that issue number.
