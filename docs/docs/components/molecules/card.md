---
title: Card
---

# Card

A rounded container that groups related content.

## When to use it

Use `Card` to visually group related content on a screen — for example, a
summary panel, a list entry, or a highlighted section. Set `interactive` or
provide `onTap` to make the whole card respond to taps.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Card(
  tone: CardTone.subtle,
  child: const Text('Hello'),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | The content of the card. |
| `padding` | `EdgeInsets` | `EdgeInsets.all(Spacing.s3)` | Inner padding applied to `child`. |
| `tone` | `CardTone` | `CardTone.surface` | The background colour style. |
| `interactive` | `bool` | `false` | Changes the cursor to a pointer on hover when `true`. |
| `onTap` | `VoidCallback?` | `null` | Called when the card is tapped. Implies `interactive`. |

## Tones

`CardTone` presets:

- `CardTone.subtle` — slightly off-canvas background with a border (default
  in the tone system, though the widget's own default is `CardTone.surface`).
- `CardTone.surface` — surface (white / dark) background with a border.
- `CardTone.brand` — brand fill for primary emphasis.
- `CardTone.tint` — lightly tinted background for secondary emphasis.

Each tone resolves to a `CardToneStyle` with a `backgroundColor` and
`borderColor`. Define your own by subclassing `CardTone` and implementing
`resolve`:

```dart
class HighlightCardTone extends CardTone {
  const HighlightCardTone();

  @override
  CardToneStyle resolve(ColorScheme cs) => CardToneStyle(
    backgroundColor: cs.warningSoft,
    borderColor: cs.warning.withValues(alpha: 0.30),
  );
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
