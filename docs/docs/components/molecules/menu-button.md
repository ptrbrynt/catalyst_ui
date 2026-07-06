---
title: Menu Button
---

# Menu Button

A button that opens a contextual dropdown menu when tapped.

## When to use it

Use `MenuButton` for a "more options" affordance — an overflow menu, a
context menu, or any trigger that should reveal a small list of actions.
Instead of accepting a fixed child widget, `MenuButton` uses a `build`
callback that receives the current `BuildContext` and an `open` callback.
Wire `open` to the trigger's tap handler so the caller controls exactly when
the menu opens — this avoids gesture conflicts with interactive widgets such
as `Button`.

The dropdown position is determined automatically: it opens below the
trigger unless there is insufficient space, in which case it opens above.
Horizontally it aligns to the trigger's leading edge unless that would
overflow the screen, in which case it aligns to the trailing edge.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
MenuButton(
  items: [
    MenuOption(
      label: 'Edit',
      icon: LucideIcons.pencil,
      onTap: _onEdit,
    ),
    MenuOption(label: 'Duplicate', onTap: _onDuplicate),
    const MenuDivider(),
    MenuOption(
      label: 'Delete',
      icon: LucideIcons.trash2,
      onTap: _onDelete,
      isDestructive: true,
    ),
  ],
  build: (context, open) => Button(
    label: const Text('Options'),
    onPressed: open,
  ),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `build` | `Widget Function(BuildContext context, VoidCallback open)` | required | Builds the trigger widget. The `open` callback opens (or closes) the dropdown; wire it to the trigger's tap handler. |
| `items` | `List<MenuItem>` | required | The list of items shown in the dropdown. May contain `MenuOption` entries and `MenuDivider` entries. |

### `MenuItem`

A sealed base class for items that can appear in a `MenuButton` dropdown.
Use `MenuOption` for actionable entries and `MenuDivider` to insert a visual
separator between groups of options.

### `MenuOption`

A single actionable item in a `MenuButton` dropdown.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | The text label displayed in the dropdown row. |
| `icon` | `IconData?` | `null` | Optional icon displayed to the left of the `label`. |
| `selected` | `bool` | `false` | Whether this option appears in a selected/checked state. When `true`, a check icon is shown on the trailing side of the row. |
| `isDestructive` | `bool` | `false` | Uses destructive colors from the theme if `true`. |
| `onTap` | `VoidCallback?` | `null` | Called when the user taps this option. The dropdown closes automatically before `onTap` is invoked. |

### `MenuDivider`

A visual divider that can be placed between groups of items in a
`MenuButton` dropdown. Takes no parameters.

## Iconography

Selected `MenuOption` rows show a check icon using
`context.iconography.checkIcon`.
