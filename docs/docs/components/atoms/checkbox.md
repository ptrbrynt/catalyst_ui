---
title: Checkbox
---

# Checkbox

A toggleable checkbox control with an optional text label.

## When to use it

Use a `Checkbox` for binary on/off choices, or for selecting multiple items
from a list — for example, accepting terms, or toggling filter options. Pass
`null` for `onChanged` to render the checkbox as disabled.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Checkbox(
  value: _checked,
  onChanged: (v) => setState(() => _checked = v ?? false),
  label: const Text('Accept terms'),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `bool` | required | Whether the checkbox is currently checked. |
| `onChanged` | `ValueChanged<bool?>?` | required | Called when the user taps. `null` disables. |
| `checkIcon` | `IconData?` | `null` | The icon to display when checked. Falls back to `context.iconography.checkIcon`. |
| `size` | `CheckboxSize` | `CheckboxSize.medium` | The size variant. |
| `label` | `Widget?` | `null` | An optional label rendered to the right of the checkbox. |

## Sizes

`CheckboxSize` values: `small` (16px), `medium` (20px, default), `large` (24px).

## Iconography

`Checkbox` renders `checkIcon` inside the box when `value` is `true`. If
`checkIcon` is not supplied, it falls back to `context.iconography.checkIcon`:

```dart
Icon(checkIcon ?? context.iconography.checkIcon, size: size.dimension - 6)
```
