# Architecture

howth is fast because of its architecture, not just because it's written in Rust. The key insight: most JavaScript tooling pays a massive startup tax on every invocation — parsing configs, initializing compilers, spawning subprocesses, reading caches from disk. howth pays that cost once and keeps everything alive in memory.

## The daemon

When you run any `howth` command, the CLI connects to a long-running daemon process over a Unix domain socket (or named pipe on Windows). If the daemon isn't running, the first command starts it automatically.

The daemon holds in memory:

- **A warm SWC compiler** — No initialization cost on subsequent transpilations.
- **A warm V8 runtime** — The deno_core-based JavaScript engine stays bootstrapped between test runs. The 6.5ms V8 startup cost is paid once.
- **Module resolution cache** — Resolved paths for `node_modules` lookups are cached across invocations.
- **Package.json cache** — Parsed `package.json` files don't need re-reading.
- **Build cache** — Content-addressed build results with file dependency tracking for automatic invalidation.

Every CLI invocation is a single IPC round-trip: send a request, receive a response. No subprocesses are spawned. No compilers are re-initialized. No caches are re-read from disk.

## IPC protocol

The CLI and daemon communicate over Unix domain sockets using length-prefixed JSON frames:

```
[4 bytes: u32 LE length][JSON payload]
```

This is simpler and faster than HTTP. The max frame size is 16 MiB. Every request includes a protocol version for forward compatibility.

The protocol supports both request-response (for `run`, `build`, `test`) and streaming (for `build --watch` and `install` progress).

## How `howth test` works

This is where the architecture really shows. Here's what happens when you run `howth test`:

1. **CLI connects to daemon** via Unix domain socket (~1ms).

2. **Parallel transpilation** — The daemon transpiles all test files concurrently using rayon across every CPU core. On an 11-core M3 Pro, 500 TypeScript files transpile nearly simultaneously. The SWC compiler is stateless and `Send + Sync`, so it parallelizes perfectly.

3. **Virtual module loading** — Transpiled code is stored in an in-memory `HashMap<String, String>` (the "virtual module map"). The V8 module loader checks this map before the filesystem. No temp files are written to disk.

4. **V8 execution** — A runner module is assembled that imports all test files and runs the test harness. This module also lives in the virtual module map. V8 loads and executes everything from memory.

5. **In-memory results** — The test harness stores its JSON report on `globalThis.__howth_test_result_json`. After execution, the daemon extracts it directly from V8 memory using `eval_to_string()`. No results file is written to disk.

6. **IPC response** — The JSON results are sent back to the CLI over the socket.

The entire pipeline — transpile 500 files, load them into V8, execute 10,000 tests, extract results — completes in 139ms. Node.js takes 4 seconds.

## How `howth run` works

```sh
howth run server.ts
```

The native V8 runtime (built on deno_core) executes your script directly. It implements most of the Node.js API surface:

- **`node:http`** — HTTP servers and clients backed by hyper and tokio. This is a real async HTTP server running inside V8, not a subprocess.
- **`node:fs`** — Synchronous, callback, and promise APIs. Real filesystem operations via Rust's `std::fs` and `tokio::fs`.
- **`node:crypto`** — Hashing, HMAC, AES-CBC/CTR/GCM, RSA sign/verify/encrypt/decrypt. Backed by the `ring` and `aes` crates.
- **`node:child_process`** — `exec`, `spawn`, `execSync`, `spawnSync`.
- **`node:stream`** — Readable, Writable, Duplex, Transform, pipeline.

The runtime also provides standard web APIs: `fetch` (via reqwest), `URL`, `TextEncoder`, `crypto.subtle`, `AbortController`, `ReadableStream`, and more.

## How `howth build` works

The build system uses a directed acyclic graph of build nodes. Each node has typed inputs (files, globs, env vars) and outputs. Content-addressed hashing determines what needs rebuilding:

1. Walk the project, discover files, build the dependency graph.
2. Hash all inputs. Compare against the build cache.
3. Execute only the nodes whose inputs changed. Transpile nodes use the warm SWC compiler.
4. Store results in the build cache with file dependency tracking for automatic invalidation.

The daemon's file watcher (via the `notify` crate, using kqueue on macOS) monitors source files and invalidates cache entries when they change. `howth build --watch` streams results back to the CLI as files change.

## Project structure

```
crates/
  fastnode-cli/      CLI binary, all commands
  fastnode-core/     Build system, bundler, SWC compiler, resolver, pkg manager
  fastnode-daemon/   Daemon: IPC server, file watching, warm worker pool
  fastnode-runtime/  Native V8 runtime via deno_core, Node.js API shims
  fastnode-proto/    IPC protocol types and frame encoding
  fastnode-util/     Pure utilities: fs helpers, hashing
  fastnode-compat/   Node API compatibility layer
  fastnode-bench/    Benchmark infrastructure
```

~59k lines of Rust across 8 crates.
