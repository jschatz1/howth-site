# Configuration

howth supports configuration files that are compatible with Vite's configuration format. This allows you to customize the dev server, define aliases, set environment replacements, and more.

## Config File Discovery

howth looks for configuration files in the following order (first match wins):

1. `howth.config.ts`
2. `howth.config.js`
3. `vite.config.ts`
4. `vite.config.js`

## Basic Configuration

Create a `howth.config.ts` file in your project root:

```typescript
export default {
  server: {
    port: 3000,
    host: 'localhost',
    open: true,
  },
  resolve: {
    alias: {
      '@': './src',
      '@components': './src/components',
    },
  },
  define: {
    __APP_VERSION__: JSON.stringify('1.0.0'),
    'process.env.NODE_ENV': JSON.stringify('development'),
  },
  base: '/',
};
```

## Configuration Options

### `server`

Server options for the dev server.

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `port` | `number` | `3000` | Port to listen on |
| `host` | `string` | `'localhost'` | Host to bind to |
| `open` | `boolean` | `false` | Open browser automatically on start |

```typescript
export default {
  server: {
    port: 8080,
    host: '0.0.0.0',  // Listen on all interfaces
    open: true,       // Open browser
  },
};
```

### `resolve.alias`

Import aliases for module resolution. Maps import specifiers to file paths.

```typescript
export default {
  resolve: {
    alias: {
      '@': './src',
      '@components': './src/components',
      '@utils': './src/utils',
      '~': './',
    },
  },
};
```

With this configuration:

```typescript
// This import:
import { Button } from '@components/Button';

// Resolves to:
import { Button } from './src/components/Button';
```

### `define`

Global constant replacements. Values are replaced at build time.

```typescript
export default {
  define: {
    __APP_VERSION__: JSON.stringify('1.0.0'),
    __DEV__: 'true',
    'process.env.NODE_ENV': JSON.stringify('development'),
  },
};
```

::: warning Note
String values must be JSON-stringified. Use `JSON.stringify()` for string constants.
:::

```typescript
// In your code:
console.log(__APP_VERSION__);  // Replaced with "1.0.0"
console.log(__DEV__);          // Replaced with true

// After transformation:
console.log("1.0.0");
console.log(true);
```

### `base`

Base public path for the application. Used when deploying to a subdirectory.

```typescript
export default {
  base: '/my-app/',
};
```

## TypeScript Path Aliases

howth automatically reads path aliases from `tsconfig.json` or `jsconfig.json`:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@components/*": ["./src/components/*"]
    }
  }
}
```

These are automatically converted to resolve aliases. You don't need to duplicate them in `howth.config.ts`.

::: tip Priority
Aliases in `howth.config.ts` take precedence over `tsconfig.json` paths.
:::

## Plugins

howth supports Vite-compatible plugins, but with some limitations:

```typescript
export default {
  plugins: [
    {
      name: 'my-plugin',
      transform(code, id) {
        // Transform module code
        return code.replace('__TIMESTAMP__', Date.now().toString());
      },
    },
  ],
};
```

::: warning Plugin Limitations
Currently, plugins with function calls (like `react()`) require the native runtime to evaluate. Static configuration parsing cannot handle:

```typescript
// This requires native runtime:
import react from '@vitejs/plugin-react';
export default {
  plugins: [react()],
};
```

howth detects when plugins are present and will use the V8 runtime to load the full configuration when available.
:::

### Supported Plugin Hooks

| Hook | Description |
|------|-------------|
| `transform(code, id)` | Transform module source code |
| `resolveId(source, importer)` | Resolve import specifiers |
| `load(id)` | Load module content |
| `config(config)` | Modify configuration |
| `configResolved(config)` | Read final configuration |
| `handleHotUpdate(ctx)` | Custom HMR handling |

## Environment Variables

howth loads environment variables from `.env` files:

```
.env                # Loaded in all cases
.env.local          # Loaded in all cases, ignored by git
.env.[mode]         # Only loaded in specified mode
.env.[mode].local   # Only loaded in specified mode, ignored by git
```

Variables prefixed with `VITE_` or `HOWTH_` are exposed to client code:

```bash
# .env
VITE_APP_TITLE=My App
VITE_API_URL=https://api.example.com
HOWTH_DEBUG=true
```

Access in code via `import.meta.env`:

```typescript
console.log(import.meta.env.VITE_APP_TITLE);  // "My App"
console.log(import.meta.env.MODE);             // "development"
console.log(import.meta.env.DEV);              // true
console.log(import.meta.env.PROD);             // false
```

### Built-in Environment Variables

| Variable | Description |
|----------|-------------|
| `import.meta.env.MODE` | The mode the app is running in (`development` or `production`) |
| `import.meta.env.DEV` | `true` in development mode |
| `import.meta.env.PROD` | `true` in production mode |
| `import.meta.env.BASE_URL` | The base URL from config |

## Config File Format

howth uses a static parser that supports JSON5-like syntax:

- Unquoted object keys
- Single-quoted strings
- Trailing commas
- Comments (`//` and `/* */`)

```typescript
export default {
  // Line comment
  server: {
    port: 3000,  /* inline comment */
  },
  resolve: {
    alias: {
      '@': './src',  // trailing comma OK
    },
  },
};
```

## CLI Flag Overrides

CLI flags take precedence over config file options:

```bash
# Config says port 3000, but this uses 8080
howth dev src/main.tsx --port 8080
```

## Example Configurations

### React Project

```typescript
export default {
  server: {
    port: 3000,
    open: true,
  },
  resolve: {
    alias: {
      '@': './src',
      '@components': './src/components',
      '@hooks': './src/hooks',
      '@utils': './src/utils',
    },
  },
  define: {
    __DEV__: 'true',
  },
};
```

### Monorepo Package

```typescript
export default {
  server: {
    port: 5173,
  },
  resolve: {
    alias: {
      '@myorg/shared': '../shared/src',
      '@myorg/ui': '../ui/src',
    },
  },
  base: '/packages/app/',
};
```

### Production Build

```typescript
export default {
  define: {
    'process.env.NODE_ENV': JSON.stringify('production'),
    __DEV__: 'false',
  },
  base: '/my-app/',
};
```
