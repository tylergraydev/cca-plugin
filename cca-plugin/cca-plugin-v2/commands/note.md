---
description: Create a new CCA note to capture learnings, patterns, or important discoveries. Usage: /cca:note [optional topic]
---

# Create CCA Note

Create a persistent note in `.cca/notes/` based on the current context or specified topic: **$ARGUMENTS**

## Note Creation Process

### Step 1: Determine Note Type

Based on the context or user input, categorize the note:

| Category | Use When |
|----------|----------|
| `[Bug]` | Documenting a bug fix and its root cause |
| `[Pattern]` | Recording a code pattern found in this codebase |
| `[Architecture]` | Capturing structural decisions or system design |
| `[Gotcha]` | Non-obvious behaviors or pitfalls discovered |
| `[Config]` | Build, deploy, or environment configurations |
| `[API]` | External API behaviors, quirks, or usage notes |

### Step 2: Generate Note Content

Create the note with this structure:

```markdown
# [Category] Descriptive Title

**Date**: YYYY-MM-DD
**Session**: Brief context of what we were working on
**Tags**: #tag1 #tag2 #tag3

## Summary
One paragraph capturing the key insight in a way that would help future you (or a teammate) quickly understand the point.

## Details
- What was the problem or task?
- What approach was taken?
- What was the outcome?

## Code References
- `path/to/relevant/file.ts:42` - Brief description
- `another/file.py` - Why it's relevant

## Lessons Learned
- Key takeaway that applies beyond this specific instance
- Another generalizable insight
```

### Step 3: Generate Filename

Use format: `NNN-short-kebab-case-title.md`

- `NNN` = Next sequential number (check existing files)
- Keep filename under 50 characters
- Use lowercase kebab-case

Examples:
- `001-auth-token-refresh-race-condition.md`
- `002-prisma-connection-pooling.md`
- `003-nextjs-app-router-caching.md`

### Step 4: Verify Content

Before saving, confirm with the user:
1. Show the proposed note content
2. Ask if they want to modify anything
3. Confirm the category and tags are appropriate

### Step 5: Save and Confirm

1. Save to `.cca/notes/<filename>.md`
2. Confirm creation with path
3. Suggest related notes if any exist

## Auto-Note Triggers

Consider proactively suggesting a note when:
- A bug is fixed after significant debugging
- An unexpected behavior is discovered
- A workaround is implemented
- Configuration took multiple attempts
- External API behaved differently than documented

## If No Topic Provided

If `$ARGUMENTS` is empty, analyze recent conversation to:
1. Identify the most note-worthy discovery or learning
2. Suggest a note topic to the user
3. Proceed with their confirmation
