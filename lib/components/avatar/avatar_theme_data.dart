// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:catalyst_ui/catalyst_ui.dart';

/// {@template avatar_theme_data}
/// The theme data for Avatars.
/// {@endtemplate}
@immutable
class AvatarThemeData extends Styleable<AvatarThemeData> {
  /// {@macro avatar_theme_data}
  const AvatarThemeData({
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.size = defaultSize,
    super.styles = const {},
  });

  /// The [BoxShape] of the avatar.
  final BoxShape shape;

  /// The [BorderRadius] of the avatar.
  /// Ignored if [shape] is [BoxShape.circle].
  final BorderRadius? borderRadius;

  /// The [BoxShadow]s of the avatar.
  final List<BoxShadow>? boxShadow;

  /// The [BoxBorder] of the avatar.
  final BoxBorder? border;

  /// The default size of the avatar. Can be overridden by individual Avatars.
  final double size;

  /// The default size for avatars if none is specified.
  static const double defaultSize = 48;

  @override
  bool operator ==(covariant AvatarThemeData other) {
    if (identical(this, other)) return true;

    return other.shape == shape && other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => shape.hashCode ^ borderRadius.hashCode;

  AvatarThemeData copyWith({
    BoxShape? shape,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    BoxBorder? border,
    double? size,
  }) {
    return AvatarThemeData(
      shape: shape ?? this.shape,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      border: border ?? this.border,
      size: size ?? this.size,
    );
  }
}
