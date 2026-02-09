<script setup lang="ts">
import { useData } from 'vitepress'
import DefaultTheme from 'vitepress/theme'
import HomePage from './components/HomePage.vue'
import BlogIndex from './components/BlogIndex.vue'

const { Layout } = DefaultTheme
const { frontmatter } = useData()
</script>

<template>
  <HomePage v-if="frontmatter.homepage" />
  <Layout v-else>
    <template #doc-before>
      <BlogIndex v-if="frontmatter.blog" />
    </template>
    <template #nav-bar-content-after>
      <slot name="nav-bar-content-after" />
    </template>
  </Layout>
</template>
