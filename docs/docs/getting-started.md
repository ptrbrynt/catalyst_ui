---
sidebar_position: 2
---

# Getting Started

This guide walks through installing `catalyst_ui`, wiring up the theme
provider, and rendering your first component.

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

`catalyst_ui` ships **no icon data**. Every component that needs a semantic
icon (a checkmark, a back arrow, a close button, and so on) reads it from an
`Iconography` instance that you construct yourself, using `IconData` values
from whichever icon package your app already depends on — `lucide_icons`,
`flutter_feather_icons`, your own custom icon font, anything works.

`Iconography` requires exactly eight fields:

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:lucide_icons/lucide_icons.dart';

final appIconography = Iconography(
  checkIcon: LucideIcons.check,
  backIcon: LucideIcons.arrowLeft,
  forwardIcon: LucideIcons.arrowRight,
  expandIcon: LucideIcons.chevronDown,
  collapseIcon: LucideIcons.chevronUp,
  closeIcon: LucideIcons.x,
  removeIcon: LucideIcons.x,
  alertIcon: LucideIcons.triangleAlert,
);
```

With an `Iconography` in hand, wrap your app in a `CatalystProvider`. It wires
up theming and all Catalyst overlay dependencies (snackbars, modals) in one
step:

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

CatalystProvider(
  theme: ThemeData.light(
    iconography: appIconography,
    fontFamily: 'Inter',
  ),
  child: MyHomePage(),
)
```

`iconography` is the only required argument to `ThemeData.light()` (and
`ThemeData.dark()`) — `fontFamily` and the other design tokens
(`colorScheme`, `typography`, `motion`, `shadows`, `breakpoints`) are all
optional and fall back to sensible defaults.

## Automatic dark mode

Provide a `darkTheme` and the active theme follows the platform brightness
automatically:

```dart
CatalystProvider(
  theme: ThemeData.light(iconography: appIconography, fontFamily: 'Inter'),
  darkTheme: ThemeData.dark(iconography: appIconography, fontFamily: 'Inter'),
  child: MyHomePage(),
)
```

You can also pin the theme regardless of platform brightness by passing a
`themeMode` of `ThemeMode.light` or `ThemeMode.dark`.

## Your first component

With the provider in place, components read their styling from context —
no extra setup needed at the call site:

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
[component reference](/components/atoms/button).
