<script setup lang="ts">
import { ref } from 'vue'

const installTab = ref<'unix' | 'windows'>('unix')

function copyInstallCommand() {
  const cmd = installTab.value === 'unix'
    ? 'curl -fsSL https://howth.run/install | sh'
    : 'powershell -c "irm howth.run/install.ps1 | iex"'
  navigator.clipboard.writeText(cmd)
}
</script>

<template>
  <div class="homepage">
    <!-- Hero: Centered, minimal -->
    <section class="hero">
      <div class="hero-inner">
        <p class="hero-eyebrow">A new JavaScript runtime</p>

        <h1 class="hero-headline">
          Tests run <span class="stat">2.6×</span> faster.<br/>
          Every command after the first is <span class="stat">instant</span>.
        </h1>

        <p class="hero-sub">
          howth keeps a daemon running in the background. V8, compilers, and caches stay warm.
          No cold starts. Ever.
        </p>

        <div class="hero-cta">
          <a href="/guide/getting-started" class="btn-primary">Get Started</a>
          <a href="https://github.com/jschatz1/howth" class="btn-secondary">GitHub</a>
        </div>

        <div class="install-box">
          <div class="install-tabs">
            <button :class="{ active: installTab === 'unix' }" @click="installTab = 'unix'">macOS / Linux</button>
            <button :class="{ active: installTab === 'windows' }" @click="installTab = 'windows'">Windows</button>
          </div>
          <div class="install-cmd">
            <code>{{ installTab === 'unix' ? 'curl -fsSL https://howth.run/install | sh' : 'powershell -c "irm howth.run/install.ps1 | iex"' }}</code>
            <button class="copy-btn" @click="copyInstallCommand">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <rect x="9" y="9" width="13" height="13" rx="2"></rect>
                <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- Key differentiator: The Daemon -->
    <section class="daemon-section">
      <div class="daemon-inner">
        <div class="daemon-visual">
          <div class="daemon-diagram">
            <div class="daemon-box daemon-cli">
              <span class="label">CLI</span>
              <code>howth test</code>
            </div>
            <div class="daemon-arrow">→</div>
            <div class="daemon-box daemon-core">
              <span class="label">Daemon (always running)</span>
              <div class="daemon-components">
                <span>V8</span>
                <span>SWC</span>
                <span>Cache</span>
              </div>
            </div>
            <div class="daemon-arrow">→</div>
            <div class="daemon-box daemon-result">
              <span class="label">Result</span>
              <code>139ms</code>
            </div>
          </div>
        </div>

        <div class="daemon-text">
          <h2>The daemon is the difference.</h2>
          <p>
            Other runtimes start fresh every time. howth starts a background process once,
            then every command is just a message over a Unix socket.
          </p>
          <ul class="daemon-benefits">
            <li><strong>0.1ms</strong> warm transpile (vs 5ms+ cold)</li>
            <li><strong>No process spawn</strong> per command</li>
            <li><strong>Module cache</strong> persists across runs</li>
          </ul>
        </div>
      </div>
    </section>

    <!-- Benchmarks: Simple table, not bars -->
    <section class="benchmarks-section">
      <h2>Benchmarks</h2>
      <p class="section-desc">Apple M3 Pro, 10,000 tests across 500 files</p>

      <div class="benchmark-table-wrap">
        <table class="benchmark-table">
          <thead>
            <tr>
              <th>Tool</th>
              <th>Time</th>
              <th>vs howth</th>
            </tr>
          </thead>
          <tbody>
            <tr class="highlight">
              <td><strong>howth</strong></td>
              <td>139 ms</td>
              <td>—</td>
            </tr>
            <tr>
              <td>Bun</td>
              <td>368 ms</td>
              <td class="slower">2.6× slower</td>
            </tr>
            <tr>
              <td>Vitest</td>
              <td>1.4s</td>
              <td class="slower">10× slower</td>
            </tr>
            <tr>
              <td>Jest + SWC</td>
              <td>3.07s</td>
              <td class="slower">22× slower</td>
            </tr>
            <tr>
              <td>node --test</td>
              <td>4.08s</td>
              <td class="slower">29× slower</td>
            </tr>
          </tbody>
        </table>
      </div>

      <p class="benchmark-note">
        <a href="/benchmarks">View methodology →</a>
      </p>
    </section>

    <!-- What's included -->
    <section class="tools-section">
      <h2>One binary. Everything included.</h2>

      <div class="tools-grid">
        <div class="tool-item">
          <div class="tool-cmd">howth run</div>
          <div class="tool-desc">Execute TypeScript directly</div>
        </div>
        <div class="tool-item">
          <div class="tool-cmd">howth test</div>
          <div class="tool-desc">Jest-compatible test runner</div>
        </div>
        <div class="tool-item">
          <div class="tool-cmd">howth bundle</div>
          <div class="tool-desc">Tree-shaking bundler</div>
        </div>
        <div class="tool-item">
          <div class="tool-cmd">howth install</div>
          <div class="tool-desc">Package manager</div>
        </div>
        <div class="tool-item">
          <div class="tool-cmd">howth dev</div>
          <div class="tool-desc">HMR dev server</div>
        </div>
        <div class="tool-item">
          <div class="tool-cmd">howth build</div>
          <div class="tool-desc">Production builds</div>
        </div>
      </div>
    </section>

    <!-- Compatibility -->
    <section class="compat-section">
      <h2>Drop into existing projects</h2>
      <p class="section-desc">85% Node.js API coverage. Works with your package.json and node_modules.</p>

      <div class="compat-grid">
        <div class="compat-item">
          <span class="compat-check">✓</span>
          <span>Express / Fastify</span>
        </div>
        <div class="compat-item">
          <span class="compat-check">✓</span>
          <span>Next.js</span>
        </div>
        <div class="compat-item">
          <span class="compat-check">✓</span>
          <span>SvelteKit</span>
        </div>
        <div class="compat-item">
          <span class="compat-check">✓</span>
          <span>Remix</span>
        </div>
        <div class="compat-item">
          <span class="compat-check">✓</span>
          <span>Jest syntax</span>
        </div>
        <div class="compat-item">
          <span class="compat-check">✓</span>
          <span>TypeScript</span>
        </div>
      </div>
    </section>

    <!-- Footer CTA -->
    <section class="cta-section">
      <h2>Try it now</h2>
      <div class="cta-code">
        <code>curl -fsSL https://howth.run/install | sh && howth test</code>
      </div>
      <div class="cta-links">
        <a href="/guide/getting-started">Documentation →</a>
      </div>
    </section>

    <!-- Footer -->
    <footer class="site-footer">
      <div class="footer-inner">
        <div class="footer-col">
          <h4>Docs</h4>
          <a href="/guide/getting-started">Getting Started</a>
          <a href="/guide/cli-reference">CLI Reference</a>
          <a href="/guide/architecture">Architecture</a>
        </div>
        <div class="footer-col">
          <h4>Project</h4>
          <a href="https://github.com/jschatz1/howth">GitHub</a>
          <a href="https://github.com/jschatz1/howth/releases">Releases</a>
          <a href="https://github.com/jschatz1/howth/blob/main/LICENSE">License (MIT)</a>
        </div>
      </div>
      <p class="footer-copy">Built with Rust, V8, SWC, and hyper.</p>
    </footer>
  </div>
</template>

<style scoped>
/* Scoped styles in custom.css */
</style>
