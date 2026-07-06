---
title: Drawer
---

# Drawer

A side panel that slides in from the edge of the screen.

## When to use it

Use `Drawer` for a side panel of secondary navigation or contextual actions —
account menus, filters, or detail panels that slide in from the edge. Present
it with `showDrawer` rather than placing it directly in the widget tree. A
close button is automatically shown in the header row.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
showDrawer<void>(
  context,
  (context) => Drawer(
    title: const Text('Account'),
    body: const Text('Drawer content goes here.'),
  ),
);
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget` | required | The header title, shown next to the close button. |
| `body` | `Widget` | required | The scrollable content area. |
| `footer` | `Widget?` | `null` | An optional footer widget pinned below the body. |
| `closeIcon` | `IconData?` | `null` | Icon to display on the close button. Falls back to `Iconography.closeIcon`. |

## Showing it

`showDrawer<T>(BuildContext context, WidgetBuilder builder, {bool barrierDismissible = true, bool useRootNavigator = true})`,
defined in `lib/src/utils/show_modal.dart`, displays a drawer panel sliding in
from the right edge of the screen with a fade + slide transition (300ms).
Returns a `Future` that resolves to the value passed to `Navigator.pop`, or
`null` if dismissed.

## Iconography

The close button in the header row uses `closeIcon`, falling back to
`context.iconography.closeIcon`.
