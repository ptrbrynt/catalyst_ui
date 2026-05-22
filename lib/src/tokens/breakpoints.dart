/// A named breakpoint resolved from the available width.
///
/// Breakpoints are ordered from narrowest to widest, so comparison operators
/// work intuitively:
///
/// ```dart
/// if (breakpoint >= CatalystBreakpoint.md) {
///   // tablet portrait or wider
/// }
/// ```
enum CatalystBreakpoint {
  /// Below [CatalystBreakpoints.sm] — phone portrait.
  xs,

  /// At or above [CatalystBreakpoints.sm] — phone landscape / large phone.
  sm,

  /// At or above [CatalystBreakpoints.md] — tablet portrait.
  md,

  /// At or above [CatalystBreakpoints.lg] — tablet landscape / small desktop.
  lg,

  /// At or above [CatalystBreakpoints.xl] — standard desktop.
  xl,

  /// At or above [CatalystBreakpoints.xxl] — large desktop.
  xxl;

  /// True when this breakpoint is at least as wide as [other].
  bool operator >=(CatalystBreakpoint other) => index >= other.index;

  /// True when this breakpoint is wider than [other].
  bool operator >(CatalystBreakpoint other) => index > other.index;

  /// True when this breakpoint is at most as wide as [other].
  bool operator <=(CatalystBreakpoint other) => index <= other.index;

  /// True when this breakpoint is narrower than [other].
  bool operator <(CatalystBreakpoint other) => index < other.index;
}

/// The minimum widths (in logical pixels) at which each named breakpoint
/// becomes active.
///
/// Defaults follow common web conventions. Override any threshold via
/// [copyWith] or by supplying a custom instance to [CatalystThemeData]:
///
/// ```dart
/// CatalystThemeData.light().copyWith(
///   breakpoints: const CatalystBreakpoints(md: 900, lg: 1200),
/// )
/// ```
class CatalystBreakpoints {
  /// Creates a breakpoints configuration.
  ///
  /// All parameters default to common web-standard values.
  const CatalystBreakpoints({
    this.sm = 640,
    this.md = 768,
    this.lg = 1024,
    this.xl = 1280,
    this.xxl = 1536,
  });

  /// Minimum width for [CatalystBreakpoint.sm] (default 640 px).
  final double sm;

  /// Minimum width for [CatalystBreakpoint.md] (default 768 px).
  final double md;

  /// Minimum width for [CatalystBreakpoint.lg] (default 1024 px).
  final double lg;

  /// Minimum width for [CatalystBreakpoint.xl] (default 1280 px).
  final double xl;

  /// Minimum width for [CatalystBreakpoint.xxl] (default 1536 px).
  final double xxl;

  /// Returns the active [CatalystBreakpoint] for the given [width].
  CatalystBreakpoint resolve(double width) {
    if (width >= xxl) return CatalystBreakpoint.xxl;
    if (width >= xl) return CatalystBreakpoint.xl;
    if (width >= lg) return CatalystBreakpoint.lg;
    if (width >= md) return CatalystBreakpoint.md;
    if (width >= sm) return CatalystBreakpoint.sm;
    return CatalystBreakpoint.xs;
  }

  /// Returns a copy with the given thresholds replaced.
  CatalystBreakpoints copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return CatalystBreakpoints(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }
}
