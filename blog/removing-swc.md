---
title: "Removing SWC from Howth: Building a Custom TypeScript Parser and Minifier"
date: 2026-02-10
---

# Removing SWC from Howth: Building a Custom TypeScript Parser and Minifier

<p class="blog-meta">February 10, 2026</p>

Howth originally relied on **SWC** for much of its JavaScript and TypeScript pipeline. SWC is fast and widely used, but it also imposed architectural constraints that conflicted with Howth's goals: **single-pass compilation, tight bundler integration, and explicit control over performance tradeoffs**.

This post explains **why SWC was removed**, **what replaced it**, and **how the new pipeline works** — including a custom TypeScript parser, JSX transform, and variable name mangler written entirely in Rust.

---

## What SWC was doing before — and why that mattered

SWC handled four distinct responsibilities in Howth:

1. **TypeScript type stripping**
2. **JSX transforms**
3. **Minification** (`swc_ecma_minifier`)
4. **Parsing and code generation**

To support that, Howth depended on a large portion of the SWC ecosystem:

* `swc_ecma_transforms_base`
* `swc_ecma_transforms_react`
* `swc_ecma_transforms_typescript`
* the SWC minifier

Functionally, this worked. Architecturally, it had costs:

* Source files were **parsed multiple times**
* JSX went through **separate parse → transform → codegen phases**
* The bundler had to treat SWC as a black box
* Performance optimizations across parsing, resolution, and emission were harder to compose

Removing SWC wasn't about replacing it "for fun." It was about enabling a pipeline that could **parse once, understand everything, and emit once**, with no redundant work.

---

## What replaced it

SWC was replaced with a **single, hand-written recursive-descent parser** in `howth-parser`.

The full parser + codegen + minifier stack is ~17,000 lines of Rust:

| File            | Lines | Role                                                |
| --------------- | ----: | --------------------------------------------------- |
| `parser.rs`     | 4,015 | Recursive-descent parser + Pratt expression parsing |
| `typescript.rs` | 3,075 | TypeScript type grammar + 147 unit tests            |
| `codegen.rs`    | 1,917 | AST → JS emission (with minify mode)                |
| `mangle.rs`     | 1,590 | Variable name mangling                              |
| `lexer.rs`      |   987 | Tokenizer with regex/division disambiguation        |
| `ast.rs`        |   995 | AST node definitions                                |
| `jsx.rs`        |   666 | JSX parsing                                         |
| `token.rs`      |   512 | Token definitions                                   |

The goal was **single-pass correctness**: parse once, extract imports, optionally strip types, optionally minify, and emit JavaScript — without bouncing between independent systems.

---

## TypeScript support

The parser supports a broad subset of TypeScript's type system, including:

* **Primitive types** (`any`, `unknown`, `never`, `void`, `null`, `undefined`, `boolean`, `number`, `string`, `symbol`, `bigint`, `object`)
* **Compound types**: unions, intersections, arrays, tuples (with labels and optional elements)
* **Generics**: constraints, defaults, qualified names
* **Function and constructor types**
* **Advanced operators**: `keyof`, `typeof`, `infer`, indexed access, `as`, `satisfies`, non-null `!`
* **Conditional and mapped types**
* **Template literal types**
* **Type predicates and assertion signatures**
* **Declarations**: `type`, `interface`, `enum`, `namespace`, `declare`
* **Class modifiers**: `abstract`, `readonly`, `override`, access modifiers
* **Import types**: `import("mod").Type`

The parser builds a **full AST including all type information**, even though most of it is later stripped.

---

## The hard part: TypeScript disambiguation

TypeScript syntax overlaps heavily with JavaScript, so parsing requires deliberate disambiguation strategies. Howth uses four main techniques.

### 1. Targeted lookahead

To distinguish:

```ts
(x: T) => V
```

from:

```ts
(T)
```

the parser peeks ahead for `:`, `?`, or `,` and validates whether the token sequence can only form a function type. This logic lives in `parse_ts_paren_or_fn_type()`.

---

### 2. Save/restore backtracking

Generic arrow functions conflict with type assertions:

```ts
<T>(x) => x
<T>x
```

The parser snapshots its state (current token index + lexer clone), attempts to parse a generic arrow, and if that fails, restores the state and parses a type assertion instead.

---

### 3. Follow-token validation

After parsing `<T, U>`, the parser checks what follows:

* `(` → call with type arguments
* `; , ) ] } ? . !` → instantiation expression
* anything else → not type arguments, backtrack

This avoids committing too early.

---

### 4. ASI awareness

Automatic Semicolon Insertion matters even in type position. The lexer tracks `had_newline_before`, preventing cases like interface members starting with `[` on a new line from being misparsed as indexed access expressions.

---

## Type stripping in codegen

Type stripping happens entirely during code generation.

The parser keeps all type nodes; the emitter simply skips them:

* `TsTypeAlias`, `TsInterface`, `TsDeclare` → emit nothing
* `TsNonNull(expr)` → emit `expr`
* `TsTypeAssertion`, `TsAs`, `TsSatisfies` → emit inner expression
* `TsEnum` and `TsNamespace` → emitted (they have runtime semantics)

This keeps parsing and emission cleanly separated.

---

## Compatibility

Current compatibility numbers:

* **92.5%** on an 8,116-file broad suite (TypeScript compiler tests, Vue 3, Deno std)

  * ~50%: multi-file harness limitations
  * ~30%: intentionally invalid TypeScript
  * ~20%: fixable edge cases
* **99.7%** on the Deno standard library (1,132 files)

Most remaining failures are unicode and regex corner cases.

---

## Performance impact

Removing SWC allowed several optimizations to compose cleanly:

* **JSX fast path** — parse, import extraction, and JSX codegen in one pass
* **Parallel resolver** — import resolution across all CPU cores
* **Directory listing cache** — one `readdir()` per directory instead of tens of thousands of `stat()` calls

On the `apps/10000` benchmark (~19,000 modules), this reduced bundling time from **634 ms to 246 ms** — a **2.58× speedup**, and **~1.25× faster than Bun** in the same configuration.

---

## Variable name mangling

Minification includes optional variable name mangling, implemented in three phases.

### Example

**Input:**

```js
function process(longName, callback) {
    let result = callback(longName);
    return { result };
}
```

**Output:**

```js
function process(a, b) {
    let c = b(a);
    return { result: c };
}
```

This demonstrates:

* Parameter renaming
* Local variable renaming
* Shorthand property expansion (`{ result }` → `{ result: c }`)
* Preservation of object property names

---

### Phase 1: Collect

A single AST traversal builds a scope tree:

* Functions, blocks, loops, and `catch` clauses create scopes
* All bindings are recorded
* `var` declarations are hoisted to the nearest function/module scope
* `let` and `const` remain block-scoped

---

### Phase 2: Assign

Scopes are walked top-down. For each scope, a `NameGenerator` assigns short names while avoiding:

* Ancestor scope bindings
* JavaScript reserved words
* User-specified reserved names

**Name encoding:**

* First character: `a–z A–Z _ $` (54 symbols)
* Subsequent characters: the same set plus `0–9` (64 symbols)

This yields:

```
a, b, …, z, A, …, Z, _, $, aa, ba, ca, …
```

---

### Phase 3: Rename

A second AST traversal mirrors Phase 1 exactly. A scope stack and child counters ensure child scopes are visited in the same order they were created. Identifiers are replaced in-place by walking up the scope chain to find the nearest rename.

---

## Safety checks

* **Shorthand properties** expanded explicitly
* **Destructuring bindings** rewritten safely
* **eval / with** trigger a conservative bailout: any scope containing `eval` disables mangling for itself and all ancestor scopes

This prioritizes correctness over aggressive compression.

---

## Bundler integration

Minification runs on the **final concatenated bundle**:

```rust
minify_bundle(code, mangle)
```

* Parses the bundle
* Optionally mangles
* Re-emits with `CodegenOptions { minify: true }`

Top-level bindings are not mangled by default to preserve module APIs.

---

## Why remove SWC (revisited)

Removing SWC enabled:

* Single-pass parsing and codegen
* Fewer dependencies and simpler builds
* Tighter integration with the bundler
* Explicit, controllable performance tradeoffs

The result is a smaller pipeline, less redundant work, and significantly better performance on large module graphs.
