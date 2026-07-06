---
title: TopBar
---

# TopBar

A horizontal top navigation bar for desktop/web layouts.

## When to use it

Use `TopBar<T>` as the primary navigation header for desktop/web apps.
Renders a 60px bar with an optional leading area (e.g. a logo), a set of
destinations, and trailing actions.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
TopBar<String>(
  leading: const FlutterLogo(),
  selectedItem: _section,
  onItemSelected: (v) => setState(() => _section = v),
  destinations: const [
    TopBarDestination(value: 'home', label: 'Home'),
    TopBarDestination(value: 'docs', label: 'Docs'),
  ],
  actions: [
    Button(label: const Text('Sign out'), onPressed: _onSignOut),
  ],
)
```

## Parameters

`TopBar<T>` is generic over the destination value type `T`.

| Parameter | Type | Default | Description |
|---|---|---|---|
| `destinations` | `List<TopBarDestination<T>>` | required | The list of navigation destinations. |
| `selectedItem` | `T` | required | The currently selected destination value. |
| `onItemSelected` | `ValueChanged<T>` | required | Called when the user taps a destination. |
| `leading` | `Widget?` | `null` | An optional widget on the far left. |
| `actions` | `List<Widget>` | `[]` | Optional action widgets on the far right. |

### `TopBarDestination<T>`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | `T` | required | The value that identifies this destination. |
| `label` | `String` | required | The text label displayed in the bar. |
