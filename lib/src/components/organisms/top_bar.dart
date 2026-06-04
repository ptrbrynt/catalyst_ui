import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// A single destination in a [TopBar].
class TopBarDestination<T> {
  /// Creates a top bar destination.
  const TopBarDestination({required this.value, required this.label});

  /// The value that identifies this destination.
  final T value;

  /// The text label displayed in the bar.
  final String label;
}

/// A horizontal top navigation bar for desktop/web layouts.
///
/// Renders a 60 px bar with an optional [leading] area (e.g. a logo), a set
/// of [destinations], and trailing [actions].
class TopBar<T> extends StatelessWidget {
  /// Creates a top bar.
  const TopBar({
    required this.destinations,
    required this.selectedItem,
    required this.onItemSelected,
    this.leading,
    this.actions = const [],
    super.key,
  });

  /// An optional widget on the far left.
  final Widget? leading;

  /// The list of navigation destinations.
  final List<TopBarDestination<T>> destinations;

  /// Optional action widgets on the far right.
  final List<Widget> actions;

  /// The currently selected destination value.
  final T selectedItem;

  /// Called when the user taps a destination.
  final ValueChanged<T> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    return IconTheme(
      data: IconThemeData(color: cs.text),
      child: AnimatedContainer(
        duration: motion.micro.duration,
        curve: motion.micro.curve,
        height: 60 + MediaQuery.paddingOf(context).top,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.s6),
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(bottom: BorderSide(color: cs.border)),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            spacing: 32,
            children: [
              if (leading != null) leading!,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: Spacing.s4),
                  child: Row(
                    spacing: 4,
                    children:
                        destinations
                            .map((d) => _buildDest(context, d))
                            .toList(),
                  ),
                ),
              ),
              Row(
                spacing: Spacing.s3,
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDest(BuildContext context, TopBarDestination<T> d) {
    final isSelected = selectedItem == d.value;
    final cs = context.colorScheme;
    final motion = context.motion;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onItemSelected(d.value),
        child: AnimatedContainer(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.s2,
            horizontal: Spacing.s3,
          ),
          decoration: BoxDecoration(
            borderRadius: Radii.smAll,
            color: isSelected ? cs.brand.withValues(alpha: 0.10) : null,
          ),
          child: Text(
            d.label,
            style: TextStyle(
              fontFamily: context.typography.fontFamily,
              fontWeight: FontWeight.w500,
              color: isSelected ? cs.brand : cs.text,
            ),
          ),
        ),
      ),
    );
  }
}
