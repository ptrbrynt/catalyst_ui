import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';

/// A centred illustration and message shown when a list or page has no data.
///
/// ```dart
/// EmptyState(
///   icon: LucideIcons.inbox,
///   title: const Text('Nothing here yet'),
///   description: const Text('Add your first item to get started.'),
///   action: Button(label: const Text('Add item'), ...),
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Creates a standard-sized empty state (64 px icon circle).
  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
    this.iconColor,
    this.iconBackgroundColor,
    super.key,
  }) : _iconSize = 64;

  /// Creates a large empty state (88 px icon circle).
  const EmptyState.large({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
    this.iconColor,
    this.iconBackgroundColor,
    super.key,
  }) : _iconSize = 88;

  /// The icon rendered inside the circular background.
  final IconData icon;

  /// Overrides the default brand-coloured icon colour.
  final Color? iconColor;

  /// Overrides the default tint background colour of the icon circle.
  final Color? iconBackgroundColor;

  /// The primary heading.
  final Widget title;

  /// Supporting description below the heading.
  final Widget description;

  /// An optional call-to-action widget.
  final Widget? action;

  final double _iconSize;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;

    return Padding(
      padding: const EdgeInsets.all(CatalystSpacing.s6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: CatalystSpacing.s3,
        children: [
          Container(
            width: _iconSize,
            height: _iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBackgroundColor ?? cs.tint,
            ),
            child: Center(
              child: Icon(
                icon,
                size: _iconSize / 2,
                color: iconColor ?? cs.brand,
              ),
            ),
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: typo.fontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 17,
              height: 1.3,
              color: cs.text,
            ),
            child: title,
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: typo.fontFamily,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 1.55,
              color: cs.textMuted,
            ),
            child: description,
          ),
          if (action != null) ...[
            const SizedBox(height: 6),
            action!,
          ],
        ],
      ),
    );
  }
}
