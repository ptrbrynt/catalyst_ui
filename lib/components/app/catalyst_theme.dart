import 'package:catalyst_ui/catalyst_ui.dart';

/// {@template catalyst_theme}
/// The Catalyst UI theme.
///
/// The theme is accessible via `CatalystTheme.of(context)`.
/// {@endtemplate}
class CatalystTheme extends InheritedWidget {
  /// {@macro catalyst_theme}
  const CatalystTheme({
    required super.child,
    required this.data,
    super.key,
  });

  /// The theme data for avatars.
  final CatalystThemeData data;

  /// {@macro catalyst_theme}
  static CatalystTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CatalystTheme>();
  }

  @override
  bool updateShouldNotify(CatalystTheme oldWidget) {
    return true;
  }
}
