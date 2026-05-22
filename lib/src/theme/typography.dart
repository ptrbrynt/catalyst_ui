import 'package:flutter/widgets.dart';

import 'color_scheme.dart';

/// The typographic scale used by Catalyst components.
///
/// Create a [CatalystTypography] and pass it to [CatalystThemeData] to
/// customise the font family, sizes, and weights.
///
/// ```dart
/// CatalystTypography(fontFamily: 'Inter')
/// ```
class CatalystTypography {
  /// Creates a typography scale.
  ///
  /// [fontFamily] defaults to `null`, which lets Flutter fall through to
  /// the platform default. Provide your app's font family name here.
  ///
  /// [colorScheme] is required to bind the default text colour. It is set
  /// automatically when you attach this typography to a [CatalystThemeData].
  CatalystTypography({required this.colorScheme, this.fontFamily});

  /// The font family used for all text styles.
  ///
  /// Pass `null` to use the platform default.
  final String? fontFamily;

  /// The colour scheme that drives the default text colour.
  final CatalystColorScheme colorScheme;

  TextStyle get _base =>
      TextStyle(fontFamily: fontFamily, color: colorScheme.text);

  TextStyle _style(double size, FontWeight weight, {double? height}) =>
      _base.copyWith(fontSize: size, fontWeight: weight, height: height);

  /// The default body style; used as the ambient [DefaultTextStyle].
  TextStyle get defaultStyle => body;

  /// 40 sp bold — hero numbers and large display text.
  TextStyle get display => _style(40, FontWeight.w700, height: 1.1);

  /// 28 sp semibold — page-level heading.
  TextStyle get h1 => _style(28, FontWeight.w600, height: 1.2);

  /// 22 sp semibold — section heading.
  TextStyle get h2 => _style(22, FontWeight.w600, height: 1.25);

  /// 18 sp medium — sub-section heading.
  TextStyle get h3 => _style(18, FontWeight.w500, height: 1.3);

  /// 20 sp medium — large paragraph text.
  TextStyle get p1 => _style(20, FontWeight.w500, height: 1.5);

  /// 18 sp regular — secondary paragraph text.
  TextStyle get p2 => _style(18, FontWeight.w400, height: 1.5);

  /// 16 sp regular — default body copy.
  TextStyle get body => _style(16, FontWeight.w400, height: 1.5);

  /// 14 sp regular — supporting body copy.
  TextStyle get p3 => _style(14, FontWeight.w400, height: 1.5);

  /// 12 sp regular — captions and helper text.
  TextStyle get caption => _style(12, FontWeight.w400, height: 1.4);

  /// 10 sp medium — micro labels and badges.
  TextStyle get micro => _style(10, FontWeight.w500, height: 1.2);

  /// Returns a copy of this typography bound to [colorScheme].
  CatalystTypography withColorScheme(CatalystColorScheme colorScheme) {
    return CatalystTypography(
      fontFamily: fontFamily,
      colorScheme: colorScheme,
    );
  }
}
