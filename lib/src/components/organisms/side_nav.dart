import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../atoms/badge.dart';

/// Base class for items that can appear in a [SideNav].
sealed class SideNavItem<T> {}

/// A tappable navigation destination in a [SideNav].
@immutable
class SideNavDestination<T> extends SideNavItem<T> {
  /// Creates a side nav destination.
  SideNavDestination({
    required this.value,
    required this.icon,
    required this.label,
    this.badge,
  });

  /// The value identifying this destination.
  final T value;

  /// The icon shown in collapsed and expanded states.
  final Widget icon;

  /// The label shown when expanded.
  final Widget label;

  /// An optional [Badge] at the trailing edge (expanded only).
  final Badge? badge;
}

/// A non-interactive group heading between destinations.
@immutable
class SideNavGroupTitle<T> extends SideNavItem<T> {
  /// Creates a side nav group title.
  SideNavGroupTitle(this.title);

  /// The group label displayed above the section.
  final String title;
}

/// A collapsible vertical navigation rail for desktop/web layouts.
///
/// When [isExpanded] is `true` the nav shows icon + label (240 px wide).
/// When `false` it collapses to icon-only (64 px wide).
///
/// An optional [header] is pinned above the scrollable item list and an
/// optional [footer] is pinned below it, both visible regardless of scroll
/// position.
class SideNav<T> extends StatelessWidget {
  /// Creates a side nav.
  const SideNav({
    required this.selectedItem,
    required this.onItemSelected,
    required this.items,
    this.isExpanded = true,
    this.header,
    this.footer,
    super.key,
  });

  /// The currently selected destination value.
  final T selectedItem;

  /// Called when the user taps a destination.
  final ValueChanged<T> onItemSelected;

  /// The ordered list of destinations and group titles.
  final List<SideNavItem<T>> items;

  /// When `true`, renders icon + label (240 px). When `false`, icon-only.
  final bool isExpanded;

  /// An optional widget pinned above the scrollable item list.
  ///
  /// Useful for branding, logos, or a collapse toggle.
  final Widget? header;

  /// An optional widget pinned below the scrollable item list.
  ///
  /// Useful for account menus, settings shortcuts, or version info.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    return AnimatedContainer(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      width: isExpanded ? 240 : 64,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(right: BorderSide(color: cs.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?header,
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.s2,
                vertical: Spacing.s3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final item in items)
                    switch (item) {
                      SideNavGroupTitle<T>() => _buildGroupTitle(context, item),
                      SideNavDestination<T>() => _buildDestination(
                        context,
                        item,
                      ),
                    },
                ],
              ),
            ),
          ),
          ?footer,
        ],
      ),
    );
  }

  Widget _buildGroupTitle(BuildContext context, SideNavGroupTitle<T> title) {
    final motion = context.motion;
    return LayoutBuilder(
      builder: (_, constraints) {
        final show = isExpanded && constraints.maxWidth >= 180;
        return AnimatedContainer(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          padding:
              show
                  ? const EdgeInsets.only(
                    top: Spacing.s3,
                    left: 10,
                    right: 10,
                    bottom: 6,
                  )
                  : EdgeInsets.zero,
          child:
              show
                  ? Text(
                    title.title.toUpperCase(),
                    style: TextStyle(
                      fontFamily: context.typography.fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      color: context.colorScheme.textMuted,
                    ),
                  )
                  : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildDestination(
    BuildContext context,
    SideNavDestination<T> destination,
  ) {
    final isSelected = selectedItem == destination.value;
    final motion = context.motion;
    final cs = context.colorScheme;
    final itemColor = isSelected ? cs.brand : cs.text;

    return AnimatedDefaultTextStyle(
      key: ValueKey(destination),
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: itemColor,
      ),
      child: IconTheme(
        data: IconThemeData(color: itemColor, size: 18),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onItemSelected(destination.value),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: isExpanded ? 1.0 : 0.0,
                end: isExpanded ? 1.0 : 0.0,
              ),
              duration: motion.micro.duration,
              curve: motion.micro.curve,
              builder: (context, t, _) {
                return LayoutBuilder(
                  builder: (_, constraints) {
                    const vertPad = 9.0;
                    const iconSize = 18.0;
                    final hPad = 10.0 + (Spacing.s3 - 10.0) * t;
                    final contentWidth = constraints.maxWidth - hPad * 2;
                    // Shrinks to zero as the nav expands, centering
                    // the icon in the collapsed rail.
                    final centerOffset = ((contentWidth - iconSize) /
                            2 *
                            (1 - t))
                        .clamp(0.0, double.infinity);

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? cs.brand.withValues(alpha: 0.10)
                                : null,
                        borderRadius: Radii.mdAll,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: vertPad,
                          horizontal: hPad,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: centerOffset),
                            destination.icon,
                            Expanded(
                              child: Opacity(
                                opacity: t,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: Spacing.s3 * t,
                                  ),
                                  child: DefaultTextStyle.merge(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: destination.label,
                                        ),
                                        if (destination.badge != null)
                                          destination.badge!,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
