---
layout: home

hero:
  name: howth
  text: Fast TypeScript builds
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
  - title: 34ms Cold Transpile
    details: Transpile 203 TypeScript files cold in 34ms. Warm builds in 3.6ms. Faster than esbuild, swc, and tsc.
  - title: Bundler with Tree Shaking
    details: Dead code elimination, code splitting on dynamic imports, CSS bundling with minification, and a Rollup-compatible plugin system.
  - title: Dev Server + HMR
    details: Built-in dev server with hot module replacement. See changes instantly during development.
  - title: Watch Mode
    details: Transpile-only by default for instant feedback. Type checking is opt-in with --watch typecheck.
  - title: SWC Backend
    details: Uses SWC for transpilation. Rust-native, no Node.js overhead. Content-based caching with parallel file hashing.
  - title: Node.js Compatible
    details: 85% Node.js API coverage. Full support for http, fs, crypto, streams, and more. Run Express, Next.js, and SvelteKit.
---

## Benchmarks

Transpiling 203 TypeScript files (Apple M3 Pro):

| Tool | Cold | Warm |
|---|---|---|
| **howth** | **34ms** | **3.6ms** |
| esbuild | 40ms | - |
| swc | 107ms | - |
| tsc | 515ms | - |

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
