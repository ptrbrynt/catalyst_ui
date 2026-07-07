# catalyst_ui

A flexible, theme-driven UI component library for Flutter — no Material or Cupertino dependency. Every design token is fully customisable, and variant-based components (`Button`, `Chip`, `Badge`) accept user-defined variants so you can extend the design system without forking the library.

📖 **[Read the documentation →](https://ptrbrynt.github.io/catalyst_ui/)** — getting started, theming, architecture, and a reference page for every component.

---

## Features

- **Zero Material / Cupertino dependency** — uses `flutter/widgets.dart` only, so it works in any Flutter app regardless of existing widget hierarchy.
- **Fully customisable design tokens** — colour scheme, typography (font family + scale), motion (durations + curves), shadows, spacing, and border radius are all configurable via `ThemeData`.
- **Open variant and tone system** — `ButtonVariant`, `ChipVariant`, `BadgeVariant`, `AlertTone`, `CardTone`, `SnackbarTone`, `ProgressBarTone`, and `StatusTone` are all abstract classes. Subclass any of them to create your own styles; no enums to extend or fork.
- **`BuildContext` extensions** — `context.colorScheme`, `context.typography`, `context.motion`, `context.shadows` anywhere below a `Provider`.
- **Overlay utilities** — `showModal`, `showBottomSheet`, `showDrawer`, and `context.showSnackbar(...)` handle their own animated transitions.
- **40+ components** spanning atoms, molecules, and organisms.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  catalyst_ui:
    path: ../catalyst_ui # or your pub.dev version once published
```

---

## Quick start

Wrap the root of your navigator with `CatalystProvider`. It sets up the theme, automatic dark/light switching, and all overlay dependencies in one step.

catalyst_ui ships no icon data — you supply an `Iconography` from whichever icon package your app uses (here, `lucide_icons`). `ThemeData.light()` and `ThemeData.dark()` both require it:

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:lucide_icons/lucide_icons.dart';

final appIconography = Iconography(
  checkIcon: LucideIcons.check,
  backIcon: LucideIcons.arrowLeft,
  forwardIcon: LucideIcons.arrowRight,
  expandIcon: LucideIcons.chevronDown,
  collapseIcon: LucideIcons.chevronUp,
  closeIcon: LucideIcons.x,
  removeIcon: LucideIcons.x,
  alertIcon: LucideIcons.triangleAlert,
);

// Light theme only:
CatalystProvider(
  theme: ThemeData.light(fontFamily: 'Inter', iconography: appIconography),
  child: MyHomePage(),
)

// Automatic dark / light switching — follows the OS setting:
CatalystProvider(
  theme: ThemeData.light(fontFamily: 'Inter', iconography: appIconography),
  darkTheme: ThemeData.dark(fontFamily: 'Inter', iconography: appIconography),
  child: MyHomePage(),
)

// Force a specific mode regardless of the OS setting:
CatalystProvider(
  theme: ThemeData.light(fontFamily: 'Inter', iconography: appIconography),
  darkTheme: ThemeData.dark(fontFamily: 'Inter', iconography: appIconography),
  themeMode: ThemeMode.dark,
  child: MyHomePage(),
)
```

`CatalystProvider` is router-agnostic — place it inside any app widget (`WidgetsApp`, `MaterialApp`, `GoRouter`, etc.) wherever an `Overlay` is available.

---

## Theming

### `ThemeData`

Three named constructors cover the common cases:

```dart
// Light theme with default tokens
ThemeData.light()

// Dark theme
ThemeData.dark()

// Full control — supply every sub-object explicitly
ThemeData.raw(
  colorScheme: ...,
  typography: ...,
  motion: ...,
  shadows: ...,
)
```

Use `copyWith` to override individual tokens:

```dart
ThemeData.light(fontFamily: 'Inter').copyWith(
  colorScheme: const ColorScheme.light().copyWith(
    brand: const Color(0xFF7C3AED),
    brandSoft: const Color(0xFFEDE9FE),
  ),
)
```

### Colour scheme

`ColorScheme` covers surfaces, brand, borders, text, and status colours. Both built-in palettes can be used directly or as a starting point:

```dart
const ColorScheme.light()   // default blue brand
const ColorScheme.dark()    // dark surfaces, blue brand
```

Override any field with `copyWith`:

```dart
const ColorScheme.light().copyWith(
  brand:     Color(0xFF7C3AED),   // purple brand
  brandSoft: Color(0xFFEDE9FE),
  success:   Color(0xFF059669),
)
```

Full token reference:

| Group    | Tokens                                                         |
| -------- | -------------------------------------------------------------- |
| Surfaces | `canvas`, `surface`, `subtle`, `muted`, `tint`                 |
| Brand    | `brand`, `brandSoft`                                           |
| Borders  | `border`, `borderStrong`, `borderSubtle`                       |
| Text     | `text`, `textMuted`, `textSubtle`, `textDisabled`              |
| Status   | `success`, `warning`, `danger`, `info` + `*Soft` variants      |
| Computed | `onBrand`, `onSuccess`, `onDanger`, `onWarning`, `onCanvas`, … |

The `on*` colours are automatically computed using WCAG luminance contrast — you never need to hardcode them.

### Typography

Catalyst ships no fonts — supply font family names that match what you have declared in your app's `pubspec.yaml`.

**Single font family (shorthand):**

```dart
ThemeData.light(fontFamily: 'Inter')
```

**Separate font families for headers and body:**

```dart
ThemeData.light(
  typography: Typography(
    colorScheme: const ColorScheme.light(),
    fontFamily: 'Inter',
    headerFontFamily: 'Playfair Display',
  ),
)
```

`headerFontFamily` applies to `display`, `h1`, `h2`, and `h3`. Body styles (`p1`, `p2`, `body`, `p3`, `caption`, `micro`) always use `fontFamily`. When `headerFontFamily` is omitted, both groups use `fontFamily`.

**Override individual styles:**

```dart
ThemeData.light(
  typography: Typography(
    colorScheme: const ColorScheme.light(),
    display: TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
    body: TextStyle(fontSize: 15, height: 1.6),
  ),
)
```

Overridden styles are used verbatim — `fontFamily`, `headerFontFamily`, and the colour scheme text colour are not merged in.

**Patch a style on an existing theme:**

```dart
final base = ThemeData.light(fontFamily: 'Inter');
base.copyWith(
  typography: base.typography.copyWith(
    caption: TextStyle(fontSize: 11, letterSpacing: 0.4),
  ),
)
```

The full scale — `display` / `h1` / `h2` / `h3` / `p1` / `p2` / `body` / `p3` / `caption` / `micro` — is accessible via `context.typography`:

```dart
Text('Hello', style: context.typography.h2)
```

### Motion

`Motion` exposes four named presets — `micro`, `standard`, `enter`, `exit` — each as a `MotionSpec` record `({Duration duration, Curve curve})`. Override any or all:

```dart
ThemeData.light().copyWith(
  motion: Motion(
    micro: (
      duration: const Duration(milliseconds: 80),
      curve: Curves.easeOut,
    ),
  ),
)
```

Read in widgets via `context.motion.standard.duration`, etc.

### Shadows

`Shadows` exposes `none`, `sm`, `md`, `lg`, and `brand` presets. Override to match your shadow style:

```dart
ThemeData.light().copyWith(
  shadows: Shadows(
    brand: [
      BoxShadow(
        color: Color.fromRGBO(124, 58, 237, 0.25),
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ],
  ),
)
```

---

## Variant and tone system

**Variants** control structure and emphasis (`Button`, `Chip`, `Badge`). **Tones** control semantic colour intent (`Alert`, `Card`, `Snackbar`, `ProgressBar`, `StatusDot`). Both use the same pattern: an abstract class with a `resolve(ColorScheme)` method returning a typed style record. Subclass either to define your own without forking the library.

### Variants

#### Built-in `ButtonVariant` presets

```
ButtonVariant.primary       // solid brand fill
ButtonVariant.secondary     // outlined, surface background
ButtonVariant.tertiary      // subtle fill + light border
ButtonVariant.ghost         // no background or border
ButtonVariant.destructive   // solid danger fill
ButtonVariant.success       // solid success fill
```

#### Custom `ButtonVariant`

```dart
class OutlineButtonVariant extends ButtonVariant {
  const OutlineButtonVariant();

  @override
  ButtonVariantStyle resolve(ColorScheme cs) => ButtonVariantStyle(
    foregroundColor: cs.brand,
    backgroundColor: const Color(0x00000000),
    borderColor: cs.brand,
  );
}

Button(
  label: const Text('Follow'),
  variant: const OutlineButtonVariant(),
  onPressed: _handleFollow,
)
```

#### `ChipVariant`

```dart
class CategoryChipVariant extends ChipVariant {
  const CategoryChipVariant();

  @override
  ChipVariantStyle resolve(
    ColorScheme cs, {
    required bool isSelected,
  }) => ChipVariantStyle(
    backgroundColor: isSelected ? cs.brand : cs.subtle,
    foregroundColor: isSelected ? cs.onBrand : cs.text,
    borderColor: isSelected ? cs.brand : cs.border,
  );
}
```

#### `BadgeVariant`

Built-in presets: `BadgeVariant.neutral`, `info`, `success`, `warning`, `danger`, `brand`.

```dart
class PremiumBadgeVariant extends BadgeVariant {
  const PremiumBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: const Color(0xFFFFF7ED),
    foregroundColor: const Color(0xFFC2410C),
    dotColor: const Color(0xFFF97316),
  );
}
```

---

### Tones

#### Built-in presets

| Class             | Presets                                           |
| ----------------- | ------------------------------------------------- |
| `AlertTone`       | `info`, `success`, `warning`, `danger`            |
| `CardTone`        | `subtle`, `surface`, `brand`, `tint`              |
| `SnackbarTone`    | `dark`, `success`, `danger`                       |
| `ProgressBarTone` | `brand`, `success`, `warning`, `danger`           |
| `StatusTone`      | `success`, `warning`, `danger`, `info`, `neutral` |

#### Custom `AlertTone`

```dart
class MaintenanceTone extends AlertTone {
  const MaintenanceTone();

  @override
  AlertToneStyle resolve(ColorScheme cs) => AlertToneStyle(
    backgroundColor: cs.warningSoft,
    accentColor: cs.warning,
  );
}

Alert(
  tone: const MaintenanceTone(),
  icon: const Icon(Icons.build),
  title: const Text('Scheduled maintenance'),
)
```

#### Custom `CardTone`

```dart
class DangerCardTone extends CardTone {
  const DangerCardTone();

  @override
  CardToneStyle resolve(ColorScheme cs) => CardToneStyle(
    backgroundColor: cs.dangerSoft,
    borderColor: cs.danger.withValues(alpha: 0.30),
  );
}
```

#### Custom `SnackbarTone`

```dart
class BrandSnackbarTone extends SnackbarTone {
  const BrandSnackbarTone();

  @override
  SnackbarToneStyle resolve(ColorScheme cs) => SnackbarToneStyle(
    backgroundColor: cs.brand,
    foregroundColor: cs.onBrand,
  );
}

context.showSnackbar(
  Snackbar(
    tone: const BrandSnackbarTone(),
    message: const Text('Subscribed!'),
  ),
)
```

#### `StatusTone.custom`

For a one-off colour without subclassing:

```dart
StatusDot(tone: StatusTone.custom(const Color(0xFF9333EA)))
```

---

## Components

### Atoms

| Widget                    | Description                                                                        |
| ------------------------- | ---------------------------------------------------------------------------------- |
| `Button` / `Button.icon`  | Pressable button with label, icons, loading state, and custom variants             |
| `Chip` / `Chip.removable` | Toggleable pill with optional remove affordance                                    |
| `Badge`                   | Small status/count pill                                                            |
| `Checkbox`                | Branded checkbox with `CheckboxSize`                                               |
| `Radio`                   | Branded radio button with `RadioSize`                                              |
| `Switch`                  | Toggle switch with `SwitchSize`                                                    |
| `Spinner`                 | Indeterminate circular progress indicator                                          |
| `ProgressBar`             | Animated linear progress bar with tone variants                                    |
| `StatusDot`               | Coloured presence dot with `success`, `warning`, `danger`, `info`, `neutral` tones |
| `Avatar` / `AvatarStack`  | Circular image/initials avatar, stackable                                          |
| `Slider`                  | Draggable horizontal slider for selecting a value within a range                   |
| `Divider`                 | Horizontal and vertical dividers                                                   |

### Molecules

| Widget             | Description                                                            |
| ------------------ | ---------------------------------------------------------------------- |
| `ActionTile`       | Tappable tile with circular icon, title, subtitle, and badge           |
| `Alert`            | Inline status banner with tone variants                                |
| `Breadcrumb`       | Navigation breadcrumb trail                                            |
| `Card`             | Themed card surface with tone variants                                 |
| `ListItem`         | Row-based list entry with leading/trailing slots                       |
| `Pagination`       | Page selector with prev/next controls                                  |
| `SegmentedControl` | Exclusive option picker                                                |
| `Select<T>`        | Overlay dropdown with typed options                                    |
| `Snackbar`         | Toast notification (show via `context.showSnackbar(...)`)              |
| `StatCard`         | Metric card with trend and delta                                       |
| `Stepper`          | Linear multi-step progress indicator                                   |
| `Tabs`             | Tab bar + tab view                                                     |
| `TextField`        | Text input with label, hint, error, leading/trailing                   |
| `Tooltip`          | Hover/long-press overlay label                                         |
| `ValueRow`         | Label + value display row                                              |

### Organisms

| Widget                            | Description                                            |
| --------------------------------- | ------------------------------------------------------ |
| `AppBar`                          | Top app bar with adaptive back button (platform-aware)                 |
| `BottomNav<T>`                    | Bottom navigation bar with typed destinations                          |
| `BottomSheet`                     | Persistent bottom sheet with drag handle                               |
| `Drawer`                          | Side drawer panel with header and optional footer                      |
| `EmptyState` / `EmptyState.large` | Empty content placeholder                                              |
| `ErrorState` / `ErrorState.large` | Error state with retry action                                          |
| `FormLayout`                      | Multi-group form with stacked, two-column, and two-column-card layouts |
| `Modal`                           | Centred dialog with title, body, and actions                           |
| `RadioGroup<T>`                   | Radio selection group with list, table, and card layout variants       |
| `SideNav<T>`                      | Sidebar navigation with destinations and group titles                  |
| `TopBar<T>`                       | Segmented top navigation bar                                           |

---

## Overlay utilities

```dart
// Modal dialog — fade + scale transition
final result = await showModal<bool>(context, (ctx) => MyModal());

// Bottom sheet — slide-up + optional drag-to-dismiss
await showBottomSheet(context, (ctx) => MySheet());

// Drawer — slide-in from the right
await showDrawer(context, (ctx) => MyDrawer());

// Snackbar — requires Provider in the tree
context.showSnackbar(
  Snackbar(
    message: const Text('Changes saved'),
    tone: SnackbarTone.success,
  ),
);
```

---

## Design tokens

### Spacing

`Spacing` provides a 4 px base grid:

```dart
Spacing.s1   //  4 px
Spacing.s2   //  8 px
Spacing.s3   // 12 px
Spacing.s4   // 16 px
Spacing.s5   // 20 px
Spacing.s6   // 24 px
// … up to s16 (64 px)
```

### Border radius

```dart
Radii.xs     //  4 px
Radii.sm     //  8 px
Radii.md     // 12 px
Radii.lg     // 16 px
Radii.xl     // 20 px
Radii.xxl    // 24 px
Radii.pill   // 999 px (full pill)

// Pre-built BorderRadius helpers
Radii.smAll   // BorderRadius.all(Radius.circular(8))
Radii.mdAll
// … etc.
```

---

## Responsive layout

`ResponsiveBuilder` uses `LayoutBuilder` internally, so the resolved breakpoint reflects the parent's available width rather than the full screen — making it suitable for both full-screen layouts and embedded components.

```dart
ResponsiveBuilder(
  builder: (context, breakpoint) {
    if (breakpoint >= Breakpoint.md) {
      return const TwoColumnLayout();
    }
    return const SingleColumnLayout();
  },
)
```

### Breakpoints

| Breakpoint | Default min-width | Typical target                   |
| ---------- | ----------------- | -------------------------------- |
| `xs`       | — (below `sm`)    | Phone portrait                   |
| `sm`       | 640 px            | Phone landscape / large phone    |
| `md`       | 768 px            | Tablet portrait                  |
| `lg`       | 1024 px           | Tablet landscape / small desktop |
| `xl`       | 1280 px           | Standard desktop                 |
| `xxl`      | 1536 px           | Large desktop                    |

All thresholds are configurable globally via `ThemeData`:

```dart
ThemeData.light().copyWith(
  breakpoints: const Breakpoints(md: 900, lg: 1200),
)
```

The `Breakpoint` enum supports comparison operators for readable conditions:

```dart
breakpoint >= Breakpoint.md   // md, lg, xl, or xxl
breakpoint < Breakpoint.lg    // xs, sm, or md
```

---

## `BuildContext` extensions

Below any `Provider`:

```dart
context.theme          // ThemeData
context.colorScheme    // ColorScheme
context.typography     // Typography
context.motion         // Motion
context.shadows        // Shadows
context.breakpoints    // Breakpoints

context.showSnackbar(snackbar)   // SnackbarContext
```
