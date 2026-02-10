<script setup lang="ts">
const posts = [
  {
    title: 'Removing SWC: Building a Custom TypeScript Parser and Minifier',
    date: '2026-02-10',
    description: 'Why we replaced SWC with a hand-written TypeScript parser, JSX transform, and variable name mangler — all in ~17k lines of Rust.',
    link: '/blog/removing-swc',
  },
  {
    title: 'A Fast Bundler',
    date: '2026-02-09',
    description: 'howth came out on top in the rolldown/benchmarks suite against bun, esbuild, rolldown, vite, rspack, and rsbuild.',
    link: '/blog/a-fast-bundler',
  },
]
</script>

<template>
  <div class="blog-index">
    <h1>Blog</h1>
    <div class="blog-list">
      <a v-for="post in posts" :key="post.link" :href="post.link" class="blog-post">
        <time :datetime="post.date">{{ post.date }}</time>
        <h2>{{ post.title }}</h2>
        <p>{{ post.description }}</p>
      </a>
    </div>
  </div>
</template>
