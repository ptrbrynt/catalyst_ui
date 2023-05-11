// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catalyst_ui/catalyst_ui.dart';

/// {@template badge_theme_data}
/// The theme data for Badges.
/// {@endtemplate}
@immutable
class BadgeThemeData extends Styleable<BadgeThemeData> {
  /// {@macro badge_theme_data}
  const BadgeThemeData({
    this.backgroundColor = defaultBackgroundColor,
    this.outlined = defaultOutlined,
    this.borderRadius = BorderRadius.zero,
    this.padding,
    this.textStyle = defaultTextStyle,
    super.styles = const {},
  });

  /// The background color of the badges.
  final Color backgroundColor;

  /// Whether the badges are outlined.
  final bool outlined;

  /// The [BorderRadius] of the badges.
  final BorderRadius borderRadius;

  /// The internal padding of the badges.
  final EdgeInsetsGeometry? padding;

  /// The [TextStyle] of the badges.
  final TextStyle textStyle;

  static const TextStyle defaultTextStyle = TextStyle(fontSize: 12);
  static const Color defaultBackgroundColor = Color(0xFFFFFFFF);
  static const bool defaultOutlined = false;

  /// Makes a copy of [BadgeThemeData] with specified parameters overridden.
  BadgeThemeData copyWith({
    Color? backgroundColor,
    bool? outlined,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    return BadgeThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      outlined: outlined ?? this.outlined,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  bool operator ==(covariant BadgeThemeData other) {
    if (identical(this, other)) return true;

    return other.backgroundColor == backgroundColor &&
        other.outlined == outlined &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode {
    return backgroundColor.hashCode ^
        outlined.hashCode ^
        borderRadius.hashCode ^
        padding.hashCode ^
        textStyle.hashCode;
  }
}
