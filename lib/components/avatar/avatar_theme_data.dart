import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:equatable/equatable.dart';

/// {@template avatar_theme_data}
/// The theme data for Avatars.
/// {@endtemplate}
@immutable
class AvatarThemeData extends Styleable<AvatarThemeData> with EquatableMixin {
  /// {@macro avatar_theme_data}
  const AvatarThemeData({
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.backgroundColor,
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

  /// The background color of the avatar.
  final Color? backgroundColor;

  /// The default size for avatars if none is specified.
  static const double defaultSize = 48;

  /// Creates a copy of this [AvatarThemeData] but with the given fields
  AvatarThemeData copyWith({
    BoxShape? shape,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    BoxBorder? border,
    double? size,
    Color? backgroundColor,
  }) {
    return AvatarThemeData(
      shape: shape ?? this.shape,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadow: boxShadow ?? this.boxShadow,
      border: border ?? this.border,
      size: size ?? this.size,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  List<Object?> get props => [
        shape,
        borderRadius,
        boxShadow,
        border,
        size,
        backgroundColor,
        styles,
      ];
}
