import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';

// ── Tone system ──────────────────────────────────────────────────────────────

/// The resolved visual properties for a single [StatusTone].
@immutable
class StatusToneStyle {
  /// Creates a status tone style.
  const StatusToneStyle({required this.color});

  /// The dot colour.
  final Color color;
}

/// Defines the colour of a [StatusDot].
///
/// Extend this class to create your own tones:
///
/// ```dart
/// class LiveTone extends StatusTone {
///   const LiveTone();
///
///   @override
///   StatusToneStyle resolve(ColorScheme cs) =>
///       StatusToneStyle(color: const Color(0xFFFF0000));
/// }
/// ```
///
/// For a one-off colour, use [StatusTone.custom]:
///
/// ```dart
/// StatusDot(tone: StatusTone.custom(const Color(0xFF9333EA)))
/// ```
@immutable
abstract class StatusTone {
  /// Const constructor for subclasses.
  const StatusTone();

  /// Green — healthy or successful.
  static const StatusTone success = _SuccessStatusTone();

  /// Amber — cautionary or pending.
  static const StatusTone warning = _WarningStatusTone();

  /// Red — error or critical.
  static const StatusTone danger = _DangerStatusTone();

  /// Blue (brand) — informational.
  static const StatusTone info = _InfoStatusTone();

  /// Grey — inactive or unknown.
  static const StatusTone neutral = _NeutralStatusTone();

  /// Creates a tone with an explicit [color].
  static StatusTone custom(Color color) => _CustomStatusTone(color);

  /// Resolves the visual style for this tone against [cs].
  StatusToneStyle resolve(ColorScheme cs);
}

class _SuccessStatusTone extends StatusTone {
  const _SuccessStatusTone();

  @override
  StatusToneStyle resolve(ColorScheme cs) =>
      StatusToneStyle(color: cs.success);
}

class _WarningStatusTone extends StatusTone {
  const _WarningStatusTone();

  @override
  StatusToneStyle resolve(ColorScheme cs) =>
      StatusToneStyle(color: cs.warning);
}

class _DangerStatusTone extends StatusTone {
  const _DangerStatusTone();

  @override
  StatusToneStyle resolve(ColorScheme cs) =>
      StatusToneStyle(color: cs.danger);
}

class _InfoStatusTone extends StatusTone {
  const _InfoStatusTone();

  @override
  StatusToneStyle resolve(ColorScheme cs) =>
      StatusToneStyle(color: cs.info);
}

class _NeutralStatusTone extends StatusTone {
  const _NeutralStatusTone();

  @override
  StatusToneStyle resolve(ColorScheme cs) =>
      StatusToneStyle(color: cs.textSubtle);
}

class _CustomStatusTone extends StatusTone {
  const _CustomStatusTone(this._color);
  final Color _color;

  @override
  StatusToneStyle resolve(ColorScheme cs) =>
      StatusToneStyle(color: _color);
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// A small coloured dot used to communicate status at a glance.
///
/// Set [pulse] to `true` to animate a repeating radial ripple for live/active
/// states.
///
/// ```dart
/// StatusDot(tone: StatusTone.success, pulse: true)
/// StatusDot(tone: StatusTone.custom(Color(0xFF9333EA)))
/// ```
class StatusDot extends StatefulWidget {
  /// Creates a status dot.
  const StatusDot({required this.tone, this.pulse = false, super.key});

  /// The colour tone.
  final StatusTone tone;

  /// Whether to animate a repeating ripple effect.
  final bool pulse;

  @override
  State<StatusDot> createState() => _StatusDotState();
}

class _StatusDotState extends State<StatusDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _scale = Tween<double>(begin: 1, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.5, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.pulse) unawaited(_controller.repeat());
  }

  @override
  void didUpdateWidget(StatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !_controller.isAnimating) {
      unawaited(_controller.repeat());
    } else if (!widget.pulse && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.tone.resolve(context.colorScheme).color;

    final dot = SizedBox.square(
      dimension: 8,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );

    if (!widget.pulse) return dot;

    return SizedBox(
      width: 8,
      height: 8,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) => Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: _scale.value,
              child: SizedBox.square(
                dimension: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: _opacity.value),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            child!,
          ],
        ),
        child: dot,
      ),
    );
  }
}
