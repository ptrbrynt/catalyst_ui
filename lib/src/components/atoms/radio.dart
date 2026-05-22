import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';

/// Controls the size of a [CatalystRadio].
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
/// CatalystRadio(
///   value: selectedOption == 'a',
///   label: const Text('Option A'),
///   onSelected: (_) => setState(() => selectedOption = 'a'),
/// )
/// ```
class CatalystRadio extends StatelessWidget {
  /// Creates a radio button.
  const CatalystRadio({
    required this.value,
    this.label,
    this.size = RadioSize.medium,
    this.onSelected,
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
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
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
                ),
                if (label != null) label!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
