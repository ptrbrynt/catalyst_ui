# CLAUDE.md — catalyst_ui

## Project purpose

`catalyst_ui` is a Flutter UI component library with no Material or Cupertino dependency. It is designed to be used in any Flutter app and provides fully customisable design tokens, a typed theme system, and an open variant architecture for components like `Button`, `Chip`, and `Badge`.

---

## Architecture overview

```
lib/
├── catalyst_ui.dart          # Main barrel — re-exports everything
└── src/
    ├── theme/                # Design token classes + InheritedWidget
    │   ├── color_scheme.dart
    │   ├── color_utils.dart  # WCAG luminance helper (free function)
    │   ├── extensions.dart   # BuildContext extensions
    │   ├── motion.dart
    │   ├── shadows.dart
    │   ├── theme.dart        # CatalystTheme (InheritedWidget)
    │   ├── theme_data.dart   # CatalystThemeData (aggregator)
    │   └── typography.dart
    ├── tokens/               # Static spacing + radius constants
    │   ├── radius.dart
    │   ├── spacing.dart
    │   └── tokens.dart       # Barrel
    ├── components/
    │   ├── atoms/            # Primitive, single-purpose widgets
    │   ├── molecules/        # Composed widgets (2–3 atoms combined)
    │   └── organisms/        # Full-screen sections and complex layouts
    └── utils/
        ├── provider.dart     # CatalystProvider (theme + overlays)
        ├── show_modal.dart   # showCatalystModal/BottomSheet/Drawer
        ├── snackbar_handler.dart
        └── utils.dart        # Barrel
```

---

## Hard rules

### No Material or Cupertino imports
Every file must import only from `flutter/widgets.dart`, `flutter/services.dart`, or `flutter/foundation.dart`. Never import `package:flutter/material.dart` or `package:flutter/cupertino.dart`. This is non-negotiable — breaking it would introduce hidden dependencies that affect rendering in apps that use neither Material nor Cupertino.

For platform detection use `defaultTargetPlatform` from `flutter/foundation.dart`, not `dart:io Platform`.

### `public_member_api_docs: true`
Every public class, constructor, field, method, and enum value must have a doc comment (`///`). The analyser enforces this. Run `dart analyze lib/` to verify — it must report `No issues found!` before any change is merged.

---

## Theme system

### How the theme flows

```
CatalystProvider
  └── CatalystTheme (InheritedWidget)     ← propagates CatalystThemeData
        └── DefaultTextStyle              ← set to typography.defaultStyle
              └── CatalystSnackbarHandler ← overlay for snackbar
                    └── child
```

`CatalystThemeData` aggregates five sub-objects: `colorScheme`, `typography`, `motion`, `shadows`, `breakpoints`. Components read them via `BuildContext` extensions defined in `extensions.dart`:

```dart
context.colorScheme   // CatalystColorScheme
context.typography    // CatalystTypography
context.motion        // CatalystMotion
context.shadows       // CatalystShadows
context.breakpoints   // CatalystBreakpoints
```

### `CatalystTypography`

`CatalystTypography` supports three levels of customisation, in ascending specificity:

1. **`fontFamily`** — applies to all non-overridden body styles (`p1`, `p2`, `body`, `p3`, `caption`, `micro`).
2. **`headerFontFamily`** — applies to heading styles (`display`, `h1`, `h2`, `h3`); falls back to `fontFamily` when `null`.
3. **Per-style `TextStyle` overrides** — individual constructor parameters (`display:`, `h1:`, …, `micro:`) stored as private fields. A getter returns the override if set, otherwise falls back to the computed default via `_style(base, size, weight, height: h)`.

Internally, `_bodyBase` and `_headerBase` are the two base `TextStyle` getters that embed the appropriate font family and colour scheme text colour. The private `_style` helper takes the base as its first argument.

Both `copyWith` and `withColorScheme` must thread **all** fields — `fontFamily`, `headerFontFamily`, and every `_*` override — through to the new instance. Neither method should silently drop any field.

### `color_utils.dart`

`catalystTextColorFor(Color bg)` is a free function (not a static method on `CatalystThemeData`) to avoid a circular dependency: `CatalystColorScheme` needs it for its `on*` computed getters, but `CatalystColorScheme` is imported by `CatalystThemeData`. Keeping it in a standalone file breaks the cycle.

---

## Variant and tone system

Both the **variant** system (structural styles — `Button`, `Chip`, `Badge`) and the **tone** system (semantic colour intent — `Alert`, `Card`, `Snackbar`, `ProgressBar`, `StatusDot`) use exactly the same pattern: an abstract class with `resolve(CatalystColorScheme)` returning a typed style record.

The only distinction is naming:
- **Variant** (`ButtonVariant`, `ChipVariant`, `BadgeVariant`) — controls structure and emphasis.
- **Tone** (`AlertTone`, `CardTone`, `SnackbarTone`, `ProgressBarTone`, `StatusTone`) — controls semantic colour intent.

### Abstract class + style record

```dart
@immutable
abstract class FooVariant {   // or FooTone
  const FooVariant();

  static const FooVariant primary = _PrimaryFooVariant();

  FooVariantStyle resolve(CatalystColorScheme colorScheme);
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
```

### Private built-in implementations

Built-in presets are private classes in the same file. Users interact only with the static constants or their own subclasses:

```dart
class _PrimaryFooVariant extends FooVariant {
  const _PrimaryFooVariant();

  @override
  FooVariantStyle resolve(CatalystColorScheme cs) => FooVariantStyle(
    foregroundColor: cs.onBrand,
    backgroundColor: cs.brand,
  );
}
```

### Custom factory on the abstract class (optional)

For one-off values (e.g. a custom colour without subclassing), expose a static factory:

```dart
abstract class StatusTone {
  // …
  static StatusTone custom(Color color) => _CustomStatusTone(color);
}
```

### Why abstract classes, not enums

Enums are closed — users cannot add cases. Abstract classes let users subclass and `resolve` to whatever style they need, while the library ships sensible defaults as static constants. The call site is identical: `tone: AlertTone.success` vs `tone: const MyTone()`.

---

## Adding a new component

1. **Atom** — new file in `src/components/atoms/`, export from `atoms.dart`.
2. **Molecule** — new file in `src/components/molecules/`, export from `molecules.dart`.
3. **Organism** — new file in `src/components/organisms/`, export from `organisms.dart`.

Checklist for each new widget:
- [ ] Import only `flutter/widgets.dart` (plus `lucide_icons_flutter` if icons needed).
- [ ] Use `context.colorScheme`, `context.typography`, `context.motion`, `context.shadows`, `context.breakpoints` — never hardcode colours, fonts, durations, or breakpoint values.
- [ ] All public symbols have `///` doc comments.
- [ ] If variant- or tone-based: define `FooVariant`/`FooTone` (abstract), `FooVariantStyle`/`FooToneStyle` (@immutable), private built-in implementations, and static const presets. See existing tones (`AlertTone`, `CardTone`, etc.) or variants (`ButtonVariant`, `ChipVariant`) for reference.
- [ ] Run `dart analyze lib/` — zero issues required.

---

## Responsive breakpoints

`CatalystBreakpoints` lives in `src/tokens/breakpoints.dart` and is threaded through `CatalystThemeData` like every other token — accessed via `context.breakpoints` and overridable via `CatalystThemeData.copyWith(breakpoints: ...)`.

`CatalystResponsiveBuilder` in `src/utils/responsive_builder.dart` wraps `LayoutBuilder` and resolves the current `CatalystBreakpoint` from the available width. It does **not** use `MediaQuery.sizeOf` — it reads the parent constraints, so it works for embedded components as well as full-screen layouts.

`CatalystBreakpoint` is an enhanced enum with comparison operators (`>=`, `>`, `<=`, `<`) so callers can write `breakpoint >= CatalystBreakpoint.md` rather than comparing raw integers.

---

## Adding a new design token

If a new token belongs on an existing sub-object (`CatalystColorScheme`, `CatalystTypography`, `CatalystMotion`, `CatalystShadows`):

1. Add the field (required or with a default).
2. Add it to the corresponding `copyWith` and factory constructors.
3. Update both `.light()` and `.dark()` factories in `CatalystColorScheme`, or the defaults in `CatalystMotion` / `CatalystShadows`.

For a new **text style** in `CatalystTypography` specifically, the checklist is longer:
- Add a private `TextStyle? _foo` field and a `TextStyle? foo` constructor parameter wired via the initializer list.
- Add a `foo` getter that returns `_foo ?? _style(_headerBase or _bodyBase, size, weight, height: h)` — use `_headerBase` for heading-level styles, `_bodyBase` for body-level styles.
- Thread `foo: foo ?? _foo` through both `copyWith` and `withColorScheme`.

If it's a new category of token, add a new class and wire it into `CatalystThemeData` (field + `copyWith` + factory constructors) and `extensions.dart` (`context.newThing` getter).

---

## Analysis & linting

```bash
dart analyze lib/
```

Must report `No issues found!`. The project uses `very_good_analysis` with two overrides in `analysis_options.yaml`:
- `always_use_package_imports: ignore` — relative imports are fine for internal files.
- `comment_references: ignore` — doc comment refs to names only visible once the barrel is assembled.

Rules enforced include `public_member_api_docs`, `lines_longer_than_80_chars`, `prefer_const_constructors`, `avoid_dynamic_calls`, and the full `very_good_analysis` set.

---

## Dependency notes

| Package | Purpose |
|---------|---------|
| `lucide_icons_flutter` | Icon set used throughout components |
| `intl` | Locale-aware formatting (used in pagination and date display) |
| `dartx` | Iterable / String extensions |
| `time` | Duration arithmetic helpers |
| `very_good_analysis` | Strict lint ruleset (dev only) |

No Material, no Cupertino, no third-party UI frameworks.
