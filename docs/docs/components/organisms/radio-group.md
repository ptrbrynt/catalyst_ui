---
title: RadioGroup
---

# RadioGroup

A collection of selectable options rendered as a radio group.

## When to use it

Use `RadioGroup<T>` whenever a screen needs a mutually-exclusive set of
options — settings pickers, plan selectors, or survey questions. `RadioGroup`
has no default (unnamed) constructor; pick one of its named constructors
based on the desired visual layout: simple lists, lists with descriptions,
tables, panels, or cards.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
RadioGroup<String>.simpleList(
  title: const Text('Notification frequency'),
  value: _frequency,
  onOptionSelected: (v) => setState(() => _frequency = v),
  options: const [
    RadioGroupOption(value: 'daily', label: Text('Daily')),
    RadioGroupOption(value: 'weekly', label: Text('Weekly')),
  ],
)
```

## Parameters

`RadioGroup<T>` is generic over the option value type `T`. All constructors
share these parameters:

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget?` | `null` | An optional title. Typically a `Text`. |
| `subtitle` | `Widget?` | `null` | An optional subtitle. Typically a `Text`. Asserts if set without a `title`. |
| `value` | `T?` | `null` | The currently selected value. |
| `onOptionSelected` | `ValueChanged<T?>?` | `null` | Called when an option is selected. |

### `RadioGroup.simpleList`

A simple vertical list of options.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<RadioGroupOption<T>>` | required | The options to display. |
| `inline` | `bool` | `false` | When `true`, displays options in a horizontal wrap layout instead of a vertical list. |

### `RadioGroup.simpleListWithTrailingRadio`

A simple vertical list of options with the radio indicator on the right.
Takes `options` (required).

### `RadioGroup.listWithDescription`

A vertical list of options with descriptions.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `options` | `List<RadioGroupOption<T>>` | required | The options to display. |
| `inlineDescription` | `bool` | `false` | When `true`, displays the description alongside the label instead of below it. |

### `RadioGroup.listWithTrailingRadio`

A vertical list of options with descriptions and the radio indicator on the
right. Takes `options` (required); dividers are shown between rows.

### `RadioGroup.table`

Options displayed in a bordered table with multiple columns per row. Takes
`tableOptions: List<RadioGroupTableOption<T>>` (required).

### `RadioGroup.panel`

Options displayed in a bordered panel. Takes `options` (required).

### `RadioGroup.cards`

Options displayed as cards.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `cardOptions` | `List<RadioGroupCardOption<T>>` | required | The card options to display. |
| `stacked` | `bool` | `false` | When `true`, displays cards in a vertical column instead of a horizontal wrap. |

### `RadioGroupOption<T>`

Used by `simpleList`, `simpleListWithTrailingRadio`, `listWithDescription`,
`listWithTrailingRadio`, and `panel`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value represented by this option. |
| `label` | `Widget` | required | The primary label. Typically a `Text` widget. |
| `description` | `Widget?` | `null` | An optional description. Typically a `Text` widget. |

### `RadioGroupTableOption<T>`

Used by `RadioGroup.table`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value represented by this option. |
| `columns` | `List<Widget>` | required | The columns to display in this row. |

### `RadioGroupCardOption<T>`

Used by `RadioGroup.cards`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value represented by this option. |
| `childBuilder` | `Widget Function(BuildContext, bool isSelected)` | required | Builds the card content; `isSelected` reflects whether this option is currently selected. |

## Notes

Internally, `table` and `panel` layouts render each row's selection state
with [RadioIndicator](/components/atoms/radio) at `RadioSize.small`, while
list-style layouts (`simpleList` and its variants) render a full
[Radio](/components/atoms/radio) control per option.
