---
title: StatusDot
---

# StatusDot

A small coloured dot used to communicate status at a glance.

## When to use it

Use a `StatusDot` to indicate the status of an item in a compact way — for
example, next to a list item to show it's online, active, or in error. Set
`pulse` to `true` to animate a repeating radial ripple for live/active
states.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
StatusDot(tone: StatusTone.success, pulse: true)
StatusDot(tone: StatusTone.custom(Color(0xFF9333EA)))
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `tone` | `StatusTone` | required | The colour tone. |
| `pulse` | `bool` | `false` | Whether to animate a repeating ripple effect. |

## Tones

Built-in `StatusTone` presets:

- `StatusTone.success` — green; healthy or successful.
- `StatusTone.warning` — amber; cautionary or pending.
- `StatusTone.danger` — red; error or critical.
- `StatusTone.info` — blue (brand); informational.
- `StatusTone.neutral` — grey; inactive or unknown.

For a one-off colour, use the `StatusTone.custom` factory:

```dart
StatusDot(tone: StatusTone.custom(const Color(0xFF9333EA)))
```

Define your own by subclassing `StatusTone` and implementing `resolve`:

```dart
class LiveTone extends StatusTone {
  const LiveTone();

  @override
  StatusToneStyle resolve(ColorScheme cs) =>
      StatusToneStyle(color: const Color(0xFFFF0000));
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
