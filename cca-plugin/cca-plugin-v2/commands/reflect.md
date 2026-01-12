---
description: Analyze the current session, extract learnings, and optionally create notes. Use at the end of sessions or after significant work.
---

# CCA Session Reflection

Analyze the current session to extract learnings, compress context, and capture valuable knowledge.

## Reflection Process

### Step 1: Session Analysis

Review the conversation history and identify:

1. **Tasks Completed**
   - What was accomplished?
   - What files were modified?
   - What problems were solved?

2. **Challenges Encountered**
   - What was difficult?
   - What took multiple attempts?
   - What unexpected behaviors occurred?

3. **Discoveries Made**
   - What new things were learned about the codebase?
   - What patterns or conventions were identified?
   - What gotchas were discovered?

4. **Decisions Made**
   - What architectural choices were made?
   - What tradeoffs were considered?
   - What was the rationale?

### Step 2: Generate Session Summary

Create a structured summary:

```markdown
## 📋 Session Summary

### Completed
- ✅ Implemented user authentication flow
- ✅ Fixed race condition in token refresh
- ✅ Added error handling to API client

### In Progress
- 🔄 Unit tests for auth module (70% complete)

### Pending
- ⏳ Integration tests
- ⏳ Documentation update

### Key Decisions
- Used JWT with refresh tokens (vs session cookies)
- Implemented retry logic with exponential backoff

### Files Modified
- `src/auth/login.ts` - New auth flow
- `src/api/client.ts` - Error handling
- `src/types/auth.ts` - New types
```

### Step 3: Extract Note Candidates

Identify potential notes:

```
📝 Potential Notes to Create:

1. **[Bug] Token Refresh Race Condition**
   You solved a tricky race condition where multiple components...
   → Would you like to create this note?

2. **[Pattern] API Error Handling**
   You established a pattern for handling API errors with...
   → Would you like to create this note?

3. **[Gotcha] JWT Expiry Edge Case**
   Discovered that JWT expiry checks need to account for...
   → Would you like to create this note?
```

### Step 4: Context Compression (Optional)

If session is long, offer to compress:

```
💾 Session Compression

This session has ~25,000 tokens of history.
I can compress this to ~5,000 tokens while preserving:
- Key decisions and rationale
- Important code snippets
- Error solutions
- Pending items

Proceed with compression? (This helps with context limits in long sessions)
```

### Step 5: Save Session Summary (Optional)

Offer to save a session record:

```markdown
# Session: 2024-01-15 - User Auth Implementation

## Duration: ~2 hours
## Branch: feature/user-auth

### Summary
Implemented complete user authentication flow including login, logout,
and token refresh. Fixed a race condition in concurrent refresh requests.

### Notes Created
- 001-token-refresh-race-condition.md
- 002-api-error-handling-pattern.md

### Next Session
- Complete unit tests for auth module
- Add integration tests
- Update API documentation
```

Save to: `.cca/sessions/2024-01-15-user-auth.md`

## Reflection Triggers

Consider suggesting reflection when:
- Session has been running for 1+ hours
- Multiple significant changes completed
- Before switching to a different feature area
- User explicitly asks "what did we do?"
- Context is approaching compression threshold

## Quick Reflect

For shorter summary, output:

```
📋 Quick Reflect:
• Completed: Auth flow, token refresh fix
• Learned: JWT edge cases with clock skew
• Pending: Tests, docs
• Suggest note: Token refresh race condition

Full reflect? Use /cca:reflect
```
