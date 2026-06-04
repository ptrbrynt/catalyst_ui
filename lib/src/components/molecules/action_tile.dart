import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/extensions.dart';
import '../../theme/theme_data.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../atoms/badge.dart';

/// A tappable tile with a circular icon, title, optional subtitle, and
/// optional badge.
///
/// Commonly used to represent a navigable action, appointment, or task.
///
/// ```dart
/// ActionTile(
///   icon: const Icon(LucideIcons.calendar),
///   iconBackgroundColor: Color(0xFFEEF2FF),
///   title: const Text('Book appointment'),
///   onTap: _handleTap,
/// )
/// ```
class ActionTile extends StatelessWidget {
  /// Creates an action tile.
  const ActionTile({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing = true,

    this.badge,
    super.key,
  });

  /// The icon inside the circular background.
  final Widget icon;

  /// The background colour of the circular icon container.
  final Color iconBackgroundColor;

  /// The primary label.
  final Widget title;

  /// An optional secondary line below [title].
  final Widget? subtitle;

  /// Whether to show a chevron arrow at the trailing edge.
  final bool trailing;

  /// An optional [Badge] shown next to [title].
  final Badge? badge;

  /// Called when the tile is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final cs = context.colorScheme;

    return AnimatedContainer(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      padding: const EdgeInsets.all(Spacing.s4),
      decoration: BoxDecoration(
        color: cs.subtle,
        border: Border.all(color: cs.border),
        borderRadius: Radii.xlAll,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            spacing: Spacing.s4,
            children: [
              _buildIcon(context),
              Expanded(child: _buildContent(context)),
              if (trailing)
                Icon(LucideIcons.chevronRight, size: 18, color: cs.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final motion = context.motion;
    return AnimatedContainer(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconBackgroundColor,
      ),
      alignment: Alignment.center,
      child: IconTheme(
        data: IconThemeData(
          color: ThemeData.textColorFor(iconBackgroundColor),
        ),
        child: icon,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: [
        Row(
          spacing: 8,
          children: [
            Flexible(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontFamily: typo.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 1.3,
                  color: cs.text,
                ),
                child: title,
              ),
            ),
            if (badge != null) badge!,
          ],
        ),
        if (subtitle != null)
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: typo.fontFamily,
              fontWeight: FontWeight.w400,
              fontSize: 13,
              height: 1.4,
              color: cs.textMuted,
            ),
            child: subtitle!,
          ),
      ],
    );
  }
}
