import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: CatalystSpacing.s2),
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
                  child: leading ??
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
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    return Button.icon(
      icon: Icon(isIOS ? LucideIcons.chevronLeft : LucideIcons.arrowLeft),
      variant: ButtonVariant.ghost,
      onPressed: () => Navigator.pop(context),
      size: ButtonSize.medium,
    );
  }
}
