import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';

/// A single destination entry in a [BottomNav] bar.
class BottomNavDestination<T> {
  /// Creates a bottom nav destination.
  const BottomNavDestination({
    required this.value,
    required this.label,
    required this.icon,
  });

  /// The value that identifies this destination.
  final T value;

  /// The short text label shown below the icon.
  final String label;

  /// The icon data displayed above the label.
  final IconData icon;
}

/// A bottom navigation bar for mobile screens.
///
/// Each [BottomNavDestination] is shown as an icon + label pair, spaced
/// evenly. The selected destination is highlighted with the brand colour.
class BottomNav<T> extends StatelessWidget {
  /// Creates a bottom nav bar.
  const BottomNav({
    required this.selectedItem,
    required this.onItemSelected,
    required this.destinations,
    super.key,
  });

  /// The value of the currently selected destination.
  final T selectedItem;

  /// Called when the user taps a destination.
  final ValueChanged<T> onItemSelected;

  /// The list of destinations.
  final List<BottomNavDestination<T>> destinations;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    return AnimatedContainer(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      height: 56 + MediaQuery.paddingOf(context).bottom,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.borderSubtle)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: CatalystSpacing.s2),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: destinations.map((d) => _buildDest(context, d)).toList(),
        ),
      ),
    );
  }

  Widget _buildDest(BuildContext context, BottomNavDestination<T> d) {
    final isSelected = selectedItem == d.value;
    final cs = context.colorScheme;
    final motion = context.motion;
    final itemColor = isSelected ? cs.brand : cs.textSubtle;

    return AnimatedDefaultTextStyle(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 11,
        height: 1,
        color: itemColor,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onItemSelected(d.value),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: CatalystSpacing.s2,
            ),
            child: Column(
              spacing: CatalystSpacing.s1,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(d.icon, size: 22, color: itemColor),
                Text(d.label, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
