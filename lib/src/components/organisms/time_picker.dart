import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

// ── PickerTime ───────────────────────────────────────────────────────────────

/// An hour-and-minute pair produced by [TimePicker].
///
/// [hour] is always in 24-hour format (0–23); [minute] is 0–59.
@immutable
class PickerTime {
  /// Creates a [PickerTime].
  const PickerTime({required this.hour, required this.minute})
      : assert(hour >= 0 && hour <= 23, 'hour must be 0–23'),
        assert(
          minute >= 0 && minute <= 59,
          'minute must be 0–59',
        );

  /// Hour in 24-hour format (0–23).
  final int hour;

  /// Minute (0–59).
  final int minute;

  @override
  bool operator ==(Object other) =>
      other is PickerTime &&
      hour == other.hour &&
      minute == other.minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() =>
      '${hour.toString().padLeft(2, '0')}'
      ':${minute.toString().padLeft(2, '0')}';
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// A scroll-wheel time picker.
///
/// Shows drum-roll columns for hours and minutes, plus an AM/PM column when
/// [use24HourFormat] is `false`. The [hour] on the emitted [PickerTime] is
/// always in 24-hour format regardless of [use24HourFormat].
///
/// ```dart
/// TimePicker(
///   initialTime: PickerTime(hour: 9, minute: 30),
///   onTimeChanged: (t) => setState(() => _time = t),
/// )
/// ```
class TimePicker extends StatefulWidget {
  /// Creates a time picker.
  const TimePicker({
    required this.onTimeChanged,
    this.initialTime,
    this.use24HourFormat = true,
    super.key,
  });

  /// The initially displayed time. Defaults to midnight (00:00).
  final PickerTime? initialTime;

  /// When `false`, shows 1–12 hours and an AM/PM column.
  final bool use24HourFormat;

  /// Called whenever the selected time changes.
  final ValueChanged<PickerTime> onTimeChanged;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  static const double _itemExtent = 44;
  static const int _visibleItems = 5;

  late int _hour;
  late int _minute;
  late bool _isAm;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  FixedExtentScrollController? _amPmController;

  @override
  void initState() {
    super.initState();
    final t = widget.initialTime ??
        const PickerTime(hour: 0, minute: 0);
    _hour = t.hour;
    _minute = t.minute;
    _isAm = _hour < 12;

    _hourController = FixedExtentScrollController(
      initialItem: widget.use24HourFormat
          ? _hour
          : _hour12ScrollIndex(_hour),
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _minute,
    );
    if (!widget.use24HourFormat) {
      _amPmController = FixedExtentScrollController(
        initialItem: _isAm ? 0 : 1,
      );
    }
  }

  // Maps a 24-hour value to 0-based index in a 1–12 list.
  int _hour12ScrollIndex(int h24) {
    final h12 = h24 % 12; // 0 for noon/midnight → display 12
    return h12 == 0 ? 11 : h12 - 1;
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _amPmController?.dispose();
    super.dispose();
  }

  void _onHourChanged(int index) {
    if (widget.use24HourFormat) {
      _hour = index;
    } else {
      final h12 = index + 1; // wheel items are 1–12
      _hour = _isAm
          ? (h12 == 12 ? 0 : h12)
          : (h12 == 12 ? 12 : h12 + 12);
    }
    widget.onTimeChanged(PickerTime(hour: _hour, minute: _minute));
  }

  void _onMinuteChanged(int index) {
    _minute = index;
    widget.onTimeChanged(PickerTime(hour: _hour, minute: _minute));
  }

  void _onAmPmChanged(int index) {
    final wasAm = _isAm;
    _isAm = index == 0;
    if (wasAm != _isAm) {
      _hour = _isAm ? _hour - 12 : _hour + 12;
    }
    widget.onTimeChanged(PickerTime(hour: _hour, minute: _minute));
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    const height = _itemExtent * _visibleItems;
    const midTop = (height - _itemExtent) / 2;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: Radii.xlAll,
          border: Border.all(color: cs.border),
          boxShadow: context.shadows.sm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.s3),
          child: SizedBox(
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Selected-row highlight band
                Positioned(
                  top: midTop,
                  left: 0,
                  right: 0,
                  height: _itemExtent,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.subtle,
                      borderRadius: Radii.lgAll,
                      border: Border.all(color: cs.border),
                    ),
                  ),
                ),
                // Wheel columns
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _WheelColumn(
                          controller: _hourController,
                          itemCount:
                              widget.use24HourFormat ? 24 : 12,
                          itemExtent: _itemExtent,
                          onSelectedItemChanged: _onHourChanged,
                          label: (i) => widget.use24HourFormat
                              ? i.toString().padLeft(2, '0')
                              : (i + 1).toString().padLeft(2, '0'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.s1,
                        ),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontFamily: typo.fontFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: cs.text,
                            height: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _WheelColumn(
                          controller: _minuteController,
                          itemCount: 60,
                          itemExtent: _itemExtent,
                          onSelectedItemChanged: _onMinuteChanged,
                          label: (i) =>
                              i.toString().padLeft(2, '0'),
                        ),
                      ),
                      if (!widget.use24HourFormat) ...[
                        const SizedBox(width: Spacing.s2),
                        SizedBox(
                          width: 52,
                          child: _WheelColumn(
                            controller: _amPmController!,
                            itemCount: 2,
                            itemExtent: _itemExtent,
                            onSelectedItemChanged: _onAmPmChanged,
                            label: (i) => i == 0 ? 'AM' : 'PM',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Fade overlay — blends wheel edges into surface colour
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            cs.surface,
                            cs.surface.withValues(alpha: 0),
                            cs.surface.withValues(alpha: 0),
                            cs.surface,
                          ],
                          stops: const [0, 0.22, 0.78, 1],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _WheelColumn extends StatelessWidget {
  const _WheelColumn({
    required this.controller,
    required this.itemCount,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required this.label,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final double itemExtent;
  final ValueChanged<int> onSelectedItemChanged;
  final String Function(int) label;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;

    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent,
      onSelectedItemChanged: onSelectedItemChanged,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 2.5,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (_, index) => Center(
          child: Text(
            label(index),
            style: TextStyle(
              fontFamily: typo.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: cs.text,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
