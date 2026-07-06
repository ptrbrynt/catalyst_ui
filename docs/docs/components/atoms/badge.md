---
title: Badge
---

# Badge

A small pill-shaped label conveying status, category, or count.

## When to use it

Use a `Badge` to annotate an item with a short status or category label —
for example "Active", "Beta", or an unread count. Combine with `showDot` to
add a small coloured indicator before the label.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Badge(
  variant: BadgeVariant.success,
  child: const Text('Active'),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | The label content, typically a `Text` widget. |
| `variant` | `BadgeVariant` | `BadgeVariant.neutral` | The visual variant. |
| `showDot` | `bool` | `false` | Shows a small coloured dot before `child` when `true`. |
| `size` | `BadgeSize` | `BadgeSize.medium` | The size. |
| `elevated` | `bool` | `false` | Adds a small shadow to this badge when `true`. |

## Sizes

`BadgeSize` values: `small` (20px), `medium` (24px, default), `large` (28px).

## Variants

Built-in `BadgeVariant` presets:

- `BadgeVariant.neutral` — grey; non-semantic label.
- `BadgeVariant.info` — blue tint; informational label.
- `BadgeVariant.success` — green tint; positive or success label.
- `BadgeVariant.warning` — amber tint; cautionary label.
- `BadgeVariant.danger` — red tint; error or destructive label.
- `BadgeVariant.brand` — brand-coloured fill; primary emphasis label.

Define your own by subclassing `BadgeVariant` and implementing `resolve`:

```dart
class PremiumBadgeVariant extends BadgeVariant {
  const PremiumBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: const Color(0xFFFFF7E6),
    foregroundColor: const Color(0xFFB45309),
    dotColor: const Color(0xFFD97706),
  );
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
