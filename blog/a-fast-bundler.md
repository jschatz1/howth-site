---
title: A Fast Bundler
date: 2026-02-09
---

# A Fast Bundler

<p class="blog-meta">February 9, 2026</p>

We ran the [rolldown/benchmarks](https://github.com/jschatz1/benchmarks) suite (10,000 React JSX components) against 7 bundlers. howth came out on top at **275ms** — ahead of bun, esbuild, rolldown, vite, rspack, and rsbuild.

## Results

### GCP c3-highcpu-8 — Linux x64

Intel Xeon Platinum 8481C @ 2.70GHz, 4 cores / 8 threads, 16GB RAM. Warm cache, 10 runs, measured with [hyperfine](https://github.com/sharkdp/hyperfine).

| Tool | Version | Time | vs howth |
|------|---------|------|----------|
| **howth** | **0.4.0** | **275ms** | **1.0x** |
| Bun | 1.3.9 | 307ms | 1.1x |
| esbuild | 0.27.3 | 589ms | 2.1x |
| Rolldown | 1.0.0-rc.3 | 735ms | 2.7x |
| Vite | 7.3.1 | 922ms | 3.3x |
| rspack | 1.7.5 | 2,067ms | 7.5x |
| Rsbuild | 1.7.3 | 2,176ms | 7.9x |

### macOS — Apple M3 Pro

| Tool | Version | Time | vs howth |
|------|---------|------|----------|
| **howth** | **0.4.0** | **276ms** | **1.0x** |
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

## Methodology

All benchmarks use the [rolldown/benchmarks](https://github.com/jschatz1/benchmarks) suite (forked with howth added). The GCP benchmark ran on a dedicated c3-highcpu-8 spot instance with no other workloads. All tools configured identically. Measured with hyperfine (10 runs).

[View the benchmark source](https://github.com/jschatz1/benchmarks)

---

## Update: v0.5.0 — Variable Name Mangling (February 10, 2026)

v0.5.0 adds variable name mangling to the minifier. `--minify` now shortens local variable names by default (`myVariable` → `a`), matching the behavior of esbuild and bun.

### macOS — Apple M3 Pro (updated)

| Tool | Version | Time | JS Size | vs fastest |
|------|---------|------|---------|------------|
| **Bun** | **1.3.9** | **321ms** | **5.34 MB** | **1.0x** |
| **howth** | **0.5.0** | **460ms** | **4.02 MB** | **1.4x** |
| esbuild | 0.27.3 | 796ms | 5.91 MB | 2.5x |
| Rolldown | 1.0.0-rc.3 | 813ms | 5.22 MB | 2.5x |
| Vite | 7.3.1 | 1,274ms | 5.28 MB | 4.0x |
| Rsbuild | 1.7.3 | 1,607ms | 5.70 MB | 5.0x |
| rspack | 1.7.5 | 1,696ms | 5.18 MB | 5.3x |

Mangling adds a re-parse and rename pass, so howth is now **460ms** (up from 276ms without mangling). It's still **1.7x faster than esbuild** and the smallest JS output in the benchmark at **4.02 MB**.

The bundle size dropped **30%** (5.72 MB → 4.02 MB) from mangling alone. There's still a gap vs bun's 5.34 MB — bun doesn't mangle in this configuration, so its output is larger but its bundling is faster.

### GCP c3-highcpu-8 — Linux x64 (updated)

Intel Xeon Platinum 8481C @ 2.70GHz, 4 cores / 8 threads, 16GB RAM.

| Tool | Version | Time | JS Size | vs fastest |
|------|---------|------|---------|------------|
| **Bun** | **1.3.9** | **526ms** | **5.34 MB** | **1.0x** |
| **howth** | **0.5.0** | **673ms** | **4.13 MB** | **1.3x** |
| Rolldown | 1.0.0-rc.3 | 1,151ms | 5.22 MB | 2.2x |
| esbuild | 0.27.3 | 1,243ms | 5.90 MB | 2.4x |
| Vite | 7.3.1 | 1,501ms | 5.28 MB | 2.9x |
| Rsbuild | 1.7.3 | 2,599ms | 5.70 MB | 4.9x |
| rspack | 1.7.5 | 2,677ms | 5.18 MB | 5.1x |

See [Removing SWC: Building a Custom TypeScript Parser and Minifier](/blog/removing-swc) for details on how the mangler works.
