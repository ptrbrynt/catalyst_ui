import 'package:flutter/widgets.dart';

import 'color_scheme.dart';

/// The typographic scale used by Catalyst components.
///
/// Create a [CatalystTypography] and pass it to [CatalystThemeData] to
/// customise the font family, sizes, weights, and individual styles.
///
/// **Single font family:**
/// ```dart
/// CatalystTypography(fontFamily: 'Inter', colorScheme: myScheme)
/// ```
///
/// **Different font families for headers and body:**
/// ```dart
/// CatalystTypography(
///   colorScheme: myScheme,
///   fontFamily: 'Inter',
///   headerFontFamily: 'Playfair Display',
/// )
/// ```
///
/// **Override individual styles:**
/// ```dart
/// CatalystTypography(
///   colorScheme: myScheme,
///   display: TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
///   body: TextStyle(fontSize: 15, height: 1.6),
/// )
/// ```
///
/// **Override via an existing theme:**
/// ```dart
/// themeData.copyWith(
///   typography: themeData.typography.copyWith(
///     body: TextStyle(fontSize: 15, height: 1.6),
///   ),
/// )
/// ```
///
/// Overridden styles are used verbatim — [fontFamily], [headerFontFamily],
/// and [colorScheme] are not merged into them. Styles that are not
/// overridden continue to inherit the appropriate font family and the text
/// colour from [colorScheme].
class CatalystTypography {
  /// Creates a typography scale.
  ///
  /// [fontFamily] is the typeface for body-level styles ([p1], [p2], [body],
  /// [p3], [caption], [micro]). Defaults to `null`, which lets Flutter fall
  /// through to the platform default.
  ///
  /// [headerFontFamily] is the typeface for heading-level styles ([display],
  /// [h1], [h2], [h3]). Defaults to [fontFamily] when `null`, so you only
  /// need to set it when headers should use a different typeface.
  ///
  /// [colorScheme] binds the default text colour for non-overridden styles.
  /// It is set automatically when you attach this typography to a
  /// [CatalystThemeData].
  ///
  /// Each named style parameter ([display], [h1], …, [micro]) replaces the
  /// computed default for that slot. Explicit overrides take precedence over
  /// both [fontFamily] and [headerFontFamily]. Pass `null` (the default) to
  /// keep the built-in scale for that style.
  CatalystTypography({
    required this.colorScheme,
    this.fontFamily,
    this.headerFontFamily,
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? p1,
    TextStyle? p2,
    TextStyle? body,
    TextStyle? p3,
    TextStyle? caption,
    TextStyle? micro,
  }) : _display = display,
       _h1 = h1,
       _h2 = h2,
       _h3 = h3,
       _p1 = p1,
       _p2 = p2,
       _body = body,
       _p3 = p3,
       _caption = caption,
       _micro = micro;

  /// The font family used for body-level styles.
  ///
  /// Pass `null` to use the platform default.
  final String? fontFamily;

  /// The font family used for heading-level styles ([display], [h1], [h2],
  /// [h3]).
  ///
  /// Defaults to [fontFamily] when `null`. Set this to use a different
  /// typeface for headings without affecting body text.
  final String? headerFontFamily;

  /// The colour scheme that drives the default text colour.
  final CatalystColorScheme colorScheme;

  final TextStyle? _display;
  final TextStyle? _h1;
  final TextStyle? _h2;
  final TextStyle? _h3;
  final TextStyle? _p1;
  final TextStyle? _p2;
  final TextStyle? _body;
  final TextStyle? _p3;
  final TextStyle? _caption;
  final TextStyle? _micro;

  TextStyle get _bodyBase =>
      TextStyle(fontFamily: fontFamily, color: colorScheme.text);

  TextStyle get _headerBase => TextStyle(
    fontFamily: headerFontFamily ?? fontFamily,
    color: colorScheme.text,
  );

  TextStyle _style(
    TextStyle base,
    double size,
    FontWeight weight, {
    double? height,
  }) =>
      base.copyWith(fontSize: size, fontWeight: weight, height: height);

  /// The default body style; used as the ambient [DefaultTextStyle].
  TextStyle get defaultStyle => body;

  /// 40 sp bold — hero numbers and large display text.
  TextStyle get display =>
      _display ?? _style(_headerBase, 40, FontWeight.w700, height: 1.1);

  /// 28 sp semibold — page-level heading.
  TextStyle get h1 =>
      _h1 ?? _style(_headerBase, 28, FontWeight.w600, height: 1.2);

  /// 22 sp semibold — section heading.
  TextStyle get h2 =>
      _h2 ?? _style(_headerBase, 22, FontWeight.w600, height: 1.25);

  /// 18 sp medium — sub-section heading.
  TextStyle get h3 =>
      _h3 ?? _style(_headerBase, 18, FontWeight.w500, height: 1.3);

  /// 20 sp medium — large paragraph text.
  TextStyle get p1 =>
      _p1 ?? _style(_bodyBase, 20, FontWeight.w500, height: 1.5);

  /// 18 sp regular — secondary paragraph text.
  TextStyle get p2 =>
      _p2 ?? _style(_bodyBase, 18, FontWeight.w400, height: 1.5);

  /// 16 sp regular — default body copy.
  TextStyle get body =>
      _body ?? _style(_bodyBase, 16, FontWeight.w400, height: 1.5);

  /// 14 sp regular — supporting body copy.
  TextStyle get p3 =>
      _p3 ?? _style(_bodyBase, 14, FontWeight.w400, height: 1.5);

  /// 12 sp regular — captions and helper text.
  TextStyle get caption =>
      _caption ?? _style(_bodyBase, 12, FontWeight.w400, height: 1.4);

  /// 10 sp medium — micro labels and badges.
  TextStyle get micro =>
      _micro ?? _style(_bodyBase, 10, FontWeight.w500, height: 1.2);

  /// Returns a copy with the specified fields replaced.
  ///
  /// Parameters set to `null` retain their current value — either the
  /// previously supplied override or the computed default.
  CatalystTypography copyWith({
    CatalystColorScheme? colorScheme,
    String? fontFamily,
    String? headerFontFamily,
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? p1,
    TextStyle? p2,
    TextStyle? body,
    TextStyle? p3,
    TextStyle? caption,
    TextStyle? micro,
  }) {
    return CatalystTypography(
      colorScheme: colorScheme ?? this.colorScheme,
      fontFamily: fontFamily ?? this.fontFamily,
      headerFontFamily: headerFontFamily ?? this.headerFontFamily,
      display: display ?? _display,
      h1: h1 ?? _h1,
      h2: h2 ?? _h2,
      h3: h3 ?? _h3,
      p1: p1 ?? _p1,
      p2: p2 ?? _p2,
      body: body ?? _body,
      p3: p3 ?? _p3,
      caption: caption ?? _caption,
      micro: micro ?? _micro,
    );
  }

  /// Returns a copy of this typography bound to [colorScheme].
  ///
  /// All style overrides and font family settings are preserved; only the
  /// default text colour changes.
  CatalystTypography withColorScheme(CatalystColorScheme colorScheme) {
    return CatalystTypography(
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      headerFontFamily: headerFontFamily,
      display: _display,
      h1: _h1,
      h2: _h2,
      h3: _h3,
      p1: _p1,
      p2: _p2,
      body: _body,
      p3: _p3,
      caption: _caption,
      micro: _micro,
    );
  }
}
