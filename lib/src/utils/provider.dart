import 'package:flutter/widgets.dart';

import '../theme/theme.dart';
import '../theme/theme_data.dart';
import 'snackbar_handler.dart';

/// Controls which theme [CatalystProvider] applies when both [theme] and
/// [darkTheme] are supplied.
enum CatalystThemeMode {
  /// Follows the host platform's brightness setting (default).
  system,

  /// Always uses [CatalystProvider.theme], ignoring the platform setting.
  light,

  /// Always uses [CatalystProvider.darkTheme] when set,
  /// otherwise falls back to [CatalystProvider.theme].
  dark,
}

/// Convenience widget that sets up the full Catalyst UI scope in one step.
///
/// Place this inside your navigator (e.g. as the `home` of a `WidgetsApp`)
/// to wire up theming and all Catalyst overlay dependencies at once.
///
/// **Light theme only:**
/// ```dart
/// CatalystProvider(
///   theme: CatalystThemeData.light(fontFamily: 'Inter'),
///   child: MyHomePage(),
/// )
/// ```
///
/// **Automatic dark / light switching:**
/// ```dart
/// CatalystProvider(
///   theme: CatalystThemeData.light(fontFamily: 'Inter'),
///   darkTheme: CatalystThemeData.dark(fontFamily: 'Inter'),
///   child: MyHomePage(),
/// )
/// ```
///
/// **Force a specific mode:**
/// ```dart
/// CatalystProvider(
///   theme: CatalystThemeData.light(fontFamily: 'Inter'),
///   darkTheme: CatalystThemeData.dark(fontFamily: 'Inter'),
///   themeMode: CatalystThemeMode.dark,
///   child: MyHomePage(),
/// )
/// ```
class CatalystProvider extends StatelessWidget {
  /// Creates a Catalyst provider scope.
  const CatalystProvider({
    required this.theme,
    required this.child,
    this.darkTheme,
    this.themeMode = CatalystThemeMode.system,
    super.key,
  });

  /// The light theme, and the fallback when [darkTheme] is not supplied.
  final CatalystThemeData theme;

  /// The dark theme. When provided alongside [themeMode] set to
  /// [CatalystThemeMode.system], the active theme switches automatically with
  /// the platform brightness.
  final CatalystThemeData? darkTheme;

  /// Controls which theme is applied. Defaults to [CatalystThemeMode.system].
  ///
  /// Ignored when [darkTheme] is `null`.
  final CatalystThemeMode themeMode;

  /// The widget subtree receiving the Catalyst scope.
  final Widget child;

  CatalystThemeData _effectiveTheme(BuildContext context) {
    final dark = darkTheme;
    if (dark == null || themeMode == CatalystThemeMode.light) return theme;
    if (themeMode == CatalystThemeMode.dark) return dark;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? dark
        : theme;
  }

  @override
  Widget build(BuildContext context) {
    return CatalystTheme(
      data: _effectiveTheme(context),
      child: CatalystSnackbarHandler(child: child),
    );
  }
}
