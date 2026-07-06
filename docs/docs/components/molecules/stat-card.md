---
title: Stat Card
---

# Stat Card

A compact card displaying a metric with a title, value, trend, and icon.

## When to use it

Use `StatCard` in a dashboard or summary grid to highlight a single metric
alongside its trend, such as revenue or active-user counts.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
StatCard(
  title: 'Revenue',
  value: '£12,400',
  trend: 'vs last month',
  delta: StatDelta.positive,
  icon: const Icon(Icons.trending_up),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `title` | `String` | required | The metric label shown above the value. |
| `value` | `String` | required | The formatted metric value. |
| `trend` | `String` | required | A short trend description (e.g. `'vs last month'`). |
| `icon` | `Icon` | required | An icon in the top-right corner. |
| `delta` | `StatDelta` | required | The direction of the trend. |
| `unit` | `String?` | `null` | An optional unit string shown next to `value` (e.g. `'kg'`). |
| `primary` | `bool` | `false` | When `true`, renders the card with a brand background. |

### `StatDelta`

The direction of a metric trend shown on a `StatCard`.

- `StatDelta.positive` — the metric has increased; shown in green (`↑`).
- `StatDelta.negative` — the metric has decreased; shown in red (`↓`).
- `StatDelta.neutral` — the metric is unchanged; shown in muted colour (`→`).

`StatCard` renders internally with `Card`, using `CardTone.brand` when
`primary` is `true` and `CardTone.surface` otherwise.
