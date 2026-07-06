---
title: ProgressBar
---

# ProgressBar

An animated horizontal progress bar.

## When to use it

Use a `ProgressBar` to show completion progress of a task — an upload,
download, or multi-step process. Progress is expressed as `value` out of
`max`. The fill animates smoothly on value changes.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
ProgressBar(
  value: 0.6,
  tone: ProgressBarTone.success,
  title: const Text('Uploading…'),
  valueLabel: const Text('60%'),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `double` | required | The current progress value. |
| `max` | `double` | `1` | The maximum value. |
| `tone` | `ProgressBarTone` | `ProgressBarTone.brand` | The colour tone. |
| `size` | `ProgressBarSize` | `ProgressBarSize.medium` | The height variant. |
| `title` | `Widget?` | `null` | An optional label above the bar on the left. |
| `valueLabel` | `Widget?` | `null` | An optional label above the bar on the right. |

## Sizes

`ProgressBarSize` values: `small` (4px), `medium` (8px, default), `large` (12px).

## Tones

Built-in `ProgressBarTone` presets:

- `ProgressBarTone.brand` — brand colour fill (default).
- `ProgressBarTone.success` — green fill; healthy or successful progress.
- `ProgressBarTone.warning` — amber fill; cautionary progress.
- `ProgressBarTone.danger` — red fill; critical or error progress.

Define your own by subclassing `ProgressBarTone` and implementing `resolve`:

```dart
class SpeedTone extends ProgressBarTone {
  const SpeedTone();

  @override
  ProgressBarToneStyle resolve(ColorScheme cs) =>
      ProgressBarToneStyle(fillColor: cs.brand);
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
