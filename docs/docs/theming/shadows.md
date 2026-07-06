---
title: Shadows
---

# Shadows

Shadow presets for elevating surfaces.

Pass a custom `Shadows` to `ThemeData` to change shadow values globally. The
`brand` shadow is tinted with your brand colour and is typically computed
from your colour scheme rather than hardcoded.

## Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `none` | `List<BoxShadow>` | `[]` | No shadow — flat/zero elevation. |
| `sm` | `List<BoxShadow>` | `Offset(0, 1)`, blur `2`, `rgba(15, 23, 42, 0.06)` | Subtle shadow for low-elevation elements such as small cards. |
| `md` | `List<BoxShadow>` | `Offset(0, 4)`, blur `12`, `rgba(15, 23, 42, 0.08)` | Medium shadow for dropdowns, tooltips, and overlays. |
| `lg` | `List<BoxShadow>` | `Offset(0, 12)`, blur `32`, `rgba(15, 23, 42, 0.12)` | Large shadow for modals, drawers, and bottom sheets. |
| `brand` | `List<BoxShadow>` | `Offset(0, 6)`, blur `18`, `rgba(0, 102, 255, 0.18)` | Brand-tinted shadow for primary call-to-action buttons. |

## Overriding

```dart
ThemeData.light(
  iconography: appIconography,
  shadows: Shadows(
    brand: [
      BoxShadow(
        offset: Offset(0, 6),
        blurRadius: 18,
        color: Color.fromRGBO(124, 58, 237, 0.20),
      ),
    ],
  ),
);
```

Since `brand` is meant to echo your brand colour, it's common to derive it
from `colorScheme.brand` rather than hardcode it, so the shadow tint stays
in sync when the colour scheme changes.

Components read the active presets via `context.shadows.none`,
`context.shadows.sm`, `context.shadows.md`, `context.shadows.lg`, and
`context.shadows.brand`.
