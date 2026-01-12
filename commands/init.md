---
description: Initialize CCA (Confucius Code Agent) in the current project. Sets up the notes system, language detection, and memory structure.
---

# Initialize CCA System

You are initializing the **Confucius Code Agent (CCA)** system in this project. Follow these steps:

## Step 1: Create CCA Directory Structure

Create the following directory structure:

```
.cca/
├── notes/              # Persistent knowledge base
│   └── .gitkeep
├── sessions/           # Session summaries (optional, gitignored)
│   └── .gitkeep
└── config.json         # CCA configuration
```

## Step 2: Detect Project Languages

Scan the project root for language indicators and create the config:

```json
{
  "version": "1.0.0",
  "initialized": "<current-date>",
  "languages": [],
  "noteCategories": ["Bug", "Pattern", "Architecture", "Gotcha", "Config", "API"],
  "autoDetect": true
}
```

Populate `languages` array based on detected files:
- `package.json` → add "typescript" or "javascript"
- `tsconfig.json` → add "typescript"
- `pyproject.toml` or `requirements.txt` → add "python"
- `Cargo.toml` → add "rust"
- `go.mod` → add "go"
- `*.csproj` or `*.sln` → add "csharp"
- `pom.xml` or `build.gradle` → add "java"

## Step 3: Create Initial Note Template

Create `.cca/notes/000-project-overview.md`:

```markdown
# [Architecture] Project Overview

**Date**: <current-date>
**Session**: Initial CCA setup
**Tags**: #overview #architecture #init

## Summary
<Brief description of what this project does - ask the user or infer from README>

## Tech Stack
- **Languages**: <detected languages>
- **Frameworks**: <detected frameworks>
- **Build Tools**: <detected build tools>

## Key Directories
- `src/` - <description>
- `tests/` - <description>
- <other important directories>

## Development Commands
- Build: `<command>`
- Test: `<command>`
- Lint: `<command>`

## Notes
- <Any initial observations about the codebase>
```

## Step 4: Update .gitignore

Add to `.gitignore` if not already present:
```
# CCA session data (personal, not shared)
.cca/sessions/
```

Note: `.cca/notes/` should be committed to share knowledge across the team.

## Step 5: Confirm Setup

After completing setup, provide a summary:

1. List detected languages
2. Show created directory structure
3. Explain how to use CCA commands:
   - `/cca:note` - Create a new note
   - `/cca:recall` - Search existing notes
   - `/cca:status` - View CCA state
   - `/cca:reflect` - Generate session learnings

Ask if the user wants to customize anything or add initial project context.
