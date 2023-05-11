import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:catalyst_ui/components/widget/catalyst_widget.dart';

export 'badge_theme_data.dart';

/// {@template badge}
/// A widget that displays a badge.
/// {@endtemplate}
class Badge extends StyleableWidget {
  /// {@macro badge}
  const Badge({
    required this.child,
    super.styles = const [],
    super.key,
  });

  /// The widget to display inside the Badge
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme =
        CatalystTheme.of(context)?.data.badgeThemeData.forStyles(styles);

    final color =
        theme?.backgroundColor ?? BadgeThemeData.defaultBackgroundColor;
    final outlined = theme?.outlined ?? BadgeThemeData.defaultOutlined;
    return DefaultTextStyle(
      style: theme?.textStyle ?? BadgeThemeData.defaultTextStyle,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: theme?.borderRadius,
          border: Border.all(
            color: color.withOpacity(outlined ? 0.2 : 1),
          ),
        ),
        padding: theme?.padding ?? EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
          ],
        ),
      ),
    );
  }
}
