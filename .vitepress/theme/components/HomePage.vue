<script setup lang="ts">
import { ref } from 'vue'

const installMethod = ref<'shell' | 'npm'>('shell')
const installTab = ref<'unix' | 'windows'>('unix')
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

function currentInstallCommand() {
  if (installMethod.value === 'npm') return 'npm i -g howth'
  return installTab.value === 'unix'
    ? 'curl -fsSL https://howth.run/install.sh | sh'
    : 'powershell -c "irm howth.run/install.ps1 | iex"'
}

function copyInstallCommand() {
  navigator.clipboard.writeText(currentInstallCommand())
}
</script>

<template>
  <div class="homepage">
    <!-- Hero: Full width, terminal-centric -->
    <section class="hero-section">
      <div class="hero-terminal">
        <div class="terminal-chrome">
          <span class="terminal-dot"></span>
          <span class="terminal-dot"></span>
          <span class="terminal-dot"></span>
          <span class="terminal-title">howth</span>
        </div>
        <div class="terminal-body">
          <div class="terminal-line">
            <span class="prompt">$</span> howth test
          </div>
          <div class="terminal-output">
            <span class="dim">Running 10,000 tests across 500 files...</span>
          </div>
          <div class="terminal-output result">
            <span class="success">PASS</span> All tests passed in <span class="highlight">139ms</span>
          </div>
        </div>
      </div>

      <h1 class="hero-title">
        A fast JavaScript toolkit.<br/>
        <span class="hero-subtitle">Runtime. Bundler. Test runner. One binary.</span>
      </h1>

      <p class="hero-desc">
        A persistent daemon keeps V8, compilers, and caches warm in memory.
        Tests run <strong>2.6x faster than Bun</strong>. Drop into any Node.js project today.
      </p>

      <div class="install-box">
        <div class="install-method-tabs">
          <button :class="{ active: installMethod === 'shell' }" @click="installMethod = 'shell'">Shell</button>
          <button :class="{ active: installMethod === 'npm' }" @click="installMethod = 'npm'">npm</button>
        </div>
        <div v-if="installMethod === 'shell'" class="install-tabs">
          <button :class="{ active: installTab === 'unix' }" @click="installTab = 'unix'">Linux & macOS</button>
          <button :class="{ active: installTab === 'windows' }" @click="installTab = 'windows'">Windows</button>
        </div>
        <div class="install-cmd">
          <span class="prompt">$</span>
          <code>{{ currentInstallCommand() }}</code>
          <button class="copy-btn" @click="copyInstallCommand">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <rect x="9" y="9" width="13" height="13" rx="2"></rect>
              <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
            </svg>
          </button>
        </div>
      </div>

      <div class="built-with">
        <span class="built-label">Built with</span>
        <span class="tech">Rust</span>
        <span class="tech">V8</span>
        <span class="tech">deno_core</span>
        <span class="tech">hyper</span>
      </div>
    </section>

    <!-- Bundler Benchmark: Horizontal bar graph -->
    <section class="graph-section">
      <h2>Bundler</h2>
      <p class="section-desc">10,000 React components &mdash; Linux x64 (c3-highcpu-8)</p>

      <div class="bar-graph">
        <div class="bar-row winner">
          <span class="bar-label">howth</span>
          <div class="bar-track">
            <div class="bar-fill howth-bar" style="width: 9.9%"></div>
          </div>
          <span class="bar-value">290ms <small>(4.12 MB)</small></span>
        </div>
        <div class="bar-row">
          <span class="bar-label">Bun</span>
          <div class="bar-track">
            <div class="bar-fill" style="width: 18.5%"></div>
          </div>
          <span class="bar-value">541ms</span>
        </div>
        <div class="bar-row">
          <span class="bar-label">esbuild</span>
          <div class="bar-track">
            <div class="bar-fill" style="width: 37.2%"></div>
          </div>
          <span class="bar-value">1,090ms</span>
        </div>
        <div class="bar-row">
          <span class="bar-label">Rolldown</span>
          <div class="bar-track">
            <div class="bar-fill" style="width: 40.2%"></div>
          </div>
          <span class="bar-value">1,179ms</span>
        </div>
        <div class="bar-row">
          <span class="bar-label">Vite</span>
          <div class="bar-track">
            <div class="bar-fill" style="width: 52.2%"></div>
          </div>
          <span class="bar-value">1,530ms</span>
        </div>
        <div class="bar-row">
          <span class="bar-label">Rsbuild</span>
          <div class="bar-track">
            <div class="bar-fill" style="width: 94.7%"></div>
          </div>
          <span class="bar-value">2,775ms</span>
        </div>
        <div class="bar-row">
          <span class="bar-label">rspack</span>
          <div class="bar-track">
            <div class="bar-fill" style="width: 100%"></div>
          </div>
          <span class="bar-value">2,930ms</span>
        </div>
      </div>

      <a href="https://github.com/jschatz1/benchmarks" class="benchmark-link">Fork of rolldown/benchmarks &mdash; View source &amp; methodology →</a>
    </section>

    <!-- Test Runner Benchmark: Stacked cards -->
    <section class="benchmarks-section">
      <h2>Running 10,000 tests</h2>
      <p class="section-desc">Apple M3 Pro, 500 test files</p>

      <div class="benchmark-stack">
        <div class="benchmark-card winner">
          <div class="benchmark-rank">1</div>
          <div class="benchmark-info">
            <span class="benchmark-name">howth</span>
            <span class="benchmark-time">139ms</span>
          </div>
          <div class="benchmark-badge">fastest</div>
        </div>
        <div class="benchmark-card">
          <div class="benchmark-rank">2</div>
          <div class="benchmark-info">
            <span class="benchmark-name">Bun</span>
            <span class="benchmark-time">368ms</span>
          </div>
          <div class="benchmark-diff">2.6x slower</div>
        </div>
        <div class="benchmark-card">
          <div class="benchmark-rank">3</div>
          <div class="benchmark-info">
            <span class="benchmark-name">Vitest</span>
            <span class="benchmark-time">1.4s</span>
          </div>
          <div class="benchmark-diff">10x slower</div>
        </div>
        <div class="benchmark-card">
          <div class="benchmark-rank">4</div>
          <div class="benchmark-info">
            <span class="benchmark-name">Jest + SWC</span>
            <span class="benchmark-time">3.07s</span>
          </div>
          <div class="benchmark-diff">22x slower</div>
        </div>
        <div class="benchmark-card">
          <div class="benchmark-rank">5</div>
          <div class="benchmark-info">
            <span class="benchmark-name">node --test</span>
            <span class="benchmark-time">4.08s</span>
          </div>
          <div class="benchmark-diff">29x slower</div>
        </div>
      </div>

      <a href="https://github.com/jschatz1/benchmarks" class="benchmark-link">View methodology →</a>
    </section>

    <!-- The Daemon: Before/After comparison -->
    <section class="daemon-section">
      <h2>Zero startup cost. Every time.</h2>
      <p class="section-desc">
        howth's persistent daemon keeps compilers, caches, and V8 warm in memory.
      </p>

      <div class="daemon-compare">
        <div class="daemon-before">
          <div class="daemon-label">Traditional runtimes</div>
          <div class="daemon-steps">
            <div class="step">Start process</div>
            <div class="step">Load V8/JSC</div>
            <div class="step">Parse TypeScript</div>
            <div class="step">Transpile</div>
            <div class="step">Execute</div>
          </div>
          <div class="daemon-note">Cold start every time</div>
        </div>

        <div class="daemon-vs">vs</div>

        <div class="daemon-after">
          <div class="daemon-label accent">howth daemon</div>
          <div class="daemon-steps minimal">
            <div class="step active">IPC message</div>
            <div class="step active">Execute</div>
          </div>
          <div class="daemon-note accent">Already running. Just execute.</div>
        </div>
      </div>

      <div class="daemon-stats">
        <div class="stat-item">
          <div class="stat-value">0.1ms</div>
          <div class="stat-label">Warm transpile</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">1</div>
          <div class="stat-label">Socket round-trip</div>
        </div>
        <div class="stat-item">
          <div class="stat-value">780x</div>
          <div class="stat-label">Faster than tsc</div>
        </div>
      </div>
    </section>

    <!-- Toolkit: Horizontal command cards -->
    <section class="toolkit-section">
      <h2>Start with tests. Adopt the rest incrementally.</h2>
      <p class="section-desc">
        Drop <code>howth test</code> into any Node.js project today. No migration required.
      </p>

      <div class="toolkit-list">
        <div class="toolkit-item featured">
          <div class="toolkit-cmd">
            <span class="prompt">$</span> howth test
          </div>
          <div class="toolkit-content">
            <div class="toolkit-header">
              <h3>Test Runner</h3>
              <span class="toolkit-badge">2.6x faster than Bun</span>
            </div>
            <p>The fastest JavaScript test runner. Jest-compatible API.</p>
            <div class="toolkit-features">
              <span>Jest expect() API</span>
              <span>Snapshot testing</span>
              <span>Watch mode</span>
              <span>DOM APIs</span>
              <span>Concurrent execution</span>
              <span>Code coverage</span>
            </div>
          </div>
        </div>

        <div class="toolkit-item">
          <div class="toolkit-cmd">
            <span class="prompt">$</span> howth run ./index.ts
          </div>
          <div class="toolkit-content">
            <div class="toolkit-header">
              <h3>JavaScript Runtime</h3>
              <span class="toolkit-badge">85% Node.js compatible</span>
            </div>
            <p>Run TypeScript directly. Daemon keeps everything warm.</p>
            <div class="toolkit-features">
              <span>Node.js APIs</span>
              <span>TypeScript & JSX</span>
              <span>Watch mode</span>
              <span>Web APIs</span>
              <span>172K req/s</span>
            </div>
          </div>
        </div>

        <div class="toolkit-item">
          <div class="toolkit-cmd">
            <span class="prompt">$</span> howth install
          </div>
          <div class="toolkit-content">
            <div class="toolkit-header">
              <h3>Package Manager</h3>
              <span class="toolkit-badge">30x faster than npm</span>
            </div>
            <p>Drop-in npm replacement with global cache.</p>
            <div class="toolkit-features">
              <span>package.json</span>
              <span>Workspaces</span>
              <span>Lifecycle scripts</span>
              <span>Security audits</span>
            </div>
          </div>
        </div>

        <div class="toolkit-item">
          <div class="toolkit-cmd">
            <span class="prompt">$</span> howth bundle ./app.tsx
          </div>
          <div class="toolkit-content">
            <div class="toolkit-header">
              <h3>Bundler</h3>
              <span class="toolkit-badge">Smallest output size</span>
            </div>
            <p>Bundle TypeScript, JSX, CSS for browsers and servers.</p>
            <div class="toolkit-features">
              <span>TypeScript & JSX</span>
              <span>CSS bundling</span>
              <span>Code splitting</span>
              <span>Minification</span>
            </div>
          </div>
        </div>

        <div class="toolkit-item">
          <div class="toolkit-cmd">
            <span class="prompt">$</span> howth dev ./src/main.tsx
          </div>
          <div class="toolkit-content">
            <div class="toolkit-header">
              <h3>Dev Server</h3>
              <span class="toolkit-badge">HMR & Fast Refresh</span>
            </div>
            <p>Development server with instant hot module replacement.</p>
            <div class="toolkit-features">
              <span>Instant HMR</span>
              <span>React Fast Refresh</span>
              <span>CSS hot reload</span>
              <span>Zero config</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Iterative development stats -->
    <section class="iteration-section">
      <h2>Built for iterative development</h2>
      <p class="section-desc">
        In a typical dev session, you run tests hundreds of times. howth gets faster with each run.
      </p>

      <div class="iteration-cards">
        <div class="iteration-card">
          <div class="iteration-label">First run</div>
          <div class="iteration-value">~200ms</div>
          <p>Daemon starts, V8 initializes, compilers warm up. Still fast.</p>
        </div>
        <div class="iteration-card highlight">
          <div class="iteration-label">Every run after</div>
          <div class="iteration-value">~139ms</div>
          <p>V8 is running. Caches are hot. Just execute.</p>
        </div>
        <div class="iteration-card">
          <div class="iteration-label">Changed file only</div>
          <div class="iteration-value">~50ms</div>
          <p>Only re-transpile what changed.</p>
        </div>
      </div>

      <p class="iteration-note">
        Over a day with 500 test runs, howth saves <strong>~2 minutes</strong> vs Bun
        and <strong>~30 minutes</strong> vs Jest.
      </p>
    </section>

    <!-- APIs section -->
    <section class="api-section">
      <h2>The APIs you need. Baked in.</h2>

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

      <div class="code-example">
        <div class="code-header">
          <span>index.ts</span>
        </div>
        <pre><code><span class="kw">import</span> { createServer } <span class="kw">from</span> <span class="str">'node:http'</span>;

<span class="kw">const</span> server = createServer(<span class="kw">async</span> (req, res) =&gt; {
  <span class="kw">if</span> (req.url === <span class="str">'/'</span>) {
    res.writeHead(<span class="num">200</span>, { <span class="str">'Content-Type'</span>: <span class="str">'text/plain'</span> });
    res.end(<span class="str">'Welcome to howth!'</span>);
  }

  <span class="kw">if</span> (req.url === <span class="str">'/api/users'</span>) {
    <span class="kw">const</span> users = [{ id: <span class="num">1</span>, name: <span class="str">'Alice'</span> }];
    res.writeHead(<span class="num">200</span>, { <span class="str">'Content-Type'</span>: <span class="str">'application/json'</span> });
    res.end(JSON.stringify(users));
  }
});

server.listen(<span class="num">3000</span>);
console.log(<span class="str">'Listening on http://localhost:3000'</span>);</code></pre>
      </div>
    </section>

    <!-- Capability grid -->
    <section class="capability-section">
      <h2>Everything you need to build & ship</h2>

      <div class="capability-grid">
        <div class="capability-group">
          <h3>HTTP & WebSockets</h3>
          <ul>
            <li><code>http.createServer()</code> <span>HTTP & HTTPS</span></li>
            <li><code>WebSocket</code> <span>Client & server</span></li>
            <li><code>fetch()</code> <span>Web standard</span></li>
            <li><code>Howth.Cookie</code> <span>Zero-overhead</span></li>
          </ul>
        </div>

        <div class="capability-group">
          <h3>File System</h3>
          <ul>
            <li><code>fs.readFile()</code> <span>Fast reading</span></li>
            <li><code>fs.writeFile()</code> <span>Efficient writes</span></li>
            <li><code>Howth.Glob</code> <span>Pattern matching</span></li>
            <li><code>path.*</code> <span>Path utilities</span></li>
          </ul>
        </div>

        <div class="capability-group">
          <h3>Testing</h3>
          <ul>
            <li><code>howth test</code> <span>Jest-compatible</span></li>
            <li><code>snapshots</code> <span>Built-in</span></li>
            <li><code>expect()</code> <span>Jest assertions</span></li>
            <li><code>--coverage</code> <span>Code coverage</span></li>
          </ul>
        </div>

        <div class="capability-group">
          <h3>Build & Deploy</h3>
          <ul>
            <li><code>howth bundle</code> <span>Tree-shaking</span></li>
            <li><code>--compile</code> <span>Single executables</span></li>
            <li><code>--hot</code> <span>Hot reload</span></li>
            <li><code>howth dev</code> <span>HMR server</span></li>
          </ul>
        </div>

        <div class="capability-group">
          <h3>TypeScript & DX</h3>
          <ul>
            <li><code>TypeScript & JSX</code> <span>Zero config</span></li>
            <li><code>import "*.yaml"</code> <span>YAML & TOML</span></li>
            <li><code>import "*.css"</code> <span>CSS imports</span></li>
            <li><code>.env</code> <span>Environment vars</span></li>
          </ul>
        </div>

        <div class="capability-group">
          <h3>Utilities</h3>
          <ul>
            <li><code>Howth.hash()</code> <span>Fast hashing</span></li>
            <li><code>Howth.semver</code> <span>Version compare</span></li>
            <li><code>Howth.markdown()</code> <span>GFM parsing</span></li>
            <li><code>crypto.*</code> <span>Crypto APIs</span></li>
          </ul>
        </div>
      </div>
    </section>

    <!-- Comparison table -->
    <section class="compare-section">
      <h2>What's different about howth?</h2>
      <p class="section-desc">A unique architecture that no other runtime has</p>

      <div class="compare-table-wrap">
        <table class="compare-table">
          <thead>
            <tr>
              <th>Architecture</th>
              <th>howth</th>
              <th>Node</th>
              <th>Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr class="highlight-row">
              <td>
                <strong>Persistent daemon</strong>
                <span>Background process keeps runtime warm</span>
              </td>
              <td class="yes">Yes</td>
              <td class="no">No</td>
              <td class="no">No</td>
            </tr>
            <tr class="highlight-row">
              <td>
                <strong>In-memory module cache</strong>
                <span>Transpiled modules persist across runs</span>
              </td>
              <td class="yes">Yes</td>
              <td class="no">No</td>
              <td class="no">No</td>
            </tr>
            <tr class="highlight-row">
              <td>
                <strong>IPC-based execution</strong>
                <span>Commands via Unix socket, no process spawn</span>
              </td>
              <td class="yes">Yes</td>
              <td class="no">No</td>
              <td class="no">No</td>
            </tr>
          </tbody>
          <thead>
            <tr>
              <th>Performance</th>
              <th>howth</th>
              <th>Node</th>
              <th>Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <strong>Test runner (10K tests)</strong>
                <span>Jest-compatible execution</span>
              </td>
              <td class="best">139ms</td>
              <td>4.08s</td>
              <td>368ms</td>
            </tr>
            <tr>
              <td>
                <strong>Bundler (10K modules)</strong>
                <span>React JSX, minified + sourcemaps</span>
              </td>
              <td class="best">290ms</td>
              <td>N/A</td>
              <td>541ms</td>
            </tr>
            <tr>
              <td>
                <strong>Warm transpile</strong>
                <span>TypeScript after daemon warm</span>
              </td>
              <td class="best">0.1ms</td>
              <td>N/A</td>
              <td>~5ms</td>
            </tr>
            <tr>
              <td>
                <strong>HTTP throughput</strong>
                <span>Requests/sec (50 connections)</span>
              </td>
              <td>172K</td>
              <td>111K</td>
              <td class="best">211K</td>
            </tr>
          </tbody>
          <thead>
            <tr>
              <th>Compatibility</th>
              <th>howth</th>
              <th>Node</th>
              <th>Bun</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <strong>Node.js API coverage</strong>
                <span>Percentage implemented</span>
              </td>
              <td>~85%</td>
              <td class="best">100%</td>
              <td>~95%</td>
            </tr>
            <tr>
              <td>
                <strong>Drop-in for Node.js projects</strong>
                <span>No migration needed</span>
              </td>
              <td class="yes">Yes</td>
              <td class="yes">Yes</td>
              <td class="yes">Yes</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Try it -->
    <section class="try-section">
      <h2>Try it in 30 seconds</h2>

      <div class="try-terminal">
        <div class="terminal-chrome">
          <span class="terminal-dot"></span>
          <span class="terminal-dot"></span>
          <span class="terminal-dot"></span>
        </div>
        <pre><code><span class="comment"># Install howth</span>
curl -fsSL https://howth.run/install.sh | sh

<span class="comment"># Run your tests with howth (works with Jest syntax)</span>
howth test

<span class="comment"># That's it. No config changes needed.</span></code></pre>
      </div>

      <div class="compat-badges">
        <div class="compat-badge"><span class="check">✓</span> package.json</div>
        <div class="compat-badge"><span class="check">✓</span> node_modules</div>
        <div class="compat-badge"><span class="check">✓</span> Jest tests</div>
        <div class="compat-badge"><span class="check">✓</span> TypeScript</div>
      </div>
    </section>

    <!-- Learn more -->
    <section class="learn-section">
      <h2>Learn more</h2>

      <div class="learn-links">
        <a href="/guide/getting-started" class="learn-link">
          <span class="learn-title">Documentation</span>
          <span class="learn-arrow">→</span>
          <span class="learn-desc">Get started with howth</span>
        </a>
        <a href="/reference/node-api-compat" class="learn-link">
          <span class="learn-title">API Reference</span>
          <span class="learn-arrow">→</span>
          <span class="learn-desc">Complete runtime reference</span>
        </a>
      </div>
    </section>

    <!-- Footer -->
    <footer class="site-footer">
      <div class="footer-grid">
        <div class="footer-col">
          <h4>Resources</h4>
          <a href="/reference/node-api-compat">Reference</a>
          <a href="/guide/getting-started">Docs</a>
          <a href="/guide/examples">Guides</a>
          <a href="https://github.com/jschatz1/howth/discussions">Discussions</a>
          <a href="https://github.com/jschatz1/howth">GitHub</a>
        </div>
        <div class="footer-col">
          <h4>Toolkit</h4>
          <a href="/guide/architecture">Runtime</a>
          <a href="/guide/cli-reference#install">Package manager</a>
          <a href="/guide/cli-reference#test">Test runner</a>
          <a href="/guide/cli-reference#bundle">Bundler</a>
          <a href="/guide/cli-reference#dev">Dev server</a>
        </div>
        <div class="footer-col">
          <h4>Project</h4>
          <a href="https://github.com/jschatz1/howth/releases">Releases</a>
          <a href="https://github.com/jschatz1/howth/blob/main/ROADMAP.md">Roadmap</a>
          <a href="https://github.com/jschatz1/howth/blob/main/CONTRIBUTING.md">Contributing</a>
          <a href="https://github.com/jschatz1/howth/blob/main/LICENSE">License</a>
        </div>
      </div>
      <div class="footer-bottom">
        Released under the MIT License.
      </div>
    </footer>
  </div>
</template>

<style scoped>
/* Styles in custom.css */
</style>
