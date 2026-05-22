import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import 'avatar.dart';

/// A horizontal stack of overlapping [Avatar] widgets.
///
/// Avatars overlap at 75 % of their size. When the list exceeds [maxCount],
/// a "+N" overflow pill is shown at the end.
class AvatarStack extends StatelessWidget {
  /// Creates an avatar stack.
  const AvatarStack({
    required this.avatars,
    int? maxCount,
    super.key,
  }) : maxCount = maxCount ?? avatars.length;

  /// The list of avatars to display.
  final List<Avatar> avatars;

  /// Maximum number shown before the overflow indicator appears.
  final int maxCount;

  bool get _showOverflow => maxCount < avatars.length;
  int get _overflowCount => avatars.length - maxCount;
  double get _size => avatars.first.size;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return SizedBox(
      width: (_size * 0.75) * (maxCount + (_showOverflow ? 2 : 1)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < maxCount; i++)
            Positioned(
              left: (_size * 0.75) * i,
              child: avatars[i],
            ),
          if (_showOverflow)
            Positioned(
              left: (_size * 0.75) * maxCount,
              child: Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  color: cs.muted,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$_overflowCount',
                  style: TextStyle(
                    fontFamily: context.typography.fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: _size * 0.4,
                    height: 1,
                    color: cs.onMuted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
