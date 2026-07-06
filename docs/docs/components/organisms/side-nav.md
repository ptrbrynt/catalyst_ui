---
title: SideNav
---

# SideNav

A collapsible vertical navigation rail for desktop/web layouts.

## When to use it

Use `SideNav<T>` as the primary navigation for desktop/web apps. When
`isExpanded` is `true` the nav shows icon + label (240px wide); when `false`
it collapses to icon-only (64px wide). An optional `header` is pinned above
the scrollable item list and an optional `footer` is pinned below it, both
visible regardless of scroll position.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
SideNav<String>(
  selectedItem: _section,
  onItemSelected: (v) => setState(() => _section = v),
  isExpanded: true,
  items: [
    SideNavGroupTitle('Main'),
    SideNavDestination(
      value: 'home',
      icon: const Icon(LucideIcons.home),
      label: const Text('Home'),
    ),
    SideNavDestination(
      value: 'inbox',
      icon: const Icon(LucideIcons.inbox),
      label: const Text('Inbox'),
      badge: const Badge(label: Text('3')),
    ),
  ],
)
```

## Parameters

`SideNav<T>` is generic over the destination value type `T`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `selectedItem` | `T` | required | The currently selected destination value. |
| `onItemSelected` | `ValueChanged<T>` | required | Called when the user taps a destination. |
| `items` | `List<SideNavItem<T>>` | required | The ordered list of destinations and group titles. |
| `isExpanded` | `bool` | `true` | When `true`, renders icon + label (240px). When `false`, icon-only (64px). |
| `header` | `Widget?` | `null` | An optional widget pinned above the scrollable item list. Useful for branding, logos, or a collapse toggle. |
| `footer` | `Widget?` | `null` | An optional widget pinned below the scrollable item list. Useful for account menus, settings shortcuts, or version info. |

### `SideNavItem<T>`

A sealed base class for entries in a `SideNav`'s `items` list. Use
`SideNavDestination` for tappable destinations and `SideNavGroupTitle` for
non-interactive section headings.

### `SideNavDestination<T>`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value identifying this destination. |
| `icon` | `Widget` | required | The icon shown in collapsed and expanded states. |
| `label` | `Widget` | required | The label shown when expanded. |
| `badge` | `Badge?` | `null` | An optional [Badge](/components/atoms/badge) at the trailing edge (expanded only). |

### `SideNavGroupTitle<T>`

A non-interactive group heading between destinations.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required (positional) | The group label displayed above the section. |
