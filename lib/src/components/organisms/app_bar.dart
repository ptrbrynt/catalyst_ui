import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';
import '../atoms/button.dart';

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
    this.trailing,
  });

  /// An optional centred widget, typically a [Text] title.
  final Widget? title;

  /// Whether to auto-show a back button when the route can pop.
  final bool automaticallyImplyLeading;

  /// Overrides the auto-generated leading widget.
  final Widget? leading;

  /// An optional trailing action widget.
  final Widget? trailing;

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
      style: context.typography.h2,
      child: IconTheme(
        data: IconThemeData(color: cs.text),
        child: AnimatedContainer(
          duration: motion.standard.duration,
          curve: motion.standard.curve,
          height: 72 + MediaQuery.paddingOf(context).top,
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
                    ?trailing,
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
    return Button.icon(
      icon: Icon(backIcon ?? context.iconography.backIcon),
      semanticsLabel: 'Back',
      variant: ButtonVariant.ghost,
      onPressed: () => Navigator.pop(context),
      size: ButtonSize.medium,
    );
  }
}
