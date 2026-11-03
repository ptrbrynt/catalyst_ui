import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

/// Defines the color scheme for an [AppBarAction]
enum ActionTone {
  /// Brand-color
  primary,

  /// Success color
  success,

  /// Danger color
  danger,

  /// Neutral foreground color
  neutral,
}

/// Defines an action in an [AppBar]
sealed class AppBarAction extends StatelessWidget {
  const AppBarAction({super.key});

  /// Builds the action widget
  @override
  Widget build(BuildContext context);
}

/// Defines a button in an [AppBar]
class AppBarButton extends AppBarAction {
  /// Creates an [AppBarButton]
  const AppBarButton({
    required this.icon,
    required this.semanticsLabel,
    required this.onTap,
    super.key,
    this.tone = .neutral,
  });

  /// The icon to display in the app bar
  final IconData icon;

  /// A semantics label and tooltip text
  final String semanticsLabel;

  /// Called when the user taps this action
  final VoidCallback onTap;

  /// Defines the color scheme for this action
  final ActionTone tone;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      content: semanticsLabel,
      child: Semantics(
        label: semanticsLabel,
        child: GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SizedBox.square(
              dimension: 44,
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: switch (tone) {
                    .danger => context.colorScheme.danger,
                    .neutral => context.colorScheme.text,
                    .primary => context.colorScheme.brand,
                    .success => context.colorScheme.success,
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A top application bar for mobile screens.
///
/// When [automaticallyImplyLeading] is `true` and the current route can be
/// popped, a back button is shown automatically. On iOS the back button uses
/// a chevron; on other platforms it uses an arrow.
///
/// When bars are vertical (inside a [VerticalBarPage]), the back button and
/// [items] with a symbol move into the vertical bar column; the [title] and
/// any [actions] widgets stay in a horizontal bar.
class AppBar extends StatelessWidget {
  /// Creates an app bar.
  const AppBar({
    this.backIcon,
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.actions = const [],
    this.items = const [],
    this.overflow = const [],
    this.compression = BarCompression.navigation,
  });

  /// An optional centred widget, typically a [Text] title.
  final Widget? title;

  /// Whether to auto-show a back button when the route can pop.
  final bool automaticallyImplyLeading;

  /// Overrides the auto-generated leading widget.
  final Widget? leading;

  /// Optional list of [Widget]s to show on the trailing end of this
  /// app bar. Typically [AppBarAction]s or [MenuButton]s.
  final List<Widget> actions;

  /// Toolbar items. Items with [BarItemRole.navigation] act as the leading
  /// widget when [leading] is null; the rest follow [actions].
  final List<BarItem> items;

  /// Extra entries for the bar's single overflow menu.
  final List<MenuItem> overflow;

  /// How the bars give way when a vertical bar runs out of room.
  final BarCompression compression;

  /// Icon to display on the default back button. If `null`, defaults to the
  /// `backIcon` supplied in `ThemeData.iconography`.
  final IconData? backIcon;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    final vertical = VerticalBarPage.columnOf(context) != null;
    final navigation = items.where((i) => i.role == BarItemRole.navigation);
    final implied = navigation.isEmpty && automaticallyImplyLeading
        ? _impliedBack(context)
        : null;
    final barItems = [?implied, ...items];
    final hasBarActions = barItems.isNotEmpty || overflow.isNotEmpty;

    final Widget? resolvedLeading;
    if (leading != null) {
      resolvedLeading = leading;
    } else if (vertical) {
      resolvedLeading = null;
    } else if (navigation.isNotEmpty) {
      resolvedLeading = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in navigation)
            item.horizontal ?? _navigationButton(context, item),
        ],
      );
    } else if (implied != null) {
      resolvedLeading = _navigationButton(context, implied);
    } else {
      resolvedLeading = null;
    }

    return AnimatedDefaultTextStyle(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      style: context.typography.h3,
      child: IconTheme(
        data: IconThemeData(color: cs.text),
        child: AnimatedContainer(
          duration: motion.standard.duration,
          curve: motion.standard.curve,
          height: 56 + MediaQuery.paddingOf(context).top,
          padding: const EdgeInsets.symmetric(horizontal: Spacing.s2),
          decoration: BoxDecoration(
            color: cs.surface,
            border: Border(bottom: BorderSide(color: cs.borderSubtle)),
          ),
          child: SafeArea(
            bottom: false,
            child: AvoidOcclusions(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Keeps the actions trailing when there's no leading
                      // widget, such as in the detail pane of a split view.
                      resolvedLeading ?? const SizedBox.shrink(),
                      Row(
                        children: [
                          ...actions,
                          if (hasBarActions)
                            BarActions(
                              items: barItems,
                              overflow: overflow,
                              compression: compression,
                            ),
                        ],
                      ),
                    ],
                  ),
                  ?title,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarItem? _impliedBack(BuildContext context) {
    if (!(ModalRoute.canPopOf(context) ?? false)) return null;
    return BarItem(
      title: 'Back',
      icon: backIcon ?? context.iconography.backIcon,
      role: BarItemRole.navigation,
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _navigationButton(BuildContext context, BarItem item) {
    return AppBarButton(
      icon: item.icon ?? context.iconography.backIcon,
      semanticsLabel: item.title,
      onTap: item.onPressed ?? () {},
    );
  }
}
