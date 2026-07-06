---
title: AvatarStack
---

# AvatarStack

A horizontal stack of overlapping `Avatar` widgets.

## When to use it

Use an `AvatarStack` to show a compact preview of multiple participants —
for example, collaborators on a document or attendees of an event. Avatars
overlap at 75% of their size. When the list exceeds `maxCount`, a "+N"
overflow pill is shown at the end.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
AvatarStack(
  avatars: [
    Avatar(name: 'Jane Doe'),
    Avatar(name: 'John Smith'),
    Avatar(name: 'Alex Lee'),
  ],
  maxCount: 2,
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `avatars` | `List<Avatar>` | required | The list of avatars to display. |
| `maxCount` | `int?` | `avatars.length` | Maximum number shown before the overflow indicator appears. |
