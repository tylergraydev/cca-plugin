# CCA Plugin - Usage Guide

## 🎯 Philosophy: Set It and Forget It

The CCA plugin is designed to work **automatically in the background**. Once initialized, you shouldn't need to think about it - just code naturally and CCA handles:

- ✅ Loading project context on session start
- ✅ Detecting your language and applying best practices
- ✅ Auto-formatting files after edits
- ✅ **Auto-creating notes** when you solve bugs or discover patterns
- ✅ Compressing context when sessions get long
- ✅ Saving session summaries automatically

---

## 🚀 One-Time Setup (Per Project)

### Step 1: Install the Plugin (Once)
```bash
# In Claude Code
/plugin install --local /path/to/cca-plugin
```

### Step 2: Initialize in Your Project
```bash
# Navigate to your project, then:
/cca:init
```

That's it! CCA is now active.

---

## 🔄 What Happens Automatically

### On Every Session Start
When you open Claude Code in a project with CCA:

```
🤖 CCA Active
📚 Notes: 5 | 🔤 TypeScript | 🌿 main
Loading context from .cca/notes/...
```

**Automated actions:**
1. Loads all notes from `.cca/notes/`
2. Detects project language(s)
3. Shows git branch and status
4. Applies language-specific context

### During Your Session

**Auto-formatting (after every edit):**
- TypeScript/JS → Prettier
- Python → Ruff/Black
- Go → gofmt
- Rust → rustfmt
- C# → dotnet format

**Auto-note detection (monitors for):**
- Bug fixes after debugging
- Error resolutions
- Pattern discoveries
- Workarounds implemented

When detected, CCA will say:
```
💡 CCA Note Suggestion: You just solved a tricky issue with [X].
   Should I save this as a note for future reference? (y/n)
```

### On Session End / Long Sessions

**Auto-compression:**
When context gets large (~20k+ tokens), CCA automatically:
1. Summarizes completed work
2. Preserves key decisions and code
3. Maintains continuity for your task

**Session summary (optional prompt):**
```
📋 Session winding down. Would you like me to:
   1. Save a session summary
   2. Create notes for learnings
   3. Just end (nothing saved)
```

---

## 📝 How Auto-Notes Work

### Trigger Conditions
CCA watches for these patterns and offers to create notes:

| Trigger | Note Type | Example |
|---------|-----------|---------|
| Multiple failed attempts → success | `[Bug]` | Debugging a race condition |
| "Turns out..." or "The issue was..." | `[Bug]` | Root cause discovery |
| "This codebase uses..." | `[Pattern]` | Convention discovery |
| "Workaround:" or "Hack:" | `[Gotcha]` | Non-obvious solutions |
| Config file changes after troubleshooting | `[Config]` | Build/deploy fixes |
| External API unexpected behavior | `[API]` | Third-party quirks |

### Auto-Note Format
Notes are saved to `.cca/notes/NNN-title.md`:

```markdown
# [Bug] Token Refresh Race Condition

**Date**: 2024-01-15
**Session**: User authentication implementation
**Tags**: #auth #async #race-condition
**Auto-generated**: true

## Summary
Multiple components calling refreshToken() simultaneously caused duplicate
refresh requests. Fixed by adding a mutex lock.

## Context
- File: src/auth/tokenManager.ts
- Related: src/api/client.ts

## Solution
Added a promise-based lock to ensure only one refresh runs at a time.

## Code
```typescript
private refreshPromise: Promise<Token> | null = null;

async refreshToken() {
  if (this.refreshPromise) return this.refreshPromise;
  this.refreshPromise = this.doRefresh();
  // ...
}
```
```

---

## 🎮 Manual Commands (When You Need Them)

While CCA is mostly automatic, you have manual controls:

| Command | When to Use |
|---------|-------------|
| `/cca:note [topic]` | Force create a note right now |
| `/cca:recall [search]` | Search your notes |
| `/cca:status` | Check CCA state |
| `/cca:reflect` | Force session summary |
| `/cca:lang` | Check/change language focus |

---

## 📁 Project Structure Created

```
your-project/
├── .cca/
│   ├── config.json          # CCA settings
│   ├── notes/               # 📚 Your knowledge base (commit this!)
│   │   ├── 000-project-overview.md
│   │   ├── 001-auth-bug-fix.md
│   │   └── ...
│   └── sessions/            # Session logs (gitignored)
│       └── 2024-01-15-auth-work.md
└── ... your code ...
```

### What to Commit
- ✅ `.cca/notes/` - Share knowledge with your team
- ❌ `.cca/sessions/` - Personal, auto-gitignored

---

## ⚙️ Configuration

Edit `.cca/config.json` to customize:

```json
{
  "version": "1.0.0",
  "autoNotes": {
    "enabled": true,
    "askBeforeCreating": true,    // false = fully automatic
    "minDebugAttempts": 2         // Attempts before suggesting bug note
  },
  "autoFormat": {
    "enabled": true,
    "languages": ["typescript", "python", "go", "rust"]
  },
  "sessionManagement": {
    "autoCompress": true,
    "compressThreshold": 20000,   // tokens
    "autoSaveSummary": false      // true = save without asking
  },
  "languages": ["typescript"],    // Auto-detected, but can override
  "noteCategories": ["Bug", "Pattern", "Architecture", "Gotcha", "Config", "API"]
}
```

---

## 🔧 Hooks Reference

These run automatically - you don't need to do anything:

### SessionStart
- Runs when you start Claude Code
- Loads notes, detects language, shows status

### PostToolUse (Edit/Write)
- Runs after any file edit
- Auto-formats based on file type
- Checks for note-worthy patterns

### Stop (Session End)
- Runs when Claude finishes a response cycle
- Monitors for long sessions
- Offers reflection prompts

### UserPromptSubmit
- Runs when you send a message
- Adds relevant notes to context
- Detects if you're in debugging mode

---

## 💡 Tips for Best Results

### 1. Let CCA Learn
The more you use it, the better your notes become. After a few sessions, you'll have a rich knowledge base that makes future debugging faster.

### 2. Commit Your Notes
Push `.cca/notes/` to git. Your future self (and teammates) will thank you.

### 3. Trust the Automation
Don't micromanage CCA. Let it:
- Suggest notes (you can always decline)
- Format your code
- Compress long sessions

### 4. Use Natural Language
When debugging, say things like:
- "The issue was..." → Triggers note suggestion
- "I found that this codebase..." → Pattern detection
- "Weird - the API returns..." → API quirk detection

---

## 🆘 Troubleshooting

### CCA not loading?
```bash
/cca:status  # Check if initialized
/cca:init    # Re-initialize if needed
```

### Notes not being suggested?
Check `.cca/config.json`:
```json
{ "autoNotes": { "enabled": true } }
```

### Formatting not working?
Ensure formatters are installed:
- TypeScript: `npm install -D prettier`
- Python: `pip install ruff` or `pip install black`
- etc.

---

## 🤝 The CCA Promise

> "You focus on coding. CCA focuses on remembering."

Every bug you fix, pattern you discover, and gotcha you encounter becomes part of your project's institutional knowledge - automatically, without breaking your flow.
