---
name: cca-vercel
description: CCA knowledge for Vercel deployments. Auto-loaded when vercel.json exists or Next.js/frontend projects are detected.
---

# CCA: Vercel Context

## Detection
This context applies when:
- `vercel.json` exists
- `next.config.js` or `next.config.mjs` exists
- `.vercel/` directory exists

## CLI Commands

### Basic Commands
```bash
# Login
vercel login

# Deploy (preview)
vercel

# Deploy to production
vercel --prod

# Link to existing project
vercel link

# Pull environment variables
vercel env pull .env.local

# List deployments
vercel ls

# Inspect a deployment
vercel inspect <deployment-url>

# View logs
vercel logs <deployment-url>

# Rollback
vercel rollback <deployment-url>
```

### Environment Variables
```bash
# Add env var
vercel env add VARIABLE_NAME

# Add for specific environment
vercel env add VARIABLE_NAME production
vercel env add VARIABLE_NAME preview
vercel env add VARIABLE_NAME development

# List env vars
vercel env ls

# Remove env var
vercel env rm VARIABLE_NAME

# Pull all env vars to local file
vercel env pull .env.local
```

### Domain Management
```bash
# Add domain
vercel domains add example.com

# List domains
vercel domains ls

# Inspect domain
vercel domains inspect example.com

# Remove domain
vercel domains rm example.com
```

## vercel.json Configuration

### Basic Configuration
```json
{
  "version": 2,
  "name": "my-project",
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "installCommand": "npm install",
  "framework": "nextjs"
}
```

### Redirects & Rewrites
```json
{
  "redirects": [
    {
      "source": "/old-page",
      "destination": "/new-page",
      "permanent": true
    },
    {
      "source": "/blog/:slug",
      "destination": "/posts/:slug",
      "permanent": false
    }
  ],
  "rewrites": [
    {
      "source": "/api/:path*",
      "destination": "https://api.example.com/:path*"
    },
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### Headers
```json
{
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        { "key": "Access-Control-Allow-Origin", "value": "*" },
        { "key": "Cache-Control", "value": "no-store" }
      ]
    },
    {
      "source": "/static/(.*)",
      "headers": [
        { "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }
      ]
    }
  ]
}
```

### Functions Configuration
```json
{
  "functions": {
    "api/**/*.ts": {
      "memory": 1024,
      "maxDuration": 30
    },
    "api/heavy-task.ts": {
      "memory": 3008,
      "maxDuration": 60
    }
  }
}
```

### Cron Jobs
```json
{
  "crons": [
    {
      "path": "/api/cron/daily-cleanup",
      "schedule": "0 0 * * *"
    },
    {
      "path": "/api/cron/hourly-sync",
      "schedule": "0 * * * *"
    }
  ]
}
```

## Next.js on Vercel

### next.config.js Optimizations
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Image optimization
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**.example.com',
      },
    ],
  },
  
  // Headers
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          { key: 'X-Frame-Options', value: 'DENY' },
        ],
      },
    ];
  },
  
  // Redirects
  async redirects() {
    return [
      {
        source: '/old',
        destination: '/new',
        permanent: true,
      },
    ];
  },
};

module.exports = nextConfig;
```

### API Routes (App Router)
```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  const users = await getUsers();
  return NextResponse.json(users);
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const user = await createUser(body);
  return NextResponse.json(user, { status: 201 });
}

// Configure edge runtime
export const runtime = 'edge';

// Configure max duration (Vercel)
export const maxDuration = 30;
```

### Middleware
```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Auth check
  const token = request.cookies.get('token');
  if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  // Add headers
  const response = NextResponse.next();
  response.headers.set('x-custom-header', 'value');
  return response;
}

export const config = {
  matcher: ['/dashboard/:path*', '/api/:path*'],
};
```

## Edge Functions

### Edge Config
```typescript
import { get } from '@vercel/edge-config';

export const config = { runtime: 'edge' };

export default async function handler() {
  const featureFlag = await get('feature-enabled');
  return new Response(JSON.stringify({ enabled: featureFlag }));
}
```

### KV Storage
```typescript
import { kv } from '@vercel/kv';

export async function GET() {
  const value = await kv.get('my-key');
  return Response.json({ value });
}

export async function POST(request: Request) {
  const { key, value } = await request.json();
  await kv.set(key, value);
  return Response.json({ success: true });
}
```

### Blob Storage
```typescript
import { put, list, del } from '@vercel/blob';

export async function POST(request: Request) {
  const form = await request.formData();
  const file = form.get('file') as File;
  
  const blob = await put(file.name, file, {
    access: 'public',
  });
  
  return Response.json(blob);
}
```

## Framework Presets

Vercel auto-detects and optimizes for:
- **Next.js** - Full support (SSR, ISR, API routes, middleware)
- **React** (Vite/CRA) - Static or SPA
- **Vue/Nuxt** - SSR support
- **Svelte/SvelteKit** - SSR support
- **Astro** - Static & SSR
- **Remix** - Full support
- **Solid** - Static & SSR

## Deployment Protection

### Password Protection
```json
{
  "passwordProtection": {
    "deploymentType": "preview"
  }
}
```

### Vercel Authentication
```json
{
  "vercelAuthentication": {
    "deploymentType": "preview"
  }
}
```

## Common Gotchas
- Preview deployments get unique URLs automatically
- Environment variables need to be added for each environment
- `NEXT_PUBLIC_*` vars are exposed to browser (intentionally)
- Serverless functions have 10s default timeout (can increase)
- Edge functions have 25ms CPU time limit
- Use `vercel dev` for local development with Vercel features
- Check build logs with `vercel logs --follow`
- ISR requires proper cache headers
- `public/` folder is served at root URL
