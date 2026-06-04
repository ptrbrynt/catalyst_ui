import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

/// An option for a [RadioGroup]
sealed class RadioGroupOption<T> {
  const RadioGroupOption({required this.value});

  /// The value of this option
  final T value;
}

/// A simple [RadioGroupOption] with a [label]
@immutable
class RadioGroupSimpleOption<T> extends RadioGroupOption<T> {
  /// Creates a [RadioGroupSimpleOption]
  const RadioGroupSimpleOption({
    required super.value,
    required this.label,
  });

  /// The main label. Typically a [Text] widget.
  final Widget label;
}

/// A simple [RadioGroupOption] with a [label] and [description]
@immutable
class RadioGroupSimpleOptionWithDescription<T> extends RadioGroupOption<T> {
  /// Creates a [RadioGroupSimpleOptionWithDescription]
  const RadioGroupSimpleOptionWithDescription({
    required super.value,
    required this.label,
    required this.description,
  });

  /// The main label. Typically a [Text] widget.
  final Widget label;

  /// The description. Typically a [Text] widget.
  final Widget description;
}

/// A [RadioGroupOption] which is displayed as a table row.
class RadioGroupTableRowOption<T> extends RadioGroupOption<T> {
  /// Creates a [RadioGroupTableRowOption]
  const RadioGroupTableRowOption({required super.value, required this.columns});

  /// The columns to display in this row.
  final List<Widget> columns;
}

/// A [RadioGroupOption] which is rendered by calling a [builder] function.
class RadioGroupCustomOption<T> extends RadioGroupOption<T> {
  /// Creates a [RadioGroupCustomOption]
  const RadioGroupCustomOption({required super.value, required this.builder});

  /// Renders this option
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext context, bool isSelected) builder;
}

/// Styles for [RadioGroup]
enum RadioGroupStyle {
  /// Options are displayed in a simple vertical list.
  simpleList,

  /// Options are displayed in a horizonal list.
  simpleListInline,

  /// Options are displayed in a vertical list with the radio button aligned
  /// at the end.
  simpleListWithTrailingRadio,

  /// Options are displayed in a vertical list with descriptions below the
  /// titles.
  listWithDescription,

  /// Options are displayed in a vertical list, with descriptions
  /// in-line with the title.
  listWithInlineDescription,

  /// Options are displayed in a vertical list with the radio button aligned
  /// at the end.
  listWithTrailingRadio,

  /// Options are displayed in a table.
  table,

  /// Options are displayed in a bordered panel.
  panel,

  /// Options are displayed as cards in a horizontal row.
  cards,

  /// Options are displayed as cards in a vertical column.
  stackedCards,
}

/// A collection of [RadioGroupOption]s.
class RadioGroup<T> extends StatelessWidget {
  const RadioGroup._({
    required this.options,
    required this.style,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  const RadioGroup.simpleList({
    required List<RadioGroupSimpleOption<T>> this.options,
    bool inline = false,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : style = inline
           ? RadioGroupStyle.simpleListInline
           : RadioGroupStyle.simpleList;

  const RadioGroup.simpleListWithTrailingRadio({
    required List<RadioGroupSimpleOption<T>> this.options,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : style = RadioGroupStyle.simpleListWithTrailingRadio;

  const RadioGroup.listWithDescription({
    required List<RadioGroupSimpleOptionWithDescription<T>> this.options,
    bool inlineDescription = false,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : style = inlineDescription
           ? RadioGroupStyle.listWithInlineDescription
           : RadioGroupStyle.listWithDescription;

  const RadioGroup.listWithTrailingRadio({
    required List<RadioGroupSimpleOptionWithDescription<T>> this.options,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : style = RadioGroupStyle.listWithTrailingRadio;

  const RadioGroup.table({
    required List<RadioGroupTableRowOption<T>> this.options,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : style = RadioGroupStyle.table;

  const RadioGroup.panel({
    required List<RadioGroupSimpleOptionWithDescription<T>> this.options,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : style = RadioGroupStyle.panel;

  const RadioGroup.cards({
    required List<RadioGroupTableRowOption<T>> this.options,
    bool stacked = false,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : style = stacked ? RadioGroupStyle.stackedCards : RadioGroupStyle.cards;

  /// The style of this group
  final RadioGroupStyle style;

  /// An optional title. Typically a [Text]
  final Widget? title;

  /// An optional subtitle. Typically a [Text].
  final Widget? subtitle;

  /// The currently selected value of this radio group.
  final T? value;

  /// The options to display
  final List<RadioGroupOption<T>> options;

  /// Called when an option is selected.
  final ValueChanged<T?>? onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: Spacing.s2,
      children: [
        if (title != null)
          DefaultTextStyle(style: context.typography.h3, child: title!),
        if (title != null)
          DefaultTextStyle(
            style: context.typography.p3.copyWith(
              color: context.colorScheme.textMuted,
            ),
            child: subtitle!,
          ),
        const SizedBox(height: 4),
        switch (style) {
          RadioGroupStyle.simpleList => _simpleList(
            context,
            trailingRadio: false,
          ),
          RadioGroupStyle.simpleListInline => _simpleListInline(context),
          RadioGroupStyle.simpleListWithTrailingRadio => _simpleList(
            context,
            trailingRadio: true,
          ),
          RadioGroupStyle.listWithDescription => _simpleListWithDescription(
            context,
            trailingRadio: false,
            inlineDescription: false,
            showDividers: false,
          ),
          RadioGroupStyle.listWithInlineDescription =>
            _simpleListWithDescription(
              context,
              trailingRadio: false,
              inlineDescription: true,
              showDividers: false,
            ),
          RadioGroupStyle.listWithTrailingRadio => _simpleListWithDescription(
            context,
            trailingRadio: true,
            inlineDescription: false,
            showDividers: true,
          ),
          RadioGroupStyle.table => _table(context),
          RadioGroupStyle.panel => _panel(context),
          // TODO: Handle this case.
          RadioGroupStyle.cards => throw UnimplementedError(),
          // TODO: Handle this case.
          RadioGroupStyle.stackedCards => throw UnimplementedError(),
        },
      ],
    );
  }

  Widget _simpleList(BuildContext context, {required bool trailingRadio}) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: Spacing.s4,
      children: [
        for (final option in options.cast<RadioGroupSimpleOption<T>>())
          Radio(
            value: option.value == value,
            label: option.label,
            onSelected: (value) {
              onOptionSelected?.call(value ? option.value : null);
            },
            trailingRadio: trailingRadio,
          ),
      ],
    );
  }

  Widget _simpleListInline(BuildContext context) {
    return Wrap(
      spacing: Spacing.s4,
      runSpacing: Spacing.s4,
      children: [
        for (final option in options.cast<RadioGroupSimpleOption<T>>())
          Radio(
            value: option.value == value,
            label: option.label,
            onSelected: (value) {
              onOptionSelected?.call(value ? option.value : null);
            },
          ),
      ],
    );
  }

  Widget _simpleListWithDescription(
    BuildContext context, {
    required bool trailingRadio,
    required bool inlineDescription,
    required bool showDividers,
  }) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: Spacing.s4,
      children: [
        for (final option
            in options.cast<RadioGroupSimpleOptionWithDescription<T>>()) ...[
          Radio(
            value: option.value == value,
            label: inlineDescription
                ? Row(
                    spacing: Spacing.s2,
                    children: [
                      option.label,
                      DefaultTextStyle(
                        style: context.typography.p3.copyWith(
                          color: context.colorScheme.textMuted,
                        ),
                        child: option.description,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: .stretch,
                    mainAxisSize: .min,
                    spacing: Spacing.s1,
                    children: [
                      option.label,
                      DefaultTextStyle(
                        style: context.typography.p3.copyWith(
                          color: context.colorScheme.textMuted,
                        ),
                        child: option.description,
                      ),
                    ],
                  ),
            onSelected: (value) {
              onOptionSelected?.call(value ? option.value : null);
            },
            trailingRadio: trailingRadio,
          ),
          if (showDividers && option != options.last) const Divider(),
        ],
      ],
    );
  }

  Widget _table(BuildContext context) {
    return Container(
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: Radii.lgAll,
        border: .all(color: context.colorScheme.border),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          for (final option in options.cast<RadioGroupTableRowOption<T>>()) ...[
            Container(
              key: ValueKey(option),
              color: option.value == value
                  ? context.colorScheme.brandSoft
                  : null,
              child: MouseRegion(
                cursor: onOptionSelected != null
                    ? SystemMouseCursors.click
                    : .defer,
                child: GestureDetector(
                  onTap: onOptionSelected != null
                      ? () => onOptionSelected!(option.value)
                      : null,
                  child: Padding(
                    padding: const .all(Spacing.s4),
                    child: DefaultTextStyle(
                      style: context.typography.p3,
                      child: Row(
                        spacing: Spacing.s4,
                        children: [
                          RadioIndicator(
                            value: option.value == value,
                            size: .small,
                          ),
                          for (final c in option.columns) Expanded(child: c),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (option != options.last) const Divider(),
          ],
        ],
      ),
    );
  }

  Widget _panel(BuildContext context) {
    return Container(
      clipBehavior: .antiAlias,
      decoration: BoxDecoration(
        borderRadius: Radii.lgAll,
        border: .all(color: context.colorScheme.border),
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          for (final option
              in options.cast<RadioGroupSimpleOptionWithDescription<T>>()) ...[
            Container(
              key: ValueKey(option),
              color: option.value == value
                  ? context.colorScheme.brandSoft
                  : null,
              child: MouseRegion(
                cursor: onOptionSelected != null
                    ? SystemMouseCursors.click
                    : .defer,
                child: GestureDetector(
                  onTap: onOptionSelected != null
                      ? () => onOptionSelected!(option.value)
                      : null,
                  child: Padding(
                    padding: const .all(Spacing.s2),
                    child: DefaultTextStyle(
                      style: context.typography.p3,
                      child: Row(
                        crossAxisAlignment: .start,
                        spacing: Spacing.s2,
                        children: [
                          Padding(
                            padding: const .symmetric(
                              vertical: Spacing.s1,
                              horizontal: Spacing.s1,
                            ),
                            child: RadioIndicator(
                              value: option.value == value,
                              size: .small,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .stretch,
                              spacing: Spacing.s1,
                              children: [
                                option.label,
                                DefaultTextStyle(
                                  style: context.typography.p3.copyWith(
                                    color: context.colorScheme.textMuted,
                                  ),
                                  child: option.description,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (option != options.last) const Divider(),
          ],
        ],
      ),
    );
  }
}
