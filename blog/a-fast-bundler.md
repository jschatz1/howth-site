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

### GCP c3-highcpu-8 — Linux x64 (updated)

Intel Xeon Platinum 8481C @ 2.70GHz, 4 cores / 8 threads, 16GB RAM. 10 runs, hyperfine.

**With mangling (default `--minify` behavior):**

| Tool | Version | Time | JS Size | vs fastest |
|------|---------|------|---------|------------|
| **Bun** | **1.3.9** | **528ms** | **5.34 MB** | **1.0x** |
| **howth** | **0.5.0** | **670ms** | **4.13 MB** | **1.3x** |
| Rolldown | 1.0.0-rc.3 | 1,144ms | 5.22 MB | 2.2x |
| esbuild | 0.27.3 | 1,248ms | 5.90 MB | 2.4x |
| Vite | 7.3.1 | 1,498ms | 5.28 MB | 2.8x |
| Rsbuild | 1.7.3 | 2,550ms | 5.70 MB | 4.8x |
| rspack | 1.7.5 | 2,676ms | 5.18 MB | 5.1x |

**Without mangling (`--minify --no-mangle`):**

| Tool | Version | Time | JS Size | vs fastest |
|------|---------|------|---------|------------|
| **Bun** | **1.3.9** | **528ms** | **5.34 MB** | **1.0x** |
| **howth** | **0.5.0** | **549ms** | **5.26 MB** | **1.04x** |

Without mangling, howth and bun are neck and neck. Mangling adds a re-parse and rename pass (~120ms overhead) but drops the JS output by **25%** (5.26 MB → 4.13 MB) — the smallest in the benchmark.

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

See [Removing SWC: Building a Custom TypeScript Parser and Minifier](/blog/removing-swc) for details on how the mangler works.

---

## Update: Per-Module Minification (February 10, 2026)

v0.5.0's minifier re-parsed the entire concatenated bundle (~5 MB) as a single pass. This added ~170ms on M3 Pro. The fix: minify and mangle each module inside the existing `par_iter()` loop instead of re-parsing the full bundle. Each module wrapper is only ~500 bytes, so 10,000 parallel parses are near-instant.

### macOS — Apple M3 Pro (updated)

| Tool | Version | Time | JS Size | vs fastest |
|------|---------|------|---------|------------|
| **Bun** | **1.3.9** | **315ms** | **5.34 MB** | **1.0x** |
| **howth** | **0.5.0** | **317ms** | **4.01 MB** | **1.0x** |
| esbuild | 0.27.3 | 736ms | 5.91 MB | 2.3x |
| Rolldown | 1.0.0-rc.3 | 799ms | 5.22 MB | 2.5x |
| Vite | 7.3.1 | 1,229ms | 5.28 MB | 3.9x |
| Rsbuild | 1.7.3 | 1,569ms | 5.70 MB | 5.0x |
| rspack | 1.7.5 | 1,646ms | 5.18 MB | 5.2x |

howth and bun are now tied — and howth produces the smallest output (4.01 MB vs 5.34 MB, 25% smaller).
