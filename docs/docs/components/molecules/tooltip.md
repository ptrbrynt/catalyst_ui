---
title: Tooltip
---

# Tooltip

A small informational overlay that appears on hover or long-press.

## When to use it

Use `Tooltip` to provide brief supplementary information for an
icon-only button or another ambiguous control. It fades and scales in
above (or below) `child`, then disappears when the pointer leaves or the
long-press ends.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Tooltip(
  content: 'Save changes',
  child: const Icon(Icons.save),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `content` | `String` | required | The plain-text message inside the tooltip. |
| `child` | `Widget` | required | The widget that triggers the tooltip. |
| `side` | `TooltipSide` | `TooltipSide.top` | Which side of `child` the tooltip appears on. |

### `TooltipSide`

The side on which a `Tooltip` appears relative to its child.

- `TooltipSide.top` — appears above the child (default).
- `TooltipSide.bottom` — appears below the child.
