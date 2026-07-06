---
title: Stepper
---

# Stepper

A horizontal step indicator showing progress through a multi-step flow.

## When to use it

Use `Stepper` to visualise a user's progress through a multi-step process,
such as an onboarding or checkout flow. Completed steps show a check mark;
the active step shows its number in an outlined circle; future steps are
greyed out.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Stepper(
  current: 1,
  steps: const ['Account', 'Details', 'Review'],
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `current` | `int` | required | The zero-based index of the currently active step. |
| `steps` | `List<String>` | required | The ordered list of step labels. |
| `checkIcon` | `IconData?` | `null` | Icon to display on completed steps. Falls back to `Iconography.checkIcon`. |

## Iconography

Completed steps show `checkIcon`, falling back to
`context.iconography.checkIcon`.
