import 'package:flutter/widgets.dart';

/// A pair of [duration] and easing [curve] describing one animation preset.
typedef MotionSpec = ({Duration duration, Curve curve});

/// The set of animation presets used by Catalyst components.
///
/// Pass a custom [Motion] to [ThemeData] to change durations
/// and curves globally across the library.
///
/// ```dart
/// Motion(
///   micro: (duration: Duration(milliseconds: 80), curve: Curves.easeOut),
/// )
/// ```
class Motion {
  /// Creates a motion preset bundle.
  ///
  /// All parameters have sensible defaults; supply only the presets you want
  /// to override.
  const Motion({
    this.micro = (
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
    ),
    this.standard = (
      duration: const Duration(milliseconds: 200),
      curve: const Cubic(0.2, 0, 0, 1),
    ),
    this.enter = (
      duration: const Duration(milliseconds: 300),
      curve: const Cubic(0.2, 0, 0, 1),
    ),
    this.exit = (
      duration: const Duration(milliseconds: 200),
      curve: const Cubic(0.4, 0, 1, 1),
    ),
  });

  /// 120 ms ease-out — immediate micro-interactions (hover, press).
  final MotionSpec micro;

  /// 200 ms decelerate — state transitions within a view.
  final MotionSpec standard;

  /// 300 ms decelerate — elements entering the screen.
  final MotionSpec enter;

  /// 200 ms accelerate — elements leaving the screen.
  final MotionSpec exit;
}
