---
title: Avatar
---

# Avatar

A circular or rounded-square avatar displaying initials or a network image.

## When to use it

Use an `Avatar` to represent a user or entity — in lists, headers, comments,
or wherever a compact visual identity is needed. When `src` is omitted, the
widget derives up to two initials from `name` and picks a deterministic
background colour from a built-in palette. An optional `status` dot can be
rendered in the bottom-right corner to show presence.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Avatar(name: 'Jane Doe', size: 40)
Avatar(name: 'John Smith', src: 'https://…', status: AvatarStatus.online)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `name` | `String` | required | The user's display name; used to derive initials and a palette colour. |
| `src` | `String?` | `null` | An optional network image URL. When set, initials are hidden. |
| `size` | `double` | `40` | The diameter (or side length) of the avatar in logical pixels. |
| `color` | `Color?` | `null` | An override for the auto-selected background colour. |
| `shape` | `BoxShape` | `BoxShape.circle` | The shape of the avatar. |
| `status` | `AvatarStatus?` | `null` | An optional presence indicator in the bottom-right corner. |

## `AvatarStatus`

`AvatarStatus` values: `online`, `busy`, `away`. Each carries a fixed
indicator colour (green, red, and amber respectively).
