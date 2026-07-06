---
title: Snackbar
---

# Snackbar

A brief overlay notification typically shown at the bottom of the screen.

## When to use it

Use `Snackbar` for transient, non-blocking feedback after a user action,
such as "Changes saved" or an error message. Display it via
`SnackbarHandler` or the `context.showSnackbar` extension rather than
placing it directly in the widget tree.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
context.showSnackbar(
  Snackbar.success(
    message: const Text('Changes saved'),
    icon: const Icon(Icons.check_circle),
    action: SnackbarAction(label: 'Undo', onPressed: _undo),
  ),
);
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `message` | `Widget` | required | The main message content, typically a `Text` widget. |
| `tone` | `SnackbarTone` | `SnackbarTone.dark` | The colour style. |
| `action` | `SnackbarAction?` | `null` | An optional action shown at the trailing edge. |
| `icon` | `Widget?` | `null` | An optional icon at the leading edge. |

### `Snackbar.success`

Creates a green success snackbar. Requires `message`; also accepts `icon`
and `action`. `tone` is fixed to `SnackbarTone.success`.

### `Snackbar.danger`

Creates a red error snackbar. Requires `message`; also accepts `icon` and
`action`. `tone` is fixed to `SnackbarTone.danger`.

### `SnackbarAction`

An optional call-to-action embedded in a `Snackbar`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `label` | `String` | required | The text label. |
| `onPressed` | `VoidCallback` | required | Called when the action is tapped. |

## Tones

`SnackbarTone` presets:

- `SnackbarTone.dark` — dark/inverse background (default).
- `SnackbarTone.success` — green background for success feedback.
- `SnackbarTone.danger` — red background for error feedback.

Each tone resolves to a `SnackbarToneStyle` with a `backgroundColor` and
`foregroundColor`. Define your own by subclassing `SnackbarTone` and
implementing `resolve`:

```dart
class BrandSnackbarTone extends SnackbarTone {
  const BrandSnackbarTone();

  @override
  SnackbarToneStyle resolve(ColorScheme cs) => SnackbarToneStyle(
    backgroundColor: cs.brand,
    foregroundColor: cs.onBrand,
  );
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
