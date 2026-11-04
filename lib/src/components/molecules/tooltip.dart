import 'dart:async' show unawaited;

import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../utils/overlay_placement.dart';

/// The side on which a [Tooltip] appears relative to its child.
enum TooltipSide {
  /// Appears above the child (default).
  top,

  /// Appears below the child.
  bottom,
}

/// A small informational overlay that appears on hover or long-press.
///
/// Fades and scales in above (or below) [child], then disappears when the
/// pointer leaves or the long-press ends. It flips sides when there isn't
/// room, and stays clear of folds and cutouts (see [DisplayRegions]).
///
/// ```dart
/// Tooltip(
///   content: 'Save changes',
///   child: const Icon(Icons.save),
/// )
/// ```
class Tooltip extends StatefulWidget {
  /// Creates a tooltip.
  const Tooltip({
    required this.content,
    required this.child,
    this.side = TooltipSide.top,
    super.key,
  });

  /// The plain-text message inside the tooltip.
  final String content;

  /// The widget that triggers the tooltip.
  final Widget child;

  /// Which side of [child] the tooltip appears on.
  final TooltipSide side;

  @override
  State<Tooltip> createState() => _TooltipState();
}

class _TooltipState extends State<Tooltip> with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  final _link = LayerLink();
  late final AnimationController _controller;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: const Cubic(0.4, 0, 1, 1),
    );
    _controller.addStatusListener(_onStatus);
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      _entry?.remove();
      _entry?.dispose();
      _entry = null;
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    _entry?.remove();
    _entry?.dispose();
    _entry = null;
    super.dispose();
  }

  void _show() {
    if (_entry == null) {
      final cs = context.colorScheme;
      final typo = context.typography;
      final shadows = context.shadows;
      final textStyle = typo.caption.copyWith(
        color: cs.onInverse,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );
      final painter = TextPainter(
        text: TextSpan(text: widget.content, style: textStyle),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      final placement = OverlayPlacement.resolve(
        context,
        size: Size(painter.width + 20, painter.height + 12),
        gap: 8,
        centered: true,
        preferAbove: widget.side == TooltipSide.top,
      );
      painter.dispose();
      final isTop = placement.showAbove;

      _entry = OverlayEntry(
        builder: (_) => Align(
          alignment: Alignment.topLeft,
          child: CompositedTransformFollower(
            link: _link,
            showWhenUnlinked: false,
            targetAnchor: placement.targetAnchor(centered: true),
            followerAnchor: placement.followerAnchor(centered: true),
            offset: placement.offset,
            child: IgnorePointer(
              child: FadeTransition(
                opacity: _animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.9,
                    end: 1,
                  ).animate(_animation),
                  alignment: isTop
                      ? Alignment.bottomCenter
                      : Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.inverse,
                      borderRadius: Radii.smAll,
                      boxShadow: shadows.md,
                    ),
                    child: Text(
                      widget.content,
                      softWrap: false,
                      style: textStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      Overlay.of(context).insert(_entry!);
    }
    unawaited(_controller.forward());
  }

  void _hide() {
    if (_entry == null) return;
    unawaited(_controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: MouseRegion(
        onEnter: (_) => _show(),
        onExit: (_) => _hide(),
        child: GestureDetector(
          onLongPress: _show,
          onLongPressEnd: (_) => _hide(),
          child: widget.child,
        ),
      ),
    );
  }
}
