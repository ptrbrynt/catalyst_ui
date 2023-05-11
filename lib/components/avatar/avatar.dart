import 'dart:io';

import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';
import 'package:flutter/foundation.dart';

export 'avatar_theme_data.dart';

/// {@template avatar}
/// An avatar is a graphical representation of a user.
///
/// Avatars in Catalyst UI are customizable with [CatalystTheme].
/// {@endtemplate}
class Avatar extends StyleableWidget {
  /// {@macro avatar}
  const Avatar({
    this.image,
    super.styles = const [],
    super.key,
  });

  /// Creates an avatar that displays an image from the network.
  factory Avatar.network(
    String url, {
    Key? key,
    List<dynamic> styles = const [],
  }) {
    return Avatar(
      key: key,
      image: NetworkImage(url),
      styles: styles,
    );
  }

  /// Creates an avatar that displays an image from an asset.
  factory Avatar.asset(
    String name, {
    Key? key,
    List<dynamic> styles = const [],
  }) {
    return Avatar(
      key: key,
      image: AssetImage(name),
      styles: styles,
    );
  }

  /// Creates an avatar that displays an image from a file on the file system.
  factory Avatar.file(
    String path, {
    Key? key,
    List<dynamic> styles = const [],
  }) {
    return Avatar(
      key: key,
      image: FileImage(File(path)),
      styles: styles,
    );
  }

  /// Creates an avatar that displays an image from a [Uint8List].
  factory Avatar.memory(
    Uint8List bytes, {
    Key? key,
    List<dynamic> styles = const [],
  }) {
    return Avatar(
      key: key,
      image: MemoryImage(bytes),
      styles: styles,
    );
  }

  /// The image to display in the avatar.
  final ImageProvider<Object>? image;

  @override
  Widget build(BuildContext context) {
    final theme =
        CatalystTheme.of(context)?.data.avatarThemeData.forStyles(styles);

    final shape = theme?.shape ?? BoxShape.circle;

    return Container(
      height: theme?.size ?? AvatarThemeData.defaultSize,
      width: theme?.size ?? AvatarThemeData.defaultSize,
      decoration: BoxDecoration(
        borderRadius: shape == BoxShape.circle
            ? null
            : theme?.borderRadius ?? BorderRadius.zero,
        shape: shape,
        image: image != null ? DecorationImage(image: image!) : null,
        border: theme?.border,
        boxShadow: theme?.boxShadow,
      ),
    );
  }
}
