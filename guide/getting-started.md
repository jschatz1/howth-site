# Getting Started

howth is a fast TypeScript build tool, bundler, and dev server written in Rust.

## Installation

The fastest way to install howth:

```sh
curl -fsSL https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh
```

See [Installation](./installation) for more options.

## Your First Build

Create a TypeScript file:

```ts
// src/index.ts
const greeting: string = "Hello from howth!";
console.log(greeting);
```

Build it:

```sh
howth build
```

This transpiles all TypeScript files in your project, outputting JavaScript to the `dist/` directory.

## Watch Mode

For development, use watch mode for instant feedback:

```sh
howth build --watch
```

By default, watch mode only transpiles (no type checking) for maximum speed. Add type checking with:

```sh
howth build --watch typecheck
```

## Bundling

Bundle your application for production:

```sh
howth bundle src/index.ts -o dist/bundle.js
```

This produces a single optimized bundle with tree shaking and dead code elimination.

## Dev Server

Start a dev server with hot module replacement:

```sh
howth dev src/index.ts --port 3000
```

## Running Scripts

Run TypeScript files directly:

```sh
howth run src/server.ts
```

## What's Next

- [Installation](./installation) - All installation methods
- [CLI Reference](./cli-reference) - Full command reference
- [Node.js API Compatibility](/reference/node-api-compat) - Supported Node.js APIs
