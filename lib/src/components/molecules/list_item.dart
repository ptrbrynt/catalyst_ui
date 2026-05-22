import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';

/// A single row in a list with optional leading icon, title, subtitle,
/// and trailing widget.
class ListItem extends StatelessWidget {
  /// Creates a list item.
  const ListItem({
    required this.title,
    this.divider = true,
    this.padding = const EdgeInsets.all(CatalystSpacing.s4),
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  /// An optional widget at the start of the row, typically an icon.
  final Widget? leading;

  /// The primary label.
  final Widget title;

  /// An optional secondary line below [title].
  final Widget? subtitle;

  /// An optional widget at the end of the row.
  final Widget? trailing;

  /// Called when the item is tapped.
  final VoidCallback? onTap;

  /// Whether to render a bottom border below the item.
  final bool divider;

  /// Inner padding applied to the row.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    return AnimatedContainer(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      padding: padding,
      decoration: BoxDecoration(
        border: divider
            ? Border(bottom: BorderSide(color: cs.borderSubtle))
            : null,
      ),
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            spacing: CatalystSpacing.s3,
            children: [
              if (leading != null)
                IconTheme(
                  data: IconThemeData(color: cs.brand),
                  child: leading!,
                ),
              Expanded(
                child: AnimatedSize(
                  duration: motion.standard.duration,
                  curve: motion.standard.curve,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 2,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          fontFamily: context.typography.fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.3,
                          color: cs.text,
                        ),
                        child: title,
                      ),
                      if (subtitle != null)
                        DefaultTextStyle(
                          style: TextStyle(
                            fontFamily: context.typography.fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            height: 1.4,
                            color: cs.textMuted,
                          ),
                          child: subtitle!,
                        ),
                    ],
                  ),
                ),
              ),
              if (trailing != null)
                IconTheme(
                  data: IconThemeData(color: cs.textMuted, size: 16),
                  child: trailing!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
