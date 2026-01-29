import { defineConfig } from "vitepress";

export default defineConfig({
  title: "howth",
  description: "Fast TypeScript builds, bundling, and dev server",

  head: [["link", { rel: "icon", href: "/earwig.png" }]],

  themeConfig: {
    logo: "/earwig.png",

    nav: [
      { text: "Guide", link: "/guide/getting-started" },
      { text: "Reference", link: "/reference/node-api-compat" },
      {
        text: "GitHub",
        link: "https://github.com/jschatz1/howth",
      },
    ],

    sidebar: [
      {
        text: "Guide",
        items: [
          { text: "Getting Started", link: "/guide/getting-started" },
          { text: "Installation", link: "/guide/installation" },
          { text: "CLI Reference", link: "/guide/cli-reference" },
        ],
      },
      {
        text: "Reference",
        items: [
          {
            text: "Node.js API Compatibility",
            link: "/reference/node-api-compat",
          },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/jschatz1/howth" },
    ],

    search: {
      provider: "local",
    },

    footer: {
      message: "Released under the MIT License.",
    },
  },

  appearance: "dark",
});
