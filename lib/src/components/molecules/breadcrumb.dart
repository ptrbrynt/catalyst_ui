import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/extensions.dart';

/// A horizontal breadcrumb trail for communicating navigational hierarchy.
///
/// The last item in [items] is treated as the current (non-tappable) page.
/// All preceding items are tappable and call [onItemTapped] with their index.
///
/// ```dart
/// Breadcrumb(
///   items: const ['Home', 'Settings', 'Profile'],
///   onItemTapped: (i) => _navigateTo(i),
/// )
/// ```
class Breadcrumb extends StatefulWidget {
  /// Creates a breadcrumb.
  const Breadcrumb({
    required this.items,
    required this.onItemTapped,
    super.key,
  });

  /// Ordered labels from root to current page.
  final List<String> items;

  /// Called with the index of a tapped ancestor item.
  final void Function(int index) onItemTapped;

  @override
  State<Breadcrumb> createState() => _BreadcrumbState();
}

class _BreadcrumbState extends State<Breadcrumb> {
  int? _hovered;

  int get _currentIndex => widget.items.length - 1;

  @override
  Widget build(BuildContext context) {
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
      ),
      child: AnimatedSize(
        alignment: Alignment.centerLeft,
        duration: motion.micro.duration,
        curve: motion.micro.curve,
        child: Row(
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < widget.items.length; i++) ...[
              _buildItem(i, context, cs),
              if (i < widget.items.length - 1)
                Icon(
                  LucideIcons.chevronRight,
                  size: 14,
                  color: cs.textSubtle,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int i, BuildContext context, dynamic cs) {
    final isCurrent = i == _currentIndex;
    return MouseRegion(
      cursor: isCurrent ? MouseCursor.defer : SystemMouseCursors.click,
      onEnter: isCurrent ? null : (_) => setState(() => _hovered = i),
      onExit: isCurrent ? null : (_) => setState(() => _hovered = null),
      child: GestureDetector(
        onTap: isCurrent ? null : () => widget.onItemTapped(i),
        child: Text(
          widget.items[i],
          style: TextStyle(
            color: isCurrent
                ? context.colorScheme.text
                : _hovered == i
                ? context.colorScheme.brand
                : context.colorScheme.textMuted,
            fontWeight:
                isCurrent ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
