import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: "ReviZa",
  tagline:
    "ReviZa is the transforming the future of eductation in Zambia and the world at large",
  favicon: "img/logo.jpeg",

  // Set the production url of your site here
  url: "https://your-docusaurus-site.example.com",
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: "/",

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: "Luso-Software", // Usually your GitHub org/user name.
  projectName: "ReviZa", // Usually your repo name.

  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            "https://github.com/KanyantaM/reviza/tree/main/reviza-doc/docs",
          breadcrumbs: true,
          beforeDefaultRemarkPlugins: [],
          beforeDefaultRehypePlugins: [],
          showLastUpdateAuthor: true,
          showLastUpdateTime: true,
          disableVersioning: false,
          includeCurrentVersion: true,
          lastVersion: undefined,
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ["rss", "atom"],
            xslt: true,
          },
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            "https://github.com/KanyantaM/reviza/tree/main/reviza-doc/blog",
          // Useful options to enforce blogging best practices
          onInlineTags: "warn",
          onInlineAuthors: "warn",
          onUntruncatedBlogPosts: "warn",
        },
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],
  themeConfig: {
    metadata: [
      {
        name: "title",
        content: "ReviZa - Share and Access Study Materials with Ease",
      },
      {
        name: "description",
        content:
          "ReviZa is your go-to platform for sharing and accessing study materials seamlessly. Explore features like course search, material uploads, and secure authentication to enhance your learning experience.",
      },
      {
        name: "keywords",
        content:
          "ReviZa, Zambia, study materials, University of Zambia, Copperbelt University, UNZA, CBU, Zambian universities, education platform, course resources, student tools, secure authentication, academic materials, Zambian student portal, university resources, course search",
      },
      { name: "author", content: "ReviZa Team" },
      { name: "viewport", content: "width=device-width, initial-scale=1" },

      // Twitter Card
      { name: "twitter:card", content: "summary_large_image" },
      {
        name: "twitter:title",
        content: "ReviZa - Share and Access Study Materials with Ease",
      },
      {
        name: "twitter:description",
        content:
          "ReviZa makes it easy for students to find, share, and manage study materials. Join now to access curated resources and tools tailored for students.",
      },
      {
        name: "twitter:image",
        content: "https://reviza-31466.web.app/img/hero_image.png",
      },

      // Open Graph (OG) Tags
      {
        property: "og:title",
        content: "ReviZa - Share and Access Study Materials with Ease",
      },
      {
        property: "og:description",
        content:
          "Join ReviZa to share and access study materials with ease. Our platform is built for students, offering a secure and innovative way to enhance your learning.",
      },
      { property: "og:type", content: "website" },
      { property: "og:url", content: "https://reviza-31466.web.app/" },
      {
        property: "og:image",
        content: "https://reviza-31466.web.app/img/hero_image.png",
      },
      { property: "og:site_name", content: "ReviZa" },

      // Favicon (for better branding and discoverability)
      { rel: "icon", href: "/img/logo.jpeg" },

      // Schema Markup for SEO
      {
        type: "application/ld+json",
        content: JSON.stringify({
          "@context": "https://schema.org",
          "@type": "WebSite",
          name: "ReviZa",
          url: "https://reviza-31466.web.app/",
          potentialAction: {
            "@type": "SearchAction",
            target:
              "https://reviza-31466.web.app//search?q={search_term_string}",
            "query-input": "required name=search_term_string",
          },
          image: "",
          description:
            "ReviZa is a platform for sharing and accessing study materials, tailored for university students worldwide.",
        }),
      },
    ],
    // Replace with your project's social card
    image: "img/logo.jpeg",
    navbar: {
      title: "ReviZa",
      logo: {
        alt: "ReviZa Logo",
        src: "img/logo.jpeg",
      },
      items: [
        {
          href: "/download",
          label: "Download",
          position: "left",
        },
        {
          type: "docSidebar",
          sidebarId: "tutorialSidebar",
          position: "left",
          label: "Docs",
        },
        { to: "/blog", label: "Blog", position: "left" },
        {
          href: "https://github.com/KanyantaM/reviza/tree/main/reviza-doc/",
          label: "GitHub",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Docs",
          items: [
            {
              label: "Docs",
              to: "/docs/intro",
            },
          ],
        },
        {
          title: "Team",
          items: [
            {
              label: "Kangwa Mukuka",
              href: "https://www.linkedin.com/in/kmukuka",
            },
            {
              label: "Kanynata M. Makasa",
              href: "https://www.linkedin.com/in/kanyanta-makasa",
            },
            {
              label: "Yanda Chilufya",
              href: "https://www.linkedin.com/in/yande-chilufya-486a83286",
            },
          ],
        },
        {
          title: "More",
          items: [
            {
              label: "Blog",
              to: "/blog",
            },
            {
              label: "GitHub",
              href: "https://github.com/KanyantaM/reviza",
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Luso-Software, built by Kanyanta M. Makasa`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
    algolia: {
      // The application ID provided by Algolia
      appId: "A4Q16AMFIR",

      // Public API key: it is safe to commit it
      apiKey: "YOUR_SEARCH_API_KEY",

      indexName: "YOUR_INDEX_NAME",

      // Optional: see doc section below
      contextualSearch: true,

      // Optional: Specify domains where the navigation should occur through window.location instead on history.push. Useful when our Algolia config crawls multiple documentation sites and we want to navigate with window.location.href to them.
      externalUrlRegex: "external\\.com|domain\\.com",

      // Optional: Replace parts of the item URLs from Algolia. Useful when using the same search index for multiple deployments using a different baseUrl. You can use regexp or string in the `from` param. For example: localhost:3000 vs myCompany.com/docs
      replaceSearchResultPathname: {
        from: "/docs/", // or as RegExp: /\/docs\//
        to: "/",
      },

      // Optional: Algolia search parameters
      searchParameters: {},

      // Optional: path for search page that enabled by default (`false` to disable it)
      searchPagePath: "search",

      // Optional: whether the insights feature is enabled or not on Docsearch (`false` by default)
      insights: false,

      //... other Algolia params
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
