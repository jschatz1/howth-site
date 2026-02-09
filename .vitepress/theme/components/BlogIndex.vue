<script setup lang="ts">
const posts = [
  {
    title: 'The Fastest JavaScript Bundler',
    date: '2026-02-09',
    description: 'How we made howth faster than bun, esbuild, rolldown, vite, rspack, and rsbuild on the rolldown/benchmarks suite.',
    link: '/blog/fastest-bundler',
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
