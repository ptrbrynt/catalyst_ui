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
class AppBar extends StatelessWidget {
  /// Creates an app bar.
  const AppBar({
    this.backIcon,
    super.key,
    this.title,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.actions = const [],
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

  /// Icon to display on the default back button. If `null`, defaults to the
  /// `backIcon` supplied in `ThemeData.iconography`.
  final IconData? backIcon;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    final resolvedLeading =
        leading ?? (automaticallyImplyLeading ? _backButton(context) : null);

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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ?resolvedLeading,
                    Row(
                      children: actions,
                    ),
                  ],
                ),
                ?title,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    if (!(ModalRoute.canPopOf(context) ?? false)) {
      return const SizedBox.shrink();
    }
    return AppBarButton(
      icon: backIcon ?? context.iconography.backIcon,
      semanticsLabel: 'Back',
      onTap: () => Navigator.pop(context),
    );
  }
}
