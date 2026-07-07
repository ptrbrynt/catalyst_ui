---
title: Iconography
---

# Iconography

`catalyst_ui` ships no icon data of its own — the library has no dependency
on Material or Cupertino icon fonts, so it can't bundle a default icon set.
Instead, components that need a semantic icon (a checkmark, a back chevron,
a close button, …) read it from `Iconography`, a required parameter on
`ThemeData.light()` and `ThemeData.dark()`.

Callers supply values from whichever icon package their app already uses
(e.g. `LucideIcons`):

```dart
ThemeData.light(
  iconography: Iconography(
    checkIcon: LucideIcons.check,
    backIcon: LucideIcons.chevronLeft,
    forwardIcon: LucideIcons.chevronRight,
    expandIcon: LucideIcons.chevronDown,
    collapseIcon: LucideIcons.chevronUp,
    closeIcon: LucideIcons.x,
    removeIcon: LucideIcons.x,
    alertIcon: LucideIcons.triangleAlert,
  ),
);
```

## The `Iconography` class

`Iconography` holds eight required `IconData` slots — all `required` on its
default constructor, so there's no silent fallback to a built-in icon:

```dart
class Iconography {
  const Iconography({
    required this.checkIcon,
    required this.backIcon,
    required this.forwardIcon,
    required this.expandIcon,
    required this.collapseIcon,
    required this.closeIcon,
    required this.removeIcon,
    required this.alertIcon,
  });

  final IconData checkIcon;
  final IconData backIcon;
  final IconData forwardIcon;
  final IconData expandIcon;
  final IconData collapseIcon;
  final IconData closeIcon;
  final IconData removeIcon;
  final IconData alertIcon;
}
```

## Slots and their consumers

| Field | Used by |
|---|---|
| `checkIcon` | Checkbox, Chip (selected state), MenuButton (selected option), Select (selected item), Stepper (completed step) |
| `backIcon` | AppBar (back button), Pagination, DatePicker (previous month) |
| `forwardIcon` | Breadcrumb (separator), Pagination, DatePicker (next month) |
| `expandIcon` | Select and MultiSelect (dropdown chevron — rotated 180° when open) |
| `collapseIcon` | *Reserved.* Currently unused by built-in components — Select rotates `expandIcon` rather than swapping to a separate icon. Supply a value (it is required) for forward compatibility. |
| `closeIcon` | Drawer (close button) |
| `removeIcon` | Chip (removable variant) |
| `alertIcon` | ErrorState (default icon) |

## Accessing icons in a component

Components read the current icon set via `context.iconography`, the same
`BuildContext` extension used for every other theme token:

```dart
context.iconography   // Iconography
```

## The optional-override-with-fallback pattern

Components that use a semantic icon expose it as an optional `IconData?`
parameter. When the caller leaves it `null`, the component falls back to the
corresponding `context.iconography` slot:

```dart
Icon(widget.backIcon ?? context.iconography.backIcon)
```

This means callers can:

- Omit the parameter entirely and get the theme-level icon for every
  instance of that component, or
- Pass a specific `IconData` to override it for just that one instance.

This pattern applies wherever a component needs a *semantic* icon that's
part of the `Iconography` system — back buttons, checkmarks, expand/collapse
indicators, and so on.

## What's not part of `Iconography`

Components that use icons for caller-supplied *content* — rather than a
fixed semantic role — take a `Widget`, not an `IconData?`, and are
deliberately excluded from the `Iconography` system. Examples include
Button's leading/trailing icon, ActionTile's icon, and BottomNavItem's icon.
Callers always provide those explicitly, since there's no sensible
theme-level default for arbitrary button or list-item content.
