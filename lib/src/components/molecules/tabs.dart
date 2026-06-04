import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';
import '../atoms/badge.dart';

/// A single option in a [Tabs] bar.
@immutable
class TabOption<T> {
  /// Creates a tab option.
  const TabOption({required this.value, required this.label, this.badge});

  /// The value associated with this tab.
  final T value;

  /// The text label shown on the tab.
  final String label;

  /// An optional count or status string shown as a small badge.
  final String? badge;
}

/// A horizontal tab bar that switches between named sections.
///
/// The active tab is underlined with the brand colour. Pair with a content
/// area below to show the corresponding view.
///
/// ```dart
/// Tabs<String>(
///   value: _selected,
///   options: const [
///     TabOption(value: 'all', label: 'All'),
///     TabOption(value: 'active', label: 'Active', badge: '3'),
///   ],
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class Tabs<T> extends StatefulWidget {
  /// Creates a tab bar.
  const Tabs({
    required this.options,
    required this.onChanged,
    this.value,
    super.key,
  });

  /// The currently selected tab value, or `null` for no selection.
  final T? value;

  /// The list of tab options.
  final List<TabOption<T>> options;

  /// Called when the user taps a different tab.
  final ValueChanged<T> onChanged;

  @override
  State<Tabs<T>> createState() => _TabsState<T>();
}

class _TabsState<T> extends State<Tabs<T>> {
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  void didUpdateWidget(Tabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() => _selected = widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: context.colorScheme.border),
        ),
      ),
      child: Row(
        spacing: Spacing.s6,
        children: [
          for (final opt in widget.options) _buildTab(context, opt),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, TabOption<T> option) {
    final isSelected = option.value == _selected;
    final motion = context.motion;
    final cs = context.colorScheme;

    return AnimatedDefaultTextStyle(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: isSelected ? cs.text : cs.textMuted,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            setState(() => _selected = option.value);
            widget.onChanged(option.value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Spacing.s3),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? cs.brand : const Color(0x00000000),
                  width: 2,
                ),
              ),
            ),
            child: SizedBox(
              height: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: Spacing.s2,
                children: [
                  Text(option.label),
                  if (option.badge != null)
                    Badge(
                      size: BadgeSize.small,
                      variant:
                          isSelected ? BadgeVariant.info : BadgeVariant.neutral,
                      child: Text(option.badge!),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
