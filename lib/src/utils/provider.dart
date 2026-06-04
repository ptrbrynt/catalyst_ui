import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

/// Controls which theme [CatalystProvider] applies when both [theme] and
/// [darkTheme] are supplied.
enum ThemeMode {
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
///   theme: ThemeData.light(fontFamily: 'Inter'),
///   child: MyHomePage(),
/// )
/// ```
///
/// **Automatic dark / light switching:**
/// ```dart
/// CatalystProvider(
///   theme: ThemeData.light(fontFamily: 'Inter'),
///   darkTheme: ThemeData.dark(fontFamily: 'Inter'),
///   child: MyHomePage(),
/// )
/// ```
///
/// **Force a specific mode:**
/// ```dart
/// CatalystProvider(
///   theme: ThemeData.light(fontFamily: 'Inter'),
///   darkTheme: ThemeData.dark(fontFamily: 'Inter'),
///   themeMode: ThemeMode.dark,
///   child: MyHomePage(),
/// )
/// ```
class CatalystProvider extends StatelessWidget {
  /// Creates a Catalyst provider scope.
  const CatalystProvider({
    required this.theme,
    required this.child,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    super.key,
  });

  /// The light theme, and the fallback when [darkTheme] is not supplied.
  final ThemeData theme;

  /// The dark theme. When provided alongside [themeMode] set to
  /// [ThemeMode.system], the active theme switches automatically with
  /// the platform brightness.
  final ThemeData? darkTheme;

  /// Controls which theme is applied. Defaults to [ThemeMode.system].
  ///
  /// Ignored when [darkTheme] is `null`.
  final ThemeMode themeMode;

  /// The widget subtree receiving the Catalyst scope.
  final Widget child;

  ThemeData _effectiveTheme(BuildContext context) {
    final dark = darkTheme;
    if (dark == null || themeMode == ThemeMode.light) return theme;
    if (themeMode == ThemeMode.dark) return dark;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark
        ? dark
        : theme;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _effectiveTheme(context),
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (_) {
              return SnackbarHandler(
                child: Builder(
                  builder: (context) {
                    return DefaultTextStyle(
                      style: context.typography.defaultStyle,
                      child: IconTheme(
                        data: IconThemeData(color: context.colorScheme.text),
                        child: ColoredBox(
                          color: context.colorScheme.canvas,
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
