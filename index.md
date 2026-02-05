---
layout: home

hero:
  name: howth
  text: One toolchain for the entire JS/TS lifecycle
  tagline: Runtime, build system, test runner, bundler, package manager, and dev server. One Rust binary. One persistent daemon.
  image:
    src: /earwig.png
    alt: howth mascot
  actions:
    - theme: brand
      text: Try in Browser
      link: https://run.howth.run
    - theme: alt
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: GitHub
      link: https://github.com/jschatz1/howth

features:
  - title: 29x Faster Tests
    details: Run 10,000 tests in 139ms. 29x faster than node --test, 2.7x faster than bun. Parallel SWC transpilation, in-memory V8 execution, zero disk I/O.
  - title: Persistent Daemon
    details: A long-running background process keeps warm compilers, caches, and a V8 runtime in memory. CLI commands connect over Unix domain sockets — no startup cost after the first run.
  - title: Native V8 Runtime
    details: Run TypeScript directly in an embedded V8 engine via deno_core. No Node.js subprocess. HTTP servers backed by hyper. 85% Node.js API coverage.
  - title: Complete Toolchain
    details: "run, build, test, bundle, install, dev — all in one binary. No more stitching together tsc + jest + webpack + nodemon + npm."
  - title: 1.2ms Transpile
    details: SWC-powered TypeScript transpilation. 1.2ms cold, 0.1ms warm. 780x faster than tsc. Content-addressed caching with parallel file hashing.
  - title: Bundler + Dev Server
    details: Tree shaking, code splitting, CSS bundling, minification, and a Rollup-compatible plugin system. Built-in dev server with HMR.
  - title: 172K HTTP RPS
    details: "Built-in HTTP server reaches 82% of Bun's throughput (172K vs 211K RPS) and 1.5x faster than Node.js. Powered by hyper with batched request handling."
---

## Benchmarks

All benchmarks on Apple M3 Pro (11 cores). Run with `howth bench`.

### Test Runner (500 files, 10,000 tests)

| Tool | Median | p95 | Peak RSS |
|---|---|---|---|
| **howth** | **139ms** | **146ms** | - |
| bun test | 368ms | 394ms | 138MB |
| node --test | 4.08s | 6.26s | 138MB |

howth is **29x faster** than node and **2.7x faster** than bun.

### Transpile (Apple M3 Pro)

| Tool | Cold | Warm | Peak RSS |
|---|---|---|---|
| **howth** | **1.2ms** | **0.1ms** | **8.2MB** |
| tsc --noEmit | 975ms | - | 143MB |

### HTTP Server (50 connections, 5 seconds)

| Tool | RPS | Latency | Relative |
|---|---|---|---|
| **Bun** | 211K | 236µs | 100% |
| **howth** | 172K | 289µs | 82% |
| Node.js | 111K | 450µs | 53% |

howth is **1.5x faster** than Node.js and reaches **82% of Bun's throughput**.

## Why it's fast

The speed isn't just Rust. It's the architecture:

- **Persistent daemon** — A background process holds warm compilers, caches, and a V8 runtime in memory. CLI commands connect via IPC — no startup penalty after the first run.
- **In-memory everything** — Transpiled modules load from a virtual module map inside V8. Test results are extracted from `globalThis`. No temp files touch disk.
- **Parallel transpilation** — All source files transpile concurrently via rayon across every available core.
- **IPC, not subprocesses** — A test run is a single Unix socket round-trip. No process spawning, no pipe setup.

[Learn more about the architecture &rarr;](/guide/architecture)

## Quick Start

```sh
# Install
curl -fsSL https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh

# Run TypeScript directly
howth run server.ts

# Build your project
howth build

# Run tests (29x faster than node)
howth test

# Bundle for production
howth bundle src/index.ts -o dist/bundle.js

# Dev server with HMR
howth dev src/index.ts --port 3000
```
