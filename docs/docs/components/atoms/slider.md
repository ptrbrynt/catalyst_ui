---
title: Slider
---

# Slider

A draggable horizontal slider for selecting a value within a range.

## When to use it

Use a `Slider` to let the user pick a numeric value by dragging — for
example, volume, brightness, or a price filter. The visual scale runs from
`start` to `end`. The selectable range can be narrowed to `min`–`max`:
portions of the track outside that range are rendered in a dimmed style with
a tick mark at each boundary, and the thumb cannot be dragged beyond those
bounds. Pass `null` for `onChanged` to render the slider as disabled.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Slider(
  value: _volume,
  onChanged: (v) => setState(() => _volume = v),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | The current value, which must be within `[min, max]`. |
| `onChanged` | `ValueChanged<double>?` | required | Called continuously as the user drags. `null` disables. |
| `start` | `double` | `0` | Where the slider scale begins. |
| `end` | `double` | `1` | Where the slider scale ends. |
| `min` | `double?` | `start` | The minimum selectable value. When greater than `start`, a dimmed track overlay and a tick mark are shown between `start` and this value. |
| `max` | `double?` | `end` | The maximum selectable value. When less than `end`, a dimmed track overlay and a tick mark are shown between this value and `end`. |
| `onChangeStarted` | `VoidCallback?` | `null` | Called when the user begins dragging. |
| `onChangeEnded` | `VoidCallback?` | `null` | Called when the user stops dragging. |
