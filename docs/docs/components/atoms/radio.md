---
title: Radio
---

# Radio

A single radio button control with an optional text label.

## When to use it

Use a `Radio` to let the user pick a single option from a set — typically
several `Radio` widgets are grouped together, with the calling code tracking
which one is selected. Pass `null` for `onSelected` to render the button as
disabled.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Radio(
  value: selectedOption == 'a',
  label: const Text('Option A'),
  onSelected: (_) => setState(() => selectedOption = 'a'),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `bool` | required | Whether this radio button is currently selected. |
| `label` | `Widget?` | `null` | An optional label rendered to the right of the control. |
| `size` | `RadioSize` | `RadioSize.medium` | The size variant. |
| `onSelected` | `ValueChanged<bool>?` | `null` | Called when the user selects this radio button. |
| `trailingRadio` | `bool` | `false` | If `true`, the radio icon will appear at the end of the widget. |
| `fullWidth` | `bool` | `false` | If `true`, the `Radio` will expand to fill all available horizontal space. Otherwise, it will be as small as the label allows. |

## Sizes

`RadioSize` values: `small` (16px), `medium` (20px, default), `large` (24px).

## `RadioIndicator`

`RadioIndicator` is the standalone circular indicator used internally by
`Radio` to render the selected/unselected state. It can be used directly when
building a custom radio-group layout.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `bool` | required | Whether the option is selected. |
| `size` | `RadioSize` | `RadioSize.medium` | The size of this indicator. |
