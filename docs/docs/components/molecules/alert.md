---
title: Alert
---

# Alert

An inline notification banner used to convey contextual feedback.

## When to use it

Use `Alert` to surface a contextual message inline in a layout — for example,
a form validation summary, a status banner, or a maintenance notice. Supply
`title` and/or `children` for message content. An optional `action` (e.g. a
`Button`) sits below the body. Provide `onDismiss` to show a close button.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Alert(
  tone: AlertTone.warning,
  icon: const Icon(Icons.warning_amber),
  title: const Text('Action required'),
  children: const [Text('Your subscription is about to expire.')],
  onDismiss: _handleDismiss,
  dismissIcon: Icons.close,
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `tone` | `AlertTone` | `AlertTone.info` | The semantic colour and icon of the alert. |
| `title` | `Widget?` | `null` | An optional bold title rendered above `children`. |
| `children` | `List<Widget>?` | `null` | Optional body content below `title`. |
| `action` | `Widget?` | `null` | An optional action widget (e.g. a button) below the body. |
| `icon` | `Widget?` | `null` | An optional icon to display at the start of the alert. |
| `onDismiss` | `VoidCallback?` | `null` | When provided, shows a dismiss button in the top-right corner. |
| `dismissIcon` | `IconData?` | `null` | Icon to display on the dismiss button. Must be provided when `onDismiss` is provided. |

An assertion enforces that `dismissIcon` is non-null whenever `onDismiss` is
provided.

## Tones

`AlertTone` presets:

- `AlertTone.info` — blue tint; general informational message.
- `AlertTone.success` — green tint; positive or completed-action message.
- `AlertTone.warning` — amber tint; cautionary message.
- `AlertTone.danger` — red tint; error or destructive-action message.

Each tone resolves to an `AlertToneStyle` with a `backgroundColor` (tinted
banner background) and `accentColor` (icon and border-tint colour). Define
your own by subclassing `AlertTone` and implementing `resolve`:

```dart
class MaintenanceTone extends AlertTone {
  const MaintenanceTone();

  @override
  AlertToneStyle resolve(ColorScheme cs) => AlertToneStyle(
    backgroundColor: cs.warningSoft,
    accentColor: cs.warning,
  );
}
```

See [Variants & Tones](/architecture/variants-and-tones) for the full pattern.
