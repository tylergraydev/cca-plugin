# CCA - Confucius Code Agent Plugin for Claude Code

🤖 **An AI software engineering system with hierarchical memory, persistent note-taking, and language-agnostic tooling.**

Inspired by [Meta/Harvard's Confucius Code Agent research](https://arxiv.org/abs/2512.10398), this plugin brings industrial-scale AI coding practices to your Claude Code workflow.

## ✨ Features

### 🧠 Hierarchical Memory System
- Structured context management with session/task/file scopes
- Automatic context compression for long sessions
- Cross-session knowledge persistence

### 📚 Persistent Note-Taking
- Capture bugs, patterns, architecture decisions, and gotchas
- Searchable knowledge base in `.cca/notes/`
- Automatic note suggestions when significant learnings occur

### 🔤 Language-Agnostic Design
- Auto-detects project languages (TypeScript, Python, Rust, Go, C#, Java)
- Loads language-specific context and commands
- Works seamlessly in polyglot projects

### 🔄 Build-Test-Improve Loop
- Systematic approach to every code change
- Language-appropriate testing and linting
- Automatic post-edit formatting

## 📦 Installation

### Option 1: Install from Marketplace (Recommended)
```bash
# Add the marketplace first
/plugin marketplace add your-username/cca-plugin

# Install the plugin
/plugin install cca
```

### Option 2: Install from Local Directory
```bash
# Clone the plugin
git clone https://github.com/your-username/cca-plugin ~/.claude/plugins/cca-plugin

# Install via Claude Code
/plugin install --local ~/.claude/plugins/cca-plugin
```

### Option 3: Manual Installation
Copy the entire `cca-plugin/` directory to your Claude Code plugins location.

## 🚀 Quick Start

### 1. Initialize CCA in Your Project
```
/cca:init
```

This creates:
```
.cca/
├── notes/              # Your knowledge base
├── sessions/           # Session summaries (gitignored)
└── config.json         # CCA configuration
```

### 2. Start Coding!
CCA automatically:
- Loads existing notes at session start
- Detects your project's languages
- Applies language-specific context

### 3. Capture Learnings
```
/cca:note Fixed a tricky race condition in the auth module
```

### 4. Recall Knowledge
```
/cca:recall auth
/cca:recall race condition
```

### 5. End-of-Session Reflection
```
/cca:reflect
```

## 📋 Commands

| Command | Description |
|---------|-------------|
| `/cca:init` | Initialize CCA in current project |
| `/cca:note [topic]` | Create a new note from current context |
| `/cca:recall [search]` | Search and load relevant notes |
| `/cca:status` | Show CCA state, notes count, languages |
| `/cca:reflect` | Analyze session and extract learnings |
| `/cca:lang [language]` | Show/set language context |

## 🤖 Agents

### Debug Agent
Systematic debugging with automatic learning capture:
```
Use the cca-debug agent to help me fix this issue
```

### Review Agent
Code review with project-specific pattern awareness:
```
Use the cca-review agent to review my changes
```

## 📁 Note Categories

| Category | Use For |
|----------|---------|
| `[Bug]` | Bug fixes and root causes |
| `[Pattern]` | Code patterns in this codebase |
| `[Architecture]` | Structural decisions |
| `[Gotcha]` | Non-obvious behaviors |
| `[Config]` | Build/deploy configurations |
| `[API]` | External API behaviors |

## 🔧 Configuration

Edit `.cca/config.json`:

```json
{
  "version": "1.0.0",
  "languages": ["typescript", "python"],
  "noteCategories": ["Bug", "Pattern", "Architecture", "Gotcha", "Config", "API"],
  "autoDetect": true,
  "autoFormat": true
}
```

## 🌐 Supported Languages

| Language | Detection Files | Features |
|----------|-----------------|----------|
| TypeScript/JS | `package.json`, `tsconfig.json` | Full support |
| Python | `pyproject.toml`, `requirements.txt` | Full support |
| Rust | `Cargo.toml` | Full support |
| Go | `go.mod` | Full support |
| C#/.NET | `*.csproj`, `*.sln` | Full support |
| Java | `pom.xml`, `build.gradle` | Basic support |
| Ruby | `Gemfile` | Basic support |

## 🔄 The Three-Axis Philosophy

CCA is built on three complementary perspectives:

### Agent Experience (AX)
- Structured context for efficient reasoning
- Noise reduction and information distillation
- Hierarchical memory scopes

### User Experience (UX)
- Clear, readable outputs
- Progress communication
- Actionable error explanations

### Developer Experience (DX)
- Observable decision traces
- Modular, composable actions
- Reproducible workflows

## 📖 How Notes Work

### Creating Notes
Notes are created in `.cca/notes/` with this structure:

```markdown
# [Category] Brief Title

**Date**: 2024-01-15
**Session**: What we were working on
**Tags**: #auth #async #race-condition

## Summary
One paragraph capturing the key insight.

## Details
- Problem description
- Approach taken
- Outcome

## Code References
- `src/auth/token.ts:42` - Where the fix was applied

## Lessons Learned
- Generalizable takeaways
```

### Automatic Note Suggestions
CCA suggests creating notes when:
- A bug is fixed after significant debugging
- An unexpected behavior is discovered
- A workaround is implemented
- An external API behaves unexpectedly

## 🤝 Team Usage

### Sharing Knowledge
The `.cca/notes/` directory should be committed to git:
- Team members benefit from shared learnings
- Institutional knowledge is preserved
- Onboarding becomes easier

### Session Data
`.cca/sessions/` is gitignored by default:
- Personal session summaries stay local
- No noise in version control

## 🛠 Extending CCA

### Adding Custom Note Categories
Edit `.cca/config.json`:
```json
{
  "noteCategories": ["Bug", "Pattern", "Architecture", "Gotcha", "Config", "API", "Security", "Performance"]
}
```

### Custom Language Support
Create a skill file in the plugin's `skills/` directory following the existing patterns.

## 📚 Resources

- [Confucius Code Agent Paper](https://arxiv.org/abs/2512.10398)
- [Claude Code Plugins Documentation](https://code.claude.com/docs/en/plugins)
- [Claude Code Hooks Reference](https://code.claude.com/docs/en/hooks)

## 📄 License

MIT License - See [LICENSE](LICENSE) file.

---

Built with 💜 for developers who want their AI assistant to learn and grow with them.
