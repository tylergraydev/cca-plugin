---
name: cca-typescript
description: CCA language context for TypeScript/JavaScript projects. Auto-loaded when package.json or tsconfig.json is detected.
---

# CCA: TypeScript/JavaScript Context

## Language Detection
This context applies when any of these files exist:
- `package.json`
- `tsconfig.json`
- `jsconfig.json`
- `*.ts`, `*.tsx`, `*.js`, `*.jsx` files

## Build-Test-Improve Commands

### Build
```bash
# Type checking
npx tsc --noEmit

# Build (if configured)
npm run build
```

### Test
```bash
# Jest
npm test
npx jest --watch

# Vitest
npm test
npx vitest run

# Specific file
npx jest path/to/file.test.ts
```

### Lint/Format
```bash
# ESLint
npx eslint . --fix

# Prettier
npx prettier --write .

# Biome
npx biome check --apply .
```

## Common Patterns

### Error Handling
```typescript
// Prefer Result types or explicit error handling
try {
  const result = await riskyOperation();
  return { success: true, data: result };
} catch (error) {
  console.error('Operation failed:', error);
  return { success: false, error: error instanceof Error ? error.message : 'Unknown error' };
}
```

### Type Safety
```typescript
// Use strict types, avoid 'any'
interface User {
  id: string;
  name: string;
  email: string;
}

// Use type guards
function isUser(obj: unknown): obj is User {
  return typeof obj === 'object' && obj !== null && 'id' in obj;
}
```

### Async Patterns
```typescript
// Prefer async/await over .then()
// Handle errors explicitly
// Use Promise.all for concurrent operations
const [users, posts] = await Promise.all([
  fetchUsers(),
  fetchPosts()
]);
```

## Project Structure Conventions

```
src/
├── components/     # React/Vue components
├── hooks/          # Custom hooks
├── services/       # API/business logic
├── utils/          # Pure utility functions
├── types/          # TypeScript type definitions
└── __tests__/      # Test files (or colocated .test.ts)
```

## Package Manager Detection
- `pnpm-lock.yaml` → Use `pnpm`
- `yarn.lock` → Use `yarn`
- `package-lock.json` → Use `npm`
- `bun.lockb` → Use `bun`

## Common Gotchas
- Check `"type": "module"` in package.json for ESM vs CJS
- tsconfig `paths` need corresponding bundler config
- React 18+ uses automatic JSX transform (no import React needed)
- Next.js App Router vs Pages Router have different conventions
