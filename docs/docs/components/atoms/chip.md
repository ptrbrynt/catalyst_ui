---
title: Chip
---

# Chip

A compact, pill-shaped selection or filtering control.

## When to use it

Use the default `Chip` constructor for a toggleable chip — for example, a
filter option that can be selected or deselected. Use `Chip.removable` for a
chip that always shows a close/remove icon, such as a tag the user can
dismiss. Supply a custom `variant` to fully control colours in both selected
and unselected states.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Chip(
  isSelected: _isSelected,
  onTap: () => setState(() => _isSelected = !_isSelected),
  child: const Text('Filter'),
)

Chip.removable(
  onTap: _handleRemove,
  child: const Text('Tag'),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `isSelected` | `bool` | required | Whether the chip is in its selected/active state. |
| `child` | `Widget` | required | The label content, typically a `Text` widget. |
| `checkIcon` | `IconData?` | `null` | The icon to display when checked. |
| `onTap` | `VoidCallback?` | `null` | Called when the chip is tapped. `null` disables. |
| `variant` | `ChipVariant` | `ChipVariant.standard` | The visual variant. |

### `Chip.removable`

Creates a removable chip that always shows a close (×) icon. Requires
`child`; also accepts `removeIcon`, `onTap`, and `variant`. `isSelected` is
always `true` internally and `isRemovable` is set to `true`.

## Variants

The built-in default is `ChipVariant.standard` — surface background when
unselected, brand fill when selected.

Define your own by subclassing `ChipVariant` and implementing `resolve`,
which receives the current `isSelected` state:

```dart
class CategoryChipVariant extends ChipVariant {
  const CategoryChipVariant();

  @override
  ChipVariantStyle resolve(
      ColorScheme cs, {required bool isSelected}) {
    return ChipVariantStyle(
      backgroundColor: isSelected ? cs.brand : cs.brandSoft,
      foregroundColor: isSelected ? cs.onBrand : cs.brand,
      borderColor: cs.brand,
    );
  }
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.

## Iconography

- The default `Chip` constructor shows `checkIcon` when `isSelected` is
  `true`, falling back to `context.iconography.checkIcon`.
- `Chip.removable` shows `removeIcon`, falling back to
  `context.iconography.removeIcon`.
