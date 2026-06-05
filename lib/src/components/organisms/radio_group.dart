import 'package:catalyst_ui/catalyst_ui.dart';
import 'package:flutter/widgets.dart';

/// An option for a [RadioGroup] with a label and optional description.
///
/// Use with [RadioGroup.simpleList], [RadioGroup.simpleListWithTrailingRadio],
/// [RadioGroup.listWithDescription], [RadioGroup.listWithTrailingRadio], and
/// [RadioGroup.panel].
@immutable
class RadioGroupOption<T> {
  /// Creates a [RadioGroupOption].
  const RadioGroupOption({
    required this.value,
    required this.label,
    this.description,
  });

  /// The value represented by this option.
  final T value;

  /// The primary label. Typically a [Text] widget.
  final Widget label;

  /// An optional description. Typically a [Text] widget.
  final Widget? description;
}

/// An option for a [RadioGroup] displayed as a table row.
///
/// Use with [RadioGroup.table].
@immutable
class RadioGroupTableOption<T> {
  /// Creates a [RadioGroupTableOption].
  const RadioGroupTableOption({
    required this.value,
    required this.columns,
  });

  /// The value represented by this option.
  final T value;

  /// The columns to display in this row.
  final List<Widget> columns;
}

/// An option for a [RadioGroup] displayed as a card.
///
/// Use with [RadioGroup.cards].
@immutable
class RadioGroupCardOption<T> {
  /// Creates a [RadioGroupCardOption].
  const RadioGroupCardOption({
    required this.value,
    required this.childBuilder,
  });

  /// The value represented by this option.
  final T value;

  /// The columns to display in this row.
  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext context, bool isSelected) childBuilder;
}

enum _RadioGroupStyle {
  simpleList,
  simpleListInline,
  simpleListWithTrailingRadio,
  listWithDescription,
  listWithInlineDescription,
  listWithTrailingRadio,
  table,
  panel,
  cards,
  stackedCards,
}

/// A collection of selectable options rendered as a radio group.
class RadioGroup<T> extends StatelessWidget {
  /// A simple vertical list of options.
  ///
  /// Set [inline] to `true` to display options in a horizontal wrap layout.
  const RadioGroup.simpleList({
    required List<RadioGroupOption<T>> this.options,
    bool inline = false,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : tableOptions = null,
       cardOptions = null,
       _style = inline
           ? _RadioGroupStyle.simpleListInline
           : _RadioGroupStyle.simpleList,
       assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  /// A simple vertical list of options with the radio indicator on the right.
  const RadioGroup.simpleListWithTrailingRadio({
    required List<RadioGroupOption<T>> this.options,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : tableOptions = null,
       cardOptions = null,
       _style = _RadioGroupStyle.simpleListWithTrailingRadio,
       assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  /// A vertical list of options with descriptions.
  ///
  /// Set [inlineDescription] to `true` to display the description alongside
  /// the label instead of below it.
  const RadioGroup.listWithDescription({
    required List<RadioGroupOption<T>> this.options,
    bool inlineDescription = false,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : tableOptions = null,
       cardOptions = null,
       _style = inlineDescription
           ? _RadioGroupStyle.listWithInlineDescription
           : _RadioGroupStyle.listWithDescription,
       assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  /// A vertical list of options with descriptions and the radio indicator on
  /// the right.
  const RadioGroup.listWithTrailingRadio({
    required List<RadioGroupOption<T>> this.options,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : tableOptions = null,
       cardOptions = null,
       _style = _RadioGroupStyle.listWithTrailingRadio,
       assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  /// Options displayed in a bordered table with multiple columns per row.
  const RadioGroup.table({
    required List<RadioGroupTableOption<T>> this.tableOptions,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : options = null,
       cardOptions = null,
       _style = _RadioGroupStyle.table,
       assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  /// Options displayed in a bordered panel.
  const RadioGroup.panel({
    required List<RadioGroupOption<T>> this.options,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : tableOptions = null,
       cardOptions = null,
       _style = _RadioGroupStyle.panel,
       assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  /// Options displayed as cards.
  ///
  /// Set [stacked] to `true` to display cards in a vertical column instead of
  /// a horizontal row.
  const RadioGroup.cards({
    required List<RadioGroupCardOption<T>> this.cardOptions,
    bool stacked = false,
    this.title,
    this.subtitle,
    this.value,
    this.onOptionSelected,
    super.key,
  }) : options = null,
       tableOptions = null,
       _style = stacked
           ? _RadioGroupStyle.stackedCards
           : _RadioGroupStyle.cards,
       assert(
         !(subtitle != null && title == null),
         'Cannot have a subtitle without a title',
       );

  /// Options for list and panel layouts. Null when using table or card layouts.
  final List<RadioGroupOption<T>>? options;

  /// Options for table layouts. Null when using other layouts.
  final List<RadioGroupTableOption<T>>? tableOptions;

  /// Options for card layouts. Null when using other layouts.
  final List<RadioGroupCardOption<T>>? cardOptions;

  final _RadioGroupStyle _style;

  /// An optional title. Typically a [Text].
  final Widget? title;

  /// An optional subtitle. Typically a [Text].
  final Widget? subtitle;

  /// The currently selected value.
  final T? value;

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
        if (subtitle != null)
          DefaultTextStyle(
            style: context.typography.p3.copyWith(
              color: context.colorScheme.textMuted,
            ),
            child: subtitle!,
          ),
        const SizedBox(height: 4),
        switch (_style) {
          _RadioGroupStyle.simpleList => _simpleList(
            context,
            trailingRadio: false,
          ),
          _RadioGroupStyle.simpleListInline => _simpleListInline(context),
          _RadioGroupStyle.simpleListWithTrailingRadio => _simpleList(
            context,
            trailingRadio: true,
          ),
          _RadioGroupStyle.listWithDescription => _simpleListWithDescription(
            context,
            trailingRadio: false,
            inlineDescription: false,
            showDividers: false,
          ),
          _RadioGroupStyle.listWithInlineDescription =>
            _simpleListWithDescription(
              context,
              trailingRadio: false,
              inlineDescription: true,
              showDividers: false,
            ),
          _RadioGroupStyle.listWithTrailingRadio => _simpleListWithDescription(
            context,
            trailingRadio: true,
            inlineDescription: false,
            showDividers: true,
          ),
          _RadioGroupStyle.table => _table(context),
          _RadioGroupStyle.panel => _panel(context),

          _RadioGroupStyle.cards => _cards(context, false),

          _RadioGroupStyle.stackedCards => _cards(context, true),
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
        for (final option in options!)
          Radio(
            value: option.value == value,
            label: option.label,
            onSelected: (selected) {
              onOptionSelected?.call(selected ? option.value : null);
            },
            trailingRadio: trailingRadio,
            fullWidth: true,
          ),
      ],
    );
  }

  Widget _simpleListInline(BuildContext context) {
    return Wrap(
      spacing: Spacing.s4,
      runSpacing: Spacing.s4,
      children: [
        for (final option in options!)
          Radio(
            value: option.value == value,
            label: option.label,
            onSelected: (selected) {
              onOptionSelected?.call(selected ? option.value : null);
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
    final opts = options!;
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: Spacing.s4,
      children: [
        for (final option in opts) ...[
          Radio(
            value: option.value == value,
            fullWidth: true,
            label: inlineDescription
                ? Row(
                    spacing: Spacing.s2,
                    children: [
                      option.label,
                      if (option.description != null)
                        DefaultTextStyle(
                          style: context.typography.caption.copyWith(
                            color: context.colorScheme.textMuted,
                          ),
                          child: option.description!,
                        ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: .stretch,
                    mainAxisSize: .min,
                    spacing: Spacing.s1,
                    children: [
                      option.label,
                      if (option.description != null)
                        DefaultTextStyle(
                          style: context.typography.p3.copyWith(
                            color: context.colorScheme.textMuted,
                          ),
                          child: option.description!,
                        ),
                    ],
                  ),
            onSelected: (selected) {
              onOptionSelected?.call(selected ? option.value : null);
            },
            trailingRadio: trailingRadio,
          ),
          if (showDividers && option != opts.last) const Divider(),
        ],
      ],
    );
  }

  Widget _table(BuildContext context) {
    final opts = tableOptions!;
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
          for (final option in opts) ...[
            MouseRegion(
              key: ValueKey(option),
              cursor: onOptionSelected != null
                  ? SystemMouseCursors.click
                  : .defer,
              child: GestureDetector(
                onTap: onOptionSelected != null
                    ? () => onOptionSelected!(option.value)
                    : null,
                child: Container(
                  color: option.value == value
                      ? context.colorScheme.brandSoft
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
            if (option != opts.last) const Divider(),
          ],
        ],
      ),
    );
  }

  Widget _panel(BuildContext context) {
    final opts = options!;
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
          for (final option in opts) ...[
            MouseRegion(
              key: ValueKey(option),
              cursor: onOptionSelected != null
                  ? SystemMouseCursors.click
                  : .defer,
              child: GestureDetector(
                onTap: onOptionSelected != null
                    ? () => onOptionSelected!(option.value)
                    : null,
                child: Container(
                  color: option.value == value
                      ? context.colorScheme.brandSoft
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
                                if (option.description != null)
                                  DefaultTextStyle(
                                    style: context.typography.p3.copyWith(
                                      color: context.colorScheme.textMuted,
                                    ),
                                    child: option.description!,
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
            if (option != opts.last) const Divider(),
          ],
        ],
      ),
    );
  }

  Widget _cards(BuildContext context, bool stacked) {
    final opts = cardOptions!;
    final widgets = [
      for (final option in opts)
        MouseRegion(
          key: ValueKey(option),
          cursor: onOptionSelected != null ? SystemMouseCursors.click : .defer,
          child: GestureDetector(
            onTap: onOptionSelected != null
                ? () => onOptionSelected!(option.value)
                : null,
            child: Container(
              constraints: stacked ? const BoxConstraints() : null,
              decoration: BoxDecoration(
                color: option.value == value
                    ? context.colorScheme.brandSoft
                    : null,
                border: option.value == value
                    ? .all(color: context.colorScheme.brand)
                    : .all(color: context.colorScheme.border),
                borderRadius: Radii.mdAll,
              ),
              padding: const .all(Spacing.s4),
              child: option.childBuilder(context, option.value == value),
            ),
          ),
        ),
    ];
    if (stacked) {
      return Column(
        crossAxisAlignment: .stretch,
        spacing: Spacing.s4,
        children: widgets,
      );
    }
    return Wrap(
      spacing: Spacing.s4,
      runSpacing: Spacing.s4,
      children: widgets,
    );
  }
}
