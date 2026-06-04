import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

// ── Tone system ──────────────────────────────────────────────────────────────

/// The resolved visual properties for a single [ProgressBarTone].
@immutable
class ProgressBarToneStyle {
  /// Creates a progress bar tone style.
  const ProgressBarToneStyle({required this.fillColor});

  /// The colour of the filled portion of the bar.
  final Color fillColor;
}

/// Defines the fill colour of a [ProgressBar].
///
/// Extend this class to create your own tones:
///
/// ```dart
/// class SpeedTone extends ProgressBarTone {
///   const SpeedTone();
///
///   @override
///   ProgressBarToneStyle resolve(ColorScheme cs) =>
///       ProgressBarToneStyle(fillColor: cs.brand);
/// }
/// ```
@immutable
abstract class ProgressBarTone {
  /// Const constructor for subclasses.
  const ProgressBarTone();

  /// Brand colour fill (default).
  static const ProgressBarTone brand = _BrandProgressBarTone();

  /// Green fill — healthy or successful progress.
  static const ProgressBarTone success = _SuccessProgressBarTone();

  /// Amber fill — cautionary progress.
  static const ProgressBarTone warning = _WarningProgressBarTone();

  /// Red fill — critical or error progress.
  static const ProgressBarTone danger = _DangerProgressBarTone();

  /// Resolves the visual style for this tone against [cs].
  ProgressBarToneStyle resolve(ColorScheme cs);
}

class _BrandProgressBarTone extends ProgressBarTone {
  const _BrandProgressBarTone();

  @override
  ProgressBarToneStyle resolve(ColorScheme cs) =>
      ProgressBarToneStyle(fillColor: cs.brand);
}

class _SuccessProgressBarTone extends ProgressBarTone {
  const _SuccessProgressBarTone();

  @override
  ProgressBarToneStyle resolve(ColorScheme cs) =>
      ProgressBarToneStyle(fillColor: cs.success);
}

class _WarningProgressBarTone extends ProgressBarTone {
  const _WarningProgressBarTone();

  @override
  ProgressBarToneStyle resolve(ColorScheme cs) =>
      ProgressBarToneStyle(fillColor: cs.warning);
}

class _DangerProgressBarTone extends ProgressBarTone {
  const _DangerProgressBarTone();

  @override
  ProgressBarToneStyle resolve(ColorScheme cs) =>
      ProgressBarToneStyle(fillColor: cs.danger);
}

// ── Size ─────────────────────────────────────────────────────────────────────

/// Controls the height of a [ProgressBar].
enum ProgressBarSize {
  /// 4 px tall.
  small(CatalystSpacing.s1),

  /// 8 px tall (default).
  medium(CatalystSpacing.s2),

  /// 12 px tall.
  large(CatalystSpacing.s3);

  const ProgressBarSize(this.height);

  /// The height in logical pixels.
  final double height;
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// An animated horizontal progress bar.
///
/// Progress is expressed as [value] out of [max]. The fill animates smoothly
/// on value changes.
///
/// ```dart
/// ProgressBar(
///   value: 0.6,
///   tone: ProgressBarTone.success,
///   title: const Text('Uploading…'),
///   valueLabel: const Text('60%'),
/// )
/// ```
class ProgressBar extends StatefulWidget {
  /// Creates a progress bar.
  const ProgressBar({
    required this.value,
    super.key,
    this.max = 1,
    this.tone = ProgressBarTone.brand,
    this.size = ProgressBarSize.medium,
    this.title,
    this.valueLabel,
  });

  /// The current progress value.
  final double value;

  /// The maximum value. Defaults to `1.0`.
  final double max;

  /// The colour tone.
  final ProgressBarTone tone;

  /// The height variant.
  final ProgressBarSize size;

  /// An optional label above the bar on the left.
  final Widget? title;

  /// An optional label above the bar on the right.
  final Widget? valueLabel;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _animate());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value || oldWidget.max != widget.max) {
      _animate();
    }
  }

  void _animate() {
    unawaited(
      _controller.animateTo(
        (widget.value / widget.max).clamp(0, 1),
        duration: context.motion.standard.duration,
        curve: context.motion.standard.curve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = widget.tone.resolve(context.colorScheme).fillColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null || widget.valueLabel != null) ...[
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: context.typography.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: context.colorScheme.textMuted,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.title ?? const SizedBox.shrink(),
                widget.valueLabel ?? const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: widget.size.height,
          decoration: BoxDecoration(
            borderRadius: CatalystRadius.pillAll,
            color: context.colorScheme.muted,
          ),
          child: LayoutBuilder(
            builder:
                (ctx, constraints) => AnimatedBuilder(
                  animation: _controller,
                  builder:
                      (_, _) => Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: widget.size.height,
                          width: constraints.maxWidth * _controller.value,
                          decoration: BoxDecoration(
                            borderRadius: CatalystRadius.pillAll,
                            color: fillColor,
                          ),
                        ),
                      ),
                ),
          ),
        ),
      ],
    );
  }
}
