---
title: Tabs
---

# Tabs

A horizontal tab bar that switches between named sections.

## When to use it

Use `Tabs<T>` to let a user switch between named sections of content on the
same screen, such as "All" / "Active" / "Archived" views. The active tab is
underlined with the brand colour. Pair with a content area below to show
the corresponding view.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Tabs<String>(
  value: _selected,
  options: const [
    TabOption(value: 'all', label: 'All'),
    TabOption(value: 'active', label: 'Active', badge: '3'),
  ],
  onChanged: (v) => setState(() => _selected = v),
)
```

## Parameters

`Tabs<T>` is generic over the tab value type `T`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<TabOption<T>>` | required | The list of tab options. |
| `onChanged` | `ValueChanged<T>` | required | Called when the user taps a different tab. |
| `value` | `T?` | `null` | The currently selected tab value, or `null` for no selection. |

### `TabOption<T>`

A single option in a `Tabs` bar.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value associated with this tab. |
| `label` | `String` | required | The text label shown on the tab. |
| `badge` | `String?` | `null` | An optional count or status string shown as a small `Badge` (`BadgeSize.small`, `BadgeVariant.info` when selected, `BadgeVariant.neutral` otherwise). |
