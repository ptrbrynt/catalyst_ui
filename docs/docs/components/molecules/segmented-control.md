---
title: Segmented Control
---

# Segmented Control

A horizontal group of mutually exclusive toggle buttons.

## When to use it

Use `SegmentedControl<T>` to switch between a small number of closely
related views, such as toggling between "List" and "Grid" layouts. The
selected option is highlighted with a surface-coloured pill against a subtle
track.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
SegmentedControl<String>(
  value: _view,
  options: const [
    SegmentedControlOption(value: 'list', label: 'List'),
    SegmentedControlOption(value: 'grid', label: 'Grid'),
  ],
  onChanged: (v) => setState(() => _view = v),
)
```

## Parameters

`SegmentedControl<T>` is generic over the option value type `T`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<SegmentedControlOption<T>>` | required | The list of options to display. |
| `onChanged` | `ValueChanged<T>` | required | Called when the user selects a different option. |
| `value` | `T?` | `null` | The currently selected value, or `null` for no selection. |
| `fullWidth` | `bool` | `false` | Segments expand to fill available width equally when `true`. |
| `size` | `double` | `40` (`32` via `.small`, `48` via `.large`) | The height of each segment in logical pixels. Set via named constructor, not a direct parameter. |

### `SegmentedControl.small`

A compact 32px-tall constructor. Accepts the same `options`, `onChanged`,
`value`, and `fullWidth` parameters.

### `SegmentedControl.large`

A large 48px-tall constructor. Accepts the same `options`, `onChanged`,
`value`, and `fullWidth` parameters.

### `SegmentedControlOption<T>`

A single option in a `SegmentedControl`. Supply `label`, `icon`, or both — at
least one must be provided (enforced by an assertion).

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value associated with this option. |
| `label` | `String?` | `null` | The text label displayed for this option, or `null` for icon-only. |
| `icon` | `IconData?` | `null` | The icon displayed for this option, or `null` for text-only. |
