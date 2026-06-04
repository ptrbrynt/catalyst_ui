import 'package:flutter/widgets.dart';

import '../tokens/breakpoints.dart';
import 'color_scheme.dart';
import 'color_utils.dart';
import 'motion.dart';
import 'shadows.dart';
import 'typography.dart';

/// Aggregates all design tokens and theme sub-objects for Catalyst.
///
/// Obtain via `Theme.of(context)` or the `context.theme` extension.
///
/// **Quick start — light theme with custom brand colour:**
/// ```dart
/// ThemeData.light().copyWith(
///   colorScheme: const ColorScheme.light().copyWith(
///     brand: Color(0xFF7C3AED),
///     brandSoft: Color(0xFFEDE9FE),
///   ),
/// )
/// ```
///
/// **Custom font:**
/// ```dart
/// ThemeData.light(fontFamily: 'Poppins')
/// ```
///
/// **Override individual text styles:**
/// ```dart
/// final base = ThemeData.light();
/// base.copyWith(
///   typography: base.typography.copyWith(
///     display: TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
///   ),
/// )
/// ```
class ThemeData {
  /// Creates a light-mode theme.
  ///
  /// Supply [colorScheme] to override colours, [fontFamily] to change the
  /// typeface, [typography] to fully customise text styles, or
  /// [motion] / [shadows] / [breakpoints] for further control.
  ///
  /// When [typography] is provided, [fontFamily] is ignored — pass
  /// [fontFamily] directly to the [Typography] constructor instead.
  factory ThemeData.light({
    ColorScheme? colorScheme,
    String? fontFamily,
    Typography? typography,
    Motion? motion,
    Shadows? shadows,
    Breakpoints? breakpoints,
  }) {
    final cs = colorScheme ?? const ColorScheme.light();
    final typo = (typography ??
            Typography(colorScheme: cs, fontFamily: fontFamily))
        .withColorScheme(cs);
    return ThemeData.raw(
      colorScheme: cs,
      typography: typo,
      motion: motion ?? const Motion(),
      shadows: shadows ?? const Shadows(),
      breakpoints: breakpoints ?? const Breakpoints(),
    );
  }

  /// Creates a dark-mode theme.
  ///
  /// Supply [colorScheme] to override colours, [fontFamily] to change the
  /// typeface, [typography] to fully customise text styles, or
  /// [motion] / [shadows] / [breakpoints] for further control.
  ///
  /// When [typography] is provided, [fontFamily] is ignored — pass
  /// [fontFamily] directly to the [Typography] constructor instead.
  factory ThemeData.dark({
    ColorScheme? colorScheme,
    String? fontFamily,
    Typography? typography,
    Motion? motion,
    Shadows? shadows,
    Breakpoints? breakpoints,
  }) {
    final cs = colorScheme ?? const ColorScheme.dark();
    final typo = (typography ??
            Typography(colorScheme: cs, fontFamily: fontFamily))
        .withColorScheme(cs);
    return ThemeData.raw(
      colorScheme: cs,
      typography: typo,
      motion: motion ?? const Motion(),
      shadows: shadows ?? const Shadows(),
      breakpoints: breakpoints ?? const Breakpoints(),
    );
  }

  /// Creates a theme from fully explicit sub-objects.
  ThemeData.raw({
    required this.colorScheme,
    required this.typography,
    required this.motion,
    required this.shadows,
    required this.breakpoints,
  });

  /// The semantic colour scheme.
  final ColorScheme colorScheme;

  /// The typographic scale.
  final Typography typography;

  /// Animation durations and curves.
  final Motion motion;

  /// Shadow presets.
  final Shadows shadows;

  /// Responsive breakpoint thresholds.
  final Breakpoints breakpoints;

  /// Returns a copy of this theme with the given fields replaced.
  ThemeData copyWith({
    ColorScheme? colorScheme,
    Typography? typography,
    Motion? motion,
    Shadows? shadows,
    Breakpoints? breakpoints,
  }) {
    final cs = colorScheme ?? this.colorScheme;
    return ThemeData.raw(
      colorScheme: cs,
      typography: (typography ?? this.typography).withColorScheme(cs),
      motion: motion ?? this.motion,
      shadows: shadows ?? this.shadows,
      breakpoints: breakpoints ?? this.breakpoints,
    );
  }

  /// Returns the legible text colour (dark or light) for [background].
  static Color textColorFor(Color background) =>
      catalystTextColorFor(background);
}
