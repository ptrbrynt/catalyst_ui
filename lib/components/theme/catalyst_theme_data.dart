import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/input/input_decoration_theme.dart';
import 'package:equatable/equatable.dart';

export 'styleable.dart';

/// {@template catalyst_theme_data}
/// A theme that defines the configuration of the Catalyst UI library.
/// {@endtemplate}
@immutable
class CatalystThemeData extends Equatable {
  /// {@macro catalyst_theme_data}
  const CatalystThemeData({
    this.avatarThemeData = const AvatarThemeData(),
    this.badgeThemeData = const BadgeThemeData(),
    this.buttonThemeData = const ButtonThemeData(),
    this.inputDecorationThemeData = const InputDecorationThemeData(),
    this.textThemeData = const TextThemeData(),
  });

  /// The [AvatarThemeData] for the [CatalystThemeData].
  final AvatarThemeData avatarThemeData;

  /// The [BadgeThemeData] for the [CatalystThemeData].
  final BadgeThemeData badgeThemeData;

  /// The [ButtonThemeData] for the [CatalystThemeData].
  final ButtonThemeData buttonThemeData;

  /// The [InputDecorationThemeData] for the [CatalystThemeData].
  final InputDecorationThemeData inputDecorationThemeData;

  /// The [TextThemeData] for the [CatalystThemeData]
  final TextThemeData textThemeData;

  @override
  List<Object?> get props => [
        avatarThemeData,
        badgeThemeData,
        buttonThemeData,
        inputDecorationThemeData,
        textThemeData,
      ];
}
