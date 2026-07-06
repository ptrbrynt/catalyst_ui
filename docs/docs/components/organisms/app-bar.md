---
title: AppBar
---

# AppBar

A top application bar for mobile screens.

## When to use it

Use `AppBar` as the header of a mobile screen — a centred title, an optional
back button, and trailing actions. When `automaticallyImplyLeading` is `true`
(the default) and the current route can be popped, a back button is shown
automatically; on iOS this uses a chevron, on other platforms an arrow (via
`context.iconography.backIcon`).

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
AppBar(
  title: const Text('Settings'),
  actions: [
    AppBarAction(
      icon: LucideIcons.search,
      semanticsLabel: 'Search',
      onTap: _onSearch,
    ),
  ],
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget?` | `null` | An optional centred widget, typically a `Text` title. |
| `automaticallyImplyLeading` | `bool` | `true` | Whether to auto-show a back button when the route can pop. |
| `leading` | `Widget?` | `null` | Overrides the auto-generated leading widget. |
| `actions` | `List<AppBarAction>` | `[]` | Actions shown on the trailing end of the bar. |
| `backIcon` | `IconData?` | `null` | Icon for the default back button. Falls back to `Iconography.backIcon`. |

### `AppBarAction`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `icon` | `IconData` | required | The icon to display in the app bar. |
| `semanticsLabel` | `String` | required | A semantics label and tooltip text. |
| `onTap` | `VoidCallback` | required | Called when the user taps this action. |
| `tone` | `ActionTone` | `ActionTone.neutral` | The color scheme for this action. |

### `ActionTone`

Enum values: `primary` (brand color), `success`, `danger`, `neutral`
(neutral foreground color, default).

## Iconography

When `automaticallyImplyLeading` is `true` and no `leading` is supplied, the
auto-generated back button uses `backIcon`, falling back to
`context.iconography.backIcon`.
