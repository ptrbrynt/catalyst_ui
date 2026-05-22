import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

// ── Tone system ──────────────────────────────────────────────────────────────

/// The resolved visual properties for a single [AlertTone].
@immutable
class AlertToneStyle {
  /// Creates an alert tone style.
  const AlertToneStyle({
    required this.backgroundColor,
    required this.accentColor,
    required this.icon,
  });

  /// The tinted banner background.
  final Color backgroundColor;

  /// The icon and border-tint colour.
  final Color accentColor;

  /// The leading icon.
  final IconData icon;
}

/// Defines the colour and icon of an [Alert].
///
/// Extend this class to create your own tones:
///
/// ```dart
/// class MaintenanceTone extends AlertTone {
///   const MaintenanceTone();
///
///   @override
///   AlertToneStyle resolve(CatalystColorScheme cs) => AlertToneStyle(
///     backgroundColor: cs.warningSoft,
///     accentColor: cs.warning,
///     icon: LucideIcons.wrench,
///   );
/// }
/// ```
@immutable
abstract class AlertTone {
  /// Const constructor for subclasses.
  const AlertTone();

  /// Blue tint — general informational message.
  static const AlertTone info = _InfoAlertTone();

  /// Green tint — positive or completed-action message.
  static const AlertTone success = _SuccessAlertTone();

  /// Amber tint — cautionary message.
  static const AlertTone warning = _WarningAlertTone();

  /// Red tint — error or destructive-action message.
  static const AlertTone danger = _DangerAlertTone();

  /// Resolves the visual style for this tone against [cs].
  AlertToneStyle resolve(CatalystColorScheme cs);
}

class _InfoAlertTone extends AlertTone {
  const _InfoAlertTone();

  @override
  AlertToneStyle resolve(CatalystColorScheme cs) => AlertToneStyle(
    backgroundColor: cs.infoSoft,
    accentColor: cs.info,
    icon: LucideIcons.info,
  );
}

class _SuccessAlertTone extends AlertTone {
  const _SuccessAlertTone();

  @override
  AlertToneStyle resolve(CatalystColorScheme cs) => AlertToneStyle(
    backgroundColor: cs.successSoft,
    accentColor: cs.success,
    icon: LucideIcons.circleCheckBig,
  );
}

class _WarningAlertTone extends AlertTone {
  const _WarningAlertTone();

  @override
  AlertToneStyle resolve(CatalystColorScheme cs) => AlertToneStyle(
    backgroundColor: cs.warningSoft,
    accentColor: cs.warning,
    icon: LucideIcons.triangleAlert,
  );
}

class _DangerAlertTone extends AlertTone {
  const _DangerAlertTone();

  @override
  AlertToneStyle resolve(CatalystColorScheme cs) => AlertToneStyle(
    backgroundColor: cs.dangerSoft,
    accentColor: cs.danger,
    icon: LucideIcons.circleX,
  );
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// An inline notification banner used to convey contextual feedback.
///
/// Supply [title] and/or [children] for message content. An optional [action]
/// (e.g. a [Button]) sits below the body. Provide [onDismiss] to show a close
/// button.
class Alert extends StatelessWidget {
  /// Creates an alert.
  const Alert({
    this.tone = AlertTone.info,
    this.title,
    this.children,
    this.action,
    this.onDismiss,
    super.key,
  });

  /// The semantic colour and icon of the alert.
  final AlertTone tone;

  /// An optional bold title rendered above [children].
  final Widget? title;

  /// Optional body content below [title].
  final List<Widget>? children;

  /// An optional action widget (e.g. a button) below the body.
  final Widget? action;

  /// When provided, shows a dismiss button in the top-right corner.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;
    final style = tone.resolve(cs);
    final borderColor = style.accentColor.withValues(alpha: 0.30);

    return AnimatedContainer(
      duration: motion.standard.duration,
      curve: motion.standard.curve,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: CatalystRadius.lgAll,
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(CatalystSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: CatalystSpacing.s3,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(style.icon, color: style.accentColor, size: 18),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: context.typography.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.4,
                      color: cs.text,
                    ),
                    child: title!,
                  ),
                if (children != null) ...[
                  if (title != null) const SizedBox(height: 4),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: context.typography.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.5,
                      color: cs.textMuted,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: children!,
                    ),
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: CatalystSpacing.s3),
                  action!,
                ],
              ],
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(LucideIcons.x, size: 16, color: cs.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}
