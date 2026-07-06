---
title: Switch
---

# Switch

A toggleable on/off switch control.

## When to use it

Use a `Switch` for a binary on/off setting that takes effect immediately —
for example, toggling a preference. Pass `null` for `onChanged` to render
the switch as disabled.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Switch(
  value: _isOn,
  onChanged: (v) => setState(() => _isOn = v),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `bool` | required | Whether the switch is currently on. |
| `onChanged` | `ValueChanged<bool>?` | required | Called when the user toggles the switch. `null` disables. |
| `size` | `SwitchSize` | `SwitchSize.medium` | The size variant. |

## Sizes

`SwitchSize` values: `small` (32×18px track, 14px knob), `medium` (44×24px
track, 20px knob, default), `large` (52×30px track, 26px knob).
