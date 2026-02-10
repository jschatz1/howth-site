import { defineConfig } from "vitepress";

export default defineConfig({
  title: "howth",
  description: "Fast JavaScript & TypeScript builds, bundling, and dev server",

  head: [["link", { rel: "icon", href: "/earwig.png" }]],

  themeConfig: {
    logo: "/earwig.png",

    nav: [
      { text: "Guide", link: "/guide/getting-started" },
      { text: "Reference", link: "/reference/node-api-compat" },
      { text: "Blog", link: "/blog/" },
      {
        text: "GitHub",
        link: "https://github.com/jschatz1/howth",
      },
    ],

    sidebar: {
      "/guide/": [
        {
          text: "Guide",
          items: [
            { text: "Getting Started", link: "/guide/getting-started" },
            { text: "Architecture", link: "/guide/architecture" },
            { text: "Installation", link: "/guide/installation" },
            { text: "CLI Reference", link: "/guide/cli-reference" },
            { text: "Framework Compatibility", link: "/guide/framework-compatibility" },
            { text: "Examples", link: "/guide/examples" },
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
      "/reference/": [
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
      "/blog/": [
        {
          text: "Blog",
          items: [
            { text: "Removing SWC", link: "/blog/removing-swc" },
            { text: "A Fast Bundler", link: "/blog/a-fast-bundler" },
          ],
        },
      ],
    },

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
