---
title: ErrorState
---

# ErrorState

An error state widget for showing failure feedback with an optional retry.

## When to use it

Use `ErrorState` to communicate a failed data load, network error, or other
recoverable failure, with an optional "Retry" action. Internally it composes
an [EmptyState](/components/organisms/empty-state) with danger-toned
colouring. Use `ErrorState.large` for a more prominent full-page version.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
ErrorState(
  title: const Text('Something went wrong'),
  description: const Text('Check your connection and try again.'),
  onRetry: _reload,
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `Widget` | required | The primary error heading. |
| `icon` | `IconData?` | `null` | The icon inside the red circle. Falls back to `Iconography.alertIcon`. |
| `description` | `Widget?` | `null` | An optional supporting description. |
| `onRetry` | `VoidCallback?` | `null` | When non-null, a "Retry" button is shown. |

### `ErrorState.large`

An alternate constructor with the same parameters, rendering an 88px icon
circle (via `EmptyState.large`) instead of the default 64px.

## Iconography

The icon inside the danger-toned circle uses `icon`, falling back to
`context.iconography.alertIcon`.
