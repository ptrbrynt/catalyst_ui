import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';

/// A thin horizontal or vertical rule used to separate content.
///
/// The horizontal variant optionally accepts a [label] centred within the
/// rule. Use [Divider.vertical] for an inline vertical divider.
class Divider extends StatelessWidget {
  /// Creates a horizontal divider.
  const Divider({super.key, this.label, this.margin = EdgeInsets.zero})
    : _orientation = Axis.horizontal;

  /// Creates a vertical divider for use inside a [Row].
  const Divider.vertical({
    super.key,
    this.margin = const EdgeInsets.symmetric(
      horizontal: CatalystSpacing.s1,
    ),
  }) : _orientation = Axis.vertical,
       label = null;

  final Axis _orientation;

  /// Outer spacing applied around the divider.
  final EdgeInsets margin;

  /// An optional widget centred inside a horizontal divider.
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    final borderColor = context.colorScheme.border;

    if (_orientation == Axis.vertical) {
      return Padding(
        padding: margin,
        child: SizedBox(
          width: 1,
          child: Center(
            child: Container(
              width: 1,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: borderColor)),
              ),
            ),
          ),
        ),
      );
    }

    if (label != null) {
      return DefaultTextStyle(
        style: TextStyle(
          fontFamily: context.typography.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: context.colorScheme.borderStrong,
        ),
        child: Padding(
          padding: margin,
          child: Row(
            children: [
              Expanded(child: _line(borderColor)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CatalystSpacing.s3,
                ),
                child: label,
              ),
              Expanded(child: _line(borderColor)),
            ],
          ),
        ),
      );
    }

    return Padding(padding: margin, child: _line(borderColor));
  }

  Widget _line(Color color) => Container(
    height: 1,
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: color)),
    ),
  );
}
