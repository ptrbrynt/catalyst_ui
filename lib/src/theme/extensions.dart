import 'package:flutter/widgets.dart';

import '../tokens/breakpoints.dart';
import 'color_scheme.dart';
import 'motion.dart';
import 'shadows.dart';
import 'theme.dart';
import 'theme_data.dart';
import 'typography.dart';

/// Convenience accessors for [CatalystThemeData] on [BuildContext].
extension CatalystThemeContext on BuildContext {
  /// The full [CatalystThemeData] from the nearest [CatalystTheme] ancestor.
  CatalystThemeData get theme => CatalystTheme.of(this);

  /// Shorthand for `context.theme.colorScheme`.
  CatalystColorScheme get colorScheme => theme.colorScheme;

  /// Shorthand for `context.theme.typography`.
  CatalystTypography get typography => theme.typography;

  /// Shorthand for `context.theme.motion`.
  CatalystMotion get motion => theme.motion;

  /// Shorthand for `context.theme.shadows`.
  CatalystShadows get shadows => theme.shadows;

  /// Shorthand for `context.theme.breakpoints`.
  CatalystBreakpoints get breakpoints => theme.breakpoints;
}

/// Brightness manipulation for widgets via a colour-matrix filter.
extension CatalystBrightnessFilter on Widget {
  /// Applies a multiplicative brightness factor to this widget.
  ///
  /// [amount] of `1.0` leaves the widget unchanged. Values below `1.0`
  /// darken it — used for pressed/active feedback on interactive elements.
  Widget withBrightness(double amount) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix([
        amount, 0, 0, 0, 0,
        0, amount, 0, 0, 0,
        0, 0, amount, 0, 0,
        0, 0, 0, 1, 0,
      ]),
      child: this,
    );
  }
}
