import 'package:flutter/widgets.dart';

import 'theme_data.dart';

/// An [InheritedWidget] that provides [ThemeData] to its subtree.
///
/// Wrap your app (or any subtree) with [Theme] and access the data
/// via [Theme.of], or the [BuildContext] extension getters
/// `context.theme`, `context.colorScheme`, `context.typography`,
/// `context.motion`, and `context.shadows`.
///
/// ```dart
/// Theme(
///   data: ThemeData.light(fontFamily: 'Inter'),
///   child: MyApp(),
/// )
/// ```
class Theme extends InheritedWidget {
  /// Creates a theme that propagates [data] to its [child] subtree.
  Theme({required Widget child, required this.data, super.key})
    : super(
        child: DefaultTextStyle(
          style: data.typography.defaultStyle,
          child: child,
        ),
      );

  /// The theme data provided to the subtree.
  final ThemeData data;

  /// Returns the [ThemeData] from the nearest [Theme] ancestor.
  ///
  /// Throws a descriptive error if no ancestor is found.
  static ThemeData of(BuildContext context) {
    final theme =
        context.dependOnInheritedWidgetOfExactType<Theme>()?.data;
    assert(
      theme != null,
      'No Theme found in the widget tree. '
      'Wrap your app or subtree with a Theme widget.',
    );
    return theme!;
  }

  /// Returns the [ThemeData] from the nearest [Theme] ancestor,
  /// or `null` if none is found.
  static ThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Theme>()?.data;
  }

  @override
  bool updateShouldNotify(Theme oldWidget) => oldWidget.data != data;
}
