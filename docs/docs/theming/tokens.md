---
title: Tokens
---

# Tokens

Static spacing, radius, and breakpoint constants used throughout Catalyst.
Unlike `ColorScheme`, `Typography`, `Motion`, and `Shadows`, `Spacing` and
`Radii` are not threaded through `ThemeData` — they are plain static
constant classes you reference directly. `Breakpoints` is the exception: it
*is* a `ThemeData` sub-object, accessed via `context.breakpoints`.

## Spacing

Standard spacing values on a 4 px base grid. The naming convention is `s`
followed by an integer; the value is 4 px × that integer.

| Field | Type | Value |
|---|---|---|
| `Spacing.s1` | `double` | 4 px |
| `Spacing.s2` | `double` | 8 px |
| `Spacing.s3` | `double` | 12 px |
| `Spacing.s4` | `double` | 16 px |
| `Spacing.s5` | `double` | 20 px |
| `Spacing.s6` | `double` | 24 px |
| `Spacing.s8` | `double` | 32 px |
| `Spacing.s10` | `double` | 40 px |
| `Spacing.s12` | `double` | 48 px |
| `Spacing.s16` | `double` | 64 px |

`Spacing` is an `abstract final class` — a namespace of `static const`
values, not something you instantiate or pass to `ThemeData`. Override it
by supplying custom `EdgeInsets`/doubles directly where components accept
them, or by using your own spacing constants instead.

## Radii

Standard border-radius values used across Catalyst components. Each named
value is available as both a raw `double` and a pre-built `BorderRadius`
(suffixed `All`).

| Field | Type | Value |
|---|---|---|
| `Radii.xs` | `double` | 4 px |
| `Radii.sm` | `double` | 8 px |
| `Radii.md` | `double` | 12 px |
| `Radii.lg` | `double` | 14 px |
| `Radii.xl` | `double` | 16 px |
| `Radii.xxl` | `double` | 24 px |
| `Radii.pill` | `double` | 1000 px — effectively infinite radius |
| `Radii.xsAll` | `BorderRadius` | `BorderRadius.all(Radius.circular(Radii.xs))` |
| `Radii.smAll` | `BorderRadius` | `BorderRadius.all(Radius.circular(Radii.sm))` |
| `Radii.mdAll` | `BorderRadius` | `BorderRadius.all(Radius.circular(Radii.md))` |
| `Radii.lgAll` | `BorderRadius` | `BorderRadius.all(Radius.circular(Radii.lg))` |
| `Radii.xlAll` | `BorderRadius` | `BorderRadius.all(Radius.circular(Radii.xl))` |
| `Radii.xxlAll` | `BorderRadius` | `BorderRadius.all(Radius.circular(Radii.xxl))` |
| `Radii.pillAll` | `BorderRadius` | `BorderRadius.all(Radius.circular(Radii.pill))` |

Like `Spacing`, `Radii` is an `abstract final class` of `static const`
values.

## Breakpoints

The minimum widths (in logical pixels) at which each named `Breakpoint`
becomes active. Defaults follow common web conventions. Unlike `Spacing`
and `Radii`, `Breakpoints` **is** part of `ThemeData` and is accessed via
`context.breakpoints`.

| Field | Type | Default |
|---|---|---|
| `sm` | `double` | 640 px |
| `md` | `double` | 768 px |
| `lg` | `double` | 1024 px |
| `xl` | `double` | 1280 px |
| `xxl` | `double` | 1536 px |

`Breakpoints.resolve(double width)` returns the active `Breakpoint` for a
given width, checking from widest to narrowest and falling back to
`Breakpoint.xs`.

`Breakpoint` is an enhanced enum — `xs`, `sm`, `md`, `lg`, `xl`, `xxl` — with
comparison operators (`>=`, `>`, `<=`, `<`) so you can write
`breakpoint >= Breakpoint.md` instead of comparing raw widths.

## Overriding

`Breakpoints` supports `copyWith`, like the other `ThemeData` sub-objects:

```dart
ThemeData.light(
  iconography: appIconography,
  breakpoints: const Breakpoints(md: 900, lg: 1200),
);
```

`Spacing` and `Radii` are not part of `ThemeData`, so there is nothing to
override there — reference the constants directly (`Spacing.s4`,
`Radii.mdAll`) or define your own equivalent constants for components that
accept raw `double`/`EdgeInsets`/`BorderRadius` values.
