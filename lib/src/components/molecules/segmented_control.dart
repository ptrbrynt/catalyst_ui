import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// A single option in a [SegmentedControl].
@immutable
class SegmentedControlOption<T> {
  /// Creates a segmented control option.
  const SegmentedControlOption({required this.value, required this.label});

  /// The value associated with this option.
  final T value;

  /// The text label displayed for this option.
  final String label;
}

/// A horizontal group of mutually exclusive toggle buttons.
///
/// The selected option is highlighted with a surface-coloured pill against
/// a subtle track.
///
/// ```dart
/// SegmentedControl<String>(
///   value: _view,
///   options: const [
///     SegmentedControlOption(value: 'list', label: 'List'),
///     SegmentedControlOption(value: 'grid', label: 'Grid'),
///   ],
///   onChanged: (v) => setState(() => _view = v),
/// )
/// ```
class SegmentedControl<T> extends StatefulWidget {
  /// Creates a segmented control (40 px height, default).
  const SegmentedControl({
    required this.options,
    required this.onChanged,
    this.value,
    this.fullWidth = false,
    super.key,
  }) : size = 40;

  /// Creates a compact 32 px segmented control.
  const SegmentedControl.small({
    required this.options,
    required this.onChanged,
    this.value,
    this.fullWidth = false,
    super.key,
  }) : size = 32;

  /// Creates a large 48 px segmented control.
  const SegmentedControl.large({
    required this.options,
    required this.onChanged,
    this.value,
    this.fullWidth = false,
    super.key,
  }) : size = 48;

  /// The height of each segment in logical pixels.
  final double size;

  /// The currently selected value, or `null` for no selection.
  final T? value;

  /// The list of options to display.
  final List<SegmentedControlOption<T>> options;

  /// Called when the user selects a different option.
  final ValueChanged<T> onChanged;

  /// Segments expand to fill available width equally when `true`.
  final bool fullWidth;

  @override
  State<SegmentedControl<T>> createState() => _SegmentedControlState<T>();
}

class _SegmentedControlState<T> extends State<SegmentedControl<T>> {
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  void didUpdateWidget(SegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _selected = widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final cs = context.colorScheme;

    return AnimatedContainer(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      padding: const EdgeInsets.all(CatalystSpacing.s1),
      decoration: BoxDecoration(
        color: cs.subtle,
        border: Border.all(color: cs.border),
        borderRadius: CatalystRadius.mdAll,
      ),
      child: AnimatedSize(
        duration: motion.standard.duration,
        curve: motion.standard.curve,
        child: Row(
          mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
          spacing: 2,
          children: [
            for (final opt in widget.options)
              widget.fullWidth
                  ? Expanded(child: _buildOption(context, opt))
                  : _buildOption(context, opt),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    SegmentedControlOption<T> option,
  ) {
    final isSelected = option.value == _selected;
    final motion = context.motion;
    final cs = context.colorScheme;

    return AnimatedDefaultTextStyle(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 13,
        height: 1,
        color: isSelected ? cs.text : cs.textMuted,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            setState(() => _selected = option.value);
            widget.onChanged(option.value);
          },
          child: AnimatedContainer(
            alignment: Alignment.center,
            duration: motion.micro.duration,
            curve: motion.micro.curve,
            height: widget.size - 8,
            padding: const EdgeInsets.symmetric(
              horizontal: CatalystSpacing.s3,
            ),
            decoration: BoxDecoration(
              borderRadius: CatalystRadius.smAll,
              color: isSelected ? cs.surface : null,
            ),
            child: Text(option.label),
          ),
        ),
      ),
    );
  }
}
