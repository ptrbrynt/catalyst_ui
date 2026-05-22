import 'package:flutter/widgets.dart';

import '../tokens/breakpoints.dart';
import 'color_scheme.dart';
import 'color_utils.dart';
import 'motion.dart';
import 'shadows.dart';
import 'typography.dart';

/// Aggregates all design tokens and theme sub-objects for Catalyst.
///
/// Obtain via `CatalystTheme.of(context)` or the `context.theme` extension.
///
/// **Quick start — light theme with custom brand colour:**
/// ```dart
/// CatalystThemeData.light().copyWith(
///   colorScheme: const CatalystColorScheme.light().copyWith(
///     brand: Color(0xFF7C3AED),
///     brandSoft: Color(0xFFEDE9FE),
///   ),
/// )
/// ```
///
/// **Custom font:**
/// ```dart
/// CatalystThemeData.light(fontFamily: 'Poppins')
/// ```
class CatalystThemeData {
  /// Creates a light-mode theme.
  ///
  /// Supply [colorScheme] to override colours, [fontFamily] to change the
  /// typeface, or [motion] / [shadows] / [breakpoints] for further control.
  CatalystThemeData.light({
    CatalystColorScheme? colorScheme,
    String? fontFamily,
    CatalystMotion? motion,
    CatalystShadows? shadows,
    CatalystBreakpoints? breakpoints,
  }) : colorScheme = colorScheme ?? const CatalystColorScheme.light(),
       motion = motion ?? const CatalystMotion(),
       shadows = shadows ?? const CatalystShadows(),
       breakpoints = breakpoints ?? const CatalystBreakpoints(),
       typography = CatalystTypography(
         colorScheme: colorScheme ?? const CatalystColorScheme.light(),
         fontFamily: fontFamily,
       );

  /// Creates a dark-mode theme.
  CatalystThemeData.dark({
    CatalystColorScheme? colorScheme,
    String? fontFamily,
    CatalystMotion? motion,
    CatalystShadows? shadows,
    CatalystBreakpoints? breakpoints,
  }) : colorScheme = colorScheme ?? const CatalystColorScheme.dark(),
       motion = motion ?? const CatalystMotion(),
       shadows = shadows ?? const CatalystShadows(),
       breakpoints = breakpoints ?? const CatalystBreakpoints(),
       typography = CatalystTypography(
         colorScheme: colorScheme ?? const CatalystColorScheme.dark(),
         fontFamily: fontFamily,
       );

  /// Creates a theme from fully explicit sub-objects.
  CatalystThemeData.raw({
    required this.colorScheme,
    required this.typography,
    required this.motion,
    required this.shadows,
    required this.breakpoints,
  });

  /// The semantic colour scheme.
  final CatalystColorScheme colorScheme;

  /// The typographic scale.
  final CatalystTypography typography;

  /// Animation durations and curves.
  final CatalystMotion motion;

  /// Shadow presets.
  final CatalystShadows shadows;

  /// Responsive breakpoint thresholds.
  final CatalystBreakpoints breakpoints;

  /// Returns a copy of this theme with the given fields replaced.
  CatalystThemeData copyWith({
    CatalystColorScheme? colorScheme,
    CatalystTypography? typography,
    CatalystMotion? motion,
    CatalystShadows? shadows,
    CatalystBreakpoints? breakpoints,
  }) {
    final cs = colorScheme ?? this.colorScheme;
    return CatalystThemeData.raw(
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
