---
description: Search and recall relevant CCA notes from the knowledge base. Usage: /cca:recall [search terms or topic]
---

# Recall CCA Notes

Search the `.cca/notes/` knowledge base for relevant information: **$ARGUMENTS**

## Recall Process

### Step 1: Load Note Index

Read all files in `.cca/notes/` and build an index:
- Parse frontmatter/headers for categories and tags
- Extract summaries (first paragraph after ## Summary)
- Note file paths for reference

### Step 2: Search Strategy

If search terms provided (`$ARGUMENTS`), search by:

1. **Exact matches** in:
   - Note titles
   - Tags
   - Category names

2. **Semantic matches** in:
   - Summary sections
   - Code references (file paths)
   - Lessons learned

3. **Related concepts**:
   - Similar technologies
   - Related problem domains

### Step 3: Present Results

Show matching notes in relevance order:

```
📚 Found N relevant notes:

1. **[Bug] Auth Token Refresh Race Condition** (001-auth-token-...)
   Tags: #auth #async #race-condition
   > When multiple components request token refresh simultaneously...
   
2. **[Pattern] API Error Handling Convention** (005-api-error-...)
   Tags: #api #errors #patterns
   > This codebase uses a Result type pattern for all API calls...

Would you like me to load the full content of any of these notes?
```

### Step 4: Load Full Notes

When user requests, display the full note content and:
- Highlight the most relevant sections
- Suggest how this knowledge applies to the current task
- Offer to update the note if new information was discovered

## Smart Recall Triggers

Automatically suggest recall when:
- Working on a file mentioned in existing notes
- Encountering an error type documented before
- User mentions a topic that has related notes
- Starting work on a feature area with existing documentation

## If No Search Terms

If `$ARGUMENTS` is empty:

1. **Context-aware suggestions**: Look at current files/task and suggest relevant notes
2. **Recent notes**: Show the 5 most recently created/modified notes
3. **Category browse**: Offer to list notes by category

```
📚 No search terms provided. Here are your options:

Recent Notes:
- [Bug] WebSocket Reconnection Logic (2 days ago)
- [Gotcha] Next.js Middleware Edge Runtime (5 days ago)

Browse by Category:
- Bug (3 notes)
- Pattern (7 notes)
- Architecture (2 notes)
- Gotcha (4 notes)

Or tell me what you're working on and I'll find relevant notes.
```

## Index Maintenance

If notes directory is large (>20 notes), suggest:
- Creating a `_index.md` summary file
- Archiving old notes to `.cca/notes/archive/`
- Consolidating related notes
