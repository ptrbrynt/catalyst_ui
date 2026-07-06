---
title: EmptyState
---

# EmptyState

A centred illustration and message shown when a list or page has no data.

## When to use it

Use `EmptyState` for empty lists, empty search results, or first-run screens
— an icon in a circular background, a heading, a description, and an
optional call-to-action. Use `EmptyState.large` for a more prominent
full-page version.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
EmptyState(
  icon: LucideIcons.inbox,
  title: const Text('Nothing here yet'),
  description: const Text('Add your first item to get started.'),
  action: Button(
    label: const Text('Add item'),
    onPressed: _onAdd,
  ),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `icon` | `IconData` | required | The icon rendered inside the circular background. |
| `title` | `Widget` | required | The primary heading. |
| `description` | `Widget` | required | Supporting description below the heading. |
| `action` | `Widget?` | `null` | An optional call-to-action widget. |
| `iconColor` | `Color?` | `null` | Overrides the default brand-coloured icon colour. |
| `iconBackgroundColor` | `Color?` | `null` | Overrides the default tint background colour of the icon circle. |

### `EmptyState.large`

An alternate constructor with the same parameters, rendering an 88px icon
circle instead of the default 64px.
