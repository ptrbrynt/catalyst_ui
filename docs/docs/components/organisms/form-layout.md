---
title: FormLayout
---

# FormLayout

Displays a series of `FormLayoutGroup`s in a particular layout style.

## When to use it

Use `FormLayout` to compose a full form screen out of titled groups of
fields, with a consistent layout treatment (stacked, two-column, or
two-column with cards) and a row of footer buttons.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
FormLayout(
  style: FormLayoutStyle.twoColumn,
  groups: [
    FormLayoutGroup(
      title: const Text('Personal details'),
      subtitle: const Text('Used on your public profile'),
      fields: [
        TextField(label: 'Name', onChanged: (_) {}),
        TextField(label: 'Email', onChanged: (_) {}),
      ],
    ),
  ],
  footerButtons: [
    Button(
      label: const Text('Save'),
      onPressed: _onSave,
    ),
  ],
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `style` | `FormLayoutStyle` | required | How the groups will be laid out. |
| `groups` | `List<FormLayoutGroup>` | required | The `FormLayoutGroup`s to display. |
| `footerButtons` | `List<Widget>` | required | Widgets to display at the end of the form, typically `Button`s. |

### `FormLayoutGroup`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget` | required | The title of the group, typically a `Text` widget. |
| `fields` | `List<Widget>` | required | The form fields to display in this group. Typically `TextField`, `Radio`, or `Checkbox` widgets (any widget is supported). |
| `subtitle` | `Widget?` | `null` | The optional subtitle of the group, typically a `Text` widget. |

### `FormLayoutStyle`

Enum values:

- `stacked` — groups are displayed in a vertical column, with title and
  subtitle at the top followed by the fields.
- `twoColumn` — the title and subtitle are shown on the left side, and the
  fields on the right side.
- `twoColumnWithCards` — same as `twoColumn`, except the fields are wrapped
  in a [Card](/components/molecules/card).
