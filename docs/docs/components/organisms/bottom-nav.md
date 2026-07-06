---
title: BottomNav
---

# BottomNav

A bottom navigation bar for mobile screens.

## When to use it

Use `BottomNav<T>` for the primary navigation of a mobile app — 2-5 top-level
destinations shown as icon + label pairs, spaced evenly. The selected
destination is highlighted with the brand colour.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
BottomNav<int>(
  selectedItem: _tabIndex,
  onItemSelected: (i) => setState(() => _tabIndex = i),
  destinations: const [
    BottomNavDestination(value: 0, label: 'Home', icon: LucideIcons.home),
    BottomNavDestination(value: 1, label: 'Search', icon: LucideIcons.search),
    BottomNavDestination(value: 2, label: 'Profile', icon: LucideIcons.user),
  ],
)
```

## Parameters

`BottomNav<T>` is generic over the destination value type `T`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `selectedItem` | `T` | required | The value of the currently selected destination. |
| `onItemSelected` | `ValueChanged<T>` | required | Called when the user taps a destination. |
| `destinations` | `List<BottomNavDestination<T>>` | required | The list of destinations. |

### `BottomNavDestination<T>`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value that identifies this destination. |
| `label` | `String` | required | The short text label shown below the icon. |
| `icon` | `IconData` | required | The icon data displayed above the label. |
