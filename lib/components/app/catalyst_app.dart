import 'package:catalyst_ui/catalyst_ui.dart';

export 'catalyst_theme.dart';
export 'catalyst_theme_data.dart';

/// {@template catalyst_app}
/// The root widget of the Catalyst UI library.
/// {@endtemplate}
class CatalystApp extends StatelessWidget {
  /// {@macro catalyst_app}
  const CatalystApp({
    required this.child,
    super.key,
    this.textDirection = TextDirection.ltr,
    this.theme = const CatalystThemeData(),
  });

  /// The [TextDirection] for this app
  final TextDirection textDirection;

  /// The [CatalystThemeData] for this app
  final CatalystThemeData theme;

  /// The [Widget] below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: CatalystTheme(
        data: theme,
        child: child,
      ),
    );
  }
}
