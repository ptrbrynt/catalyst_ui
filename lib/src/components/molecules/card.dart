import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../theme/theme_data.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

// ── Tone system ──────────────────────────────────────────────────────────────

/// The resolved visual properties for a single [CardTone].
@immutable
class CardToneStyle {
  /// Creates a card tone style.
  const CardToneStyle({
    required this.backgroundColor,
    required this.borderColor,
  });

  /// The card background colour.
  final Color backgroundColor;

  /// The card border colour.
  final Color borderColor;
}

/// Defines the background and border of a [Card].
///
/// Extend this class to create your own tones:
///
/// ```dart
/// class HighlightCardTone extends CardTone {
///   const HighlightCardTone();
///
///   @override
///   CardToneStyle resolve(ColorScheme cs) => CardToneStyle(
///     backgroundColor: cs.warningSoft,
///     borderColor: cs.warning.withValues(alpha: 0.30),
///   );
/// }
/// ```
@immutable
abstract class CardTone {
  /// Const constructor for subclasses.
  const CardTone();

  /// Slightly off-canvas background with a border (default).
  static const CardTone subtle = _SubtleCardTone();

  /// Surface (white / dark) background with a border.
  static const CardTone surface = _SurfaceCardTone();

  /// Brand fill for primary emphasis.
  static const CardTone brand = _BrandCardTone();

  /// Lightly tinted background for secondary emphasis.
  static const CardTone tint = _TintCardTone();

  /// Resolves the visual style for this tone against [cs].
  CardToneStyle resolve(ColorScheme cs);
}

class _SubtleCardTone extends CardTone {
  const _SubtleCardTone();

  @override
  CardToneStyle resolve(ColorScheme cs) =>
      CardToneStyle(backgroundColor: cs.subtle, borderColor: cs.border);
}

class _SurfaceCardTone extends CardTone {
  const _SurfaceCardTone();

  @override
  CardToneStyle resolve(ColorScheme cs) =>
      CardToneStyle(backgroundColor: cs.surface, borderColor: cs.border);
}

class _BrandCardTone extends CardTone {
  const _BrandCardTone();

  @override
  CardToneStyle resolve(ColorScheme cs) => CardToneStyle(
    backgroundColor: cs.brand,
    borderColor: const Color(0x00000000),
  );
}

class _TintCardTone extends CardTone {
  const _TintCardTone();

  @override
  CardToneStyle resolve(ColorScheme cs) => CardToneStyle(
    backgroundColor: cs.tint,
    borderColor: cs.brand.withValues(alpha: 0.20),
  );
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// A rounded container that groups related content.
///
/// ```dart
/// Card(
///   tone: CardTone.subtle,
///   child: const Text('Hello'),
/// )
/// ```
class Card extends StatelessWidget {
  /// Creates a card.
  const Card({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(Spacing.s3),
    this.tone = CardTone.surface,
    this.interactive = false,
    this.onTap,
  });

  /// Inner padding applied to [child].
  final EdgeInsets padding;

  /// The background colour style.
  final CardTone tone;

  /// Changes the cursor to a pointer on hover when `true`.
  final bool interactive;

  /// Called when the card is tapped. Implies [interactive].
  final VoidCallback? onTap;

  /// The content of the card.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final motion = context.motion;
    final style = tone.resolve(context.colorScheme);
    final fg = ThemeData.textColorFor(style.backgroundColor);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: motion.standard.duration,
        curve: motion.standard.curve,
        clipBehavior: .antiAlias,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          border: Border.all(color: style.borderColor),
          borderRadius: Radii.xlAll,
        ),
        padding: padding,
        child: AnimatedDefaultTextStyle(
          duration: motion.standard.duration,
          curve: motion.standard.curve,
          style: TextStyle(color: fg),
          child: IconTheme(
            data: IconThemeData(color: fg),
            child: MouseRegion(
              cursor: (interactive || onTap != null)
                  ? SystemMouseCursors.click
                  : MouseCursor.defer,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
