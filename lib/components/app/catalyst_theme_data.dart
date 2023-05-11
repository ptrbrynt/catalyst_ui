import 'package:catalyst_ui/catalyst_ui.dart';

export 'styleable.dart';

/// {@template catalyst_theme_data}
/// A theme that defines the configuration of the Catalyst UI library.
/// {@endtemplate}
@immutable
class CatalystThemeData {
  /// {@macro catalyst_theme_data}
  const CatalystThemeData({
    this.avatarThemeData = const AvatarThemeData(),
    this.badgeThemeData = const BadgeThemeData(),
  });

  /// The default [AvatarThemeData] for the [CatalystThemeData].
  final AvatarThemeData avatarThemeData;

  /// The default [BadgeThemeData] for the [CatalystThemeData].
  final BadgeThemeData badgeThemeData;

  @override
  bool operator ==(covariant CatalystThemeData other) {
    if (identical(this, other)) return true;

    return other.avatarThemeData == avatarThemeData;
  }

  @override
  int get hashCode => avatarThemeData.hashCode;
}
