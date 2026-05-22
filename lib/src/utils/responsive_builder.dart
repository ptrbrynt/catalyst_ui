import 'package:flutter/widgets.dart';

import '../theme/extensions.dart';
import '../tokens/breakpoints.dart';

/// A layout builder that resolves the current [CatalystBreakpoint] from
/// the available width and passes it to [builder].
///
/// Uses [LayoutBuilder] internally, so the breakpoint reflects the
/// parent's constraints rather than the full screen size — making it
/// suitable for both full-screen layouts and embedded components.
///
/// Breakpoint thresholds are read from the nearest [CatalystTheme] and
/// can be customised globally via [CatalystThemeData.breakpoints].
///
/// ```dart
/// CatalystResponsiveBuilder(
///   builder: (context, breakpoint) {
///     if (breakpoint >= CatalystBreakpoint.md) {
///       return const TwoColumnLayout();
///     }
///     return const SingleColumnLayout();
///   },
/// )
/// ```
class CatalystResponsiveBuilder extends StatelessWidget {
  /// Creates a responsive builder.
  const CatalystResponsiveBuilder({required this.builder, super.key});

  /// Called with the resolved [CatalystBreakpoint] whenever the available
  /// width changes.
  final Widget Function(
    BuildContext context,
    CatalystBreakpoint breakpoint,
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
