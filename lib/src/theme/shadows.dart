import 'package:flutter/widgets.dart';

/// Shadow presets for elevating surfaces.
///
/// Pass a custom [CatalystShadows] to [CatalystThemeData] to change shadow
/// values globally. The [brand] shadow is tinted with your brand colour and
/// is typically computed from your colour scheme rather than hardcoded.
///
/// ```dart
/// CatalystShadows(
///   brand: [BoxShadow(color: Color.fromRGBO(0, 102, 255, 0.20), ...)],
/// )
/// ```
class CatalystShadows {
  /// Creates a shadow preset bundle.
  const CatalystShadows({
    this.none = const [],
    this.sm = const [
      BoxShadow(
        offset: Offset(0, 1),
        blurRadius: 2,
        color: Color.fromRGBO(15, 23, 42, 0.06),
      ),
    ],
    this.md = const [
      BoxShadow(
        offset: Offset(0, 4),
        blurRadius: 12,
        color: Color.fromRGBO(15, 23, 42, 0.08),
      ),
    ],
    this.lg = const [
      BoxShadow(
        offset: Offset(0, 12),
        blurRadius: 32,
        color: Color.fromRGBO(15, 23, 42, 0.12),
      ),
    ],
    this.brand = const [
      BoxShadow(
        offset: Offset(0, 6),
        blurRadius: 18,
        color: Color.fromRGBO(0, 102, 255, 0.18),
      ),
    ],
  });

  /// No shadow — flat/zero elevation.
  final List<BoxShadow> none;

  /// Subtle shadow for low-elevation elements such as small cards.
  final List<BoxShadow> sm;

  /// Medium shadow for dropdowns, tooltips, and overlays.
  final List<BoxShadow> md;

  /// Large shadow for modals, drawers, and bottom sheets.
  final List<BoxShadow> lg;

  /// Brand-tinted shadow for primary call-to-action buttons.
  final List<BoxShadow> brand;
}
