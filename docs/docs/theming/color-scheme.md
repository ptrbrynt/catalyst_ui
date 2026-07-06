---
title: ColorScheme
---

# ColorScheme

The full set of semantic colours consumed by all Catalyst components.

Retrieve it via `context.colorScheme`. Two factory constructors are provided
for convenience — `ColorScheme.light()` and `ColorScheme.dark()` — but every
field may also be overridden individually using the default (required)
constructor or `copyWith`.

## Fields

| Field | Type | Description | `.light()` | `.dark()` |
|---|---|---|---|---|
| `canvas` | `Color` | The outermost page/screen background. | `0xFFFFFFFF` | `0xFF0B0F19` |
| `surface` | `Color` | Standard card and panel background. | `0xFFFFFFFF` | `0xFF141924` |
| `subtle` | `Color` | One step above `canvas`; used for nested or secondary sections. | `0xFFF8F9FA` | `0xFF1A2030` |
| `muted` | `Color` | Muted background for disabled or low-emphasis areas. | `0xFFF1F3F5` | `0xFF1E2638` |
| `tint` | `Color` | Lightly tinted background for brand-adjacent surfaces. | `0xFFF0F5FF` | `0xFF141E3A` |
| `brand` | `Color` | The primary brand colour. Used for CTAs, active states, and focus rings. | `0xFF0066FF` | `0xFF3B82F6` |
| `brandSoft` | `Color` | A soft tint of `brand` for backgrounds behind brand-coloured elements. | `0xFFE5EEFF` | `0xFF0F1E40` |
| `inverse` | `Color` | High-contrast background — typically the inverse of `canvas`. | `0xFF0F172A` | `0xFFF8FAFC` |
| `border` | `Color` | Default border/divider colour. | `0xFFE2E8F0` | `0xFF273045` |
| `borderStrong` | `Color` | A more prominent border for emphasis. | `0xFF94A3B8` | `0xFF3B4D6A` |
| `borderSubtle` | `Color` | A very subtle border for low-emphasis separators. | `0xFFF1F5F9` | `0xFF1E2638` |
| `text` | `Color` | Default body text colour. | `0xFF0F172A` | `0xFFF1F5F9` |
| `textMuted` | `Color` | Supporting / secondary text colour. | `0xFF475569` | `0xFF94A3B8` |
| `textSubtle` | `Color` | Placeholder and tertiary text colour. | `0xFF94A3B8` | `0xFF64748B` |
| `textDisabled` | `Color` | Text colour for disabled controls. | `0xFFCBD5E1` | `0xFF334155` |
| `success` | `Color` | Green — healthy, confirmed, or successful states. | `0xFF16A34A` | `0xFF4ADE80` |
| `warning` | `Color` | Amber — cautionary or pending states. | `0xFFD97706` | `0xFFFBBF24` |
| `danger` | `Color` | Red — error, destructive, or critical states. | `0xFFDC2626` | `0xFFF87171` |
| `info` | `Color` | Blue — informational states (defaults to `brand`). | `0xFF0066FF` | `0xFF60A5FA` |
| `successSoft` | `Color` | Soft green background for success banners/badges. | `0xFFDCFCE7` | `rgba(74, 222, 128, 0.12)` |
| `warningSoft` | `Color` | Soft amber background for warning banners/badges. | `0xFFFEF3C7` | `rgba(251, 191, 36, 0.12)` |
| `dangerSoft` | `Color` | Soft red background for danger banners/badges. | `0xFFFEE2E2` | `rgba(248, 113, 113, 0.12)` |
| `infoSoft` | `Color` | Soft blue background for info banners/badges. | `0xFFEFF6FF` | `rgba(96, 165, 250, 0.12)` |

All fields are `required` on the default constructor — no colour is silently
defaulted when constructing a `ColorScheme` from scratch.

## Computed on-colours

`ColorScheme` also exposes read-only `on*` getters that compute a legible
text colour for each background, using the WCAG luminance helper
`getTextColorFor` from `color_utils.dart`:

| Getter | Type | Computed from |
|---|---|---|
| `onCanvas` | `Color` | `canvas` |
| `onSurface` | `Color` | `surface` |
| `onSubtle` | `Color` | `subtle` |
| `onMuted` | `Color` | `muted` |
| `onTint` | `Color` | `tint` |
| `onBrand` | `Color` | `brand` |
| `onBrandSoft` | `Color` | `brandSoft` |
| `onInverse` | `Color` | `inverse` |
| `onSuccess` | `Color` | `success` |
| `onDanger` | `Color` | `danger` |
| `onWarning` | `Color` | `warning` |

These are computed, not stored — there is no `onWarningSoft`, `onDangerSoft`,
`onInfoSoft`, or `onInfo` getter in the current API.

## Overriding

Start from `ColorScheme.light()` or `ColorScheme.dark()` and call `copyWith`
to change only the fields you care about:

```dart
ThemeData.light(
  iconography: appIconography,
  colorScheme: const ColorScheme.light().copyWith(
    brand: Color(0xFF7C3AED),
    brandSoft: Color(0xFFEDE9FE),
  ),
);
```

`copyWith` accepts every field shown above (all optional, all `Color?`) and
falls back to the current value for anything left `null`.
