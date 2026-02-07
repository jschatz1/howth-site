<script setup lang="ts">
import { ref } from 'vue'

// Install tab state
const installTab = ref<'unix' | 'windows'>('unix')

// Benchmark tab state
const benchmarkTab = ref<'bundler' | 'tests' | 'http'>('bundler')

// API chip state
const activeApi = ref('http-server')

const apis = [
  'Start an HTTP server',
  'Start a WebSocket server',
  'Read and write files',
  'Hash a password',
  'Frontend dev server',
  'Write a test',
  'Parse markdown',
  'Set cookies',
  'Run a shell script',
]

function copyInstallCommand() {
  const cmd = installTab.value === 'unix'
    ? 'curl -fsSL https://howth.run/install | sh'
    : 'powershell -c "irm howth.run/install.ps1 | iex"'
  navigator.clipboard.writeText(cmd)
}
</script>

<template>
  <div class="homepage">
    <!-- Section 1: Hero / Primary Value Proposition -->
    <section class="hero-section">
      <div class="hero-content">
        <div class="hero-left">
          <div class="hero-badge">
            <span>howth v0.1.0 is here!</span>
            <a href="/guide/getting-started">Get started &rarr;</a>
          </div>

          <h1 class="hero-title">
            howth is a <span class="highlight">fast</span> JavaScript<br/>
            runtime & toolkit
          </h1>

          <p class="hero-description">
            howth is a fast, <strong>incrementally adoptable</strong> all-in-one JavaScript, TypeScript & JSX toolkit.
            Use individual tools like <code>howth test</code> or <code>howth install</code> in Node.js projects,
            or adopt the complete stack with a fast JavaScript runtime, bundler, test runner, and package manager built in.
          </p>

          <div class="install-section">
            <div class="install-tabs">
              <button
                class="install-tab"
                :class="{ active: installTab === 'unix' }"
                @click="installTab = 'unix'"
              >
                Linux & macOS
              </button>
              <button
                class="install-tab"
                :class="{ active: installTab === 'windows' }"
                @click="installTab = 'windows'"
              >
                Windows
              </button>
            </div>

            <div class="install-command">
              <code>
                <span class="prompt">$</span>
                {{ installTab === 'unix'
                  ? 'curl -fsSL https://howth.run/install | sh'
                  : 'powershell -c "irm howth.run/install.ps1 | iex"'
                }}
              </code>
              <button class="copy-btn" @click="copyInstallCommand" title="Copy to clipboard">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                  <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                </svg>
              </button>
            </div>
          </div>

          <div class="used-by">
            <span class="used-by-label">Built with Rust & V8</span>
            <div class="used-by-logos">
              <span style="font-weight: 600;">SWC</span>
              <span style="font-weight: 600;">deno_core</span>
              <span style="font-weight: 600;">hyper</span>
              <span style="font-weight: 600;">rayon</span>
            </div>
          </div>
        </div>

        <div class="hero-right">
          <div class="benchmark-tabs">
            <button
              class="benchmark-tab"
              :class="{ active: benchmarkTab === 'bundler' }"
              @click="benchmarkTab = 'bundler'"
            >
              Bundler
            </button>
            <button
              class="benchmark-tab"
              :class="{ active: benchmarkTab === 'tests' }"
              @click="benchmarkTab = 'tests'"
            >
              Tests
            </button>
            <button
              class="benchmark-tab"
              :class="{ active: benchmarkTab === 'http' }"
              @click="benchmarkTab = 'http'"
            >
              HTTP
            </button>
          </div>

          <div class="benchmark-chart" v-if="benchmarkTab === 'bundler'">
            <div class="benchmark-title">Bundling 10,000 React components</div>
            <div class="benchmark-subtitle">Build time in milliseconds (Apple M3 Pro)</div>

            <div class="benchmark-row">
              <span class="benchmark-label">Bun</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar howth" style="width: 8%"></div>
              </div>
              <span class="benchmark-time">162 ms</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">howth</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 19%"></div>
              </div>
              <span class="benchmark-time">387 ms</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">esbuild</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 28%"></div>
              </div>
              <span class="benchmark-time">571 ms</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">Rolldown</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 24%"></div>
              </div>
              <span class="benchmark-time">495 ms</span>
            </div>
          </div>

          <div class="benchmark-chart" v-if="benchmarkTab === 'tests'">
            <div class="benchmark-title">Running 10,000 tests</div>
            <div class="benchmark-subtitle">Test execution time (Apple M3 Pro)</div>

            <div class="benchmark-row">
              <span class="benchmark-label">howth</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar howth" style="width: 3%"></div>
              </div>
              <span class="benchmark-time">139 ms</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">Bun</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 9%"></div>
              </div>
              <span class="benchmark-time">368 ms</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">Vitest</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 35%"></div>
              </div>
              <span class="benchmark-time">1.4s</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">node --test</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 100%"></div>
              </div>
              <span class="benchmark-time">4.08s</span>
            </div>
          </div>

          <div class="benchmark-chart" v-if="benchmarkTab === 'http'">
            <div class="benchmark-title">HTTP Server Throughput</div>
            <div class="benchmark-subtitle">Requests per second (50 connections)</div>

            <div class="benchmark-row">
              <span class="benchmark-label">Bun</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar howth" style="width: 100%"></div>
              </div>
              <span class="benchmark-time">211K rps</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">howth</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 82%"></div>
              </div>
              <span class="benchmark-time">172K rps</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">Node.js</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 53%"></div>
              </div>
              <span class="benchmark-time">111K rps</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Section 2: Unified Toolkit Overview -->
    <section class="homepage-section">
      <h2 class="section-title">Five tools, one toolkit</h2>
      <p class="section-subtitle">
        Use them together as an all-in-one toolkit, or adopt them incrementally.
        <code>howth test</code> works in Node.js projects. <code>howth install</code> can be used as the fastest npm client.
        Each tool stands on its own.
      </p>

      <div class="toolkit-grid">
        <div class="toolkit-card">
          <div class="toolkit-card-header">
            <div>
              <h3 class="toolkit-card-title">JavaScript Runtime</h3>
              <span class="toolkit-badge">Starts 3x faster than Node.js</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth run ./index.ts</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            A fast JavaScript runtime designed as a drop-in replacement for Node.js.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">Node.js API compatibility</span>
            <span class="toolkit-feature">TypeScript, JSX & React</span>
            <span class="toolkit-feature">PostgreSQL, Redis, SQLite</span>
            <span class="toolkit-feature">Hot & watch mode built-in</span>
            <span class="toolkit-feature">Environment variables</span>
            <span class="toolkit-feature">Web standard APIs</span>
          </div>
        </div>

        <div class="toolkit-card">
          <div class="toolkit-card-header">
            <div>
              <h3 class="toolkit-card-title">Package Manager</h3>
              <span class="toolkit-badge">30x faster</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth install</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            Install packages up to 30x faster than npm with a global cache and workspaces.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">Simple migration from npm/pnpm/yarn</span>
            <span class="toolkit-feature">Eliminate phantom dependencies</span>
            <span class="toolkit-feature">Workspaces, monorepos</span>
            <span class="toolkit-feature">Lifecycle scripts</span>
            <span class="toolkit-feature">Dependency auditing</span>
            <span class="toolkit-feature">Block malicious packages</span>
          </div>
        </div>

        <div class="toolkit-card">
          <div class="toolkit-card-header">
            <div>
              <h3 class="toolkit-card-title">Test Runner</h3>
              <span class="toolkit-badge replaces">Replaces Jest & Vitest</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth test</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            Jest-compatible test runner with built-in code coverage and watch mode.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">Jest-compatible expect() API</span>
            <span class="toolkit-feature">Snapshot testing</span>
            <span class="toolkit-feature">Watch mode & lifecycle hooks</span>
            <span class="toolkit-feature">DOM APIs via happy-dom</span>
            <span class="toolkit-feature">Concurrent test execution</span>
            <span class="toolkit-feature">Built-in code coverage</span>
          </div>
        </div>

        <div class="toolkit-card">
          <div class="toolkit-card-header">
            <div>
              <h3 class="toolkit-card-title">Bundler</h3>
              <span class="toolkit-badge replaces">Replaces Vite and esbuild</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth bundle ./app.tsx</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            Bundle TypeScript, JSX, React & CSS for both browsers and servers.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">TypeScript & JSX built-in</span>
            <span class="toolkit-feature">CSS imports & bundling</span>
            <span class="toolkit-feature">React support out of the box</span>
            <span class="toolkit-feature">Build for browser, Bun, Node.js</span>
            <span class="toolkit-feature">Tree shaking</span>
            <span class="toolkit-feature">Code splitting</span>
          </div>
        </div>

        <div class="toolkit-card">
          <div class="toolkit-card-header">
            <div>
              <h3 class="toolkit-card-title">Dev Server</h3>
              <span class="toolkit-badge">HMR & Fast Refresh</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth dev ./src/main.tsx</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            High-performance development server with instant hot module replacement.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">Instant HMR</span>
            <span class="toolkit-feature">React Fast Refresh</span>
            <span class="toolkit-feature">CSS hot reload</span>
            <span class="toolkit-feature">TypeScript errors in browser</span>
            <span class="toolkit-feature">Zero configuration</span>
            <span class="toolkit-feature">Proxy support</span>
          </div>
        </div>
      </div>
    </section>

    <!-- Section 3: Performance Proof -->
    <section class="homepage-section" style="background: var(--howth-bg-card);">
      <div class="terminal" style="max-width: 300px;">
        <div class="terminal-header">
          <span class="terminal-dot red"></span>
          <span class="terminal-dot yellow"></span>
          <span class="terminal-dot green"></span>
        </div>
        <div class="terminal-content">
          <span class="prompt">$</span> howth test
        </div>
      </div>

      <h2 class="section-title">howth is a test runner that makes<br/>the rest look like test walkers.</h2>

      <div style="max-width: 700px; margin: 3rem auto;">
        <div class="benchmark-row" style="margin-bottom: 1.5rem;">
          <span class="benchmark-label" style="width: 100px;">howth</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar howth" style="width: 3%"></div>
          </div>
          <span class="benchmark-time">00.14s</span>
        </div>
        <div class="benchmark-row" style="margin-bottom: 1.5rem;">
          <span class="benchmark-label" style="width: 100px;">Bun</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar other" style="width: 9%; position: relative;">
              <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">2.6x slower</span>
            </div>
          </div>
          <span class="benchmark-time">00.37s</span>
        </div>
        <div class="benchmark-row" style="margin-bottom: 1.5rem;">
          <span class="benchmark-label" style="width: 100px;">Vitest</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar other" style="width: 35%; position: relative;">
              <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">10x slower</span>
            </div>
          </div>
          <span class="benchmark-time">01.40s</span>
        </div>
        <div class="benchmark-row" style="margin-bottom: 1.5rem;">
          <span class="benchmark-label" style="width: 100px;">Jest+SWC</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar other" style="width: 75%; position: relative;">
              <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">22x slower</span>
            </div>
          </div>
          <span class="benchmark-time">03.07s</span>
        </div>
        <div class="benchmark-row">
          <span class="benchmark-label" style="width: 100px;">node --test</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar other" style="width: 100%; position: relative;">
              <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">29x slower</span>
            </div>
          </div>
          <span class="benchmark-time">04.08s</span>
        </div>
      </div>

      <div style="display: flex; align-items: center; justify-content: center; gap: 1rem; flex-wrap: wrap;">
        <span>Replace <code style="background: var(--howth-bg-elevated); padding: 0.25rem 0.5rem; border-radius: 4px;">jest</code> with <code style="background: var(--howth-bg-elevated); padding: 0.25rem 0.5rem; border-radius: 4px;">howth test</code> to run your tests 10-30x faster.</span>
        <a href="/guide/getting-started" class="learn-card" style="display: inline-flex; padding: 0.75rem 1.5rem; background: transparent; border: 1px solid var(--howth-border);">
          Try it &rarr;
        </a>
      </div>
    </section>

    <!-- Section 4: Built-in APIs & Primitives -->
    <section class="homepage-section">
      <h2 class="section-title">The APIs you need. Baked in.</h2>

      <div class="api-chips">
        <button
          v-for="api in apis"
          :key="api"
          class="api-chip"
          :class="{ active: activeApi === api }"
          @click="activeApi = api"
        >
          {{ api }}
        </button>
      </div>

      <div class="code-block">
        <div class="code-block-header">
          <span class="code-block-filename">index.ts</span>
          <button class="copy-btn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
              <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
            </svg>
          </button>
        </div>
        <pre><code><span class="keyword">import</span> { createServer } <span class="keyword">from</span> <span class="string">'node:http'</span>;

<span class="keyword">const</span> server = <span class="function">createServer</span>(<span class="keyword">async</span> (req, res) =&gt; {
  <span class="keyword">if</span> (req.url === <span class="string">'/'</span>) {
    res.<span class="function">writeHead</span>(<span class="number">200</span>, { <span class="string">'Content-Type'</span>: <span class="string">'text/plain'</span> });
    res.<span class="function">end</span>(<span class="string">'Welcome to howth!'</span>);
  }

  <span class="keyword">if</span> (req.url === <span class="string">'/api/users'</span>) {
    <span class="keyword">const</span> users = [{ <span class="property">id</span>: <span class="number">1</span>, <span class="property">name</span>: <span class="string">'Alice'</span> }];
    res.<span class="function">writeHead</span>(<span class="number">200</span>, { <span class="string">'Content-Type'</span>: <span class="string">'application/json'</span> });
    res.<span class="function">end</span>(JSON.<span class="function">stringify</span>(users));
  }
});

server.<span class="function">listen</span>(<span class="number">3000</span>);
console.<span class="function">log</span>(<span class="string">'Listening on http://localhost:3000'</span>);</code></pre>
      </div>
    </section>

    <!-- Section 5: Everything You Need to Build & Ship -->
    <section class="homepage-section" style="background: var(--howth-bg-card);">
      <h2 class="section-title">Everything you need to build & ship</h2>
      <p class="section-subtitle">Production-ready APIs and tools, built into howth</p>

      <div class="capability-grid">
        <div class="capability-category">
          <h3 class="capability-category-title">
            <span>HTTP & WebSockets</span>
          </h3>
          <div class="capability-list">
            <div class="capability-item">
              <span class="capability-name">http.createServer()</span>
              <span class="capability-desc">HTTP & HTTPS server</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">WebSocket</span>
              <span class="capability-desc">WebSocket client & server</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">fetch()</span>
              <span class="capability-desc">Web standard fetch API</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">Howth.Cookie</span>
              <span class="capability-desc">Zero-overhead cookie parsing</span>
            </div>
          </div>
        </div>

        <div class="capability-category">
          <h3 class="capability-category-title">
            <span>File System</span>
          </h3>
          <div class="capability-list">
            <div class="capability-item">
              <span class="capability-name">fs.readFile()</span>
              <span class="capability-desc">Fast file reading & streaming</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">fs.writeFile()</span>
              <span class="capability-desc">Write files efficiently</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">Howth.Glob</span>
              <span class="capability-desc">Fast file pattern matching</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">path.*</span>
              <span class="capability-desc">Path manipulation utilities</span>
            </div>
          </div>
        </div>

        <div class="capability-category">
          <h3 class="capability-category-title">
            <span>Testing</span>
          </h3>
          <div class="capability-list">
            <div class="capability-item">
              <span class="capability-name">howth test</span>
              <span class="capability-desc">Jest-compatible test runner</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">snapshots</span>
              <span class="capability-desc">Snapshot testing built-in</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">expect()</span>
              <span class="capability-desc">Jest-compatible assertions</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">--coverage</span>
              <span class="capability-desc">Built-in code coverage</span>
            </div>
          </div>
        </div>

        <div class="capability-category">
          <h3 class="capability-category-title">
            <span>Build & Deploy</span>
          </h3>
          <div class="capability-list">
            <div class="capability-item">
              <span class="capability-name">howth bundle</span>
              <span class="capability-desc">Fast bundler with tree-shaking</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">--compile</span>
              <span class="capability-desc">Single-file executables</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">--hot</span>
              <span class="capability-desc">Hot reload without restarts</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">howth dev</span>
              <span class="capability-desc">Development server with HMR</span>
            </div>
          </div>
        </div>

        <div class="capability-category">
          <h3 class="capability-category-title">
            <span>TypeScript & DX</span>
          </h3>
          <div class="capability-list">
            <div class="capability-item">
              <span class="capability-name">TypeScript & JSX</span>
              <span class="capability-desc">No config required</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">import "*.yaml"</span>
              <span class="capability-desc">YAML & TOML imports</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">import "*.css"</span>
              <span class="capability-desc">CSS & asset imports</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">.env</span>
              <span class="capability-desc">Environment variables</span>
            </div>
          </div>
        </div>

        <div class="capability-category">
          <h3 class="capability-category-title">
            <span>Utilities</span>
          </h3>
          <div class="capability-list">
            <div class="capability-item">
              <span class="capability-name">Howth.hash()</span>
              <span class="capability-desc">Fast hashing utilities</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">Howth.semver</span>
              <span class="capability-desc">Version comparison</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">Howth.markdown()</span>
              <span class="capability-desc">CommonMark/GFM parsing</span>
            </div>
            <div class="capability-item">
              <span class="capability-name">crypto.*</span>
              <span class="capability-desc">Cryptographic APIs</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Section 6: Runtime Philosophy & Architecture -->
    <section class="homepage-section">
      <div class="terminal" style="max-width: 300px;">
        <div class="terminal-header">
          <span class="terminal-dot red"></span>
          <span class="terminal-dot yellow"></span>
          <span class="terminal-dot green"></span>
        </div>
        <div class="terminal-content">
          <span class="prompt">$</span> howth run
        </div>
      </div>

      <h2 class="section-title" style="margin-top: 2rem;">howth is a JavaScript runtime.</h2>

      <div class="philosophy-content">
        <div class="philosophy-text">
          <p style="color: var(--howth-text-muted); margin-bottom: 1.5rem; font-size: 1.0625rem; line-height: 1.7;">
            howth is a new JavaScript runtime built from scratch to serve the modern JavaScript ecosystem.
            It has three major design goals:
          </p>

          <div class="philosophy-points">
            <div class="philosophy-point">
              <h4>Speed.</h4>
              <p>howth starts fast and runs fast. It uses V8 via deno_core and hyper for HTTP.
                 A persistent daemon keeps compilers warm. Fast start times mean fast apps and fast APIs.</p>
            </div>
            <div class="philosophy-point">
              <h4>Elegant APIs.</h4>
              <p>howth provides a minimal set of highly-optimized APIs for common tasks,
                 like starting an HTTP server and writing files.</p>
            </div>
            <div class="philosophy-point">
              <h4>Cohesive DX.</h4>
              <p>howth is a complete toolkit for building JavaScript apps, including a package manager,
                 test runner, bundler, and dev server.</p>
            </div>
          </div>

          <p style="color: var(--howth-text-muted); margin-top: 1.5rem; font-size: 0.9375rem; line-height: 1.7;">
            howth is designed as a drop-in replacement for Node.js. It natively implements many Node.js
            and Web APIs, including <code>fs</code>, <code>path</code>, <code>Buffer</code>, and more.
          </p>
        </div>

        <div class="philosophy-code">
          <pre style="font-family: 'JetBrains Mono', monospace; font-size: 0.875rem; line-height: 1.6;"><code><span class="comment">// Run any TypeScript directly</span>
<span class="keyword">import</span> { readFile } <span class="keyword">from</span> <span class="string">'node:fs/promises'</span>;

<span class="keyword">const</span> content = <span class="keyword">await</span> <span class="function">readFile</span>(<span class="string">'./data.json'</span>, <span class="string">'utf-8'</span>);
<span class="keyword">const</span> data = JSON.<span class="function">parse</span>(content);

console.<span class="function">log</span>(data);

<span class="comment">// Works with npm packages</span>
<span class="keyword">import</span> express <span class="keyword">from</span> <span class="string">'express'</span>;

<span class="keyword">const</span> app = <span class="function">express</span>();
app.<span class="function">get</span>(<span class="string">'/'</span>, (req, res) =&gt; {
  res.<span class="function">send</span>(<span class="string">'Hello from howth!'</span>);
});
app.<span class="function">listen</span>(<span class="number">3000</span>);</code></pre>
        </div>
      </div>
    </section>

    <!-- Section 7: Package Manager -->
    <section class="homepage-section" style="background: var(--howth-bg-card);">
      <div class="terminal" style="max-width: 350px;">
        <div class="terminal-header">
          <span class="terminal-dot red"></span>
          <span class="terminal-dot yellow"></span>
          <span class="terminal-dot green"></span>
        </div>
        <div class="terminal-content">
          <span class="prompt">$</span> howth install
        </div>
      </div>

      <h2 class="section-title" style="margin-top: 2rem;">howth is an npm-compatible package manager.</h2>

      <div style="max-width: 700px; margin: 3rem auto;">
        <div class="benchmark-row" style="margin-bottom: 1.5rem;">
          <span class="benchmark-label" style="width: 100px;">howth</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar howth" style="width: 3%"></div>
          </div>
          <span class="benchmark-time">00.36s</span>
        </div>
        <div class="benchmark-row" style="margin-bottom: 1.5rem;">
          <span class="benchmark-label" style="width: 100px;">pnpm</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar other" style="width: 53%; position: relative;">
              <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">17x slower</span>
            </div>
          </div>
          <span class="benchmark-time">06.44s</span>
        </div>
        <div class="benchmark-row" style="margin-bottom: 1.5rem;">
          <span class="benchmark-label" style="width: 100px;">npm</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar other" style="width: 88%; position: relative;">
              <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">29x slower</span>
            </div>
          </div>
          <span class="benchmark-time">10.58s</span>
        </div>
        <div class="benchmark-row">
          <span class="benchmark-label" style="width: 100px;">Yarn</span>
          <div class="benchmark-bar-container">
            <div class="benchmark-bar other" style="width: 100%; position: relative;">
              <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">33x slower</span>
            </div>
          </div>
          <span class="benchmark-time">12.08s</span>
        </div>
        <p style="text-align: center; color: var(--howth-text-dim); font-size: 0.875rem; margin-top: 1.5rem;">
          Installing dependencies from cache for a React app.
        </p>
      </div>

      <div style="display: flex; align-items: center; justify-content: center; gap: 1rem; flex-wrap: wrap;">
        <span>Replace <code style="background: var(--howth-bg-elevated); padding: 0.25rem 0.5rem; border-radius: 4px;">npm</code> with <code style="background: var(--howth-bg-elevated); padding: 0.25rem 0.5rem; border-radius: 4px;">howth install</code> to get 30x faster package installs.</span>
        <a href="/guide/getting-started" class="learn-card" style="display: inline-flex; padding: 0.75rem 1.5rem; background: transparent; border: 1px solid var(--howth-border);">
          Try it &rarr;
        </a>
      </div>
    </section>

    <!-- Section 8: Competitive Differentiation Matrix -->
    <section class="homepage-section">
      <h2 class="section-title">What's different about howth?</h2>
      <p class="section-subtitle">howth provides extensive builtin APIs and tooling</p>

      <div style="overflow-x: auto;">
        <table class="comparison-table">
          <thead>
            <tr>
              <th style="min-width: 300px;">Builtin Core Features</th>
              <th style="text-align: center; width: 80px;">howth</th>
              <th style="text-align: center; width: 80px;">Node</th>
              <th style="text-align: center; width: 80px;">Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <div class="feature-name">Node.js compatibility</div>
                <div class="feature-desc">Aiming to be a drop-in replacement for Node.js apps</div>
              </td>
              <td style="text-align: center;"><span class="partial">~85%</span></td>
              <td style="text-align: center;"><span class="check">100%</span></td>
              <td style="text-align: center;"><span class="partial">~95%</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Web Standard APIs</div>
                <div class="feature-desc">Support for fetch, URL, EventTarget, Headers, etc.</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">TypeScript</div>
                <div class="feature-desc">First-class support, including paths and namespace</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="partial">Exp.</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">JSX</div>
                <div class="feature-desc">First-class support without configuration</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
          </tbody>
          <thead>
            <tr>
              <th>Builtin APIs</th>
              <th style="text-align: center;">howth</th>
              <th style="text-align: center;">Node</th>
              <th style="text-align: center;">Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <div class="feature-name">HTTP server</div>
                <div class="feature-desc">Lightning-fast HTTP server built-in</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">WebSocket server</div>
                <div class="feature-desc">WebSocket server with pub/sub support</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Cookies API</div>
                <div class="feature-desc">Parse and set cookies with zero overhead</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Markdown parser</div>
                <div class="feature-desc">Built-in CommonMark/GFM Markdown parsing</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
          </tbody>
          <thead>
            <tr>
              <th>Builtin Tooling</th>
              <th style="text-align: center;">howth</th>
              <th style="text-align: center;">Node</th>
              <th style="text-align: center;">Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <div class="feature-name">npm package management</div>
                <div class="feature-desc">Install, manage, and publish npm-compatible dependencies</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Bundler</div>
                <div class="feature-desc">Build production-ready code for frontend & backend</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Jest-compatible test runner</div>
                <div class="feature-desc">Testing library compatible with Jest</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Frontend Development Server</div>
                <div class="feature-desc">Run modern frontend apps with HMR</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Persistent daemon</div>
                <div class="feature-desc">Background process for instant warm starts</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Section 9: Learn More / Education CTA -->
    <section class="homepage-section" style="background: var(--howth-bg-card);">
      <h2 class="section-title">Learn more</h2>

      <div class="learn-cards">
        <a href="/guide/getting-started" class="learn-card">
          <div class="learn-card-title">
            Documentation
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M5 12h14M12 5l7 7-7 7"/>
            </svg>
          </div>
          <p class="learn-card-desc">Get started with howth and learn how to use all of its features</p>
        </a>

        <a href="/reference/node-api-compat" class="learn-card">
          <div class="learn-card-title">
            API Reference
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M5 12h14M12 5l7 7-7 7"/>
            </svg>
          </div>
          <p class="learn-card-desc">Explore the complete API reference for howth's runtime and toolkit</p>
        </a>
      </div>
    </section>

    <!-- Section 10: Footer -->
    <footer class="site-footer">
      <div class="footer-grid">
        <div class="footer-column">
          <h4 class="footer-column-title">Resources</h4>
          <div class="footer-links">
            <a href="/reference/node-api-compat" class="footer-link">Reference</a>
            <a href="/guide/getting-started" class="footer-link">Docs</a>
            <a href="/guide/examples" class="footer-link">Guides</a>
            <a href="https://github.com/jschatz1/howth/discussions" class="footer-link">Discussions</a>
            <a href="https://github.com/jschatz1/howth" class="footer-link">GitHub</a>
          </div>
        </div>

        <div class="footer-column">
          <h4 class="footer-column-title">Toolkit</h4>
          <div class="footer-links">
            <a href="/guide/architecture" class="footer-link">Runtime</a>
            <a href="/guide/cli-reference#install" class="footer-link">Package manager</a>
            <a href="/guide/cli-reference#test" class="footer-link">Test runner</a>
            <a href="/guide/cli-reference#bundle" class="footer-link">Bundler</a>
            <a href="/guide/cli-reference#dev" class="footer-link">Dev server</a>
          </div>
        </div>

        <div class="footer-column">
          <h4 class="footer-column-title">Project</h4>
          <div class="footer-links">
            <a href="https://github.com/jschatz1/howth/releases" class="footer-link">Releases</a>
            <a href="https://github.com/jschatz1/howth/blob/main/ROADMAP.md" class="footer-link">Roadmap</a>
            <a href="https://github.com/jschatz1/howth/blob/main/CONTRIBUTING.md" class="footer-link">Contributing</a>
            <a href="https://github.com/jschatz1/howth/blob/main/LICENSE" class="footer-link">License</a>
          </div>
        </div>
      </div>

      <div class="footer-bottom">
        <p>Released under the MIT License.</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
/* Component-specific styles are in custom.css */
</style>
