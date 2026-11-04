import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';
import '../molecules/menu_button.dart';
import '../molecules/tooltip.dart';

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
      height: 64 + MediaQuery.paddingOf(context).bottom,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.borderSubtle)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Spacing.s2),
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

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
      child: AnimatedDefaultTextStyle(
        duration: motion.micro.duration,
        curve: motion.micro.curve,
        style: TextStyle(
          fontFamily: context.typography.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: itemColor,
        ),
        child: GestureDetector(
          onTap: () => onItemSelected(d.value),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: Spacing.s2,
              ),
              child: Column(
                spacing: Spacing.s1,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(d.icon, size: 22, color: itemColor),
                  Text(d.label, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A tab bar that runs down the side of the screen, for devices that place
/// bars vertically.
///
/// Each destination is shown as a symbol, with its label used for
/// accessibility and tooltips. When [minimized] is true (task-focused screens
/// that need the room for their toolbar), only the selected destination is
/// shown, and tapping it opens a menu of all destinations.
class VerticalTabBar<T> extends StatelessWidget {
  /// Creates a vertical tab bar.
  const VerticalTabBar({
    required this.selectedItem,
    required this.onItemSelected,
    required this.destinations,
    this.minimized = false,
    super.key,
  });

  /// The width of each destination.
  static const double itemExtent = 44;

  /// The value of the currently selected destination.
  final T selectedItem;

  /// Called when the user taps a destination.
  final ValueChanged<T> onItemSelected;

  /// The list of destinations.
  final List<BottomNavDestination<T>> destinations;

  /// Whether to show only the selected destination.
  final bool minimized;

  /// The height the bar needs.
  static double extentFor(int destinations, {bool minimized = false}) =>
      (minimized ? 1 : destinations) * itemExtent + Spacing.s1 * 2;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final selected = destinations
        .where((d) => d.value == selectedItem)
        .firstOrNull;

    final Widget content;
    if (minimized && selected != null) {
      content = MenuButton(
        items: [
          for (final d in destinations)
            MenuOption(
              label: d.label,
              icon: d.icon,
              selected: d.value == selectedItem,
              onTap: () => onItemSelected(d.value),
            ),
        ],
        build: (context, open) => _dest(context, selected, open),
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final d in destinations)
            _dest(context, d, () => onItemSelected(d.value)),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(Spacing.s1),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(itemExtent),
        border: Border.all(color: cs.borderSubtle),
        boxShadow: context.shadows.md,
      ),
      child: content,
    );
  }

  Widget _dest(
    BuildContext context,
    BottomNavDestination<T> d,
    VoidCallback onTap,
  ) {
    final cs = context.colorScheme;
    final isSelected = d.value == selectedItem;
    return Tooltip(
      content: d.label,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: d.label,
        excludeSemantics: true,
        child: GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: context.motion.micro.duration,
              curve: context.motion.micro.curve,
              width: itemExtent,
              height: itemExtent,
              decoration: BoxDecoration(
                color: isSelected ? cs.subtle : null,
                shape: BoxShape.circle,
              ),
              child: Icon(
                d.icon,
                size: 22,
                color: isSelected ? cs.brand : cs.textSubtle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
