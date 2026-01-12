---
description: Display current CCA status including detected languages, notes count, and session context.
---

# CCA Status Report

Generate a comprehensive status report of the CCA system in this project.

## Status Report Structure

### 1. System Status

Check CCA initialization:
```
🤖 CCA Status Report
═══════════════════════════════════════

📁 System Status: [Initialized ✓ / Not Initialized ✗]
   Location: .cca/
   Config: .cca/config.json [Found ✓ / Missing ✗]
```

If not initialized, suggest running `/cca:init`.

### 2. Language Detection

Show detected languages and their confidence:
```
🔤 Languages Detected:
   • TypeScript (package.json, tsconfig.json) ✓
   • Python (pyproject.toml) ✓
   
   Primary: TypeScript
   Package Manager: pnpm
```

### 3. Notes Summary

Summarize the knowledge base:
```
📚 Knowledge Base:
   Total Notes: 12
   
   By Category:
   • Bug: 4 notes
   • Pattern: 3 notes
   • Architecture: 2 notes
   • Gotcha: 2 notes
   • Config: 1 note
   
   Recent Notes:
   • [Bug] API Rate Limiting Edge Case (2 days ago)
   • [Pattern] Component State Management (5 days ago)
   • [Gotcha] ESM Import Gotcha (1 week ago)
```

### 4. Session Context

Show current working context:
```
🧠 Current Session:
   Working Directory: /path/to/project
   Git Branch: feature/user-auth
   Modified Files: 3
   
   Recent Focus:
   • src/auth/login.ts
   • src/api/users.ts
```

### 5. Memory State

Estimate context usage:
```
💾 Memory State:
   Loaded Notes: 2
   Session History: ~15,000 tokens (estimated)
   Compression: Not needed
   
   Tip: Use /cca:reflect to compress and summarize this session.
```

### 6. Recommendations

Provide actionable suggestions:
```
💡 Recommendations:
   • No notes exist for 'auth' - consider documenting patterns
   • 3 files modified without tests - run test suite
   • Session is long - consider /cca:reflect to capture learnings
```

## Quick Status (Short Form)

If context is limited, provide abbreviated status:
```
🤖 CCA: ✓ | 📚 12 notes | 🔤 TypeScript | 🌿 feature/user-auth
```

## Health Checks

Verify system integrity:
- [ ] `.cca/` directory exists
- [ ] `.cca/config.json` is valid JSON
- [ ] `.cca/notes/` is accessible
- [ ] At least one language detected
- [ ] No orphaned note references

Report any issues found.
