import 'package:flutter/widgets.dart';

import '../theme/extensions.dart';
import '../tokens/breakpoints.dart';

/// A layout builder that resolves the current [Breakpoint] from
/// the available width and passes it to [builder].
///
/// Uses [LayoutBuilder] internally, so the breakpoint reflects the
/// parent's constraints rather than the full screen size — making it
/// suitable for both full-screen layouts and embedded components.
///
/// Breakpoint thresholds are read from the nearest [Theme] and
/// can be customised globally via [ThemeData.breakpoints].
///
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, breakpoint) {
///     if (breakpoint >= Breakpoint.md) {
///       return const TwoColumnLayout();
///     }
///     return const SingleColumnLayout();
///   },
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a responsive builder.
  const ResponsiveBuilder({required this.builder, super.key});

  /// Called with the resolved [Breakpoint] whenever the available
  /// width changes.
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
