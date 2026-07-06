---
title: Action Tile
---

# Action Tile

A tappable tile with a circular icon, title, optional subtitle, and optional
badge.

## When to use it

Use an `ActionTile` to represent a navigable action, appointment, or task in
a list — for example, an item in a settings menu or a scheduled event card.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
ActionTile(
  icon: const Icon(Icons.calendar_today),
  iconBackgroundColor: const Color(0xFFEEF2FF),
  title: const Text('Book appointment'),
  onTap: _handleTap,
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `icon` | `Widget` | required | The icon inside the circular background. |
| `iconBackgroundColor` | `Color` | required | The background colour of the circular icon container. |
| `title` | `Widget` | required | The primary label. |
| `onTap` | `VoidCallback` | required | Called when the tile is tapped. |
| `subtitle` | `Widget?` | `null` | An optional secondary line below `title`. |
| `trailing` | `Widget?` | `null` | Optional widget to display at the end of the tile. |
| `badge` | `Badge?` | `null` | An optional `Badge` shown next to `title`. |
