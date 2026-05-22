import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

// ── Tone system ──────────────────────────────────────────────────────────────

/// The resolved visual properties for a single [SnackbarTone].
@immutable
class SnackbarToneStyle {
  /// Creates a snackbar tone style.
  const SnackbarToneStyle({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  /// The snackbar background colour.
  final Color backgroundColor;

  /// The text and icon colour.
  final Color foregroundColor;
}

/// Defines the background and foreground colours of a [CatalystSnackbar].
///
/// Extend this class to create your own tones:
///
/// ```dart
/// class BrandSnackbarTone extends SnackbarTone {
///   const BrandSnackbarTone();
///
///   @override
///   SnackbarToneStyle resolve(CatalystColorScheme cs) => SnackbarToneStyle(
///     backgroundColor: cs.brand,
///     foregroundColor: cs.onBrand,
///   );
/// }
/// ```
@immutable
abstract class SnackbarTone {
  /// Const constructor for subclasses.
  const SnackbarTone();

  /// Dark/inverse background (default).
  static const SnackbarTone dark = _DarkSnackbarTone();

  /// Green background for success feedback.
  static const SnackbarTone success = _SuccessSnackbarTone();

  /// Red background for error feedback.
  static const SnackbarTone danger = _DangerSnackbarTone();

  /// Resolves the visual style for this tone against [cs].
  SnackbarToneStyle resolve(CatalystColorScheme cs);
}

class _DarkSnackbarTone extends SnackbarTone {
  const _DarkSnackbarTone();

  @override
  SnackbarToneStyle resolve(CatalystColorScheme cs) => SnackbarToneStyle(
    backgroundColor: cs.inverse,
    foregroundColor: cs.onInverse,
  );
}

class _SuccessSnackbarTone extends SnackbarTone {
  const _SuccessSnackbarTone();

  @override
  SnackbarToneStyle resolve(CatalystColorScheme cs) => SnackbarToneStyle(
    backgroundColor: cs.success,
    foregroundColor: cs.onSuccess,
  );
}

class _DangerSnackbarTone extends SnackbarTone {
  const _DangerSnackbarTone();

  @override
  SnackbarToneStyle resolve(CatalystColorScheme cs) => SnackbarToneStyle(
    backgroundColor: cs.danger,
    foregroundColor: cs.onDanger,
  );
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// An optional call-to-action embedded in a [CatalystSnackbar].
@immutable
class SnackbarAction {
  /// Creates a snackbar action.
  const SnackbarAction({required this.label, required this.onPressed});

  /// The text label.
  final String label;

  /// Called when the action is tapped.
  final VoidCallback onPressed;
}

/// A brief overlay notification typically shown at the bottom of the screen.
///
/// Display via [CatalystSnackbarHandler] or the `context.showSnackbar`
/// extension rather than placing directly in the widget tree.
class CatalystSnackbar extends StatelessWidget {
  /// Creates a snackbar. [tone] defaults to [SnackbarTone.dark].
  const CatalystSnackbar({
    required this.message,
    this.tone = SnackbarTone.dark,
    this.action,
    this.icon,
    super.key,
  });

  /// Creates a green success snackbar.
  const CatalystSnackbar.success({
    required this.message,
    this.action,
    this.icon = const Icon(LucideIcons.circleCheckBig),
    super.key,
  }) : tone = SnackbarTone.success;

  /// Creates a red error snackbar.
  const CatalystSnackbar.danger({
    required this.message,
    this.action,
    this.icon = const Icon(LucideIcons.circleX),
    super.key,
  }) : tone = SnackbarTone.danger;

  /// An optional action shown at the trailing edge.
  final SnackbarAction? action;

  /// The colour style.
  final SnackbarTone tone;

  /// An optional icon at the leading edge.
  final Widget? icon;

  /// The main message content, typically a [Text] widget.
  final Widget message;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final style = tone.resolve(context.colorScheme);

    return AnimatedDefaultTextStyle(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.3,
        color: style.foregroundColor,
      ),
      child: IconTheme(
        data: IconThemeData(color: style.foregroundColor),
        child: AnimatedContainer(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: CatalystRadius.xlAll,
            boxShadow: context.shadows.lg,
          ),
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.symmetric(
            horizontal: CatalystSpacing.s3,
            vertical: CatalystSpacing.s4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: CatalystSpacing.s3,
            children: [
              if (icon != null) icon!,
              Expanded(child: message),
              if (action != null)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: action!.onPressed,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: CatalystSpacing.s1,
                        vertical: CatalystSpacing.s2,
                      ),
                      child: Opacity(
                        opacity: 0.85,
                        child: Text(
                          action!.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
