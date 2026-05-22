import 'package:flutter/widgets.dart';

import 'theme_data.dart';

/// An [InheritedWidget] that provides [CatalystThemeData] to its subtree.
///
/// Wrap your app (or any subtree) with [CatalystTheme] and access the data
/// via [CatalystTheme.of], or the [BuildContext] extension getters
/// `context.theme`, `context.colorScheme`, `context.typography`,
/// `context.motion`, and `context.shadows`.
///
/// ```dart
/// CatalystTheme(
///   data: CatalystThemeData.light(fontFamily: 'Inter'),
///   child: MyApp(),
/// )
/// ```
class CatalystTheme extends InheritedWidget {
  /// Creates a theme that propagates [data] to its [child] subtree.
  CatalystTheme({required Widget child, required this.data, super.key})
    : super(
        child: DefaultTextStyle(
          style: data.typography.defaultStyle,
          child: child,
        ),
      );

  /// The theme data provided to the subtree.
  final CatalystThemeData data;

  /// Returns the [CatalystThemeData] from the nearest [CatalystTheme] ancestor.
  ///
  /// Throws a descriptive error if no ancestor is found.
  static CatalystThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<CatalystTheme>()?.data;
    assert(
      theme != null,
      'No CatalystTheme found in the widget tree. '
      'Wrap your app or subtree with a CatalystTheme widget.',
    );
    return theme!;
  }

  /// Returns the [CatalystThemeData] from the nearest [CatalystTheme] ancestor,
  /// or `null` if none is found.
  static CatalystThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CatalystTheme>()?.data;
  }

  @override
  bool updateShouldNotify(CatalystTheme oldWidget) => oldWidget.data != data;
}
