import 'package:flutter/widgets.dart';

/// Standard border-radius values used across Catalyst components.
///
/// Each named value is available as both a raw [double] and a pre-built
/// [BorderRadius] (suffixed `All`).
abstract final class CatalystRadius {
  /// 4 px
  static const double xs = 4;

  /// 8 px
  static const double sm = 8;

  /// 12 px
  static const double md = 12;

  /// 14 px
  static const double lg = 14;

  /// 16 px
  static const double xl = 16;

  /// 24 px
  static const double xxl = 24;

  /// Pill — effectively infinite radius.
  static const double pill = 1000;

  /// [BorderRadius.all] using [xs].
  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));

  /// [BorderRadius.all] using [sm].
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));

  /// [BorderRadius.all] using [md].
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));

  /// [BorderRadius.all] using [lg].
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));

  /// [BorderRadius.all] using [xl].
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));

  /// [BorderRadius.all] using [xxl].
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));

  /// [BorderRadius.all] using [pill].
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}
