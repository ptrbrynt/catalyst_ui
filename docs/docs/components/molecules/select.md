---
title: Select
---

# Select

A dropdown field for selecting a single value from a list of options.

## When to use it

Use `Select<T>` for a single-choice dropdown field, such as a country picker
or a form field with a fixed set of options. The `options` list accepts
`SelectOption` entries and `SelectDivider` entries, which render as a thin
horizontal separator between groups. `SelectOption` entries may include an
optional icon displayed to the left of the label in both the trigger and the
dropdown rows.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Select<String>(
  label: 'Country',
  placeholder: 'Pick a country…',
  value: _country,
  options: const [
    SelectOption(
      value: 'gb',
      label: 'United Kingdom',
      icon: MyIcons.flagGb,
    ),
    SelectOption(value: 'us', label: 'United States'),
    SelectDivider(),
    SelectOption(value: 'ca', label: 'Canada'),
  ],
  onChanged: (v) => setState(() => _country = v),
)
```

## Parameters

`Select<T>` is generic over the option value type `T`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | `null` | An optional label rendered above the trigger. |
| `value` | `T?` | `null` | The currently selected value, or `null` for no selection. |
| `onChanged` | `ValueChanged<T>?` | `null` | Called when the user selects a different option. |
| `options` | `List<SelectItem<T>>` | `[]` | The list of items shown in the dropdown. May contain `SelectOption` entries and `SelectDivider` entries. |
| `placeholder` | `String?` | `'Select…'` | Placeholder text when no value is selected. |
| `disabled` | `bool` | `false` | When `true`, the field is non-interactive. |
| `helper` | `String?` | `null` | Helper text below the trigger. |
| `error` | `String?` | `null` | When non-null, shows error styling with this message. |
| `size` | `SelectSize` | `SelectSize.medium` | The height variant. |
| `trailingIcon` | `IconData?` | `null` | Icon to display at the end of the field. Falls back to `Iconography.expandIcon`. |
| `checkIcon` | `IconData?` | `null` | Icon to display on selected options. Falls back to `Iconography.checkIcon`. |

### `SelectItem<T>`

A sealed base class for items that can appear in a `Select` dropdown. Use
`SelectOption` for selectable entries and `SelectDivider` to insert a visual
separator between groups.

### `SelectOption<T>`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value this option represents. |
| `label` | `String` | required | The text label displayed in the dropdown and trigger. |
| `icon` | `IconData?` | `null` | Optional icon displayed to the left of the `label` in both the trigger and the dropdown row. |

### `SelectDivider<T>`

A visual divider placed between groups of options in a `Select` dropdown.
Takes no parameters.

## Sizes

`SelectSize` values: `small` (44px trigger), `medium` (48px, default),
`large` (52px).

## Iconography

- The trailing expand/collapse icon uses `trailingIcon`, falling back to
  `context.iconography.expandIcon` (the field does not distinguish an
  open/closed variant via `collapseIcon` — it rotates the `expandIcon` 180°
  when open).
- The check icon shown next to the selected option in the dropdown uses
  `checkIcon`, falling back to `context.iconography.checkIcon`.
