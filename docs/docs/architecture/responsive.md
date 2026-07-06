---
title: Responsive Layout
---

# Responsive Layout

`catalyst_ui` provides a small, theme-aware responsive layout system built
from three pieces: `Breakpoints` (thresholds), `Breakpoint` (a named,
comparable enum), and `ResponsiveBuilder` (a width-aware layout widget).

## `Breakpoints`

`Breakpoints` lives in `src/tokens/breakpoints.dart` and is threaded through
`ThemeData` like every other design token — accessed via
`context.breakpoints` and overridable via `ThemeData.copyWith(breakpoints:
...)`.

It holds the minimum width (in logical pixels) at which each named
breakpoint becomes active:

```dart
class Breakpoints {
  const Breakpoints({
    this.sm = 640,
    this.md = 768,
    this.lg = 1024,
    this.xl = 1280,
    this.xxl = 1536,
  });

  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  /// Returns the active [Breakpoint] for the given [width].
  Breakpoint resolve(double width) {
    if (width >= xxl) return Breakpoint.xxl;
    if (width >= xl) return Breakpoint.xl;
    if (width >= lg) return Breakpoint.lg;
    if (width >= md) return Breakpoint.md;
    if (width >= sm) return Breakpoint.sm;
    return Breakpoint.xs;
  }

  Breakpoints copyWith({...});
}
```

Defaults follow common web conventions. Override any threshold by
supplying a custom instance to `ThemeData`:

```dart
ThemeData.light().copyWith(
  breakpoints: const Breakpoints(md: 900, lg: 1200),
)
```

## `Breakpoint`

`Breakpoint` is an *enhanced enum* — it carries comparison operators so
callers can compare breakpoints directly instead of comparing raw pixel
widths:

```dart
enum Breakpoint {
  xs,   // below Breakpoints.sm — phone portrait
  sm,   // at/above Breakpoints.sm — phone landscape / large phone
  md,   // at/above Breakpoints.md — tablet portrait
  lg,   // at/above Breakpoints.lg — tablet landscape / small desktop
  xl,   // at/above Breakpoints.xl — standard desktop
  xxl;  // at/above Breakpoints.xxl — large desktop

  bool operator >=(Breakpoint other) => index >= other.index;
  bool operator >(Breakpoint other) => index > other.index;
  bool operator <=(Breakpoint other) => index <= other.index;
  bool operator <(Breakpoint other) => index < other.index;
}
```

Because the enum's declaration order is narrowest-to-widest, the comparison
operators work intuitively against that ordering:

```dart
if (breakpoint >= Breakpoint.md) {
  // tablet portrait or wider
}
```

## `ResponsiveBuilder`

`ResponsiveBuilder`, in `src/utils/responsive_builder.dart`, wraps
`LayoutBuilder` and resolves the current `Breakpoint` from the *available
width*. Critically, it does **not** use `MediaQuery.sizeOf` — it reads the
parent's constraints, so it works correctly both for full-screen layouts and
for components embedded inside a narrower parent (a side panel, a card, a
split view, and so on):

```dart
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({required this.builder, super.key});

  final Widget Function(
    BuildContext context,
    Breakpoint breakpoint,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final breakpoints = context.breakpoints;
    return LayoutBuilder(
      builder: (context, constraints) =>
          builder(context, breakpoints.resolve(constraints.maxWidth)),
    );
  }
}
```

Breakpoint thresholds are read from the nearest theme, so they respect any
`ThemeData.copyWith(breakpoints: ...)` override in scope.

### Usage

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

Because `ResponsiveBuilder` reacts to the parent's constraints rather than
the device's screen size, the same widget behaves correctly whether it's the
root of the page or nested three levels deep inside a narrower container.
