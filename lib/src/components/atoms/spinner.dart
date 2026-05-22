import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';

/// An animated circular loading indicator.
///
/// The spinner continuously rotates a quarter-arc on a faded track ring.
/// When [color] is `null` it defaults to `context.colorScheme.brand`.
class Spinner extends StatefulWidget {
  /// Creates a spinner.
  const Spinner({this.size = 20, this.color, super.key});

  /// Creates a 16 px spinner.
  const Spinner.small({this.color, super.key}) : size = 16;

  /// Creates a 28 px spinner.
  const Spinner.large({this.color, super.key}) : size = 28;

  /// Creates a 36 px spinner.
  const Spinner.extraLarge({this.color, super.key}) : size = 36;

  /// The diameter of the spinner in logical pixels.
  final double size;

  /// The arc colour. Defaults to `colorScheme.brand` when `null`.
  final Color? color;

  @override
  State<Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? context.colorScheme.brand;
    final trackColor = effectiveColor.withValues(alpha: 0.18);

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => CustomPaint(
        size: Size.square(widget.size),
        painter: _SpinnerPainter(
          progress: _controller.value,
          color: effectiveColor,
          trackColor: trackColor,
          thickness: 3,
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.thickness,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      thickness / 2,
      thickness / 2,
      size.width - thickness,
      size.height - thickness,
    );
    canvas
      ..drawArc(
        rect,
        0,
        2 * math.pi,
        false,
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness,
      )
      ..drawArc(
        rect,
        progress * 2 * math.pi,
        math.pi / 2,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.square,
      );
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.thickness != thickness;
}
