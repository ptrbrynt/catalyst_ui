---
title: Spinner
---

# Spinner

An animated circular loading indicator.

## When to use it

Use a `Spinner` to indicate an in-progress operation — for example, inside a
`Button` in its `loading` state, or as a standalone loading indicator. The
spinner continuously rotates a quarter-arc on a faded track ring.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
const Spinner()

const Spinner.large(color: Colors.red)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `size` | `double` | `20` | The diameter of the spinner in logical pixels. |
| `color` | `Color?` | `null` | The arc colour. Defaults to `context.colorScheme.brand` when `null`. |

### Named size constructors

- `Spinner.small` — 16px diameter.
- `Spinner.large` — 28px diameter.
- `Spinner.extraLarge` — 36px diameter.

Each accepts an optional `color` parameter.
