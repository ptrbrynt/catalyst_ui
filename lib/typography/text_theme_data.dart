import 'package:catalyst_ui/catalyst_ui.dart';

/// {@template text_theme_data}
/// Defines text styles
/// {@endtemplate}
@immutable
class TextThemeData extends Styleable<TextStyle> {
  /// {@macro text_theme_data}
  const TextThemeData({
    this.defaultStyle = const TextStyle(),
    super.styles = const {},
  });

  /// The default [TextStyle] for this [TextThemeData]
  final TextStyle defaultStyle;
}
