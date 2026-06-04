import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';

const double _kTrackHeight = 4;
const double _kThumbSize = 20;

/// A draggable horizontal slider for selecting a value within a range.
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
    this.min = 0,
    this.max = 1,
    super.key,
  }) : assert(min < max, 'min must be less than max');

  /// The current value, which must be within [[min], [max]].
  final double value;

  /// Called continuously as the user drags. Pass `null` to disable.
  final ValueChanged<double>? onChanged;

  /// The minimum selectable value. Defaults to `0`.
  final double min;

  /// The maximum selectable value. Defaults to `1`.
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
    final newValue = widget.min + fraction * (widget.max - widget.min);
    setState(() => _value = newValue);
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;
    final fraction = (_value - widget.min) / (widget.max - widget.min);

    return MouseRegion(
      cursor:
          _disabled
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

            return GestureDetector(
              onHorizontalDragStart:
                  _disabled
                      ? null
                      : (d) => _updateFromDx(d.localPosition.dx, trackWidth),
              onHorizontalDragUpdate:
                  _disabled
                      ? null
                      : (d) => _updateFromDx(d.localPosition.dx, trackWidth),
              onTapDown:
                  _disabled
                      ? null
                      : (d) => _updateFromDx(d.localPosition.dx, trackWidth),
              child: SizedBox(
                height: _kThumbSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Track background
                    Positioned(
                      left: 0,
                      right: 0,
                      top: (_kThumbSize - _kTrackHeight) / 2,
                      height: _kTrackHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: CatalystRadius.pillAll,
                          color: cs.muted,
                        ),
                      ),
                    ),
                    // Track fill
                    Positioned(
                      left: 0,
                      width: fillWidth,
                      top: (_kThumbSize - _kTrackHeight) / 2,
                      height: _kTrackHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: CatalystRadius.pillAll,
                          color: cs.brand,
                        ),
                      ),
                    ),
                    // Thumb
                    Positioned(
                      left: thumbLeft,
                      top: 0,
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
