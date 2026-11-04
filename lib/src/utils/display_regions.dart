import 'dart:ui' show DisplayFeature, DisplayFeatureType;

import 'package:flutter/widgets.dart';

/// The physical edge of the screen where vertical bars (toolbars and tab bars)
/// are placed.
///
/// This is a physical side, not a leading/trailing one: on devices that place
/// bars vertically, the bars stay aligned with the hardware, so they don't
/// flip in right-to-left languages.
enum VerticalBarEdge {
  /// Bars are horizontal (top and bottom), as on most devices.
  none,

  /// Bars run down the left edge of the screen.
  left,

  /// Bars run down the right edge of the screen.
  right;

  /// The narrowest the vertical bar column may be: room for a 44 pt control
  /// with a 16 pt margin on each side.
  static const double barExtent = 76;

  /// Whether bars are placed vertically.
  bool get isVertical => this != none;
}

/// Provides the [VerticalBarEdge] to descendant widgets.
///
/// Apps feed this from the platform; when it's absent, components assume
/// [VerticalBarEdge.none] and lay out horizontal bars.
class VerticalBarEdgeScope extends InheritedWidget {
  /// Creates a vertical bar edge scope.
  const VerticalBarEdgeScope({
    required this.edge,
    required super.child,
    this.topCornerRadius = 0,
    this.bottomCornerRadius = 0,
    super.key,
  });

  /// The edge where vertical bars are placed.
  final VerticalBarEdge edge;

  /// The radius of the display's rounded corner at the top of [edge], so
  /// vertical bars can keep their first control clear of it.
  final double topCornerRadius;

  /// The radius of the display's rounded corner at the bottom of [edge].
  final double bottomCornerRadius;

  /// Returns the nearest [VerticalBarEdge], or [VerticalBarEdge.none].
  static VerticalBarEdge of(BuildContext context) =>
      maybeOf(context)?.edge ?? VerticalBarEdge.none;

  /// The nearest scope, if any.
  static VerticalBarEdgeScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VerticalBarEdgeScope>();

  @override
  bool updateShouldNotify(VerticalBarEdgeScope oldWidget) =>
      edge != oldWidget.edge ||
      topCornerRadius != oldWidget.topCornerRadius ||
      bottomCornerRadius != oldWidget.bottomCornerRadius;
}

/// Helpers for working with reserved regions of the display: folds and hinges
/// that divide it, and cutouts such as cameras that occlude part of it.
///
/// All regions come from [MediaQueryData.displayFeatures] and are in the
/// coordinate space of the root view (global coordinates).
abstract final class DisplayRegions {
  /// The display features that divide the screen into separate areas, such as
  /// the fold of a partially folded device.
  static Iterable<Rect> dividers(MediaQueryData media) =>
      DisplayFeatureSubScreen.avoidBounds(media).where(
        (bounds) => !_isCutout(media.displayFeatures, bounds),
      );

  /// The display features that occlude part of the screen, such as cameras.
  static Iterable<Rect> occlusions(MediaQueryData media) => media
      .displayFeatures
      .where((f) => f.type == DisplayFeatureType.cutout)
      .map((f) => f.bounds);

  static bool _isCutout(List<DisplayFeature> features, Rect bounds) =>
      features.any(
        (f) => f.type == DisplayFeatureType.cutout && f.bounds == bounds,
      );

  /// The usable area for an overlay (menu, tooltip, snackbar…) anchored at
  /// [anchor], in global coordinates.
  ///
  /// This is the screen minus the safe area insets, narrowed to the part of
  /// the screen on the same side of any fold as [anchor], so overlays never
  /// straddle the fold.
  static Rect overlayArea(MediaQueryData media, Offset anchor) {
    final safe = media.padding.deflateRect(Offset.zero & media.size);
    final areas = DisplayFeatureSubScreen.subScreensInBounds(
      safe,
      dividers(media),
    );
    if (areas.isEmpty) return safe;
    return areas.reduce(
      (a, b) => _distance(anchor, a) <= _distance(anchor, b) ? a : b,
    );
  }

  /// Whether any divider crosses [rect] (in global coordinates).
  static bool divides(MediaQueryData media, Rect rect) =>
      dividers(media).any((d) => d.overlaps(rect));

  /// Moves [rect] by the smallest amount that keeps it inside [area] and
  /// clear of any occlusion, as far as possible.
  static Offset nudgeInto(MediaQueryData media, Rect rect, Rect area) {
    var moved = rect.shift(_clampShift(rect, area));
    for (final occlusion in occlusions(media)) {
      if (!moved.overlaps(occlusion)) continue;
      final candidates = <Offset>[
        Offset(0, occlusion.bottom - moved.top),
        Offset(0, occlusion.top - moved.bottom),
        Offset(occlusion.right - moved.left, 0),
        Offset(occlusion.left - moved.right, 0),
      ].where((shift) => _contains(area, moved.shift(shift))).toList();
      if (candidates.isEmpty) continue;
      candidates.sort((a, b) => a.distance.compareTo(b.distance));
      moved = moved.shift(candidates.first);
    }
    return moved.topLeft - rect.topLeft;
  }

  static Offset _clampShift(Rect rect, Rect area) {
    double axis(double start, double end, double min, double max) {
      if (end - start > max - min) return min - start;
      if (start < min) return min - start;
      if (end > max) return max - end;
      return 0;
    }

    return Offset(
      axis(rect.left, rect.right, area.left, area.right),
      axis(rect.top, rect.bottom, area.top, area.bottom),
    );
  }

  static bool _contains(Rect outer, Rect inner) =>
      inner.left >= outer.left - 0.5 &&
      inner.top >= outer.top - 0.5 &&
      inner.right <= outer.right + 0.5 &&
      inner.bottom <= outer.bottom + 0.5;

  static double _distance(Offset point, Rect rect) {
    final dx = point.dx < rect.left
        ? rect.left - point.dx
        : point.dx > rect.right
        ? point.dx - rect.right
        : 0.0;
    final dy = point.dy < rect.top
        ? rect.top - point.dy
        : point.dy > rect.bottom
        ? point.dy - rect.bottom
        : 0.0;
    return Offset(dx, dy).distance;
  }
}

/// Keeps its child clear of occlusions (such as a camera in a corner of the
/// display) that overlap it, by padding it sideways — moving content aside
/// locally rather than shrinking the whole screen's safe area.
///
/// Use it for bars and headers that run along an edge with an occlusion in
/// one corner: only the part next to the occlusion moves.
class AvoidOcclusions extends StatefulWidget {
  /// Creates an occlusion-avoiding wrapper.
  const AvoidOcclusions({required this.child, super.key});

  /// The content to keep clear of occlusions.
  final Widget child;

  @override
  State<AvoidOcclusions> createState() => _AvoidOcclusionsState();
}

class _AvoidOcclusionsState extends State<AvoidOcclusions> {
  // Occlusions are reported globally; this maps them into the widget. The
  // rect is from the last frame, as a widget can't know its global position
  // while it's being laid out.
  Rect? _globalRect;

  void _measure() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final rect = box.localToGlobal(Offset.zero) & box.size;
    if (rect != _globalRect) setState(() => _globalRect = rect);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final occlusions = DisplayRegions.occlusions(media).toList();
    if (occlusions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    }
    var left = 0.0;
    var right = 0.0;
    final rect = _globalRect;
    if (rect != null) {
      for (final occlusion in occlusions) {
        if (!occlusion.overlaps(rect)) continue;
        if (occlusion.center.dx < rect.center.dx) {
          left = left < occlusion.right - rect.left
              ? occlusion.right - rect.left
              : left;
        } else {
          right = right < rect.right - occlusion.left
              ? rect.right - occlusion.left
              : right;
        }
      }
    }
    // Always padded, so the child keeps its state when occlusions come and go.
    return Padding(
      padding: EdgeInsets.only(left: left, right: right),
      child: widget.child,
    );
  }
}
