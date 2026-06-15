import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';

const double _kTrackHeight = 4;
const double _kThumbSize = 20;
const double _kTickWidth = 2;
const double _kTickHeight = 8;
const double _kHitSlop = 12;

/// A draggable horizontal slider for selecting a value within a range.
///
/// The visual scale runs from [start] to [end]. The selectable range can be
/// narrowed to [min]–[max]: portions of the track outside that range are
/// rendered in a dimmed style with a tick mark at each boundary, and the thumb
/// cannot be dragged beyond those bounds.
///
/// Pass `null` for [onChanged] to render the slider as disabled.
///
/// ```dart
/// Slider(
///   value: _volume,
///   onChanged: (v) => setState(() => _volume = v),
/// )
/// ```
class Slider extends StatefulWidget {
  /// Creates a slider.
  const Slider({
    required this.value,
    required this.onChanged,
    this.start = 0,
    this.end = 1,
    double? min,
    double? max,
    this.onChangeStarted,
    this.onChangeEnded,
    super.key,
  }) : min = min ?? start,
       max = max ?? end,
       assert(start < end, 'start must be less than end'),
       assert((min ?? start) < (max ?? end), 'min must be less than max'),
       assert((min ?? start) >= start, 'min must be >= start'),
       assert((max ?? end) <= end, 'max must be <= end');

  /// The current value, which must be within [[min], [max]].
  final double value;

  /// Called continuously as the user drags. Pass `null` to disable.
  final ValueChanged<double>? onChanged;

  /// Called when the user begins dragging.
  final VoidCallback? onChangeStarted;

  /// Called when the user stops dragging.
  final VoidCallback? onChangeEnded;

  /// Where the slider scale begins. Defaults to `0`.
  final double start;

  /// Where the slider scale ends. Defaults to `1`.
  final double end;

  /// The minimum selectable value. Defaults to [start].
  ///
  /// When greater than [start], a dimmed track overlay and a tick mark are
  /// shown between [start] and this value to indicate the restricted zone.
  final double min;

  /// The maximum selectable value. Defaults to [end].
  ///
  /// When less than [end], a dimmed track overlay and a tick mark are shown
  /// between this value and [end] to indicate the restricted zone.
  final double max;

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  late double _value;

  bool get _disabled => widget.onChanged == null;

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(Slider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _value = widget.value.clamp(widget.min, widget.max);
      });
    }
  }

  void _updateFromDx(double dx, double trackWidth) {
    final usableWidth = trackWidth - _kThumbSize;
    if (usableWidth <= 0) return;
    final fraction = ((dx - _kThumbSize / 2) / usableWidth).clamp(0.0, 1.0);
    final rawValue = widget.start + fraction * (widget.end - widget.start);
    final newValue = rawValue.clamp(widget.min, widget.max);
    setState(() => _value = newValue);
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;
    final fraction = (_value - widget.start) / (widget.end - widget.start);
    final hasMinBound = widget.min != widget.start;
    final hasMaxBound = widget.max != widget.end;

    return MouseRegion(
      cursor: _disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.resizeLeftRight,
      child: AnimatedOpacity(
        duration: motion.micro.duration,
        curve: motion.micro.curve,
        opacity: _disabled ? 0.4 : 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth;
            final thumbLeft = fraction * (trackWidth - _kThumbSize);
            final fillWidth = thumbLeft + _kThumbSize / 2;

            double pixelForValue(double v) =>
                (v - widget.start) /
                    (widget.end - widget.start) *
                    (trackWidth - _kThumbSize) +
                _kThumbSize / 2;

            final minPixel = hasMinBound ? pixelForValue(widget.min) : null;
            final maxPixel = hasMaxBound ? pixelForValue(widget.max) : null;

            return GestureDetector(
              onHorizontalDragStart: _disabled
                  ? null
                  : (d) {
                      widget.onChangeStarted?.call();
                      _updateFromDx(d.localPosition.dx, trackWidth);
                    },
              onHorizontalDragUpdate: _disabled
                  ? null
                  : (d) => _updateFromDx(d.localPosition.dx, trackWidth),
              onHorizontalDragEnd: _disabled
                  ? null
                  : (_) => widget.onChangeEnded?.call(),
              onTapUp: _disabled
                  ? null
                  : (d) {
                      _updateFromDx(d.localPosition.dx, trackWidth);
                    },

              child: SizedBox(
                height: _kThumbSize + _kHitSlop * 2,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Track background
                    Positioned(
                      left: 0,
                      right: 0,
                      top: _kHitSlop + (_kThumbSize - _kTrackHeight) / 2,
                      height: _kTrackHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: Radii.pillAll,
                          color: cs.muted,
                        ),
                      ),
                    ),
                    // Track fill
                    Positioned(
                      left: 0,
                      width: fillWidth,
                      top: _kHitSlop + (_kThumbSize - _kTrackHeight) / 2,
                      height: _kTrackHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: Radii.pillAll,
                          color: cs.brand,
                        ),
                      ),
                    ),
                    // Restricted-zone overlays and boundary ticks
                    if (minPixel != null) ...[
                      Positioned(
                        left: 0,
                        width: minPixel,
                        top: _kHitSlop + (_kThumbSize - _kTrackHeight) / 2,
                        height: _kTrackHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: cs.subtle),
                        ),
                      ),
                      Positioned(
                        left: minPixel - _kTickWidth / 2,
                        top: _kHitSlop + (_kThumbSize - _kTickHeight) / 2,
                        width: _kTickWidth,
                        height: _kTickHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: Radii.pillAll,
                            color: cs.border,
                          ),
                        ),
                      ),
                    ],
                    if (maxPixel != null) ...[
                      Positioned(
                        left: maxPixel,
                        right: 0,
                        top: _kHitSlop + (_kThumbSize - _kTrackHeight) / 2,
                        height: _kTrackHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: cs.subtle),
                        ),
                      ),
                      Positioned(
                        left: maxPixel - _kTickWidth / 2,
                        top: _kHitSlop + (_kThumbSize - _kTickHeight) / 2,
                        width: _kTickWidth,
                        height: _kTickHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: Radii.pillAll,
                            color: cs.border,
                          ),
                        ),
                      ),
                    ],
                    // Thumb
                    Positioned(
                      left: thumbLeft,
                      top: _kHitSlop,
                      child: Container(
                        width: _kThumbSize,
                        height: _kThumbSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFFFFF),
                          boxShadow: context.shadows.sm,
                          border: Border.all(color: cs.border),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
