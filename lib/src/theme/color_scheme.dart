import 'package:flutter/widgets.dart';

import 'color_utils.dart';

/// The full set of semantic colours consumed by all Catalyst components.
///
/// Retrieve via `context.colorScheme`. Two factory constructors are provided
/// for convenience — [ColorScheme.light] and
/// [ColorScheme.dark] — but every field may also be overridden
/// individually using the default (required) constructor or [copyWith].
class ColorScheme {
  /// Creates a fully custom colour scheme.
  ///
  /// Every field is required so that no colour is silently defaulted.
  /// Use [ColorScheme.light] or [ColorScheme.dark] and
  /// call [copyWith] to start from a sensible base.
  const ColorScheme({
    required this.canvas,
    required this.surface,
    required this.subtle,
    required this.muted,
    required this.tint,
    required this.brand,
    required this.brandSoft,
    required this.inverse,
    required this.border,
    required this.borderStrong,
    required this.borderSubtle,
    required this.text,
    required this.textMuted,
    required this.textSubtle,
    required this.textDisabled,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.successSoft,
    required this.warningSoft,
    required this.dangerSoft,
    required this.infoSoft,
  });

  /// A sensible light-mode colour scheme.
  ///
  /// Brand defaults to a clean blue (`#0066FF`). Override by calling
  /// `ColorScheme.light().copyWith(brand: yourColor, ...)`.
  const ColorScheme.light()
    : canvas = const Color(0xFFFFFFFF),
      surface = const Color(0xFFFFFFFF),
      subtle = const Color(0xFFF8F9FA),
      muted = const Color(0xFFF1F3F5),
      tint = const Color(0xFFF0F5FF),
      brand = const Color(0xFF0066FF),
      brandSoft = const Color(0xFFE5EEFF),
      inverse = const Color(0xFF0F172A),
      border = const Color(0xFFE2E8F0),
      borderStrong = const Color(0xFF94A3B8),
      borderSubtle = const Color(0xFFF1F5F9),
      text = const Color(0xFF0F172A),
      textMuted = const Color(0xFF475569),
      textSubtle = const Color(0xFF94A3B8),
      textDisabled = const Color(0xFFCBD5E1),
      success = const Color(0xFF16A34A),
      warning = const Color(0xFFD97706),
      danger = const Color(0xFFDC2626),
      info = const Color(0xFF0066FF),
      successSoft = const Color(0xFFDCFCE7),
      warningSoft = const Color(0xFFFEF3C7),
      dangerSoft = const Color(0xFFFEE2E2),
      infoSoft = const Color(0xFFEFF6FF);

  /// A sensible dark-mode colour scheme.
  const ColorScheme.dark()
    : canvas = const Color(0xFF0B0F19),
      surface = const Color(0xFF141924),
      subtle = const Color(0xFF1A2030),
      muted = const Color(0xFF1E2638),
      tint = const Color(0xFF141E3A),
      brand = const Color(0xFF3B82F6),
      brandSoft = const Color(0xFF0F1E40),
      inverse = const Color(0xFFF8FAFC),
      border = const Color(0xFF273045),
      borderStrong = const Color(0xFF3B4D6A),
      borderSubtle = const Color(0xFF1E2638),
      text = const Color(0xFFF1F5F9),
      textMuted = const Color(0xFF94A3B8),
      textSubtle = const Color(0xFF64748B),
      textDisabled = const Color(0xFF334155),
      success = const Color(0xFF4ADE80),
      warning = const Color(0xFFFBBF24),
      danger = const Color(0xFFF87171),
      info = const Color(0xFF60A5FA),
      successSoft = const Color.fromRGBO(74, 222, 128, 0.12),
      warningSoft = const Color.fromRGBO(251, 191, 36, 0.12),
      dangerSoft = const Color.fromRGBO(248, 113, 113, 0.12),
      infoSoft = const Color.fromRGBO(96, 165, 250, 0.12);

  // ── Surfaces ──────────────────────────────────────────────────────────────

  /// The outermost page/screen background.
  final Color canvas;

  /// Standard card and panel background.
  final Color surface;

  /// One step above [canvas]; used for nested or secondary sections.
  final Color subtle;

  /// Muted background for disabled or low-emphasis areas.
  final Color muted;

  /// Lightly tinted background for brand-adjacent surfaces.
  final Color tint;

  // ── Brand ─────────────────────────────────────────────────────────────────

  /// The primary brand colour. Used for CTAs, active states, and focus rings.
  final Color brand;

  /// A soft tint of [brand] for backgrounds behind brand-coloured elements.
  final Color brandSoft;

  // ── Inverse ───────────────────────────────────────────────────────────────

  /// High-contrast background — typically the inverse of [canvas].
  final Color inverse;

  // ── Borders ───────────────────────────────────────────────────────────────

  /// Default border/divider colour.
  final Color border;

  /// A more prominent border for emphasis.
  final Color borderStrong;

  /// A very subtle border for low-emphasis separators.
  final Color borderSubtle;

  // ── Text ──────────────────────────────────────────────────────────────────

  /// Default body text colour.
  final Color text;

  /// Supporting / secondary text colour.
  final Color textMuted;

  /// Placeholder and tertiary text colour.
  final Color textSubtle;

  /// Text colour for disabled controls.
  final Color textDisabled;

  // ── Status ────────────────────────────────────────────────────────────────

  /// Green — healthy, confirmed, or successful states.
  final Color success;

  /// Amber — cautionary or pending states.
  final Color warning;

  /// Red — error, destructive, or critical states.
  final Color danger;

  /// Blue — informational states (defaults to [brand]).
  final Color info;

  /// Soft green background for success banners/badges.
  final Color successSoft;

  /// Soft amber background for warning banners/badges.
  final Color warningSoft;

  /// Soft red background for danger banners/badges.
  final Color dangerSoft;

  /// Soft blue background for info banners/badges.
  final Color infoSoft;

  // ── Computed on-colours ───────────────────────────────────────────────────

  /// Readable text colour for content placed on [canvas].
  Color get onCanvas => catalystTextColorFor(canvas);

  /// Readable text colour for content placed on [surface].
  Color get onSurface => catalystTextColorFor(surface);

  /// Readable text colour for content placed on [subtle].
  Color get onSubtle => catalystTextColorFor(subtle);

  /// Readable text colour for content placed on [muted].
  Color get onMuted => catalystTextColorFor(muted);

  /// Readable text colour for content placed on [tint].
  Color get onTint => catalystTextColorFor(tint);

  /// Readable text colour for content placed on [brand].
  Color get onBrand => catalystTextColorFor(brand);

  /// Readable text colour for content placed on [brandSoft].
  Color get onBrandSoft => catalystTextColorFor(brandSoft);

  /// Readable text colour for content placed on [inverse].
  Color get onInverse => catalystTextColorFor(inverse);

  /// Readable text colour for content placed on [success].
  Color get onSuccess => catalystTextColorFor(success);

  /// Readable text colour for content placed on [danger].
  Color get onDanger => catalystTextColorFor(danger);

  /// Readable text colour for content placed on [warning].
  Color get onWarning => catalystTextColorFor(warning);

  // ── Mutation ──────────────────────────────────────────────────────────────

  /// Returns a copy of this scheme with the given fields replaced.
  ColorScheme copyWith({
    Color? canvas,
    Color? surface,
    Color? subtle,
    Color? muted,
    Color? tint,
    Color? brand,
    Color? brandSoft,
    Color? inverse,
    Color? border,
    Color? borderStrong,
    Color? borderSubtle,
    Color? text,
    Color? textMuted,
    Color? textSubtle,
    Color? textDisabled,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? successSoft,
    Color? warningSoft,
    Color? dangerSoft,
    Color? infoSoft,
  }) {
    return ColorScheme(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      subtle: subtle ?? this.subtle,
      muted: muted ?? this.muted,
      tint: tint ?? this.tint,
      brand: brand ?? this.brand,
      brandSoft: brandSoft ?? this.brandSoft,
      inverse: inverse ?? this.inverse,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      textDisabled: textDisabled ?? this.textDisabled,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      info: info ?? this.info,
      successSoft: successSoft ?? this.successSoft,
      warningSoft: warningSoft ?? this.warningSoft,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      infoSoft: infoSoft ?? this.infoSoft,
    );
  }
}
