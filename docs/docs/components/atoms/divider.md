---
title: Divider
---

# Divider

A thin horizontal or vertical rule used to separate content.

## When to use it

Use a `Divider` to visually separate sections of content in a list or layout.
The horizontal variant optionally accepts a `label` centred within the rule.
Use `Divider.vertical` for an inline vertical divider inside a `Row`.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
const Divider()

Divider(label: const Text('OR'))

Row(
  children: [
    const Text('Left'),
    const Divider.vertical(),
    const Text('Right'),
  ],
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `Widget?` | `null` | An optional widget centred inside a horizontal divider. |
| `margin` | `EdgeInsets` | `EdgeInsets.zero` | Outer spacing applied around the divider. |

### `Divider.vertical`

Creates a vertical divider for use inside a `Row`. Does not accept `label`.
Accepts `margin`, which defaults to
`EdgeInsets.symmetric(horizontal: Spacing.s1)`.
