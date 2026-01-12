---
description: Display detected languages and load language-specific context. Usage: /cca:lang [language to focus]
---

# CCA Language Context

Display detected languages and optionally load specific language context: **$ARGUMENTS**

## Language Detection Report

### Step 1: Scan Project

Detect all languages by scanning for indicator files:

```
🔤 Language Detection Report
═══════════════════════════════════════

Detected Languages:
┌─────────────────┬──────────────────────────────┬──────────┐
│ Language        │ Indicators                    │ Primary  │
├─────────────────┼──────────────────────────────┼──────────┤
│ TypeScript      │ tsconfig.json, *.ts files    │ ✓        │
│ JavaScript      │ package.json, *.js files     │          │
│ Python          │ pyproject.toml               │          │
│ CSS             │ *.css, tailwind.config.js    │          │
└─────────────────┴──────────────────────────────┴──────────┘

Primary Language: TypeScript
   Based on: Most source files (.ts), tsconfig.json present
```

### Step 2: Framework Detection

Identify frameworks within each language:

```
📦 Frameworks & Tools:

TypeScript/JavaScript:
• React 18.2.0 (dependencies)
• Next.js 14.0.0 (next.config.js)
• Tailwind CSS (tailwind.config.js)
• Jest (jest.config.js)

Python:
• FastAPI (pyproject.toml dependencies)
• Pytest (dev dependencies)
```

### Step 3: Build Tool Detection

```
🔧 Build & Package Tools:

Package Manager: pnpm (pnpm-lock.yaml)
Build Tool: Next.js built-in (next build)
Test Runner: Jest
Linter: ESLint (.eslintrc.js)
Formatter: Prettier (.prettierrc)
```

### Step 4: Load Language Context

If a specific language is requested (`$ARGUMENTS`), load its full context:

```
📖 Loading TypeScript Context...

## Build-Test-Improve Commands

### Build
npm run build          # or: pnpm build
npx tsc --noEmit       # Type check only

### Test
npm test               # or: pnpm test
npx jest --watch       # Watch mode

### Lint/Format
npm run lint           # or: pnpm lint
npx prettier --write . # Format all

## Project-Specific Notes

This project uses:
• Path aliases (@/* → src/*)
• Strict TypeScript mode
• ESM modules ("type": "module")

## Loaded CCA Notes
• [Pattern] Component Props Pattern (003-...)
• [Gotcha] Next.js App Router Caching (007-...)
```

### Step 5: Multi-Language Projects

For polyglot projects, provide guidance:

```
🌐 Multi-Language Project Detected

This project uses multiple languages:
• TypeScript (frontend) - src/web/
• Python (backend) - src/api/
• SQL (database) - migrations/

Recommendation:
When working in a specific area, let me know which language
context to prioritize. Example: "focus on Python API work"

Current Focus: TypeScript (based on recent file access)
Change focus: /cca:lang python
```

## Language-Specific Quick Reference

Show most relevant commands for detected language:

```
⚡ Quick Reference (TypeScript)

Build:    pnpm build
Test:     pnpm test  
Lint:     pnpm lint
Format:   pnpm format
Types:    pnpm typecheck

Common Tasks:
• Add dependency: pnpm add <package>
• Dev dependency: pnpm add -D <package>
• Update all: pnpm update
```

## If Language Not Detected

If no languages detected or CCA not initialized:

```
⚠️ No languages detected.

Possible reasons:
1. CCA not initialized - run /cca:init
2. Empty project directory
3. Non-standard project structure

To manually specify: /cca:lang typescript
```
