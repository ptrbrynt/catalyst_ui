import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'display_regions.dart';

/// Where to place an overlay (dropdown, tooltip…) anchored to a trigger so it
/// stays inside the safe area, on the trigger's side of any fold, and clear of
/// occlusions such as cameras.
@immutable
class OverlayPlacement {
  /// Creates an overlay placement.
  const OverlayPlacement({
    required this.showAbove,
    required this.alignEnd,
    required this.offset,
    required this.maxHeight,
  });

  /// Resolves the placement for an overlay of [size] anchored to [context]'s
  /// render box.
  ///
  /// When [centered] is true the overlay is centred on the trigger
  /// horizontally (tooltips); otherwise it aligns to the trigger's left edge,
  /// or its right edge when there isn't room (dropdowns). The overlay opens
  /// below the trigger, or above it when [preferAbove] is true, unless the
  /// other side has more room.
  factory OverlayPlacement.resolve(
    BuildContext context, {
    required Size size,
    double gap = 4,
    bool centered = false,
    bool preferAbove = false,
  }) {
    final box = context.findRenderObject()! as RenderBox;
    final trigger = box.localToGlobal(Offset.zero) & box.size;
    final media = MediaQuery.of(context);
    final area = DisplayRegions.overlayArea(media, trigger.center);

    final spaceBelow = area.bottom - trigger.bottom - gap;
    final spaceAbove = trigger.top - area.top - gap;
    final showAbove = preferAbove
        ? !(spaceAbove < size.height && spaceBelow > spaceAbove)
        : spaceBelow < size.height && spaceAbove > spaceBelow;
    final maxHeight = math.max<double>(
      0,
      math.min(size.height, showAbove ? spaceAbove : spaceBelow),
    );

    final alignEnd =
        !centered &&
        trigger.left + size.width > area.right &&
        trigger.right - size.width >= area.left;
    final left = centered
        ? trigger.center.dx - size.width / 2
        : alignEnd
        ? trigger.right - size.width
        : trigger.left;
    final top = showAbove
        ? trigger.top - gap - maxHeight
        : trigger.bottom + gap;
    final rect = Rect.fromLTWH(left, top, size.width, maxHeight);
    final nudge = DisplayRegions.nudgeInto(media, rect, area);

    return OverlayPlacement(
      showAbove: showAbove,
      alignEnd: alignEnd,
      // Only nudge sideways: moving vertically would cover the trigger.
      offset: Offset(nudge.dx, showAbove ? -gap : gap),
      maxHeight: maxHeight,
    );
  }

  /// Whether the overlay opens above the trigger.
  final bool showAbove;

  /// Whether the overlay's right edge aligns with the trigger's right edge.
  final bool alignEnd;

  /// The offset to pass to the [CompositedTransformFollower].
  final Offset offset;

  /// The tallest the overlay can be without leaving its area.
  final double maxHeight;

  /// The anchor on the trigger.
  Alignment targetAnchor({bool centered = false}) {
    if (centered) {
      return showAbove ? Alignment.topCenter : Alignment.bottomCenter;
    }
    if (showAbove) return alignEnd ? Alignment.topRight : Alignment.topLeft;
    return alignEnd ? Alignment.bottomRight : Alignment.bottomLeft;
  }

  /// The matching anchor on the overlay.
  Alignment followerAnchor({bool centered = false}) {
    if (centered) {
      return showAbove ? Alignment.bottomCenter : Alignment.topCenter;
    }
    if (showAbove) {
      return alignEnd ? Alignment.bottomRight : Alignment.bottomLeft;
    }
    return alignEnd ? Alignment.topRight : Alignment.topLeft;
  }
}
