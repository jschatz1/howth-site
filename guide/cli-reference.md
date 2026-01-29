# CLI Reference

## howth

The main CLI binary. Also available as `fastnode`.

### Global Options

| Flag | Description |
|---|---|
| `--version` | Print version |
| `--help` | Print help |
| `--json` | JSON output |

### `howth build`

Transpile TypeScript files to JavaScript.

```sh
howth build [OPTIONS]
```

| Option | Description |
|---|---|
| `--watch` | Watch for changes and rebuild |
| `--watch typecheck` | Watch with type checking enabled |

### `howth bundle`

Bundle TypeScript/JavaScript into a single output file.

```sh
howth bundle <ENTRY> -o <OUTPUT> [OPTIONS]
```

| Option | Description |
|---|---|
| `-o, --output <FILE>` | Output file path |

### `howth dev`

Start a dev server with hot module replacement.

```sh
howth dev <ENTRY> [OPTIONS]
```

| Option | Description |
|---|---|
| `--port <PORT>` | Port to listen on (default: 3000) |

### `howth run`

Run a TypeScript or JavaScript file directly.

```sh
howth run <FILE> [ARGS...]
```

### `howth test`

Run tests.

```sh
howth test [OPTIONS]
```

### `howth bench`

Run benchmarks.

```sh
howth bench [OPTIONS]
```
