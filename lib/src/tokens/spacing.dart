import 'package:flutter/widgets.dart';

/// Standard spacing values on a 4 px base grid.
///
/// The naming convention is `s` followed by an integer; the value is 4 px ×
/// that integer. For example, [s6] is 24 px.
///
/// These are used as defaults throughout the library. Override them by
/// supplying custom [EdgeInsets]/doubles where components accept them
/// directly, or by substituting your own spacing constants.
abstract final class Spacing {
  /// 4 px
  static const double s1 = 4;

  /// 8 px
  static const double s2 = 8;

  /// 12 px
  static const double s3 = 12;

  /// 16 px
  static const double s4 = 16;

  /// 20 px
  static const double s5 = 20;

  /// 24 px
  static const double s6 = 24;

  /// 32 px
  static const double s8 = 32;

  /// 40 px
  static const double s10 = 40;

  /// 48 px
  static const double s12 = 48;

  /// 64 px
  static const double s16 = 64;
}
