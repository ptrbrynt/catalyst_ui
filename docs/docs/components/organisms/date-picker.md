---
title: DatePicker
---

# DatePicker

A calendar-based date picker.

## When to use it

Use `DatePicker` when the user needs to pick a single date from a month grid
— booking forms, filters, or scheduling flows. Displays a month grid and lets
the user navigate months and tap a day to select it. Constrain the selectable
range with `firstDate` and `lastDate`.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
DatePicker(
  initialDate: DateTime.now(),
  onDateChanged: (date) => setState(() => _date = date),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onDateChanged` | `ValueChanged<DateTime>` | required | Called whenever the user selects a date. |
| `initialDate` | `DateTime?` | `null` | The initially selected date. |
| `firstDate` | `DateTime?` | `null` | Earliest selectable date. `null` means no lower bound. |
| `lastDate` | `DateTime?` | `null` | Latest selectable date. `null` means no upper bound. |
| `backIcon` | `IconData?` | `null` | Override for the previous-month icon. Falls back to `Iconography.backIcon`. |
| `forwardIcon` | `IconData?` | `null` | Override for the next-month icon. Falls back to `Iconography.forwardIcon`. |

## Iconography

The month-navigation header uses `backIcon`/`forwardIcon`, each falling back
to `context.iconography.backIcon` / `context.iconography.forwardIcon`
respectively.
