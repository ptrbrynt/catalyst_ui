---
title: Typography
---

# Typography

The typographic scale used by Catalyst components.

Create a `Typography` and pass it to `ThemeData` to customise the font
family, sizes, weights, and individual styles. `Typography` supports three
levels of customisation, in ascending specificity:

1. **`fontFamily`** — applies to all non-overridden body styles (`p1`, `p2`,
   `body`, `p3`, `caption`, `micro`). Defaults to `null`, which lets Flutter
   fall through to the platform default.
2. **`headerFontFamily`** — applies to heading styles (`display`, `h1`, `h2`,
   `h3`); falls back to `fontFamily` when `null`, so you only need to set it
   when headers should use a different typeface.
3. **Per-style `TextStyle` overrides** — individual constructor parameters
   (`display:`, `h1:`, `h2:`, `h3:`, `p1:`, `p2:`, `body:`, `p3:`,
   `caption:`, `micro:`) that replace the computed default for that slot
   entirely. Overridden styles are used verbatim — `fontFamily`,
   `headerFontFamily`, and `colorScheme` are not merged into them.

## Fields

| Field | Type | Description |
|---|---|---|
| `fontFamily` | `String?` | Typeface for body-level styles. `null` uses the platform default. |
| `headerFontFamily` | `String?` | Typeface for heading-level styles (`display`, `h1`, `h2`, `h3`). Falls back to `fontFamily` when `null`. |
| `colorScheme` | `ColorScheme` | Required. Binds the default text colour for non-overridden styles; set automatically when attached to a `ThemeData`. |

## Style getters

Each getter returns the explicit override if one was supplied to the
constructor, otherwise a computed default built from `_headerBase` (heading
styles) or `_bodyBase` (body styles):

| Getter | Base | Size | Weight | Line height | Description |
|---|---|---|---|---|---|
| `display` | header | 40 sp | `FontWeight.w700` | 1 | Hero numbers and large display text. |
| `h1` | header | 28 sp | `FontWeight.w600` | 1 | Page-level heading. |
| `h2` | header | 22 sp | `FontWeight.w600` | 1 | Section heading. |
| `h3` | header | 18 sp | `FontWeight.w500` | 1 | Sub-section heading. |
| `p1` | body | 20 sp | `FontWeight.w500` | 1 | Large paragraph text. |
| `p2` | body | 18 sp | `FontWeight.w400` | 1 | Secondary paragraph text. |
| `body` | body | 16 sp | `FontWeight.w400` | 1 | Default body copy. |
| `p3` | body | 14 sp | `FontWeight.w400` | 1 | Supporting body copy. |
| `caption` | body | 12 sp | `FontWeight.w400` | 1 | Captions and helper text. |
| `micro` | body | 10 sp | `FontWeight.w500` | 1 | Micro labels and badges. |

`defaultStyle` is an additional getter equal to `body`; it is used as the
ambient `DefaultTextStyle` set up by the `Theme` widget.

`_bodyBase` and `_headerBase` are private getters — the two base
`TextStyle` values that embed the appropriate font family and the
`colorScheme.text` colour. `headerFontFamily ?? fontFamily` is used for
`_headerBase`; `fontFamily` alone is used for `_bodyBase`.

## Overriding

**Single font family:**

```dart
Typography(colorScheme: myScheme, fontFamily: 'Inter')
```

**Different font families for headers and body:**

```dart
Typography(
  colorScheme: myScheme,
  fontFamily: 'Inter',
  headerFontFamily: 'Playfair Display',
)
```

**Override individual styles:**

```dart
Typography(
  colorScheme: myScheme,
  display: TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
  body: TextStyle(fontSize: 15, height: 1.6),
)
```

**Override via an existing theme:**

```dart
themeData.copyWith(
  typography: themeData.typography.copyWith(
    body: TextStyle(fontSize: 15, height: 1.6),
  ),
);
```

`copyWith` and `withColorScheme` both thread every field —`fontFamily`,
`headerFontFamily`, and each per-style override — through to the new
instance; `withColorScheme` additionally rebinds `colorScheme` while
preserving every style override and font family setting.

`ThemeData.light()` and `ThemeData.dark()` build a default `Typography`
internally from `fontFamily` when no explicit `typography` is supplied, then
call `withColorScheme` to bind it to the resolved `ColorScheme`. See
[Context extensions](/theming/extensions) for how components read the
active `Typography` via `context.typography`.
