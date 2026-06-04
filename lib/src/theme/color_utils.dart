import 'package:flutter/widgets.dart';

/// Returns the legible foreground colour (dark or light) for [background].
///
/// Uses relative luminance with a perceptual threshold so that components can
/// automatically choose readable text/icon colours without hardcoding them.
Color getTextColorFor(Color background) {
  const darkText = Color(0xFF0F172A);
  const lightText = Color(0xFFFFFFFF);
  final luminance = background.computeLuminance();
  return (luminance + 0.05) * (luminance + 0.05) > 0.15 ? darkText : lightText;
}
