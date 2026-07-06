---
title: Text Field
---

# Text Field

A styled single- or multi-line text input field.

## When to use it

Use `TextField` for any free-text input in a form — names, emails, search
boxes, or multi-line notes. Supports labels, placeholder text, helper/error
messages, and leading and trailing widgets. Either `controller` or
`initialValue` may be provided, not both.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
TextField(
  label: 'Email',
  placeholder: 'you@example.com',
  required: true,
  onChanged: (v) => setState(() => _email = v),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String?` | `null` | An optional label rendered above the input. |
| `controller` | `TextEditingController?` | `null` | An optional controller for reading and writing text programmatically. |
| `initialValue` | `String?` | `null` | Initial text when no `controller` is provided. |
| `onChanged` | `ValueChanged<String>?` | `null` | Called whenever the text changes. |
| `onSubmitted` | `void Function(String)?` | `null` | Called when the user indicates that they are done editing the text in the field. |
| `placeholder` | `String?` | `null` | Hint text shown when the field is empty. |
| `helper` | `String?` | `null` | Helper text shown below the field in the default (non-error) state. |
| `error` | `String?` | `null` | When non-null, shows error styling with this message below the field. |
| `leading` | `Widget?` | `null` | An optional widget at the leading edge (e.g. an icon). |
| `trailing` | `Widget?` | `null` | An optional widget at the trailing edge (e.g. a clear button). |
| `keyboardType` | `TextInputType?` | `null` | The keyboard type to use on mobile. |
| `obscureText` | `bool` | `false` | Whether to obscure the text (e.g. for passwords). |
| `enabled` | `bool` | `true` | Whether the field accepts input. |
| `readOnly` | `bool` | `false` | When `true`, text is visible but not editable. |
| `required` | `bool` | `false` | When `true`, appends a red asterisk to `label`. |
| `size` | `TextFieldSize` | `TextFieldSize.medium` | The height variant. |
| `focusNode` | `FocusNode?` | `null` | An optional focus node for programmatic focus control. |
| `textInputAction` | `TextInputAction?` | `null` | The action button shown on the software keyboard. |
| `autocorrect` | `bool` | `true` | Whether autocorrect is enabled. |
| `smartDashesType` | `SmartDashesType?` | `null` | Smart dashes behaviour on iOS. |
| `smartQuotesType` | `SmartQuotesType?` | `null` | Smart quotes behaviour on iOS. |
| `maxLines` | `int?` | `1` | Maximum number of lines. Pass `null` for unlimited. |
| `minLines` | `int?` | `null` | Minimum number of lines for a multi-line field. |
| `expands` | `bool` | `false` | When `true`, the field expands to fill its parent. |
| `autofocus` | `bool` | `false` | Whether to auto-focus on first build. |
| `textCapitalization` | `TextCapitalization` | `TextCapitalization.none` | Controls platform keyboard capitalisation. |
| `inputFormatters` | `List<TextInputFormatter>?` | `null` | Input formatters applied on each change. |
| `autofillHints` | `Iterable<String>?` | `[]` | Autofill hints passed to the platform autofill service. |

An assertion enforces that `controller` and `initialValue` are not both
provided.

## Sizes

`TextFieldSize` values: `small` (44px), `medium` (48px, default), `large`
(52px).
