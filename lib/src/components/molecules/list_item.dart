import 'package:catalyst_ui/src/tokens/tokens.dart';
import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';

/// A single row in a list with optional leading icon, title, subtitle,
/// and trailing widget.
class ListItem extends StatefulWidget {
  /// Creates a list item.
  const ListItem({
    required this.title,
    this.divider = true,
    this.padding = const EdgeInsets.all(Spacing.s4),
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
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool get _interactive => widget.onTap != null;

  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    return AnimatedContainer(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      padding: widget.padding,
      decoration: BoxDecoration(
        border:
            widget.divider
                ? Border(bottom: BorderSide(color: cs.borderSubtle))
                : null,
      ),
      child: MouseRegion(
        cursor: _interactive ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter:
            _interactive
                ? (_) {
                  setState(() {
                    _hovered = true;
                  });
                }
                : null,
        onExit:
            _interactive
                ? (_) {
                  setState(() {
                    _pressed = false;
                    _hovered = false;
                  });
                }
                : null,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown:
              _interactive
                  ? (_) {
                    setState(() {
                      _pressed = true;
                    });
                  }
                  : null,
          onTapUp:
              _interactive
                  ? (_) {
                    setState(() {
                      _pressed = false;
                    });
                  }
                  : null,
          child: AnimatedContainer(
            duration: motion.micro.duration,
            curve: motion.micro.curve,
            decoration: BoxDecoration(
              borderRadius: Radii.smAll,
              color: _hovered ? context.colorScheme.muted : null,
            ),
            child: Row(
              spacing: Spacing.s3,
              children: [
                if (widget.leading != null)
                  IconTheme(
                    data: IconThemeData(color: cs.brand),
                    child: widget.leading!,
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
                          child: widget.title,
                        ),
                        if (widget.subtitle != null)
                          DefaultTextStyle(
                            style: TextStyle(
                              fontFamily: context.typography.fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              height: 1.4,
                              color: cs.textMuted,
                            ),
                            child: widget.subtitle!,
                          ),
                      ],
                    ),
                  ),
                ),
                if (widget.trailing != null)
                  IconTheme(
                    data: IconThemeData(color: cs.textMuted, size: 16),
                    child: widget.trailing!,
                  ),
              ],
            ),
          ).withBrightness(_pressed ? 0.92 : 1),
        ),
      ),
    );
  }
}
