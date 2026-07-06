---
title: TimePicker
---

# TimePicker

A scroll-wheel time picker.

## When to use it

Use `TimePicker` when the user needs to pick an hour and minute — scheduling
forms, alarms, or reminders. Shows drum-roll columns for hours and minutes,
plus an AM/PM column when `use24HourFormat` is `false`. The `hour` on the
emitted `PickerTime` is always in 24-hour format regardless of
`use24HourFormat`.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
TimePicker(
  initialTime: const PickerTime(hour: 9, minute: 30),
  onTimeChanged: (t) => setState(() => _time = t),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onTimeChanged` | `ValueChanged<PickerTime>` | required | Called whenever the selected time changes. |
| `initialTime` | `PickerTime?` | `null` | The initially displayed time. Defaults to midnight (00:00) when `null`. |
| `use24HourFormat` | `bool` | `true` | When `false`, shows 1-12 hours and an AM/PM column. |

### `PickerTime`

An hour-and-minute pair produced by `TimePicker`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `hour` | `int` | required | Hour in 24-hour format (0-23). |
| `minute` | `int` | required | Minute (0-59). |

`PickerTime` implements value equality (`==`/`hashCode`) based on `hour` and
`minute`, and its `toString()` renders as zero-padded `HH:mm`.
