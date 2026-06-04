import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/spacing.dart';
import 'card.dart';

/// The direction of a metric trend shown on a [StatCard].
enum StatDelta {
  /// The metric has increased — shown in green.
  positive,

  /// The metric has decreased — shown in red.
  negative,

  /// The metric is unchanged — shown in muted colour.
  neutral,
}

/// A compact card displaying a metric with a title, value, trend, and icon.
///
/// ```dart
/// StatCard(
///   title: 'Revenue',
///   value: '£12,400',
///   trend: 'vs last month',
///   delta: StatDelta.positive,
///   icon: const Icon(LucideIcons.trendingUp),
/// )
/// ```
class StatCard extends StatelessWidget {
  /// Creates a stat card.
  const StatCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.delta,
    this.unit,
    this.primary = false,
    super.key,
  });

  /// When `true`, renders the card with a brand background.
  final bool primary;

  /// The metric label shown above the value.
  final String title;

  /// The formatted metric value.
  final String value;

  /// An optional unit string shown next to [value] (e.g. `'kg'`).
  final String? unit;

  /// A short trend description (e.g. `'vs last month'`).
  final String trend;

  /// The direction of the trend.
  final StatDelta delta;

  /// An icon in the top-right corner.
  final Icon icon;

  String get _arrow => switch (delta) {
    StatDelta.positive => '↑',
    StatDelta.negative => '↓',
    StatDelta.neutral => '→',
  };

  Color _deltaColor(BuildContext context) {
    final cs = context.colorScheme;
    return switch (delta) {
      StatDelta.positive => cs.success,
      StatDelta.negative => cs.danger,
      StatDelta.neutral => cs.textMuted,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;

    final iconColor = primary
        ? cs.onBrand
        : cs.brand;
    final titleColor = primary
        ? cs.onBrand.withValues(alpha: 0.85)
        : cs.textMuted;
    final valueColor = primary ? cs.onBrand : cs.text;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Card(
        tone: primary ? CardTone.brand : CardTone.subtle,
        padding: const EdgeInsets.all(CatalystSpacing.s4),
        child: IconTheme(
          data: IconThemeData(color: iconColor, size: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: typo.fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: titleColor,
                      ),
                    ),
                  ),
                  icon,
                ],
              ),
              Row(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: typo.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 28,
                      color: valueColor,
                    ),
                  ),
                  if (unit != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        unit!,
                        style: TextStyle(
                          fontFamily: typo.fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: titleColor,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                '$_arrow $trend',
                style: TextStyle(
                  fontFamily: typo.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: primary ? cs.onBrand : _deltaColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
