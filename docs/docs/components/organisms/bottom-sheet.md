---
title: BottomSheet
---

# BottomSheet

A modal bottom sheet with a drag handle, title, body, and footer.

## When to use it

Use `BottomSheet` for a mobile-style panel that slides up from the bottom —
action pickers, filter panels, or confirmation flows. Present it with
`showBottomSheet` rather than placing it directly in the widget tree. The
sheet constrains its height to 80% of the screen and its width to 440px.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
showBottomSheet<void>(
  context,
  (context) => BottomSheet(
    title: const Text('Filter results'),
    showDragHandle: true,
    footer: Button(
      label: const Text('Apply'),
      onPressed: () => Navigator.pop(context),
    ),
    child: const Text('Filter options go here.'),
  ),
);
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget` | required | The title rendered below the drag handle. |
| `child` | `Widget` | required | The scrollable body content. |
| `footer` | `Widget` | required | A footer pinned to the bottom (e.g. action buttons). |
| `showDragHandle` | `bool` | required | Whether to show a drag handle at the top of the sheet. |

## Showing it

`showBottomSheet<T>(BuildContext context, WidgetBuilder builder, {bool barrierDismissible = true, bool useRootNavigator = true, bool draggable = true})`,
defined in `lib/src/utils/show_modal.dart`, displays a bottom sheet sliding up
from the bottom of the screen with a fade + slide transition
(300ms). When `draggable` is `true` (the default), the sheet can be dismissed
by dragging it downward past a threshold or with sufficient velocity. Returns
a `Future` that resolves to the value passed to `Navigator.pop`, or `null` if
dismissed.

:::note
The `BottomSheet` class doc comment references `showModalBottomSheet`, but the
actual function exported from `lib/src/utils/show_modal.dart` is
`showBottomSheet`. This page documents the runtime name, `showBottomSheet`.
:::
