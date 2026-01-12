# CCA - Confucius Code Agent Plugin

🤖 **Set it and forget it.** CCA automatically manages memory, creates notes, and learns from your coding sessions.

---

## ⚡ Quick Start

```bash
# 1. Install the plugin (one time)
/plugin install --local /path/to/cca-plugin

# 2. Initialize in your project
/cca:init

# 3. That's it! Just code normally.
```

---

## 🔄 What Happens Automatically

Once initialized, CCA runs in the background:

| Event | CCA Does |
|-------|----------|
| **Session starts** | Loads your notes, detects language, shows context |
| **You edit a file** | Auto-formats based on language |
| **You fix a bug** | Offers to save it as a note |
| **You discover a pattern** | Suggests documenting it |
| **Session runs long** | Reminds you to reflect/summarize |

### Example Flow

```
You: "This auth bug is driving me crazy"

Claude: [investigates, finds the issue]

Claude: ✅ Fixed! The race condition was in tokenRefresh().

        💡 CCA: That was tricky! Save as note for future reference?
           → /cca:note [Bug] Token refresh race condition

You: "yes"

Claude: [creates note in .cca/notes/003-token-refresh-race.md]
        ✨ Note saved! This will help next time.
```

---

## 📁 What Gets Created

```
your-project/
├── .cca/
│   ├── config.json      # Settings (customize behavior)
│   ├── notes/           # 📚 Your knowledge base
│   │   ├── 001-auth-patterns.md
│   │   ├── 002-api-gotchas.md
│   │   └── ...
│   └── sessions/        # Auto-generated (gitignored)
```

**Commit `.cca/notes/`** → Share knowledge with your team!

---

## 🎮 Manual Commands (When Needed)

| Command | Use |
|---------|-----|
| `/cca:init` | Initialize CCA in a project |
| `/cca:note [topic]` | Force create a note now |
| `/cca:recall [search]` | Search your notes |
| `/cca:status` | Check CCA state |
| `/cca:reflect` | Summarize session & extract learnings |
| `/cca:lang` | Check/change language focus |

---

## 🔤 Supported Languages

Auto-detected and applied:
- TypeScript / JavaScript
- Python
- Rust
- Go
- C# / .NET
- Java / Kotlin

---

## ⚙️ Configuration

Edit `.cca/config.json`:

```json
{
  "autoNotes": {
    "enabled": true,
    "askBeforeCreating": true
  },
  "autoFormat": {
    "enabled": true
  }
}
```

Set `"askBeforeCreating": false` for fully automatic notes.

---

## 📖 Full Documentation

See [USAGE.md](USAGE.md) for complete details on:
- How auto-notes work
- All hook behaviors  
- Configuration options
- Tips for best results

---

## 🧠 The Philosophy

> **You focus on coding. CCA focuses on remembering.**

Every bug you fix becomes searchable knowledge. Every pattern you discover is preserved. Your project's institutional memory grows automatically.

---

## 📄 License

MIT - See [LICENSE](LICENSE)
