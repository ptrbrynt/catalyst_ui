import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';

/// Controls the size of a [CatalystCheckbox].
enum CheckboxSize {
  /// 16 × 16 px.
  small(16),

  /// 20 × 20 px (default).
  medium(20),

  /// 24 × 24 px.
  large(24);

  const CheckboxSize(this.dimension);

  /// The width and height of the checkbox in logical pixels.
  final double dimension;
}

/// A toggleable checkbox control with an optional text label.
///
/// Pass `null` for [onChanged] to render the checkbox as disabled.
///
/// ```dart
/// CatalystCheckbox(
///   value: _checked,
///   onChanged: (v) => setState(() => _checked = v ?? false),
///   label: const Text('Accept terms'),
/// )
/// ```
class CatalystCheckbox extends StatelessWidget {
  /// Creates a checkbox.
  const CatalystCheckbox({
    required this.value,
    required this.onChanged,
    this.size = CheckboxSize.medium,
    this.label,
    super.key,
  });

  /// Whether the checkbox is currently checked.
  final bool value;

  /// Called when the user taps. Pass `null` to disable.
  final ValueChanged<bool?>? onChanged;

  /// An optional label rendered to the right of the checkbox.
  final Widget? label;

  /// The size variant.
  final CheckboxSize size;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final cs = context.colorScheme;

    return MouseRegion(
      cursor: onChanged != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      child: GestureDetector(
        onTap: () => onChanged?.call(!value),
        child: AnimatedDefaultTextStyle(
          style: TextStyle(
            fontFamily: context.typography.fontFamily,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            height: 1.2,
            color: cs.text,
          ),
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          child: IconTheme(
            data: const IconThemeData(color: Color(0xFFFFFFFF)),
            child: AnimatedOpacity(
              duration: motion.micro.duration,
              curve: motion.micro.curve,
              opacity: onChanged != null ? 1 : 0.5,
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
                      color: value ? cs.brand : cs.surface,
                      borderRadius: CatalystRadius.smAll,
                      border: value
                          ? null
                          : Border.all(width: 1.5, color: cs.border),
                    ),
                    child: value
                        ? Icon(LucideIcons.check, size: size.dimension - 6)
                        : null,
                  ),
                  if (label != null) label!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
