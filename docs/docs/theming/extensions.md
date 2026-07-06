---
title: Context extensions
---

# Context extensions

Convenience accessors for `ThemeData` on `BuildContext`, defined in
`extensions.dart` as the `ThemeContext` extension.

## How the theme flows

```
Provider
  └── Theme (InheritedWidget)     ← propagates ThemeData
        └── DefaultTextStyle              ← set to typography.defaultStyle
              └── SnackbarHandler ← overlay for snackbar
                    └── child
```

`ThemeData` aggregates six sub-objects: `colorScheme`, `typography`,
`motion`, `shadows`, `breakpoints`, `iconography`. Components read them via
the `BuildContext` extensions below rather than calling `Theme.of(context)`
directly.

## `ThemeContext` getters

| Getter | Type | Equivalent to |
|---|---|---|
| `theme` | `ThemeData` | `Theme.of(this)` — the full theme from the nearest `Theme` ancestor. |
| `colorScheme` | `ColorScheme` | `theme.colorScheme` |
| `typography` | `Typography` | `theme.typography` |
| `motion` | `Motion` | `theme.motion` |
| `shadows` | `Shadows` | `theme.shadows` |
| `breakpoints` | `Breakpoints` | `theme.breakpoints` |
| `iconography` | `Iconography` | `theme.iconography` |

Usage inside a component:

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

Widget build(BuildContext context) {
  return DecoratedBox(
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: Radii.mdAll,
      boxShadow: context.shadows.sm,
    ),
    child: Text(
      'Hello',
      style: context.typography.body,
    ),
  );
}
```

Every built-in component reads styling exclusively through these getters —
never hardcoding colours, fonts, durations, breakpoint values, or icon
data — so overriding any `ThemeData` sub-object (see
[ColorScheme](/theming/color-scheme), [Typography](/theming/typography),
[Motion](/theming/motion), [Shadows](/theming/shadows), and
[Tokens](/theming/tokens)) propagates automatically to every component
beneath the `Theme` in the tree.

## `BrightnessFilter` extension

`extensions.dart` also defines a `BrightnessFilter` extension on `Widget`:

| Method | Type | Description |
|---|---|---|
| `withBrightness(double amount)` | `Widget` | Applies a multiplicative brightness factor via a colour-matrix filter. `1.0` leaves the widget unchanged; values below `1.0` darken it — used for pressed/active feedback on interactive elements. |

```dart
MyIcon().withBrightness(0.85) // dims the widget for a pressed state
```

This extension is unrelated to `ThemeData` — it operates directly on any
`Widget` and does not require a `BuildContext` or an ambient `Theme`.
