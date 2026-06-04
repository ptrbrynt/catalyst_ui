import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../theme/theme_data.dart';
import '../../tokens/radius.dart';

/// The presence/availability status shown on an [Avatar].
enum AvatarStatus {
  /// Online and available.
  online(Color(0xFF22C55E)),

  /// Online but busy.
  busy(Color(0xFFEF4444)),

  /// Away or idle.
  away(Color(0xFFF59E0B));

  const AvatarStatus(this.color);

  /// The colour of the status indicator dot.
  final Color color;
}

/// A circular or rounded-square avatar displaying initials or a network image.
///
/// When [src] is omitted the widget derives up to two initials from [name]
/// and picks a deterministic background colour from a built-in palette.
/// An optional [status] dot is rendered in the bottom-right corner.
///
/// ```dart
/// Avatar(name: 'Jane Doe', size: 40)
/// Avatar(name: 'John Smith', src: 'https://…', status: AvatarStatus.online)
/// ```
class Avatar extends StatelessWidget {
  /// Creates an avatar.
  const Avatar({
    required this.name,
    this.src,
    this.size = 40,
    this.shape = BoxShape.circle,
    this.color,
    this.status,
    super.key,
  });

  /// The user's display name; used to derive initials and a palette colour.
  final String name;

  /// An optional network image URL. When set, initials are hidden.
  final String? src;

  /// The diameter (or side length) of the avatar in logical pixels.
  final double size;

  /// An override for the auto-selected background colour.
  final Color? color;

  /// The shape. Defaults to [BoxShape.circle].
  final BoxShape shape;

  /// An optional presence indicator in the bottom-right corner.
  final AvatarStatus? status;

  static const _palette = [
    Color(0xFF0066FF),
    Color(0xFF7C3AED),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF16A34A),
    Color(0xFF0891B2),
    Color(0xFFDB2777),
  ];

  Color get _effectiveColor {
    if (color != null) return color!;
    final code =
        name.codeUnits.first + (name.codeUnits.elementAtOrNull(1) ?? 0);
    return _palette[code % _palette.length];
  }

  String get _initials =>
      name.split(' ').map((w) => w[0]).take(2).join().toUpperCase();

  double get _statusSize => max(8, size * 0.28);

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: motion.micro.duration,
            curve: motion.micro.curve,
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius:
                  shape == BoxShape.circle ? null : CatalystRadius.smAll,
              color: _effectiveColor,
              image:
                  src != null
                      ? DecorationImage(
                        image: NetworkImage(src!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            alignment: Alignment.center,
            child:
                src != null
                    ? null
                    : Text(
                      _initials,
                      style: TextStyle(
                        fontFamily: context.typography.fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: size * 0.4,
                        color: ThemeData.textColorFor(_effectiveColor),
                      ),
                    ),
          ),
          if (status != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: _statusSize,
                height: _statusSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: status!.color,
                  border: Border.all(
                    color: context.colorScheme.canvas,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
