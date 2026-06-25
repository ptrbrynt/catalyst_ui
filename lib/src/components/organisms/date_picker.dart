import 'package:flutter/widgets.dart';

import '../../theme/extensions.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

// ── Month names & weekday abbreviations ──────────────────────────────────────

const _kMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _kDayAbbr = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

// ── Widget ───────────────────────────────────────────────────────────────────

/// A calendar-based date picker.
///
/// Displays a month grid and lets the user navigate months and tap a day to
/// select it. Constrain the selectable range with [firstDate] and [lastDate].
///
/// ```dart
/// DatePicker(
///   initialDate: DateTime.now(),
///   onDateChanged: (date) => setState(() => _date = date),
/// )
/// ```
class DatePicker extends StatefulWidget {
  /// Creates a date picker.
  const DatePicker({
    required this.onDateChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.backIcon,
    this.forwardIcon,
    super.key,
  });

  /// The initially selected date.
  final DateTime? initialDate;

  /// Earliest selectable date. `null` means no lower bound.
  final DateTime? firstDate;

  /// Latest selectable date. `null` means no upper bound.
  final DateTime? lastDate;

  /// Called whenever the user selects a date.
  final ValueChanged<DateTime> onDateChanged;

  /// Override for the previous-month icon.
  /// Falls back to [Iconography.backIcon].
  final IconData? backIcon;

  /// Override for the next-month icon.
  /// Falls back to [Iconography.forwardIcon].
  final IconData? forwardIcon;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(
      _selectedDate?.year ?? now.year,
      _selectedDate?.month ?? now.month,
    );
  }

  bool _canGoBack() {
    if (widget.firstDate == null) return true;
    final prev = DateTime(
      _displayedMonth.year,
      _displayedMonth.month - 1,
    );
    final first = DateTime(
      widget.firstDate!.year,
      widget.firstDate!.month,
    );
    return !prev.isBefore(first);
  }

  bool _canGoForward() {
    if (widget.lastDate == null) return true;
    final next = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
    );
    final last = DateTime(
      widget.lastDate!.year,
      widget.lastDate!.month,
    );
    return !next.isAfter(last);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  bool _isDisabled(DateTime date) {
    final fd = widget.firstDate;
    final ld = widget.lastDate;
    if (fd != null) {
      final floor = DateTime(fd.year, fd.month, fd.day);
      if (date.isBefore(floor)) return true;
    }
    if (ld != null) {
      final ceil = DateTime(ld.year, ld.month, ld.day);
      if (date.isAfter(ceil)) return true;
    }
    return false;
  }

  bool _isSelected(DateTime date) {
    final s = _selectedDate;
    if (s == null) return false;
    return date.year == s.year &&
        date.month == s.month &&
        date.day == s.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onDateChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    final motion = context.motion;
    final icons = context.iconography;

    final firstOfMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    // Offset from Monday (weekday 1) → column 0
    final startOffset = (firstOfMonth.weekday - 1) % 7;
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final rowCount = ((startOffset + daysInMonth) / 7).ceil();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: Radii.xlAll,
          border: Border.all(color: cs.border),
          boxShadow: context.shadows.sm,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.s3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Month navigation header ──────────────────────────────────
              Row(
                children: [
                  _NavButton(
                    icon: widget.backIcon ?? icons.backIcon,
                    enabled: _canGoBack(),
                    onTap: _previousMonth,
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: motion.standard.duration,
                      child: Text(
                        '${_kMonthNames[_displayedMonth.month - 1]}'
                        ' ${_displayedMonth.year}',
                        key: ValueKey(
                          '${_displayedMonth.year}-'
                          '${_displayedMonth.month}',
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: typo.fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: cs.text,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  _NavButton(
                    icon: widget.forwardIcon ?? icons.forwardIcon,
                    enabled: _canGoForward(),
                    onTap: _nextMonth,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.s3),
              // ── Weekday label row ────────────────────────────────────────
              Row(
                children: _kDayAbbr
                    .map(
                      (d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: TextStyle(
                              fontFamily: typo.fontFamily,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: cs.textSubtle,
                              letterSpacing: 0.5,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: Spacing.s2),
              // ── Day grid ─────────────────────────────────────────────────
              for (int row = 0; row < rowCount; row++) ...[
                if (row > 0) const SizedBox(height: Spacing.s1),
                Row(
                  children: List.generate(7, (col) {
                    final cell = row * 7 + col;
                    final day = cell - startOffset + 1;
                    if (day < 1 || day > daysInMonth) {
                      return const Expanded(
                        child: SizedBox(height: 36),
                      );
                    }
                    final date = DateTime(
                      _displayedMonth.year,
                      _displayedMonth.month,
                      day,
                    );
                    final disabled = _isDisabled(date);
                    return Expanded(
                      child: Center(
                        child: _DayCell(
                          day: day,
                          isSelected: _isSelected(date),
                          isToday: _isToday(date),
                          isDisabled: disabled,
                          onTap: disabled
                              ? null
                              : () => _selectDate(date),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _NavButton extends StatefulWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final motion = context.motion;

    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _hovered && widget.enabled
                ? cs.subtle
                : const Color(0x00000000),
            borderRadius: Radii.smAll,
          ),
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(
              color: widget.enabled
                  ? cs.textMuted
                  : cs.textDisabled,
              size: 16,
            ),
            child: Icon(widget.icon),
          ),
        ),
      ),
    );
  }
}

class _DayCell extends StatefulWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isDisabled,
    this.onTap,
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    final motion = context.motion;

    final Color bg;
    final Color fg;

    if (widget.isSelected) {
      bg = cs.brand;
      fg = cs.onBrand;
    } else if (_hovered && !widget.isDisabled) {
      bg = cs.muted;
      fg = cs.text;
    } else {
      bg = const Color(0x00000000);
      fg = widget.isDisabled
          ? cs.textDisabled
          : widget.isToday
              ? cs.brand
              : cs.text;
    }

    return MouseRegion(
      cursor: widget.isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: motion.micro.duration,
          curve: motion.micro.curve,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: Radii.smAll,
            border: widget.isToday && !widget.isSelected
                ? Border.all(
                    color: cs.brand.withValues(alpha: 0.35),
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '${widget.day}',
            style: TextStyle(
              fontFamily: typo.fontFamily,
              fontSize: 13,
              fontWeight: widget.isSelected || widget.isToday
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: fg,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
