---
title: Motion
---

# Motion

The set of animation presets used by Catalyst components.

Pass a custom `Motion` to `ThemeData` to change durations and curves
globally across the library. Each preset is a `MotionSpec` — a record
typedef pairing a `Duration` with a `Curve`:

```dart
typedef MotionSpec = ({Duration duration, Curve curve});
```

## Fields

| Field | Type | Default duration | Default curve | Description |
|---|---|---|---|---|
| `micro` | `MotionSpec` | 120 ms | `Curves.easeOut` | Immediate micro-interactions (hover, press). |
| `standard` | `MotionSpec` | 200 ms | `Cubic(0.2, 0, 0, 1)` | State transitions within a view. |
| `enter` | `MotionSpec` | 300 ms | `Cubic(0.2, 0, 0, 1)` | Elements entering the screen. |
| `exit` | `MotionSpec` | 200 ms | `Cubic(0.4, 0, 1, 1)` | Elements leaving the screen. |

All constructor parameters have sensible defaults, so you only need to
supply the presets you want to override.

## Overriding

```dart
ThemeData.light(
  iconography: appIconography,
  motion: const Motion(
    micro: (duration: Duration(milliseconds: 80), curve: Curves.easeOut),
  ),
);
```

Components read the active presets via `context.motion.micro`,
`context.motion.standard`, `context.motion.enter`, and
`context.motion.exit`.
