---
layout: home

hero:
  name: howth
  text: Fast JavaScript & TypeScript builds
  tagline: A commodius vicus of recirculation for your JavaScript.
  image:
    src: /earwig.png
    alt: howth mascot
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: Installation
      link: /guide/installation
    - theme: alt
      text: GitHub
      link: https://github.com/jschatz1/howth

features:
  - title: 1.2ms Cold Transpile
    details: Transpile TypeScript files cold in 1.2ms. Warm rebuilds in 0.1ms. 780x faster than tsc.
  - title: 8.7x Faster Tests
    details: Run 120 tests in 19ms. 8.7x faster than node --test, on par with bun. Warm Node worker pool with SWC transpilation.
  - title: Bundler with Tree Shaking
    details: Dead code elimination, code splitting on dynamic imports, CSS bundling with minification, and a Rollup-compatible plugin system.
  - title: Dev Server + HMR
    details: Built-in dev server with hot module replacement. See changes instantly during development.
  - title: SWC Backend
    details: Uses SWC for transpilation. Rust-native, no Node.js overhead. Content-based caching with parallel file hashing.
  - title: Node.js Compatible
    details: 85% Node.js API coverage. Full support for http, fs, crypto, streams, and more. Run Express, Next.js, and SvelteKit.
---

## Benchmarks

### Transpile (Apple M3 Pro)

| Tool | Cold | Warm | Peak RSS |
|---|---|---|---|
| **howth** | **1.2ms** | **0.1ms** | **8.2MB** |
| tsc --noEmit | 975ms | - | 143MB |

### Test Runner (15 files, 120 tests)

| Tool | Median | p95 | Peak RSS |
|---|---|---|---|
| **howth** | **19ms** | **20ms** | - |
| bun test | 20ms | 25ms | 56.8MB |
| node --test | 163ms | 189ms | 56.8MB |

howth is **8.7x faster** than node and **1.05x faster** than bun.

## Quick Start

```sh
# Install
curl -fsSL https://raw.githubusercontent.com/jschatz1/howth/main/install.sh | sh

# Build your project
howth build

# Watch mode
howth build --watch

# Bundle for production
howth bundle src/index.ts -o dist/bundle.js

# Dev server with HMR
howth dev src/index.ts --port 3000
```
