# Framework Compatibility

howth can run modern JavaScript frameworks directly in its native V8 runtime, without requiring Node.js.

## Compatibility Matrix

| Framework | Status | Notes |
|-----------|--------|-------|
| **Next.js** | ✅ Working | Static pages, API routes, SSR |
| **SvelteKit** | ✅ Working | Full SSR support |
| **Remix** | ✅ Working | Full SSR with loaders and actions |
| **Express** | ✅ Working | Full support via node:http |
| **Fastify** | ✅ Working | Full support via node:http |
| **Hono** | ✅ Working | Full support |

## Next.js

Next.js works with howth out of the box.

### Setup

1. Build your app:
```bash
npm run build
```

2. Run with howth:
```bash
howth run node_modules/next/dist/bin/next -- start
```

### What Works

- Static pages
- Server-side rendering (SSR)
- API routes (`pages/api/*`)
- Dynamic routes
- Static generation

## SvelteKit

SvelteKit works with howth using `@sveltejs/adapter-node`.

### Setup

1. Install the adapter:
```bash
npm install @sveltejs/adapter-node
```

2. Configure `svelte.config.js`:
```js
import adapter from '@sveltejs/adapter-node';

export default {
  kit: {
    adapter: adapter()
  }
};
```

3. Build your app:
```bash
npm run build
```

4. Run with howth:
```bash
howth run build/index.js
```

### What Works

- Server-side rendering (SSR)
- Routing and page navigation
- API routes (`+server.js`)
- Form actions
- Streaming responses
- Custom URL protocols (e.g., `sveltekit-internal://`)

## Remix

Remix works with howth using `@remix-run/express`.

### Setup

1. Use the Express adapter:
```bash
npm install @remix-run/express @remix-run/node express
```

2. Create a server entry point (`server.js`):
```js
const express = require("express");
const { createRequestHandler } = require("@remix-run/express");

const app = express();
app.all("*", createRequestHandler({ build: require("./build") }));
app.listen(3000);
```

3. Build and run:
```bash
npm run build
howth run server.js
```

### What Works

- Server-side rendering (SSR)
- Loaders and loader data
- Actions and form handling
- File-based routing
- Streaming responses (React 18 `renderToPipeableStream`)

## Express

Express works out of the box with howth's `node:http` implementation.

```js
import express from 'express';

const app = express();

app.get('/', (req, res) => {
  res.send('Hello from howth!');
});

app.listen(3000, () => {
  console.log('Server running at http://localhost:3000');
});
```

Run with:
```bash
howth run server.js
```

## Fastify

Fastify works with howth's `node:http` implementation.

```js
import Fastify from 'fastify';

const fastify = Fastify();

fastify.get('/', async () => {
  return { hello: 'world' };
});

await fastify.listen({ port: 3000 });
```

## API Features Required by Frameworks

The following APIs were added to support framework compatibility:

| API | Frameworks Using It |
|-----|-------------------|
| `Request.signal` | Remix |
| `TextEncoder.encodeInto()` | Remix (React SSR streaming) |
| Named exports for `node:*` modules | SvelteKit |
| Custom URL protocols | SvelteKit |
| `AbortController`/`AbortSignal` | Remix, SvelteKit |
| `ReadableStream`/`WritableStream` | Remix, SvelteKit |
