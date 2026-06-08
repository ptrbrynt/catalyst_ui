import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../tokens/radius.dart';

// ── Variant system ───────────────────────────────────────────────────────────

/// The resolved visual properties for a single [BadgeVariant].
@immutable
class BadgeVariantStyle {
  /// Creates a badge variant style.
  const BadgeVariantStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.dotColor,
  });

  /// The pill background colour.
  final Color backgroundColor;

  /// The text and dot colour.
  final Color foregroundColor;

  /// The colour of the optional leading status dot.
  final Color dotColor;
}

/// Defines the visual appearance of a [Badge].
///
/// Extend this class to create custom badge styles:
///
/// ```dart
/// class PremiumBadgeVariant extends BadgeVariant {
///   const PremiumBadgeVariant();
///
///   @override
///   BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
///     backgroundColor: const Color(0xFFFFF7E6),
///     foregroundColor: const Color(0xFFB45309),
///     dotColor: const Color(0xFFD97706),
///   );
/// }
/// ```
///
/// Built-in variants: [BadgeVariant.neutral], [BadgeVariant.info],
/// [BadgeVariant.success], [BadgeVariant.warning], [BadgeVariant.danger],
/// [BadgeVariant.brand].
@immutable
abstract class BadgeVariant {
  /// Const constructor for subclasses.
  const BadgeVariant();

  /// Grey — non-semantic label.
  static const BadgeVariant neutral = _NeutralBadgeVariant();

  /// Blue tint — informational label.
  static const BadgeVariant info = _InfoBadgeVariant();

  /// Green tint — positive or success label.
  static const BadgeVariant success = _SuccessBadgeVariant();

  /// Amber tint — cautionary label.
  static const BadgeVariant warning = _WarningBadgeVariant();

  /// Red tint — error or destructive label.
  static const BadgeVariant danger = _DangerBadgeVariant();

  /// Brand-coloured fill — primary emphasis label.
  static const BadgeVariant brand = _BrandBadgeVariant();

  /// Resolves the visual style for this variant against [colorScheme].
  BadgeVariantStyle resolve(ColorScheme colorScheme);
}

class _NeutralBadgeVariant extends BadgeVariant {
  const _NeutralBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: cs.subtle,
    foregroundColor: cs.textMuted,
    dotColor: cs.textSubtle,
  );
}

class _InfoBadgeVariant extends BadgeVariant {
  const _InfoBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: cs.infoSoft,
    foregroundColor: cs.info,
    dotColor: cs.info,
  );
}

class _SuccessBadgeVariant extends BadgeVariant {
  const _SuccessBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: cs.successSoft,
    foregroundColor: cs.success,
    dotColor: cs.success,
  );
}

class _WarningBadgeVariant extends BadgeVariant {
  const _WarningBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: cs.warningSoft,
    foregroundColor: cs.warning,
    dotColor: cs.warning,
  );
}

class _DangerBadgeVariant extends BadgeVariant {
  const _DangerBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: cs.dangerSoft,
    foregroundColor: cs.danger,
    dotColor: cs.danger,
  );
}

class _BrandBadgeVariant extends BadgeVariant {
  const _BrandBadgeVariant();

  @override
  BadgeVariantStyle resolve(ColorScheme cs) => BadgeVariantStyle(
    backgroundColor: cs.brand,
    foregroundColor: cs.onBrand,
    dotColor: cs.onBrand,
  );
}

// ── Size ─────────────────────────────────────────────────────────────────────

/// Controls the height and font size of a [Badge].
enum BadgeSize {
  /// 20 px tall; 11 sp text.
  small(height: 20, fontSize: 11, horizontalPadding: 8),

  /// 24 px tall; 12 sp text (default).
  medium(height: 24, fontSize: 12, horizontalPadding: 10),

  /// 28 px tall; 13 sp text.
  large(height: 28, fontSize: 13, horizontalPadding: 12);

  const BadgeSize({
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
  });

  /// The total height of the badge in logical pixels.
  final double height;

  /// The font size of the label.
  final double fontSize;

  /// Horizontal padding inside the pill.
  final double horizontalPadding;
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// A small pill-shaped label conveying status, category, or count.
///
/// ```dart
/// Badge(
///   variant: BadgeVariant.success,
///   child: const Text('Active'),
/// )
/// ```
class Badge extends StatelessWidget {
  /// Creates a badge.
  const Badge({
    required this.child,
    this.variant = BadgeVariant.neutral,
    this.showDot = false,
    this.size = BadgeSize.medium,
    this.elevated = false,
    super.key,
  });

  /// The visual variant. Defaults to [BadgeVariant.neutral].
  final BadgeVariant variant;

  /// The size. Defaults to [BadgeSize.medium].
  final BadgeSize size;

  /// Shows a small coloured dot before [child] when `true`.
  final bool showDot;

  /// Adds a small shadow to this badge when `true`.
  final bool elevated;

  /// The label content, typically a [Text] widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = variant.resolve(context.colorScheme);
    final motion = context.motion;

    return AnimatedDefaultTextStyle(
      duration: motion.micro.duration,
      curve: motion.micro.curve,
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontSize: size.fontSize,
        fontWeight: FontWeight.w600,
        color: style.foregroundColor,
      ),
      child: AnimatedContainer(
        duration: motion.micro.duration,
        curve: motion.micro.curve,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: size.horizontalPadding),
        decoration: BoxDecoration(
          borderRadius: Radii.pillAll,
          color: style.backgroundColor,
          boxShadow: elevated ? context.shadows.sm : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: style.dotColor,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
