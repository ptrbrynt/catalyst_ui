---
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
