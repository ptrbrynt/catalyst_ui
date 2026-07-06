---
title: Modal
---

# Modal

A dialog modal with a title, body, and row of action buttons.

## When to use it

Use `Modal` for confirmations, destructive-action prompts, or short focused
tasks that require a decision before the user can continue. Present it with
`showModal` rather than placing it directly in the widget tree. Actions are
right-aligned at the bottom.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
showModal<void>(
  context,
  (context) => Modal(
    title: const Text('Delete item?'),
    body: const Text('This action cannot be undone.'),
    actions: [
      Button(
        label: const Text('Cancel'),
        variant: ButtonVariant.secondary,
        onPressed: () => Navigator.pop(context),
      ),
      Button(
        label: const Text('Delete'),
        variant: ButtonVariant.destructive,
        onPressed: _onDelete,
      ),
    ],
  ),
);
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget` | required | The modal heading. |
| `body` | `Widget` | required | The main content. |
| `actions` | `List<Widget>` | `[]` | Action widgets (e.g. `Button`s) at the bottom. When empty, no action row or divider is shown. |
| `maxWidth` | `double` | `480` | Maximum width of the modal. |

## Showing it

`showModal<T>(BuildContext context, WidgetBuilder builder, {bool barrierDismissible = true, bool useRootNavigator = true})`,
defined in `lib/src/utils/show_modal.dart`, displays a modal dialog centred on
screen with a fade + scale transition (300ms). Returns a `Future` that
resolves to the value passed to `Navigator.pop`, or `null` if dismissed.
