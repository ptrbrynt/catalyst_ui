---
title: Multi Select
---

# Multi Select

A dropdown field for selecting multiple values from a list of options.

## When to use it

Use `MultiSelect<T>` when a user needs to choose several options from a
list, such as tagging an item with multiple categories. The `options` list
accepts `SelectOption` entries and `SelectDivider` entries, which render as a
thin horizontal separator between groups. Unlike `Select`, the dropdown
stays open after a selection so users can toggle several options in one
session — it closes only when the user taps outside it or taps the trigger
again.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
MultiSelect<String>(
  label: 'Countries',
  placeholder: 'Pick countries…',
  value: _countries,
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
  onChanged: (v) => setState(() => _countries = v),
)
```

## Parameters

`MultiSelect<T>` is generic over the option value type `T`. It reuses the
`SelectOption<T>`, `SelectDivider<T>`, `SelectItem<T>`, and `SelectSize`
types defined alongside `Select`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | `null` | An optional label rendered above the trigger. |
| `value` | `List<T>` | `[]` | The currently selected values. |
| `onChanged` | `ValueChanged<List<T>>?` | `null` | Called with the full updated selection when the user toggles an option. |
| `options` | `List<SelectItem<T>>` | `[]` | The list of items shown in the dropdown. May contain `SelectOption` entries and `SelectDivider` entries. |
| `placeholder` | `String?` | `'Select…'` | Placeholder text when no value is selected. |
| `disabled` | `bool` | `false` | When `true`, the field is non-interactive. |
| `helper` | `String?` | `null` | Helper text below the trigger. |
| `error` | `String?` | `null` | When non-null, shows error styling with this message. |
| `size` | `SelectSize` | `SelectSize.medium` | The height variant. |
| `trailingIcon` | `IconData?` | `null` | Icon to display at the end of the field. Falls back to `Iconography.expandIcon`. |
| `checkIcon` | `IconData?` | `null` | Icon to display on selected options' checkboxes. Falls back to `Iconography.checkIcon`. |

See the [Select](/components/molecules/select) page for `SelectOption` and
`SelectDivider` field details.

## Sizes

`SelectSize` values: `small` (44px trigger), `medium` (48px, default),
`large` (52px).

## Iconography

- The trailing expand icon uses `trailingIcon`, falling back to
  `context.iconography.expandIcon`, and rotates 180° when the dropdown is
  open.
- Each option row renders a `Checkbox` whose `checkIcon` uses `checkIcon`,
  falling back to `context.iconography.checkIcon`.
