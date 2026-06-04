import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BoolControl extends StatelessWidget {
  const BoolControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.typography.p2),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class SelectControl<T> extends StatelessWidget {
  const SelectControl({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<(T, String)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.typography.p2),
        const SizedBox(height: 6),
        Select<T>(
          value: value,
          options: options
              .map((o) => SelectOption<T>(value: o.$1, label: o.$2))
              .toList(),
          onChanged: onChanged,
          size: SelectSize.small,
          trailingIcon: LucideIcons.chevronDown,
          checkIcon: LucideIcons.check,
        ),
      ],
    );
  }
}

class SliderControl extends StatelessWidget {
  const SliderControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final isWhole = value == value.roundToDouble();
    final display = isWhole
        ? value.toInt().toString()
        : value.toStringAsFixed(2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: context.typography.p2),
            Text(
              display,
              style: context.typography.p2.copyWith(
                color: context.colorScheme.textSubtle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}

class IntControl extends StatelessWidget {
  const IntControl({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 10,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.typography.p2),
        Row(
          children: [
            Button.icon(
              icon: const Icon(LucideIcons.minus),
              variant: ButtonVariant.secondary,
              size: ButtonSize.small,
              onPressed: value > min ? () => onChanged(value - 1) : null,
            ),
            SizedBox(
              width: 40,
              child: Center(
                child: Text('$value', style: context.typography.p2),
              ),
            ),
            Button.icon(
              icon: const Icon(LucideIcons.plus),
              variant: ButtonVariant.secondary,
              size: ButtonSize.small,
              onPressed: value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }
}
