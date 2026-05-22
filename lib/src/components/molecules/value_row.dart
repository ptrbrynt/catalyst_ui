import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';
import '../atoms/divider.dart';

/// A single label–value pair row, typically used in a details section.
///
/// Renders [title] left-aligned and [value] right-aligned, separated by
/// an optional bottom border.
class ValueRow extends StatelessWidget {
  /// Creates a value row.
  const ValueRow(
    this.title,
    this.value, {
    super.key,
    this.divider = true,
  });

  /// The descriptive label shown on the left.
  final String title;

  /// The data value shown on the right.
  final String value;

  /// Whether to render a subtle bottom border below the row.
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(CatalystSpacing.s3),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: typo.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: cs.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: typo.fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: cs.text,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (divider)
          const CatalystDivider(
            margin: EdgeInsets.symmetric(horizontal: CatalystSpacing.s3),
          ),
      ],
    );
  }
}
