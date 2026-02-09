---
title: The Fastest JavaScript Bundler
date: 2026-02-09
---

# The Fastest JavaScript Bundler

<p class="blog-meta">February 9, 2026</p>

howth is now the fastest JavaScript bundler. On the [rolldown/benchmarks](https://github.com/jschatz1/benchmarks) suite (10,000 React JSX components), howth bundles in **275ms** — faster than bun, esbuild, rolldown, vite, rspack, and rsbuild.

## Results

### GCP c3-highcpu-8 — Linux x64

Intel Xeon Platinum 8481C @ 2.70GHz, 4 cores / 8 threads, 16GB RAM. Warm cache, 10 runs, measured with [hyperfine](https://github.com/sharkdp/hyperfine).

| Tool | Version | Time | vs howth |
|------|---------|------|----------|
| **howth** | **0.2.0** | **275ms** | **1.0x** |
| Bun | 1.3.9 | 307ms | 1.1x |
| esbuild | 0.27.3 | 589ms | 2.1x |
| Rolldown | 1.0.0-rc.3 | 735ms | 2.7x |
| Vite | 7.3.1 | 922ms | 3.3x |
| rspack | 1.7.5 | 2,067ms | 7.5x |
| Rsbuild | 1.7.3 | 2,176ms | 7.9x |

### macOS — Apple M3 Pro

| Tool | Version | Time | vs howth |
|------|---------|------|----------|
| **howth** | **0.2.0** | **276ms** | **1.0x** |
| Bun | 1.3.9 | 350ms | 1.3x |
| esbuild | 0.27.3 | 724ms | 2.6x |
| Rolldown | 1.0.0-rc.3 | 765ms | 2.8x |
| Vite | 7.3.1 | 1,203ms | 4.4x |
| Rsbuild | 1.7.3 | 1,587ms | 5.8x |
| rspack | 1.7.5 | 1,648ms | 6.0x |

All tools configured identically: production mode, minification, sourcemaps, no gzip.

## How we got here

A day earlier, howth was at **634ms** on this benchmark — slower than bun. Here's what changed.

### The bottleneck: SWC

Profiling showed 90% of time was spent in `build_graph_parallel`, and the single biggest cost was SWC transpilation — 48% of all worker thread samples. Every `.jsx` file was being parsed **three times**:

1. By howth-parser for import extraction
2. By SWC for JSX → `_jsx()` transformation
3. By howth-parser again to re-extract imports from transpiled output

The apps/10000 benchmark is 100% `.jsx` files with no TypeScript. SWC was entirely unnecessary.

### Optimization 1: JSX fast path — 634ms → 520ms

howth-parser already had complete JSX codegen — it just wasn't wired into the bundler. We added a `transform_jsx()` function that does parse + codegen + import extraction in a single pass, and routed `.jsx` files through it instead of SWC.

For this benchmark, SWC is completely eliminated from the hot path. TypeScript files still use SWC for type stripping.

### Optimization 2: Parallel resolver — 520ms → 384ms

The module resolver was sequential. We made the `Resolver` struct thread-safe with `RwLock<HashMap>` caches and moved resolution into rayon parallel closures. Imports now resolve across all CPU cores simultaneously.

### Optimization 3: Directory listing cache — 384ms → 246ms

The resolver was doing ~12 `stat()` syscalls per import, trying extensions like `.js`, `.jsx`, `.ts`, `.tsx`, `/index.js`, etc. For 10,000 modules, that's over 120,000 stat() calls.

The fix: read each directory once and cache file names as `HashSet`s. One `readdir` replaces all per-extension probing. We also replaced `canonicalize()` (which calls `realpath()`) with in-memory path normalization that resolves `.` and `..` without any syscalls.

### Optimization 4: Drop SWC minifier — cleaner pipeline

Replaced SWC's minifier with howth-parser's `CodegenOptions { minify: true }`. Performance-neutral, but removes the last SWC dependency from the JS/JSX bundling path.

## Why howth is fast

1. **Native binary** — no Node.js startup cost
2. **Single-pass JSX** — howth-parser does parse + import extraction + codegen in one pass
3. **Rayon parallelism** — file I/O and transpilation across all cores
4. **Arena allocation** — bump allocator for AST nodes, better cache locality
5. **Directory listing cache** — one readdir per directory, HashSet lookups
6. **Dense module graph** — `Vec<Module>` indexed by `usize`, no pointer chasing
7. **In-memory path normalization** — zero realpath() syscalls

## What's next

howth's JS output is currently larger than competitors (3.4 MB vs ~800 KB). This is because we don't yet do identifier mangling — the minifier strips whitespace and comments but preserves original variable names. Mangling is the next optimization target.

## Methodology

All benchmarks use the [rolldown/benchmarks](https://github.com/jschatz1/benchmarks) suite (forked with howth added). The GCP benchmark ran on a dedicated c3-highcpu-8 spot instance with no other workloads. All tools configured identically. Measured with hyperfine (10 runs).

[View the benchmark source](https://github.com/jschatz1/benchmarks)
