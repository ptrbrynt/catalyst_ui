---
title: Breadcrumb
---

# Breadcrumb

A horizontal breadcrumb trail for communicating navigational hierarchy.

## When to use it

Use `Breadcrumb` to show a user's location within a nested navigation
hierarchy, such as a folder path or a multi-level settings screen. The last
item in `items` is treated as the current (non-tappable) page. All preceding
items are tappable and call `onItemTapped` with their index.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Breadcrumb(
  items: const ['Home', 'Settings', 'Profile'],
  onItemTapped: (i) => _navigateTo(i),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `items` | `List<String>` | required | Ordered labels from root to current page. |
| `onItemTapped` | `void Function(int index)` | required | Called with the index of a tapped ancestor item. |
| `separatorIcon` | `IconData?` | `null` | Icon to display between the items. Falls back to `context.iconography.forwardIcon` when `null`. |

## Iconography

`Breadcrumb` shows `separatorIcon` between items, falling back to
`context.iconography.forwardIcon` when not provided.
