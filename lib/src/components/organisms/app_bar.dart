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

    return AnimatedDefaultTextStyle(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: cs.text,
      ),
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
            child: Row(
              spacing: 4,
              children: [
                SizedBox.square(
                  dimension: 44,
                  child:
                      leading ??
                      (automaticallyImplyLeading
                          ? _backButton(context)
                          : const SizedBox.shrink()),
                ),
                Expanded(
                  child: Center(
                    child: title ?? const SizedBox.shrink(),
                  ),
                ),
                SizedBox.square(dimension: 44, child: trailing),
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
      variant: ButtonVariant.ghost,
      onPressed: () => Navigator.pop(context),
      size: ButtonSize.medium,
    );
  }
}
