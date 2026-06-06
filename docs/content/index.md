---
title: Catalyst UI
description: A flexible, theme-driven UI component library for Flutter
---

Catalyst UI is a flexible, theme-drive UI component library for Flutter. It's completely independent of Material and Cupertino.

## Features

- **Zero Material / Cupertino dependency** — uses `flutter.widgets.dart` only. Your app won't look generic.
- **Fully customisable design tokens** — colour scheme, typography, motion, shadows, spacing, and border radius are all globally customisable using `ThemeData`
- **Open variant and tone system** — subclass any `Variant` or `Tone` class to create your own styles for a number of components including `Button`, `Chip`, `Card`, and more.
- **Overlay utilities** — `showModal`, `showBottomSheet`, `showDrawer`, and `showSnackbar` all handle their own transitions and layouts
  — **40+ components**

## Installation

Add to your `pubspec.yaml`:

```shellscript
$ flutter pub add catalyst_ui
```

## Quick start

Wrap the root of your navigator with `CatalystProvider`. This sets up the theme and all overlay dependencies in one step:

```dart
import 'package:catalyst_ui/catalyst_ui.dart';

// Build your Iconography once (use any icon package you like):
final icons = Iconography(
  checkIcon: MyIcons.check,
  backIcon: MyIcons.chevronLeft,
  forwardIcon: MyIcons.chevronRight,
  expandIcon: MyIcons.chevronDown,
  collapseIcon: MyIcons.chevronUp,
  closeIcon: MyIcons.x,
  removeIcon: MyIcons.x,
  alertIcon: MyIcons.alertCircle,
);

// Light theme only:
CatalystProvider(
  theme: ThemeData.light(iconography: icons, fontFamily: 'Inter'),
  child: MyHomePage(),
)

// Automatic dark / light switching — follows the OS setting:
CatalystProvider(
  theme: ThemeData.light(iconography: icons, fontFamily: 'Inter'),
  darkTheme: ThemeData.dark(iconography: icons, fontFamily: 'Inter'),
  child: MyHomePage(),
)

// Force a specific mode regardless of the OS setting:
CatalystProvider(
  theme: ThemeData.light(iconography: icons, fontFamily: 'Inter'),
  darkTheme: ThemeData.dark(iconography: icons, fontFamily: 'Inter'),
  themeMode: ThemeMode.dark,
  child: MyHomePage(),
)

// With WidgetsApp.router:
WidgetsApp.router(
  routerConfig: routerConfig,
  color: myBrandColor,
  builder: (context, child) {
    return CatalystProvider(
      theme: ThemeData.light(iconography: icons),
      child: child!,
    );
  }
);
```

`CatalystProvider` is router-agnostic — you can place it inside any app widget wherever an `Overlay` is available.
