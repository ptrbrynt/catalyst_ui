import 'package:catalyst_ui/src/theme/iconography.dart';
import 'package:flutter/widgets.dart';

import '../tokens/breakpoints.dart';
import 'color_scheme.dart';
import 'motion.dart';
import 'shadows.dart';
import 'theme.dart';
import 'theme_data.dart';
import 'typography.dart';

/// Convenience accessors for [ThemeData] on [BuildContext].
extension ThemeContext on BuildContext {
  /// The full [ThemeData] from the nearest [Theme] ancestor.
  ThemeData get theme => Theme.of(this);

  /// Shorthand for `context.theme.colorScheme`.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Shorthand for `context.theme.typography`.
  Typography get typography => theme.typography;

  /// Shorthand for `context.theme.motion`.
  Motion get motion => theme.motion;

  /// Shorthand for `context.theme.shadows`.
  Shadows get shadows => theme.shadows;

  /// Shorthand for `context.theme.breakpoints`.
  Breakpoints get breakpoints => theme.breakpoints;

  /// Shorthand for `context.theme.iconography`.
  Iconography get iconography => theme.iconography;
}

/// Brightness manipulation for widgets via a colour-matrix filter.
extension BrightnessFilter on Widget {
  /// Applies a multiplicative brightness factor to this widget.
  ///
  /// [amount] of `1.0` leaves the widget unchanged. Values below `1.0`
  /// darken it — used for pressed/active feedback on interactive elements.
  Widget withBrightness(double amount) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        amount,
        0,
        0,
        0,
        0,
        0,
        amount,
        0,
        0,
        0,
        0,
        0,
        amount,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: this,
    );
  }
}
