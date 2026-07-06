---
title: Value Row
---

# Value Row

A single label–value pair row, typically used in a details section.

## When to use it

Use `ValueRow` to display a read-only label/value pair, such as a line in an
order summary or a details/settings screen. Renders `title` left-aligned and
`value` right-aligned, separated by an optional bottom border.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
ValueRow('Order ID', '#48213')
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required | The descriptive label shown on the left. Positional parameter. |
| `value` | `String` | required | The data value shown on the right. Positional parameter. |
| `divider` | `bool` | `true` | Whether to render a subtle bottom border below the row. |

`ValueRow` uses positional constructor parameters:
`ValueRow(title, value, {divider = true})`. Internally it renders a `Divider`
when `divider` is `true`.
