---
title: Variants & Tones
---

# Variants & Tones

Both the **variant** system (structural styles — Button, Chip, Badge) and the
**tone** system (semantic colour intent — Alert, Card, Snackbar, ProgressBar,
StatusDot) use exactly the same underlying pattern: an abstract class with a
`resolve(ColorScheme)` method that returns a typed style record.

The only distinction between the two is naming:

- **Variant** (`ButtonVariant`, `ChipVariant`, `BadgeVariant`) — controls
  structure and emphasis.
- **Tone** (`AlertTone`, `CardTone`, `SnackbarTone`, `ProgressBarTone`,
  `StatusTone`) — controls semantic colour intent.

## The pattern

Every variant or tone is built from three pieces:

1. **A style record** — an `@immutable` class holding only the resolved
   visual properties the component actually needs (colours, borders,
   shadows, and so on).
2. **An abstract class** — exposes built-in options as `static const`
   fields and declares the `resolve(ColorScheme)` method that subclasses
   must implement.
3. **Private built-in implementations** — one small private class per
   built-in preset, each returning a style record computed from the
   `ColorScheme` passed to `resolve`.

```dart
@immutable
abstract class FooVariant {   // or FooTone
  const FooVariant();

  static const FooVariant primary = _PrimaryFooVariant();

  FooVariantStyle resolve(ColorScheme colorScheme);
}

@immutable
class FooVariantStyle {
  const FooVariantStyle({
    required this.foregroundColor,
    this.backgroundColor,
    // … only the fields this component actually needs
  });
  final Color foregroundColor;
  final Color? backgroundColor;
}

class _PrimaryFooVariant extends FooVariant {
  const _PrimaryFooVariant();

  @override
  FooVariantStyle resolve(ColorScheme cs) => FooVariantStyle(
    foregroundColor: cs.onBrand,
    backgroundColor: cs.brand,
  );
}
```

Users interact only with the static constants (`FooVariant.primary`) or their
own subclasses — the private `_PrimaryFooVariant`-style implementations never
appear in the public API.

## Worked example: `ButtonVariant`

The Button component (see `lib/src/components/atoms/button.dart`) is the
canonical example. `ButtonVariantStyle` holds exactly what a button needs to
render — no more:

```dart
@immutable
class ButtonVariantStyle {
  const ButtonVariantStyle({
    required this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
    this.shadows,
  });

  final Color foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? shadows;
}
```

`ButtonVariant` is the abstract class. It exposes six built-in presets as
static constants — `primary`, `secondary`, `tertiary`, `ghost`,
`destructive`, `success` — and declares the `resolve` contract:

```dart
@immutable
abstract class ButtonVariant {
  const ButtonVariant();

  static const ButtonVariant primary = _PrimaryButtonVariant();
  static const ButtonVariant secondary = _SecondaryButtonVariant();
  static const ButtonVariant tertiary = _TertiaryButtonVariant();
  static const ButtonVariant ghost = _GhostButtonVariant();
  static const ButtonVariant destructive = _DestructiveButtonVariant();
  static const ButtonVariant success = _SuccessButtonVariant();

  ButtonVariantStyle resolve(ColorScheme colorScheme);
}
```

Each preset is a private class resolving to a style record built from the
`ColorScheme`. For example, the primary variant:

```dart
class _PrimaryButtonVariant extends ButtonVariant {
  const _PrimaryButtonVariant();

  @override
  ButtonVariantStyle resolve(ColorScheme cs) {
    return ButtonVariantStyle(
      backgroundColor: cs.brand,
      foregroundColor: cs.onBrand,
      shadows: [
        BoxShadow(
          offset: const Offset(0, 6),
          blurRadius: 18,
          color: cs.brand.withValues(alpha: 0.28),
        ),
      ],
    );
  }
}
```

The Button widget itself simply calls `resolve` against the current theme's
colour scheme at build time:

```dart
final style = widget.variant.resolve(context.colorScheme);
```

## Worked example: `AlertTone`

`AlertTone` follows the identical shape, but for semantic colour intent
rather than structure. `AlertToneStyle` only needs two colours:

```dart
@immutable
class AlertToneStyle {
  const AlertToneStyle({
    required this.backgroundColor,
    required this.accentColor,
  });

  final Color backgroundColor;
  final Color accentColor;
}
```

`AlertTone` exposes four built-in presets — `info`, `success`, `warning`,
`danger`:

```dart
@immutable
abstract class AlertTone {
  const AlertTone();

  static const AlertTone info = _InfoAlertTone();
  static const AlertTone success = _SuccessAlertTone();
  static const AlertTone warning = _WarningAlertTone();
  static const AlertTone danger = _DangerAlertTone();

  AlertToneStyle resolve(ColorScheme cs);
}

class _InfoAlertTone extends AlertTone {
  const _InfoAlertTone();

  @override
  AlertToneStyle resolve(ColorScheme cs) => AlertToneStyle(
    backgroundColor: cs.infoSoft,
    accentColor: cs.info,
  );
}
```

## Defining your own variant or tone

Because the abstract class is open for subclassing, you are not limited to
the built-in presets. Extend the abstract class and implement `resolve`:

```dart
class MyBrandVariant extends ButtonVariant {
  const MyBrandVariant();

  @override
  ButtonVariantStyle resolve(ColorScheme cs) {
    return ButtonVariantStyle(
      backgroundColor: cs.brand,
      foregroundColor: cs.onBrand,
      shadows: [
        BoxShadow(
          color: cs.brand.withValues(alpha: 0.35),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    );
  }
}

// Then use it exactly like a built-in preset:
Button(
  label: const Text('Go'),
  variant: const MyBrandVariant(),
  onPressed: _handleGo,
)
```

The same applies to tones — subclass `AlertTone` (or `CardTone`,
`SnackbarTone`, `ProgressBarTone`, `StatusTone`) and implement `resolve` to
return whatever colours you need.

### Custom factory for one-off values

Some tones also expose a static factory for a one-off colour that doesn't
warrant a named subclass. `StatusTone`, for example, exposes
`StatusTone.custom`:

```dart
abstract class StatusTone {
  // …
  static StatusTone custom(Color color) => _CustomStatusTone(color);
}
```

Call sites look identical whether you use a built-in preset, a custom
factory, or your own subclass:

```dart
tone: AlertTone.success
tone: StatusTone.custom(const Color(0xFF9333EA))
tone: const MyMaintenanceTone()
```

## Why abstract classes, not enums

Enums are closed — users cannot add cases to them. Abstract classes let
users subclass and implement `resolve` to produce whatever style they need,
while the library still ships sensible defaults as static constants. The
call site is identical either way: `tone: AlertTone.success` vs
`tone: const MyTone()`.

## Variants and tones in this library

- **Variants** — ButtonVariant, ChipVariant, BadgeVariant (see the
  Button, Chip, and Badge components).
- **Tones** — AlertTone, CardTone, SnackbarTone, ProgressBarTone,
  StatusTone (see the Alert, Card, Snackbar, ProgressBar, and StatusDot
  components).
