---
title: List Item
---

# List Item

A single row in a list with optional leading icon, title, subtitle, and
trailing widget.

## When to use it

Use `ListItem` to render rows in a settings list, contact list, or any
vertically stacked list of similar entries. Provide `onTap` to make the row
interactive; omit it for a static, non-interactive row.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
ListItem(
  leading: const Icon(Icons.person),
  title: const Text('Account'),
  subtitle: const Text('Manage your profile'),
  trailing: const Icon(Icons.chevron_right),
  onTap: _openAccount,
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget` | required | The primary label. |
| `divider` | `bool` | `true` | Whether to render a bottom border below the item. |
| `padding` | `EdgeInsets` | `EdgeInsets.all(Spacing.s4)` | Inner padding applied to the row. |
| `borderRadius` | `BorderRadius` | `BorderRadius.zero` | Optional border radius. |
| `leading` | `Widget?` | `null` | An optional widget at the start of the row, typically an icon. |
| `subtitle` | `Widget?` | `null` | An optional secondary line below `title`. |
| `trailing` | `Widget?` | `null` | An optional widget at the end of the row. |
| `onTap` | `VoidCallback?` | `null` | Called when the item is tapped. When `null`, the row is non-interactive. |
