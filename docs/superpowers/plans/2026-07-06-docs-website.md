# catalyst_ui Documentation Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Docusaurus documentation website for the `catalyst_ui` Flutter component library in the `docs/` subdirectory, covering foundations (getting started, theming, architecture) and a reference page for every one of the 43 exported components.

**Architecture:** Docusaurus classic preset (TypeScript config) rooted at `docs/`. Docs-only (blog disabled), served at the site root, with offline local search. Content is hand-written Markdown extracted faithfully from the Dart source in `lib/src/` — parameter tables, variant/tone lists, and code samples come from reading each source file. Sidebar auto-generated from the folder tree, mirroring the atoms/molecules/organisms structure.

**Tech Stack:** Docusaurus 3 (classic preset), TypeScript config, `@easyops-cn/docusaurus-search-local`, Node v22 (via nvm), GitHub Pages + GitHub Actions for deploy.

## Global Constraints

- **Node invocation:** the interactive shell's nvm shims are NOT loaded in non-interactive bash. Prefix every node/npm/npx command with the nvm bin on PATH: `export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"` at the start of each Bash step that runs node tooling. Verify with `node -v` → `v22.12.0`.
- **Docusaurus root is `docs/`.** All npm commands run with `docs/` as the working directory (use `npm --prefix docs ...` or `cd` within a single compound command).
- **Do not touch `docs/superpowers/`** — it holds specs/plans and must remain outside the Docusaurus content path.
- **Content fidelity:** every parameter table, type, default, variant name, and tone name MUST be copied from the actual Dart source in `lib/src/`. Never invent parameters or defaults. When unsure, read the source file.
- **Repo facts (verbatim):** package name `catalyst_ui`; version `0.4.1`; repo `https://github.com/ptrbrynt/catalyst_ui`; org `ptrbrynt`; project `catalyst_ui`; tagline "A flexible, theme-driven UI component library for Flutter. No Material or Cupertino dependency."
- **GitHub Pages config (verbatim):** `url: 'https://ptrbrynt.github.io'`, `baseUrl: '/catalyst_ui/'`, `organizationName: 'ptrbrynt'`, `projectName: 'catalyst_ui'`.
- **Verification for content tasks:** `npm --prefix docs run build` must succeed. Docusaurus fails the build on broken internal links (`onBrokenLinks: 'throw'`), so a green build is the primary gate for every content task.
- **Import statement in all component samples:** `import 'package:catalyst_ui/catalyst_ui.dart';`
- **43 components:** Atoms (13): avatar, avatar_stack, badge, button, checkbox, chip, divider, progress_bar, radio, slider, spinner, status_dot, switch. Molecules (17): action_tile, alert, breadcrumb, card, list_item, menu_button, multi_select, pagination, segmented_control, select, snackbar, stat_card, stepper, tabs, text_field, tooltip, value_row. Organisms (13): app_bar, bottom_nav, bottom_sheet, date_picker, drawer, empty_state, error_state, form_layout, modal, radio_group, side_nav, time_picker, top_bar.

---

## Task 1: Scaffold Docusaurus site with docs-only + search + GitHub Pages config

**Files:**
- Create: `docs/` (Docusaurus classic scaffold — `package.json`, `docusaurus.config.ts`, `sidebars.ts`, `tsconfig.json`, `src/`, `static/`, `docs/`)
- Create: `docs/.gitignore`
- Modify: `docs/docusaurus.config.ts` (docs-only, search, GH Pages)
- Modify: `docs/package.json` (add search dependency)
- Delete: `docs/blog/` (blog disabled)

**Interfaces:**
- Produces: a buildable Docusaurus site at `docs/`. Content path is `docs/docs/`. Docs served at site root (`routeBasePath: '/'`). Sidebar id `docsSidebar` auto-generated from `docs/docs/`.

- [ ] **Step 1: Scaffold the classic TypeScript site into `docs/`**

The `docs/` directory already exists and contains `docs/superpowers/`. `create-docusaurus` requires a fresh target, so scaffold into a temp dir and move the generated files in (preserving `docs/superpowers/`).

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
node -v   # expect v22.12.0
cd /Users/peter.bryant/Developer/catalyst_ui
npx --yes create-docusaurus@latest docs-scaffold classic --typescript
# Move generated files into docs/ without clobbering docs/superpowers
rsync -a docs-scaffold/ docs/
rm -rf docs-scaffold
```

- [ ] **Step 2: Verify the baseline scaffold builds**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs install
npm --prefix docs run build
```
Expected: build completes, `docs/build/` created. (Default scaffold has a working blog + docs; this confirms the toolchain works before customising.)

- [ ] **Step 3: Add the local search dependency**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs install @easyops-cn/docusaurus-search-local
```

- [ ] **Step 4: Remove the default blog and demo docs content**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
rm -rf docs/blog
rm -rf docs/docs/*
```
(The `docs/docs/` folder is repopulated in later tasks. Blog is disabled in config next.)

- [ ] **Step 5: Replace `docs/docusaurus.config.ts` with the catalyst_ui config**

```ts
import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'catalyst_ui',
  tagline:
    'A flexible, theme-driven UI component library for Flutter. No Material or Cupertino dependency.',
  favicon: 'img/favicon.ico',

  url: 'https://ptrbrynt.github.io',
  baseUrl: '/catalyst_ui/',
  organizationName: 'ptrbrynt',
  projectName: 'catalyst_ui',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {defaultLocale: 'en', locales: ['en']},

  presets: [
    [
      'classic',
      {
        docs: {
          routeBasePath: '/',
          sidebarPath: './sidebars.ts',
          editUrl:
            'https://github.com/ptrbrynt/catalyst_ui/tree/main/docs/',
        },
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themes: [
    [
      require.resolve('@easyops-cn/docusaurus-search-local'),
      {
        hashed: true,
        indexBlog: false,
        docsRouteBasePath: '/',
      },
    ],
  ],

  themeConfig: {
    navbar: {
      title: 'catalyst_ui',
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docsSidebar',
          position: 'left',
          label: 'Docs',
        },
        {
          href: 'https://github.com/ptrbrynt/catalyst_ui',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {label: 'Getting Started', to: '/getting-started'},
            {label: 'Components', to: '/components/atoms/button'},
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/ptrbrynt/catalyst_ui',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} catalyst_ui.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['dart', 'bash', 'yaml'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
```

- [ ] **Step 6: Replace `docs/sidebars.ts` with an auto-generated sidebar**

```ts
import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

const sidebars: SidebarsConfig = {
  docsSidebar: [{type: 'autogenerated', dirName: '.'}],
};

export default sidebars;
```

- [ ] **Step 7: Add a temporary intro so the site has at least one doc**

Create `docs/docs/intro.md`:

```md
---
slug: /
sidebar_position: 1
---

# catalyst_ui

Placeholder — replaced in Task 3.
```

- [ ] **Step 8: Write `docs/.gitignore`**

```
node_modules/
build/
.docusaurus/
.cache-loader/
```

- [ ] **Step 9: Build to verify the customised config**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds; no blog routes; search plugin loads.

- [ ] **Step 10: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs .gitignore
git commit -m "docs: scaffold Docusaurus site (docs-only, local search, GitHub Pages config)"
```

---

## Task 2: Homepage and Introduction

**Files:**
- Modify: `docs/src/pages/index.tsx`
- Modify: `docs/src/components/HomepageFeatures/index.tsx`
- Modify: `docs/src/css/custom.css` (brand colours)
- Replace: `docs/docs/intro.md`

**Interfaces:**
- Consumes: sidebar + config from Task 1.
- Produces: `intro.md` at slug `/` used as the docs landing; `getting-started` link target (created in Task 3) referenced by the homepage CTA.

- [ ] **Step 1: Set the homepage hero and CTA in `docs/src/pages/index.tsx`**

Replace the hero title/subtitle with the catalyst_ui name and tagline, and point the primary button at `/getting-started`:

```tsx
import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Heading from '@theme/Heading';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <Heading as="h1" className="hero__title">
          {siteConfig.title}
        </Heading>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/getting-started">
            Get Started →
          </Link>
        </div>
      </div>
    </header>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.title}
      description="Theme-driven Flutter UI component library with no Material or Cupertino dependency.">
      <HomepageHeader />
      <main>
        <HomepageFeatures />
      </main>
    </Layout>
  );
}
```

- [ ] **Step 2: Set the four feature cards in `docs/src/components/HomepageFeatures/index.tsx`**

Replace the `FeatureList` array with catalyst_ui features (drop the default SVG images; use emoji headings to avoid missing-asset issues):

```tsx
import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: '🚫 No Material or Cupertino',
    description: (
      <>
        Every widget imports only from <code>flutter/widgets.dart</code>. Drop
        catalyst_ui into any Flutter app without pulling in Material or
        Cupertino.
      </>
    ),
  },
  {
    title: '🎨 Typed theme system',
    description: (
      <>
        Colour scheme, typography, motion, shadows, and tokens are strongly
        typed and read through <code>BuildContext</code> extensions.
      </>
    ),
  },
  {
    title: '🧩 Open variants & tones',
    description: (
      <>
        Variants and tones are abstract classes — subclass them and{' '}
        <code>resolve</code> to any style, rather than being locked to a fixed
        enum.
      </>
    ),
  },
  {
    title: '⚛️ Atomic design',
    description: (
      <>
        Components are organised into atoms, molecules, and organisms so you can
        find the right building block fast.
      </>
    ),
  },
];

function Feature({title, description}: FeatureItem) {
  return (
    <div className={clsx('col col--3')}>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
```

- [ ] **Step 3: Set the brand colour in `docs/src/css/custom.css`**

Replace the `--ifm-color-primary` block (both light and dark `:root` / `[data-theme='dark']`) with the catalyst_ui brand purple (`#7C3AED`, matching the README quick-start):

```css
:root {
  --ifm-color-primary: #7c3aed;
  --ifm-color-primary-dark: #6d28d9;
  --ifm-color-primary-darker: #5b21b6;
  --ifm-color-primary-darkest: #4c1d95;
  --ifm-color-primary-light: #8b5cf6;
  --ifm-color-primary-lighter: #a78bfa;
  --ifm-color-primary-lightest: #c4b5fd;
  --ifm-code-font-size: 95%;
}

[data-theme='dark'] {
  --ifm-color-primary: #a78bfa;
  --ifm-color-primary-dark: #8b5cf6;
  --ifm-color-primary-darker: #7c3aed;
  --ifm-color-primary-darkest: #6d28d9;
  --ifm-color-primary-light: #c4b5fd;
  --ifm-color-primary-lighter: #ddd6fe;
  --ifm-color-primary-lightest: #ede9fe;
}
```

- [ ] **Step 4: Replace `docs/docs/intro.md` with the real Introduction**

```md
---
slug: /
sidebar_position: 1
title: Introduction
---

# catalyst_ui

`catalyst_ui` is a Flutter UI component library with **no Material or Cupertino
dependency**. Every widget imports only from `flutter/widgets.dart`, so it drops
cleanly into any Flutter app regardless of which design system (if any) you use.

## Why catalyst_ui?

- **No hidden dependencies.** No Material, no Cupertino, no third-party UI
  frameworks. Platform detection uses `defaultTargetPlatform`.
- **Fully customisable design tokens.** Colours, typography, spacing, radius,
  motion, and shadows are all typed and overridable through `ThemeData`.
- **Open variant & tone architecture.** Component styles are abstract classes
  you can subclass — not closed enums.
- **Atomic design.** Components are grouped into atoms, molecules, and organisms.

## What's inside

- **Foundations** — [Getting Started](/getting-started), theming, and the
  architecture behind variants, tones, and iconography.
- **Components** — reference pages for every atom, molecule, and organism,
  each with parameters, code samples, and variant/tone options.

Head to [Getting Started](/getting-started) to install the package and render
your first component.
```

- [ ] **Step 5: Build to verify homepage + intro**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds. The `/getting-started` link will 404 the broken-link check ONLY if referenced from a built doc — it is created in Task 3. To keep this task's build green, create a stub now (next step).

- [ ] **Step 6: Add a stub `getting-started.md` so links resolve**

Create `docs/docs/getting-started.md`:

```md
---
sidebar_position: 2
---

# Getting Started

Placeholder — replaced in Task 3.
```

- [ ] **Step 7: Rebuild and confirm green**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds with no broken links.

- [ ] **Step 8: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs
git commit -m "docs: branded homepage and introduction"
```

---

## Task 3: Getting Started page

**Files:**
- Replace: `docs/docs/getting-started.md`

**Interfaces:**
- Consumes: intro/homepage links to `/getting-started`.
- Produces: install + `CatalystProvider`/`ThemeData` setup content. Referenced by component pages' "see Getting Started" links.

- [ ] **Step 1: Read the source of truth for setup**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
sed -n '1,120p' lib/src/utils/provider.dart
sed -n '1,80p' README.md
```
Use `CatalystProvider` (from `lib/src/utils/provider.dart`) as the documented setup entry point, and the README install section for the pubspec snippet. Note: `ThemeData.light()`/`ThemeData.dark()` require an `iconography:` argument — confirm the exact required parameters by reading `lib/src/theme/theme_data.dart` and `lib/src/theme/iconography.dart` before writing the sample.

- [ ] **Step 2: Write `docs/docs/getting-started.md`**

Write the page using this structure (fill the pubspec version and iconography fields from what you read in Step 1 — do NOT guess the `Iconography` constructor field names; copy them from `iconography.dart`):

```md
---
sidebar_position: 2
---

# Getting Started

## Install

Add `catalyst_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  catalyst_ui: ^0.4.1
```

Then fetch packages:

```bash
flutter pub get
```

## Set up the provider

catalyst_ui ships no icon data — you supply `IconData` values from whichever
icon package your app uses (for example `lucide_icons`). Wrap your app in a
`CatalystProvider`, which wires up theming and all Catalyst overlay
dependencies (snackbars, modals) in one step.

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

// ...set up an Iconography with your app's icons (copy the exact field
// names from the Iconography class), then:

CatalystProvider(
  theme: ThemeData.light(
    fontFamily: 'Inter',
    iconography: appIconography,
  ),
  child: MyHomePage(),
)
```

## Automatic dark mode

Provide a `darkTheme` and the active theme follows the platform brightness:

```dart
CatalystProvider(
  theme: ThemeData.light(fontFamily: 'Inter', iconography: appIconography),
  darkTheme: ThemeData.dark(fontFamily: 'Inter', iconography: appIconography),
  child: MyHomePage(),
)
```

## Your first component

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

Button(
  label: const Text('Save'),
  variant: ButtonVariant.primary,
  onPressed: () {},
)
```

Next: learn how the [theme system](/theming/color-scheme) works, or browse the
[components](/components/atoms/button).
```

- [ ] **Step 3: Build to verify**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds. The `/theming/color-scheme` and `/components/atoms/button` links are created in later tasks — if the broken-link check fails, temporarily change those two links to plain text, and restore them in the tasks that create the targets. (Prefer ordering: run Tasks 4–8 before final link-in.)

- [ ] **Step 4: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs/docs/getting-started.md
git commit -m "docs: getting started page"
```

---

## Task 4: Theming section

**Files:**
- Create: `docs/docs/theming/_category_.json`
- Create: `docs/docs/theming/color-scheme.md`
- Create: `docs/docs/theming/typography.md`
- Create: `docs/docs/theming/motion.md`
- Create: `docs/docs/theming/shadows.md`
- Create: `docs/docs/theming/tokens.md`
- Create: `docs/docs/theming/extensions.md`

**Interfaces:**
- Consumes: config/sidebar from Task 1.
- Produces: `/theming/color-scheme`, `/theming/typography`, `/theming/motion`, `/theming/shadows`, `/theming/tokens`, `/theming/extensions` routes.

- [ ] **Step 1: Read the theming source files**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
cat lib/src/theme/color_scheme.dart
cat lib/src/theme/typography.dart
cat lib/src/theme/motion.dart
cat lib/src/theme/shadows.dart
cat lib/src/theme/extensions.dart
cat lib/src/tokens/spacing.dart lib/src/tokens/radius.dart lib/src/tokens/breakpoints.dart
```

- [ ] **Step 2: Write `docs/docs/theming/_category_.json`**

```json
{
  "label": "Theming",
  "position": 3,
  "link": {"type": "generated-index", "description": "Design tokens and the typed theme system."}
}
```

- [ ] **Step 3: Write each theming page from the source you read**

For each file, write a page documenting the class, its fields (name/type/default from the source), and the `.light()`/`.dark()` defaults where applicable. Include a `copyWith` override example. Use CLAUDE.md's "Theme system" and "Typography" sections as the narrative backbone. Each page begins with frontmatter, e.g.:

```md
---
title: ColorScheme
---

# ColorScheme

<one-line summary from the class doc comment>

## Fields

| Field | Type | Description |
|---|---|---|
| `brand` | `Color` | ... |

## Overriding

```dart
ThemeData.light(
  colorScheme: const ColorScheme.light().copyWith(brand: Color(0xFF7C3AED)),
);
```
```

Repeat for `typography.md` (document `fontFamily`, `headerFontFamily`, and the per-style overrides `display`…`micro` exactly as listed in CLAUDE.md and the source), `motion.md`, `shadows.md`, `tokens.md` (spacing constants, radius constants, breakpoints), and `extensions.md` (the `context.colorScheme` … `context.iconography` getters).

- [ ] **Step 4: Build to verify**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds.

- [ ] **Step 5: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs/docs/theming
git commit -m "docs: theming section"
```

---

## Task 5: Architecture section

**Files:**
- Create: `docs/docs/architecture/_category_.json`
- Create: `docs/docs/architecture/variants-and-tones.md`
- Create: `docs/docs/architecture/iconography.md`
- Create: `docs/docs/architecture/responsive.md`

**Interfaces:**
- Consumes: config/sidebar from Task 1.
- Produces: `/architecture/variants-and-tones`, `/architecture/iconography`, `/architecture/responsive` routes.

- [ ] **Step 1: Read the architecture source**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
cat lib/src/theme/iconography.dart
cat lib/src/utils/responsive_builder.dart lib/src/tokens/breakpoints.dart
sed -n '1,90p' lib/src/components/atoms/button.dart   # variant pattern reference
```

- [ ] **Step 2: Write `docs/docs/architecture/_category_.json`**

```json
{
  "label": "Architecture",
  "position": 4,
  "link": {"type": "generated-index", "description": "The patterns behind catalyst_ui components."}
}
```

- [ ] **Step 3: Write `variants-and-tones.md`**

Document the abstract-class + `resolve(ColorScheme)` + style-record pattern, the variant vs tone distinction, private built-in implementations, static const presets, and the custom-factory/subclass approach. Use CLAUDE.md's "Variant and tone system" section verbatim as the source of truth, with the `Button` example from `button.dart`.

- [ ] **Step 4: Write `iconography.md`**

Document `Iconography` as a required parameter on `ThemeData.light()`/`.dark()`, the slot table (from CLAUDE.md's Iconography table — `checkIcon`, `backIcon`, `forwardIcon`, `expandIcon`, `collapseIcon`, `closeIcon`, `removeIcon`, `alertIcon` and their consumers), and the optional-override-with-fallback pattern.

- [ ] **Step 5: Write `responsive.md`**

Document `Breakpoints`, `Breakpoint` (enhanced enum with comparison operators), and `ResponsiveBuilder` (uses parent constraints, not `MediaQuery.sizeOf`). Source: CLAUDE.md "Responsive breakpoints" + the two source files.

- [ ] **Step 6: Build and commit**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
git add docs/docs/architecture
git commit -m "docs: architecture section"
```
Expected: build succeeds before commit.

---

## Task 6: Components — Atoms (13 pages)

**Files:**
- Create: `docs/docs/components/_category_.json`
- Create: `docs/docs/components/atoms/_category_.json`
- Create: `docs/docs/components/atoms/{avatar,avatar-stack,badge,button,checkbox,chip,divider,progress-bar,radio,slider,spinner,status-dot,switch}.md` (13 files)

**Interfaces:**
- Consumes: config/sidebar from Task 1.
- Produces: `/components/atoms/<name>` routes. `/components/atoms/button` is linked from Task 2 footer, Task 3, and the intro.

- [ ] **Step 1: Write the category files**

`docs/docs/components/_category_.json`:
```json
{
  "label": "Components",
  "position": 5,
  "link": {"type": "generated-index", "description": "Reference for every catalyst_ui component."}
}
```
`docs/docs/components/atoms/_category_.json`:
```json
{"label": "Atoms", "position": 1}
```

- [ ] **Step 2: Write the reference template (worked example: `button.md`)**

Read `lib/src/components/atoms/button.dart`, then write `docs/docs/components/atoms/button.md` following this exact template. This is the canonical model every component page copies:

````md
---
title: Button
---

# Button

A pressable button supporting labels, icons, loading states, and user-defined
visual variants.

## When to use it

Use a `Button` for the primary and secondary actions on a screen — submitting
forms, confirming dialogs, triggering navigation. Use `Button.icon` for a
square icon-only button.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Button(
  label: const Text('Save'),
  variant: ButtonVariant.primary,
  onPressed: _handleSave,
)
```

Pass `null` for `onPressed` to disable the button.

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `Widget` | required | The primary content, typically a `Text`. |
| `onPressed` | `VoidCallback?` | required | Called when tapped. `null` disables. |
| `leadingIcon` | `Widget?` | `null` | Icon placed left of the label. |
| `trailingIcon` | `Widget?` | `null` | Icon placed right of the label. |
| `loading` | `bool` | `false` | Shows a `Spinner` and ignores taps. |
| `elevated` | `bool` | `false` | Adds a drop shadow. |
| `fullWidth` | `bool` | `false` | Stretches to fill available width. |
| `size` | `ButtonSize` | `ButtonSize.large` | Height/padding/font-size preset. |
| `variant` | `ButtonVariant` | `ButtonVariant.primary` | Visual variant. |
| `semanticsLabel` | `String?` | `null` | Accessibility label. |

### `Button.icon`

A square icon-only constructor. Requires `icon`, `onPressed`, and
`semanticsLabel`; also accepts `loading`, `elevated`, `size`, `variant`, and
`shape`.

## Sizes

`ButtonSize` values: `link`, `small` (44px), `medium` (48px), `large` (52px,
default), `extraLarge` (60px).

## Variants

Built-in `ButtonVariant` presets:

- `ButtonVariant.primary` — solid brand fill; default call-to-action.
- `ButtonVariant.secondary` — outlined on a surface background.
- `ButtonVariant.tertiary` — subtle filled with a light border.
- `ButtonVariant.ghost` — no background or border.
- `ButtonVariant.destructive` — solid danger fill.
- `ButtonVariant.success` — solid success fill.

Define your own by subclassing `ButtonVariant` and implementing `resolve`:

```dart
class OutlineButtonVariant extends ButtonVariant {
  const OutlineButtonVariant();

  @override
  ButtonVariantStyle resolve(ColorScheme cs) => ButtonVariantStyle(
    foregroundColor: cs.brand,
    borderColor: cs.brand,
  );
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
````

- [ ] **Step 3: Write the remaining 12 atom pages**

For each of `avatar, avatar_stack, badge, checkbox, chip, divider, progress_bar, radio, slider, spinner, status_dot, switch`: read `lib/src/components/atoms/<file>.dart` and write `docs/docs/components/atoms/<kebab-name>.md` using the same template as `button.md`. Include the **Variants/Tones** section only where the component defines one (e.g. `badge` → `BadgeVariant`, `chip` → `ChipVariant`, `progress_bar` → `ProgressBarTone`, `status_dot` → `StatusTone`). Include an **Iconography** note where the component consumes an icon slot (e.g. `checkbox`/`chip` → `checkIcon`). Copy parameter names, types, and defaults directly from each constructor.

File-name mapping (kebab-case): `avatar_stack.dart` → `avatar-stack.md`, `progress_bar.dart` → `progress-bar.md`, `status_dot.dart` → `status-dot.md`; all others are the single word.

- [ ] **Step 4: Build to verify all atom pages**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds; `/components/atoms/button` and siblings resolve.

- [ ] **Step 5: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs/docs/components
git commit -m "docs: atom component reference pages"
```

---

## Task 7: Components — Molecules (17 pages)

**Files:**
- Create: `docs/docs/components/molecules/_category_.json`
- Create: `docs/docs/components/molecules/{action-tile,alert,breadcrumb,card,list-item,menu-button,multi-select,pagination,segmented-control,select,snackbar,stat-card,stepper,tabs,text-field,tooltip,value-row}.md` (17 files)

**Interfaces:**
- Consumes: components category from Task 6; the page template defined in Task 6 Step 2.
- Produces: `/components/molecules/<name>` routes.

- [ ] **Step 1: Write `docs/docs/components/molecules/_category_.json`**

```json
{"label": "Molecules", "position": 2}
```

- [ ] **Step 2: Write the 17 molecule pages**

For each of `action_tile, alert, breadcrumb, card, list_item, menu_button, multi_select, pagination, segmented_control, select, snackbar, stat_card, stepper, tabs, text_field, tooltip, value_row`: read `lib/src/components/molecules/<file>.dart` and write `docs/docs/components/molecules/<kebab-name>.md` using the Task 6 Step 2 template (title, summary, when-to-use, import, usage, parameters table, variants/tones, iconography note). Tone-based molecules include a **Tones** section: `alert` → `AlertTone`, `card` → `CardTone`, `snackbar` → `SnackbarTone`. Iconography consumers include: `breadcrumb` → `forwardIcon`, `menu_button` → `checkIcon`, `select` → `checkIcon`/`expandIcon`/`collapseIcon`, `stepper` → `checkIcon`, `pagination` → `backIcon`/`forwardIcon`. Verify each against the source before writing — do not assume.

Kebab mapping: `action_tile`→`action-tile`, `list_item`→`list-item`, `menu_button`→`menu-button`, `multi_select`→`multi-select`, `segmented_control`→`segmented-control`, `stat_card`→`stat-card`, `text_field`→`text-field`, `value_row`→`value-row`.

- [ ] **Step 3: Build to verify**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds.

- [ ] **Step 4: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs/docs/components/molecules
git commit -m "docs: molecule component reference pages"
```

---

## Task 8: Components — Organisms (13 pages)

**Files:**
- Create: `docs/docs/components/organisms/_category_.json`
- Create: `docs/docs/components/organisms/{app-bar,bottom-nav,bottom-sheet,date-picker,drawer,empty-state,error-state,form-layout,modal,radio-group,side-nav,time-picker,top-bar}.md` (13 files)

**Interfaces:**
- Consumes: components category from Task 6; the page template from Task 6 Step 2.
- Produces: `/components/organisms/<name>` routes.

- [ ] **Step 1: Write `docs/docs/components/organisms/_category_.json`**

```json
{"label": "Organisms", "position": 3}
```

- [ ] **Step 2: Write the 13 organism pages**

For each of `app_bar, bottom_nav, bottom_sheet, date_picker, drawer, empty_state, error_state, form_layout, modal, radio_group, side_nav, time_picker, top_bar`: read `lib/src/components/organisms/<file>.dart` and write `docs/docs/components/organisms/<kebab-name>.md` using the Task 6 Step 2 template. Note the modal/bottom-sheet/drawer helpers live in `lib/src/utils/show_modal.dart` — read it too and document the `showModal`/bottom-sheet/drawer entry points on the relevant pages. Iconography consumers: `app_bar` → `backIcon`, `drawer` → `closeIcon`, `error_state` → `alertIcon`. Verify against source before writing.

Kebab mapping: `app_bar`→`app-bar`, `bottom_nav`→`bottom-nav`, `bottom_sheet`→`bottom-sheet`, `date_picker`→`date-picker`, `empty_state`→`empty-state`, `error_state`→`error-state`, `form_layout`→`form-layout`, `radio_group`→`radio-group`, `side_nav`→`side-nav`, `time_picker`→`time-picker`, `top_bar`→`top-bar`.

- [ ] **Step 3: Build to verify**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: build succeeds.

- [ ] **Step 4: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs/docs/components/organisms
git commit -m "docs: organism component reference pages"
```

---

## Task 9: GitHub Pages deploy workflow

**Files:**
- Create: `.github/workflows/deploy-docs.yml` (repo root)

**Interfaces:**
- Consumes: the buildable `docs/` site.
- Produces: CI that builds `docs/` and publishes to GitHub Pages on push to `main`.

- [ ] **Step 1: Write `.github/workflows/deploy-docs.yml`**

```yaml
name: Deploy docs to GitHub Pages

on:
  push:
    branches: [main]
    paths: ['docs/**', '.github/workflows/deploy-docs.yml']
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: docs
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 22
          cache: npm
          cache-dependency-path: docs/package-lock.json
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-pages-artifact@v3
        with:
          path: docs/build

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

- [ ] **Step 2: Confirm a lockfile exists for `npm ci`**

```bash
ls docs/package-lock.json
```
Expected: file exists (created by the install in Task 1). If missing, run `npm --prefix docs install` and commit it.

- [ ] **Step 3: Commit**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add .github/workflows/deploy-docs.yml docs/package-lock.json
git commit -m "ci: deploy docs to GitHub Pages on push to main"
```

Note: the repo's GitHub Pages source must be set to "GitHub Actions" in repo settings (Settings → Pages) for the workflow to publish. This is a one-time manual step outside this plan.

---

## Task 10: Final verification and link-in

**Files:**
- Modify: any page with links temporarily downgraded to plain text during earlier tasks (restore them).

**Interfaces:**
- Consumes: all prior tasks.
- Produces: a fully green production build with all cross-links live and every component reachable from the sidebar.

- [ ] **Step 1: Restore any temporarily-plain links**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
grep -rn "Placeholder" docs/docs || echo "no placeholders"
```
Expected: `no placeholders`. If any remain, replace with real content. Also re-add any links to `/theming/color-scheme` and `/components/atoms/button` that were downgraded in Task 3.

- [ ] **Step 2: Full production build (broken-link gate)**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run build
```
Expected: "Generated static files in build." with no broken-link errors.

- [ ] **Step 3: Verify every exported component has a page**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
for f in $(cat lib/src/components/atoms/atoms.dart lib/src/components/molecules/molecules.dart lib/src/components/organisms/organisms.dart | sed "s/export '//;s/.dart';//"); do
  kebab=$(echo "$f" | tr '_' '-')
  found=$(find docs/docs/components -name "$kebab.md")
  [ -z "$found" ] && echo "MISSING PAGE: $f"
done
echo "check complete"
```
Expected: "check complete" with no "MISSING PAGE" lines.

- [ ] **Step 4: Local smoke check (optional, manual)**

```bash
export PATH="$HOME/.nvm/versions/node/v22.12.0/bin:$PATH"
cd /Users/peter.bryant/Developer/catalyst_ui
npm --prefix docs run serve
```
Open the served URL, confirm homepage, search box, and sidebar navigation across atoms/molecules/organisms. Stop the server when done.

- [ ] **Step 5: Final commit (if any fixes were made)**

```bash
cd /Users/peter.bryant/Developer/catalyst_ui
git add docs
git commit -m "docs: finalise cross-links and verify full build"
```

---

## Self-Review Notes

- **Spec coverage:** location/tooling (T1), docs-only + local search + GH Pages config (T1), homepage/intro (T2), getting started (T3), theming (T4), architecture (T5), all 43 component pages via the standard template (T6–T8), deploy workflow (T9), verification/broken-link gate (T10). All spec sections mapped.
- **Component count:** 13 atoms + 17 molecules + 13 organisms = 43, matching the barrel exports (the spec's "~45" estimate resolves to 43 actual exported widgets).
- **Broken-link ordering:** cross-links between sections can fail the `onBrokenLinks: 'throw'` build if a target is written later. The plan handles this with stubs (T2 Step 6) and an explicit restore/verify pass (T10). Executors may also choose to write Tasks 4–8 before finalising Task 3's links.
- **Content fidelity:** every component/theming page instructs reading the specific source file before writing, and forbids inventing parameters — enforced by the Global Constraints.
