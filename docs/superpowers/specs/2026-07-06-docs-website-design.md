# Design: catalyst_ui documentation website

**Date:** 2026-07-06
**Status:** Approved

## Goal

Build a documentation website for the `catalyst_ui` Flutter component library
using [Docusaurus](https://docusaurus.io), located in a `docs/` subdirectory
below the package root. The site is a static reference covering foundations
(getting started, theming, architecture) and a page for every component
(~45 across atoms, molecules, and organisms).

## Decisions

| Question | Decision |
|---|---|
| Content scope | Full reference — foundations + a page for every component (~45) |
| Per-page depth | API + copy-paste Dart code samples (no Flutter-Web embeds, no screenshots) |
| Site features | Docs-only (blog disabled) + local offline search |
| Deploy target | GitHub Pages (`ptrbrynt/catalyst_ui`) |
| Versioning | None |

## Location & tooling

- Docusaurus **classic preset**, TypeScript config, rooted at `docs/`.
  - `docs/package.json`, `docs/docusaurus.config.ts`, `docs/sidebars.ts`,
    `docs/src/`, `docs/static/`, `docs/docs/` (content).
- The existing `docs/superpowers/` folder (specs/plans) sits alongside the
  Docusaurus root. Docusaurus reads only its configured content path
  (`docs/docs/`), so `docs/superpowers/` is never treated as documentation.
- Node: use nvm's Node v22 (`~/.nvm/versions/node/v22.12.0/bin`). The
  interactive shell's nvm shims are not loaded in non-interactive bash, so
  invoke node/npm/npx via the absolute nvm path (or `source` nvm first).
- `docs/.gitignore` ignores `node_modules/`, `build/`, `.docusaurus/`.

## Site configuration (`docusaurus.config.ts`)

- **Docs-only:** disable the blog in the classic preset (`blog: false`); serve
  docs at the site root (`routeBasePath: '/'`).
- **Local search:** `@easyops-cn/docusaurus-search-local` theme, configured for
  offline indexing (no Algolia).
- **GitHub Pages:**
  - `url: 'https://ptrbrynt.github.io'`
  - `baseUrl: '/catalyst_ui/'`
  - `organizationName: 'ptrbrynt'`, `projectName: 'catalyst_ui'`
  - `editUrl` pointing at the repo `docs/` folder.
- Title: `catalyst_ui`. Tagline from pubspec: a flexible, theme-driven Flutter
  UI library with no Material or Cupertino dependency.
- Navbar: brand + GitHub link. Footer: minimal (links to repo, pub.dev when
  published).

## Deployment

- A GitHub Actions workflow at the **repo root** (`.github/workflows/`) that,
  on push to `main`:
  1. checks out, sets up Node,
  2. `npm ci` + `npm run build` inside `docs/`,
  3. publishes `docs/build` to GitHub Pages via the Pages deploy action.
- Documented in the site's own "contributing/deploy" note or the design only;
  no manual `gh-pages` branch management required.

## Content structure

Sidebar mirrors the atomic-design layout of `lib/src/components/`. Auto-generated
from the folder tree using `_category_.json` files for labels/positions.

```
docs/docs/
  intro.md                    Introduction (what/why, no-Material pitch)
  getting-started.md          Install, Provider + ThemeData setup, first widget
  theming/
    _category_.json
    color-scheme.md
    typography.md
    motion.md
    shadows.md
    tokens.md                 spacing, radius, breakpoints
    extensions.md             context.colorScheme etc.
  architecture/
    _category_.json
    variants-and-tones.md      abstract class + resolve() + style record pattern
    iconography.md             required Iconography slots + override fallback
    responsive.md              Breakpoints, ResponsiveBuilder
  components/
    _category_.json
    atoms/
      _category_.json
      (avatar, avatar-stack, badge, button, checkbox, chip, divider,
       progress-bar, radio, slider, spinner, status-dot, switch)   [13]
    molecules/
      _category_.json
      (action-tile, alert, breadcrumb, card, list-item, menu-button,
       multi-select, pagination, segmented-control, select, snackbar,
       stat-card, stepper, tabs, text-field, tooltip, value-row)    [18]
    organisms/
      _category_.json
      (app-bar, bottom-nav, bottom-sheet, date-picker, drawer,
       empty-state, error-state, form-layout, modal, radio-group,
       side-nav, time-picker, top-bar)                              [14 — see note]
```

Note: the organisms directory also contains `radio_group.dart`. Final component
list is derived from the actual exported public widgets in `atoms.dart`,
`molecules.dart`, and `organisms.dart` at build time; the counts above are the
target and may adjust by ±1 if a file exports a helper rather than a top-level
component.

## Per-component page template

Every component page follows the same structure for consistency:

1. **Title + one-line summary** — from the class doc comment.
2. **When to use it** — short prose.
3. **Import** — ```import 'package:catalyst_ui/catalyst_ui.dart';```
4. **Usage** — minimal copy-paste Dart snippet showing the common case.
5. **Parameters** — a Markdown table: name · type · default · description.
   Sourced from the widget's constructor signature and the `///` doc comments
   on each field. Required params flagged.
6. **Variants / Tones** — where the component is variant- or tone-based: list
   the built-in static presets and note that callers can subclass the abstract
   `FooVariant`/`FooTone` and implement `resolve` for custom styles.
7. **Iconography** — where the component consumes theme icon slots (e.g.
   `checkIcon`, `backIcon`), note the slot used and the optional override param.

Content is **extracted from the Dart source**, never invented: parameter tables,
types, defaults, and variant/tone lists come from reading each source file in
`lib/src/`. Source files are read in batches so the reference matches the real
API.

## Homepage

A light custom landing page (`docs/src/pages/index.tsx`) branded for
catalyst_ui:

- Hero: name, tagline, "Get Started" CTA linking to `getting-started`.
- A small set of feature cards: "No Material or Cupertino dependency",
  "Typed theme system", "Open variant & tone architecture", "Atomic design".
- Reuses the classic template's component/CSS scaffolding, restyled.

## Out of scope (YAGNI)

- Flutter-Web interactive embeds or rendered screenshots.
- Doc versioning.
- Blog.
- Algolia / hosted search.
- Auto-generation of parameter tables from source via a codegen tool — pages
  are hand-written from source reads for this first version.

## Verification

- `npm run build` inside `docs/` completes with no broken-link errors
  (Docusaurus fails the build on broken internal links by default).
- `npm run start` serves the site locally for a visual smoke check.
- Every component exported from the three barrel files has a corresponding page
  reachable from the sidebar.
