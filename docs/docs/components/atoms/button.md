---
title: Button
---

# Button

A pressable button supporting labels, icons, loading states, and user-defined
visual variants.

## When to use it

Use a `Button` for the primary and secondary actions on a screen — submitting
forms, confirming dialogs, triggering navigation. Use `Button.icon` for a
square icon-only button.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Button(
  label: const Text('Save'),
  variant: ButtonVariant.primary,
  onPressed: _handleSave,
)
```

Pass `null` for `onPressed` to disable the button.

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `Widget` | required | The primary content, typically a `Text`. |
| `onPressed` | `VoidCallback?` | required | Called when tapped. `null` disables. |
| `leadingIcon` | `Widget?` | `null` | Icon placed left of the label. |
| `trailingIcon` | `Widget?` | `null` | Icon placed right of the label. |
| `loading` | `bool` | `false` | Shows a `Spinner` and ignores taps. |
| `elevated` | `bool` | `false` | Adds a drop shadow. |
| `fullWidth` | `bool` | `false` | Stretches to fill available width. |
| `size` | `ButtonSize` | `ButtonSize.large` | Height/padding/font-size preset. |
| `variant` | `ButtonVariant` | `ButtonVariant.primary` | Visual variant. |
| `semanticsLabel` | `String?` | `null` | Accessibility label. |

### `Button.icon`

A square icon-only constructor. Requires `icon`, `onPressed`, and
`semanticsLabel`; also accepts `loading`, `elevated`, `size`, `variant`, and
`shape`.

## Sizes

`ButtonSize` values: `link`, `small` (44px), `medium` (48px), `large` (52px,
default), `extraLarge` (60px).

## Variants

Built-in `ButtonVariant` presets:

- `ButtonVariant.primary` — solid brand fill; default call-to-action.
- `ButtonVariant.secondary` — outlined on a surface background.
- `ButtonVariant.tertiary` — subtle filled with a light border.
- `ButtonVariant.ghost` — no background or border.
- `ButtonVariant.destructive` — solid danger fill.
- `ButtonVariant.success` — solid success fill.

Define your own by subclassing `ButtonVariant` and implementing `resolve`:

```dart
class OutlineButtonVariant extends ButtonVariant {
  const OutlineButtonVariant();

  @override
  ButtonVariantStyle resolve(ColorScheme cs) => ButtonVariantStyle(
    foregroundColor: cs.brand,
    borderColor: cs.brand,
  );
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
