<script setup lang="ts">
import { ref } from 'vue'

// Install tab state
const installTab = ref<'unix' | 'windows'>('unix')

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
            The <span class="highlight">fastest</span> JavaScript<br/>
            test runner
          </h1>

          <p class="hero-description">
            howth runs tests <strong>2.6x faster than Bun</strong> and <strong>29x faster than Node</strong>.
            A persistent daemon keeps V8 and compilers warm in memory, eliminating startup cost entirely.
            Drop <code>howth test</code> into any Node.js project today.
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
          <div class="benchmark-chart">
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
                <div class="benchmark-bar other" style="width: 9%; position: relative;">
                  <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">2.6x slower</span>
                </div>
              </div>
              <span class="benchmark-time">368 ms</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">Vitest</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 35%; position: relative;">
                  <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">10x slower</span>
                </div>
              </div>
              <span class="benchmark-time">1.4s</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">Jest+SWC</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 75%; position: relative;">
                  <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">22x slower</span>
                </div>
              </div>
              <span class="benchmark-time">3.07s</span>
            </div>
            <div class="benchmark-row">
              <span class="benchmark-label">node --test</span>
              <div class="benchmark-bar-container">
                <div class="benchmark-bar other" style="width: 100%; position: relative;">
                  <span style="position: absolute; left: 100%; padding-left: 8px; color: var(--howth-text-dim); font-size: 0.75rem; white-space: nowrap;">29x slower</span>
                </div>
              </div>
              <span class="benchmark-time">4.08s</span>
            </div>

            <p style="text-align: center; color: var(--howth-text-dim); font-size: 0.75rem; margin-top: 1.5rem;">
              <a href="/guide/getting-started" style="color: var(--howth-primary-light);">View benchmark methodology &rarr;</a>
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Section 2: The Daemon Architecture (Key Differentiator) -->
    <section class="homepage-section" style="background: var(--howth-bg-card);">
      <h2 class="section-title">Zero startup cost. Every time.</h2>
      <p class="section-subtitle">
        howth's persistent daemon keeps compilers, caches, and a V8 runtime warm in memory.
        After the first run, every command is instant.
      </p>

      <div class="daemon-comparison">
        <div class="daemon-card">
          <h3 style="color: var(--howth-text-dim); font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 1rem;">Traditional runtimes</h3>
          <div class="daemon-flow">
            <div class="daemon-step">Start process</div>
            <div class="daemon-arrow">&rarr;</div>
            <div class="daemon-step">Load V8/JSC</div>
            <div class="daemon-arrow">&rarr;</div>
            <div class="daemon-step">Parse TypeScript</div>
            <div class="daemon-arrow">&rarr;</div>
            <div class="daemon-step">Transpile</div>
            <div class="daemon-arrow">&rarr;</div>
            <div class="daemon-step">Execute</div>
          </div>
          <p style="color: var(--howth-text-dim); font-size: 0.875rem; margin-top: 1rem;">
            Every command pays full startup cost. Cold start every time.
          </p>
        </div>

        <div class="daemon-card" style="border-color: var(--howth-primary); background: rgba(59, 130, 246, 0.05);">
          <h3 style="color: var(--howth-primary-light); font-size: 0.875rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 1rem;">howth daemon</h3>
          <div class="daemon-flow">
            <div class="daemon-step" style="background: var(--howth-primary); border-color: var(--howth-primary);">IPC message</div>
            <div class="daemon-arrow">&rarr;</div>
            <div class="daemon-step" style="background: var(--howth-primary); border-color: var(--howth-primary);">Execute</div>
          </div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-top: 1rem;">
            V8 is already running. Compilers are warm. Caches are hot. Just execute.
          </p>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin-top: 3rem;">
        <div style="text-align: center;">
          <div style="font-size: 2.5rem; font-weight: 700; color: var(--howth-primary-light);">0.1ms</div>
          <div style="color: var(--howth-text-muted); font-size: 0.875rem;">Warm transpile time</div>
        </div>
        <div style="text-align: center;">
          <div style="font-size: 2.5rem; font-weight: 700; color: var(--howth-primary-light);">1</div>
          <div style="color: var(--howth-text-muted); font-size: 0.875rem;">Unix socket round-trip per command</div>
        </div>
        <div style="text-align: center;">
          <div style="font-size: 2.5rem; font-weight: 700; color: var(--howth-primary-light);">780x</div>
          <div style="color: var(--howth-text-muted); font-size: 0.875rem;">Faster than tsc</div>
        </div>
      </div>
    </section>

    <!-- Section 3: Unified Toolkit Overview -->
    <section class="homepage-section">
      <h2 class="section-title">Start with tests. Adopt the rest incrementally.</h2>
      <p class="section-subtitle">
        Drop <code>howth test</code> into any Node.js project today. No migration required.
        When you're ready, adopt the runtime, bundler, and package manager one at a time.
      </p>

      <div class="toolkit-grid">
        <div class="toolkit-card" style="border-color: var(--howth-primary); background: rgba(59, 130, 246, 0.03);">
          <div class="toolkit-card-header">
            <div>
              <h3 class="toolkit-card-title">Test Runner</h3>
              <span class="toolkit-badge" style="background: var(--howth-primary);">2.6x faster than Bun</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth test</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            The fastest JavaScript test runner. Jest-compatible API, works in any Node.js project.
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
              <h3 class="toolkit-card-title">JavaScript Runtime</h3>
              <span class="toolkit-badge">85% Node.js compatible</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth run ./index.ts</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            Run TypeScript directly. Daemon keeps everything warm for instant execution.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">Node.js API compatibility</span>
            <span class="toolkit-feature">TypeScript, JSX & React</span>
            <span class="toolkit-feature">Hot & watch mode built-in</span>
            <span class="toolkit-feature">Environment variables</span>
            <span class="toolkit-feature">Web standard APIs</span>
            <span class="toolkit-feature">172K HTTP req/s</span>
          </div>
        </div>

        <div class="toolkit-card">
          <div class="toolkit-card-header">
            <div>
              <h3 class="toolkit-card-title">Package Manager</h3>
              <span class="toolkit-badge">30x faster than npm</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth install</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            Drop-in npm replacement with global cache and workspaces.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">Works with package.json</span>
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
              <h3 class="toolkit-card-title">Bundler</h3>
              <span class="toolkit-badge">Tree shaking & splitting</span>
            </div>
          </div>
          <div class="toolkit-command"><span class="prompt">$</span> howth bundle ./app.tsx</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem; margin-bottom: 1rem;">
            Bundle TypeScript, JSX, React & CSS for browsers and servers.
          </p>
          <div class="toolkit-features">
            <span class="toolkit-feature">TypeScript & JSX built-in</span>
            <span class="toolkit-feature">CSS imports & bundling</span>
            <span class="toolkit-feature">React support out of the box</span>
            <span class="toolkit-feature">Tree shaking</span>
            <span class="toolkit-feature">Code splitting</span>
            <span class="toolkit-feature">Minification</span>
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
            Development server with instant hot module replacement.
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

    <!-- Section 3: Why the Daemon Matters -->
    <section class="homepage-section" style="background: var(--howth-bg-card);">
      <h2 class="section-title">Built for iterative development</h2>
      <p class="section-subtitle">
        In a typical dev session, you run tests hundreds of times. howth gets faster with each run.
      </p>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 2rem; margin-top: 3rem;">
        <div style="background: var(--howth-bg-dark); border: 1px solid var(--howth-border); border-radius: 0.75rem; padding: 1.5rem;">
          <div style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--howth-text-dim); margin-bottom: 0.75rem;">First run</div>
          <div style="font-size: 2rem; font-weight: 700; color: var(--howth-text); margin-bottom: 0.5rem;">~200ms</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem;">Daemon starts, V8 initializes, compilers warm up. Still fast.</p>
        </div>
        <div style="background: rgba(59, 130, 246, 0.05); border: 1px solid var(--howth-primary); border-radius: 0.75rem; padding: 1.5rem;">
          <div style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--howth-primary-light); margin-bottom: 0.75rem;">Every run after</div>
          <div style="font-size: 2rem; font-weight: 700; color: var(--howth-primary-light); margin-bottom: 0.5rem;">~139ms</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem;">V8 is already running. Caches are hot. Just execute your code.</p>
        </div>
        <div style="background: var(--howth-bg-dark); border: 1px solid var(--howth-border); border-radius: 0.75rem; padding: 1.5rem;">
          <div style="font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--howth-text-dim); margin-bottom: 0.75rem;">Changed file only</div>
          <div style="font-size: 2rem; font-weight: 700; color: var(--howth-accent); margin-bottom: 0.5rem;">~50ms</div>
          <p style="color: var(--howth-text-muted); font-size: 0.875rem;">Only re-transpile what changed. Unchanged modules stay cached.</p>
        </div>
      </div>

      <div style="text-align: center; margin-top: 3rem;">
        <p style="color: var(--howth-text-muted); max-width: 600px; margin: 0 auto;">
          Over a day of development with 500 test runs, howth saves you <strong style="color: var(--howth-primary-light);">~2 minutes</strong> of waiting
          compared to Bun and <strong style="color: var(--howth-primary-light);">~30 minutes</strong> compared to Jest.
        </p>
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

    <!-- Section 7: Easy Migration -->
    <section class="homepage-section" style="background: var(--howth-bg-card);">
      <h2 class="section-title">Try it in 30 seconds</h2>
      <p class="section-subtitle">
        No migration needed. Just run one command in your existing project.
      </p>

      <div class="code-block" style="max-width: 600px; margin: 0 auto;">
        <div class="code-block-header">
          <span class="code-block-filename">Your existing Node.js project</span>
        </div>
        <pre><code><span class="comment"># Install howth</span>
curl -fsSL https://howth.run/install | sh

<span class="comment"># Run your tests with howth (works with Jest syntax)</span>
howth test

<span class="comment"># That's it. No config changes needed.</span>
<span class="comment"># Your existing test files just work.</span></code></pre>
      </div>

      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-top: 3rem; max-width: 800px; margin-left: auto; margin-right: auto;">
        <div style="text-align: center;">
          <div style="font-size: 1.5rem; margin-bottom: 0.5rem;">
            <span class="check">Yes</span>
          </div>
          <div style="color: var(--howth-text-muted); font-size: 0.875rem;">Works with package.json</div>
        </div>
        <div style="text-align: center;">
          <div style="font-size: 1.5rem; margin-bottom: 0.5rem;">
            <span class="check">Yes</span>
          </div>
          <div style="color: var(--howth-text-muted); font-size: 0.875rem;">Works with node_modules</div>
        </div>
        <div style="text-align: center;">
          <div style="font-size: 1.5rem; margin-bottom: 0.5rem;">
            <span class="check">Yes</span>
          </div>
          <div style="color: var(--howth-text-muted); font-size: 0.875rem;">Works with Jest tests</div>
        </div>
        <div style="text-align: center;">
          <div style="font-size: 1.5rem; margin-bottom: 0.5rem;">
            <span class="check">Yes</span>
          </div>
          <div style="color: var(--howth-text-muted); font-size: 0.875rem;">Works with TypeScript</div>
        </div>
      </div>
    </section>

    <!-- Section 8: Competitive Differentiation Matrix -->
    <section class="homepage-section">
      <h2 class="section-title">What's different about howth?</h2>
      <p class="section-subtitle">A unique architecture that no other runtime has</p>

      <div style="overflow-x: auto;">
        <table class="comparison-table">
          <thead>
            <tr>
              <th style="min-width: 300px;">Architecture</th>
              <th style="text-align: center; width: 80px;">howth</th>
              <th style="text-align: center; width: 80px;">Node</th>
              <th style="text-align: center; width: 80px;">Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr style="background: rgba(59, 130, 246, 0.05);">
              <td>
                <div class="feature-name">Persistent daemon</div>
                <div class="feature-desc">Background process keeps runtime warm - zero startup cost</div>
              </td>
              <td style="text-align: center;"><span class="check" style="font-weight: 600;">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
            </tr>
            <tr style="background: rgba(59, 130, 246, 0.05);">
              <td>
                <div class="feature-name">In-memory module cache</div>
                <div class="feature-desc">Transpiled modules stay in memory across runs</div>
              </td>
              <td style="text-align: center;"><span class="check" style="font-weight: 600;">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
            </tr>
            <tr style="background: rgba(59, 130, 246, 0.05);">
              <td>
                <div class="feature-name">IPC-based execution</div>
                <div class="feature-desc">Commands execute via Unix socket, no process spawn</div>
              </td>
              <td style="text-align: center;"><span class="check" style="font-weight: 600;">Yes</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
              <td style="text-align: center;"><span class="cross">No</span></td>
            </tr>
          </tbody>
          <thead>
            <tr>
              <th>Performance</th>
              <th style="text-align: center;">howth</th>
              <th style="text-align: center;">Node</th>
              <th style="text-align: center;">Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <div class="feature-name">Test runner (10K tests)</div>
                <div class="feature-desc">Jest-compatible test execution</div>
              </td>
              <td style="text-align: center;"><span class="check" style="font-weight: 600;">139ms</span></td>
              <td style="text-align: center;"><span class="partial">4.08s</span></td>
              <td style="text-align: center;"><span class="partial">368ms</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Warm transpile</div>
                <div class="feature-desc">TypeScript to JavaScript after daemon warm</div>
              </td>
              <td style="text-align: center;"><span class="check" style="font-weight: 600;">0.1ms</span></td>
              <td style="text-align: center;"><span class="partial">N/A</span></td>
              <td style="text-align: center;"><span class="partial">~5ms</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">HTTP throughput</div>
                <div class="feature-desc">Requests per second (50 connections)</div>
              </td>
              <td style="text-align: center;"><span class="partial">172K</span></td>
              <td style="text-align: center;"><span class="partial">111K</span></td>
              <td style="text-align: center;"><span class="check">211K</span></td>
            </tr>
          </tbody>
          <thead>
            <tr>
              <th>Compatibility</th>
              <th style="text-align: center;">howth</th>
              <th style="text-align: center;">Node</th>
              <th style="text-align: center;">Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <div class="feature-name">Node.js API coverage</div>
                <div class="feature-desc">Percentage of Node.js APIs implemented</div>
              </td>
              <td style="text-align: center;"><span class="partial">~85%</span></td>
              <td style="text-align: center;"><span class="check">100%</span></td>
              <td style="text-align: center;"><span class="check">~95%</span></td>
            </tr>
            <tr>
              <td>
                <div class="feature-name">Works in existing Node.js projects</div>
                <div class="feature-desc">Drop-in usage without migration</div>
              </td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
              <td style="text-align: center;"><span class="check">Yes</span></td>
            </tr>
          </tbody>
        </table>
      </div>

      <div style="text-align: center; margin-top: 2rem;">
        <p style="color: var(--howth-text-muted); font-size: 0.9375rem;">
          howth's daemon architecture means the more you use it, the faster it gets.
          Other runtimes pay startup cost every single time.
        </p>
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
