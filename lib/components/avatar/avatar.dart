import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';

export 'avatar_theme_data.dart';

/// {@template avatar}
/// An avatar is a graphical representation of a user.
///
/// Avatars in Catalyst UI are customizable with [CatalystTheme].
/// {@endtemplate}
class Avatar extends StyleableWidget {
  /// {@macro avatar}
  const Avatar(
    this.avatarImage, {
    this.child,
    super.styles = const [],
    super.key,
  });

  /// The image to display in the avatar.
  final ImageProvider<Object>? avatarImage;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme =
        CatalystTheme.of(context)?.data.avatarThemeData.forStyles(styles);

    final shape = theme?.shape ?? BoxShape.circle;

    return Container(
      alignment: Alignment.center,
      height: theme?.size ?? AvatarThemeData.defaultSize,
      width: theme?.size ?? AvatarThemeData.defaultSize,
      decoration: BoxDecoration(
        color: theme?.backgroundColor,
        borderRadius: shape == BoxShape.circle
            ? null
            : theme?.borderRadius ?? BorderRadius.zero,
        shape: shape,
        image:
            avatarImage != null ? DecorationImage(image: avatarImage!) : null,
        border: theme?.border,
        boxShadow: theme?.boxShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
