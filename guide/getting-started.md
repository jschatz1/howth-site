# Getting Started

howth is a complete JavaScript/TypeScript toolchain — runtime, build system, test runner, bundler, package manager, and dev server — in a single Rust binary.

Instead of stitching together `tsc` + `jest` + `webpack` + `nodemon` + `npm`, you use one tool that covers the entire development lifecycle. A persistent background daemon keeps everything warm, so every command after the first is near-instant.

## Installation

The fastest way to install howth:

```sh
curl -fsSL https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh
```

See [Installation](./installation) for more options.

## Run TypeScript directly

No `ts-node`, no `tsx`, no configuration:

```sh
howth run server.ts
```

This executes your script in a native V8 runtime with 85% Node.js API coverage. HTTP servers use hyper under the hood. `fs`, `crypto`, `child_process`, `streams` — all work out of the box.

## Build your project

Transpile TypeScript to JavaScript:

```sh
howth build
```

SWC-powered transpilation: 1.2ms cold, 0.1ms warm. Content-addressed caching means only changed files rebuild.

## Watch Mode

For development, use watch mode for instant feedback:

```sh
howth build --watch
```

## Run tests

```sh
howth test
```

Tests run in a warm V8 runtime inside the daemon. 500 TypeScript test files transpile in parallel across all CPU cores, load from memory (no temp files), and execute immediately. 29x faster than `node --test`, 2.7x faster than `bun test` at 10,000 tests.

## Bundle for production

```sh
howth bundle src/index.ts -o dist/bundle.js
```

Tree shaking, dead code elimination, code splitting on dynamic imports, CSS bundling, and minification.

## Install packages

```sh
howth install
```

Package management with lockfile support, integrity verification, and offline caching.

## Dev Server

Start a dev server with hot module replacement:

```sh
howth dev src/index.ts --port 3000
```

## What's Next

- [Architecture](./architecture) — How the daemon, V8 runtime, and IPC work together
- [Installation](./installation) — All installation methods
- [CLI Reference](./cli-reference) — Full command reference
- [Node.js API Compatibility](/reference/node-api-compat) — Supported Node.js APIs
