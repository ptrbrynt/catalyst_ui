import 'package:catalyst_ui/src/theme/color_scheme.dart';
import 'package:catalyst_ui/src/theme/motion.dart';
import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';

/// Controls the size of a [Radio].
enum RadioSize {
  /// 16 × 16 px.
  small(16),

  /// 20 × 20 px (default).
  medium(20),

  /// 24 × 24 px.
  large(24);

  const RadioSize(this.dimension);

  /// The diameter of the radio control in logical pixels.
  final double dimension;
}

/// A single radio button control with an optional text label.
///
/// Pass `null` for [onSelected] to render the button as disabled.
///
/// ```dart
/// Radio(
///   value: selectedOption == 'a',
///   label: const Text('Option A'),
///   onSelected: (_) => setState(() => selectedOption = 'a'),
/// )
/// ```
class Radio extends StatelessWidget {
  /// Creates a radio button.
  const Radio({
    required this.value,
    this.label,
    this.size = RadioSize.medium,
    this.onSelected,
    this.trailingRadio = false,
    super.key,
  });

  /// Whether this radio button is currently selected.
  final bool value;

  /// Called when the user selects this radio button.
  final ValueChanged<bool>? onSelected;

  /// An optional label rendered to the right of the control.
  final Widget? label;

  /// The size variant.
  final RadioSize size;

  /// If `true`, the radio icon will appear at the end of the widget.
  final bool trailingRadio;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final cs = context.colorScheme;

    return AnimatedDefaultTextStyle(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.2,
        color: cs.text,
      ),
      child: MouseRegion(
        cursor: onSelected != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        child: GestureDetector(
          onTap: () => onSelected?.call(true),
          child: AnimatedOpacity(
            duration: motion.micro.duration,
            curve: motion.micro.curve,
            opacity: onSelected == null ? 0.5 : 1,
            child: Row(
              crossAxisAlignment: .start,
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!trailingRadio) _radio(motion, cs),
                if (label != null) Expanded(child: label!),
                if (trailingRadio) _radio(motion, cs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _radio(Motion motion, ColorScheme cs) {
    return RadioIndicator(size: size, value: value);
  }
}

/// An indicator used in [Radio] to show whether it is selected or not.
class RadioIndicator extends StatelessWidget {
  /// Creates a [RadioIndicator]
  const RadioIndicator({
    required this.value,
    super.key,
    this.size = .medium,
  });

  /// The [RadioSize] of this indicator
  final RadioSize size;

  /// Whether the option is selected
  final bool value;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final cs = context.colorScheme;
    return AnimatedContainer(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      width: size.dimension,
      height: size.dimension,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: cs.surface,
        border: Border.all(
          width: 2,
          color: value ? cs.brand : cs.border,
        ),
      ),
      child: value
          ? Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.brand,
              ),
            )
          : null,
    );
  }
}
