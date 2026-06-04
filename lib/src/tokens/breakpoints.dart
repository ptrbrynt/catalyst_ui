/// A named breakpoint resolved from the available width.
///
/// Breakpoints are ordered from narrowest to widest, so comparison operators
/// work intuitively:
///
/// ```dart
/// if (breakpoint >= Breakpoint.md) {
///   // tablet portrait or wider
/// }
/// ```
enum Breakpoint {
  /// Below [Breakpoints.sm] — phone portrait.
  xs,

  /// At or above [Breakpoints.sm] — phone landscape / large phone.
  sm,

  /// At or above [Breakpoints.md] — tablet portrait.
  md,

  /// At or above [Breakpoints.lg] — tablet landscape / small desktop.
  lg,

  /// At or above [Breakpoints.xl] — standard desktop.
  xl,

  /// At or above [Breakpoints.xxl] — large desktop.
  xxl;

  /// True when this breakpoint is at least as wide as [other].
  bool operator >=(Breakpoint other) => index >= other.index;

  /// True when this breakpoint is wider than [other].
  bool operator >(Breakpoint other) => index > other.index;

  /// True when this breakpoint is at most as wide as [other].
  bool operator <=(Breakpoint other) => index <= other.index;

  /// True when this breakpoint is narrower than [other].
  bool operator <(Breakpoint other) => index < other.index;
}

/// The minimum widths (in logical pixels) at which each named breakpoint
/// becomes active.
///
/// Defaults follow common web conventions. Override any threshold via
/// [copyWith] or by supplying a custom instance to [ThemeData]:
///
/// ```dart
/// ThemeData.light().copyWith(
///   breakpoints: const Breakpoints(md: 900, lg: 1200),
/// )
/// ```
class Breakpoints {
  /// Creates a breakpoints configuration.
  ///
  /// All parameters default to common web-standard values.
  const Breakpoints({
    this.sm = 640,
    this.md = 768,
    this.lg = 1024,
    this.xl = 1280,
    this.xxl = 1536,
  });

  /// Minimum width for [Breakpoint.sm] (default 640 px).
  final double sm;

  /// Minimum width for [Breakpoint.md] (default 768 px).
  final double md;

  /// Minimum width for [Breakpoint.lg] (default 1024 px).
  final double lg;

  /// Minimum width for [Breakpoint.xl] (default 1280 px).
  final double xl;

  /// Minimum width for [Breakpoint.xxl] (default 1536 px).
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

  /// Returns a copy with the given thresholds replaced.
  Breakpoints copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return Breakpoints(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }
}
