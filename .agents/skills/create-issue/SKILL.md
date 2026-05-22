---
name: create-issue
description: Draft and create a well-structured GitLab issue. Takes a description from arguments or prompts the user, scans the codebase for context, asks clarifying questions, then creates the issue with correct labels and body.
argument-hint: "[brief description of the issue]"
---

# Create Issue

Draft and file a GitLab issue. Gather context from the user and the codebase before writing anything.

## Steps

Follow these steps in order.

### 1. Gather the initial description

If `$ARGUMENTS` was provided, use it as the initial description.

If no arguments were given, ask the user:

> "What's the issue? Describe the problem, feature request, or task in as much detail as you have."

Wait for their response before continuing.

### 2. Determine the issue type

From the description, decide which type best fits:

| Type                    | Label                   | When to use                                 |
| ----------------------- | ----------------------- | ------------------------------------------- |
| Bug                     | `bug`                   | Something is broken or behaving incorrectly |
| Feature                 | `enhancement` or `feat` | New capability or user-facing change        |
| Chore / maintenance     | _(no label)_            | Tooling, dependencies, config               |
| Documentation           | `documentation`         | Docs only, no code change                   |
| Refactor                | `refactor`              | Internal restructure, no behaviour change   |
| Architecture / research | `architecture`          | Design decisions, spikes, ADRs              |

If the type is ambiguous, ask the user before continuing.

### 3. Scan the codebase for context

Do a **lightweight scan** — enough to understand what already exists, not a full audit. Focus on:

- The area of the codebase most relevant to the issue
- Relevant existing services, components, or tests — skim file names and top-level exports rather than reading every line
- Related issues or recent commits if the description references them

Use `glab issue list --state opened --search "<keyword>"` to check for duplicates or related prior work.

Do **not** do a full codebase exploration. Read 3–6 files at most. The goal is enough context to write a useful, specific issue — not to plan the implementation.

### 4. Ask clarifying questions (if needed)

If, after scanning, there are gaps that would make the issue ambiguous or hard to act on, ask the user targeted questions. Examples:

- "Is this affecting all users or a specific subset?"
- "Should this be a new page or extend an existing one?"
- "Do you have a preferred approach in mind, or is that open?"
- "Are there related issues this depends on or blocks?"

Only ask questions that genuinely change what goes in the issue. Keep it to 1–3 questions max. If the issue is clear enough, skip this step.

### 5. Draft the issue

Write a complete issue using the appropriate template below.

**For bugs:**

```markdown
## Bug

<one-paragraph description of the wrong behaviour>

## Root Cause

<what you found in the codebase that explains why this happens, or "Unknown — needs investigation" if unclear>

## Proposed Fix

<concrete suggestion, or leave blank if this is purely a bug report>

## Files

- `<path>` — <why it's relevant>

## Acceptance Criteria

- [ ] <observable outcome 1>
- [ ] <observable outcome 2>
```

**For features / enhancements:**

```markdown
## Problem / Motivation

<why this is needed; what the user cannot do today>

## Proposed Solution

<what the feature does; how it fits into the existing app>

## Work Required

- <task 1>
- <task 2>

## Files

- `<path>` — <why it's relevant>

## Acceptance Criteria

- [ ] <observable outcome 1>
- [ ] <observable outcome 2>
```

**For documentation, refactors, architecture, chores:**

```markdown
## Context

<why this work is needed now>

## Work Required

1. <step 1>
2. <step 2>

## Related

- #<number> — <how it relates>

## Acceptance Criteria

- [ ] <outcome 1>
- [ ] <outcome 2>
```

Rules for a good issue body:

- Be specific: name the files, functions, or components involved where known
- Acceptance criteria must be checkboxes and must be observable/testable
- Do not pad with unnecessary sections — omit a section if it adds nothing
- Do not include implementation details that belong in an MR, not an issue

### 6. Show the draft to the user

Present the full draft — title, labels, and body — and ask:

> "Does this look right, or would you like to change anything before I file it?"

Incorporate any feedback. Once the user approves (or says "looks good", "yes", "ship it", etc.), proceed.

### 7. Create the issue

```bash
glab issue create \
  --title "<title>" \
  --label "<label>" \
  --description "$(cat <<'EOF'
<body>
EOF
)"
```

If no label fits, omit `--label`.

Report the issue URL and number to the user.

### 8. Offer to start work

Ask:

> "Want me to start work on this now with `/start-issue <number>`?"

If the user says yes, invoke the `start-issue` skill with the new issue number.
