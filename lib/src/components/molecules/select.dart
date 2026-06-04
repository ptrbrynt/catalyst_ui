import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../theme/shadows.dart';
import '../../theme/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// A single item in a [Select] dropdown.
@immutable
class SelectOption<T> {
  /// Creates a select option.
  const SelectOption({required this.value, required this.label});

  /// The value this option represents.
  final T value;

  /// The text label displayed in the dropdown and trigger.
  final String label;
}

/// The height variant of a [Select] field.
enum SelectSize {
  /// 40 px tall trigger.
  small,

  /// 48 px tall trigger (default).
  medium,

  /// 56 px tall trigger.
  large,
}

/// A dropdown field for selecting a single value from a list of options.
///
/// ```dart
/// Select<String>(
///   label: 'Country',
///   placeholder: 'Pick a country…',
///   value: _country,
///   options: const [
///     SelectOption(value: 'gb', label: 'United Kingdom'),
///     SelectOption(value: 'us', label: 'United States'),
///   ],
///   onChanged: (v) => setState(() => _country = v),
/// )
/// ```
class Select<T> extends StatefulWidget {
  /// Creates a select field.
  const Select({
    super.key,
    this.label,
    this.value,
    this.onChanged,
    this.options = const [],
    this.placeholder = 'Select…',
    this.disabled = false,
    this.helper,
    this.error,
    this.size = SelectSize.medium,
  });

  /// An optional label rendered above the trigger.
  final String? label;

  /// The currently selected value, or `null` for no selection.
  final T? value;

  /// Called when the user selects a different option.
  final ValueChanged<T>? onChanged;

  /// The list of options shown in the dropdown.
  final List<SelectOption<T>> options;

  /// Placeholder text when no value is selected.
  final String? placeholder;

  /// When `true`, the field is non-interactive.
  final bool disabled;

  /// Helper text below the trigger.
  final String? helper;

  /// When non-null, shows error styling with this message.
  final String? error;

  /// The height variant.
  final SelectSize size;

  @override
  State<Select<T>> createState() => _SelectState<T>();
}

class _SelectState<T> extends State<Select<T>> {
  OverlayEntry? _overlay;
  final _link = LayerLink();

  bool get _isOpen => _overlay != null;

  double get _triggerHeight => switch (widget.size) {
    SelectSize.small => Spacing.s10,
    SelectSize.medium => Spacing.s12,
    SelectSize.large => 56.0,
  };

  void _open() {
    final cs = context.colorScheme;
    final typo = context.typography;
    final sh = context.shadows;

    _overlay = OverlayEntry(
      builder:
          (_) => _SelectDropdown<T>(
            layerLink: _link,
            triggerWidth: (context.findRenderObject()! as RenderBox).size.width,
            triggerHeight: _triggerHeight,
            options: widget.options,
            value: widget.value,
            colorScheme: cs,
            typography: typo,
            shadows: sh,
            onSelect: (v) {
              widget.onChanged?.call(v);
              _close();
            },
            onDismiss: _close,
          ),
    );
    Overlay.of(context).insert(_overlay!);
    setState(() {});
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() {});
  }

  void _toggle() {
    if (widget.disabled) return;
    _isOpen ? _close() : _open();
  }

  @override
  void dispose() {
    _overlay?.remove();
    _overlay = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final typo = context.typography;
    final motion = context.motion;
    final hasError = widget.error != null;

    final selected =
        widget.options.where((o) => o.value == widget.value).firstOrNull;

    final Color borderColor;
    final List<BoxShadow> boxShadow;

    if (hasError) {
      borderColor = cs.danger;
      boxShadow = [
        BoxShadow(color: cs.danger.withValues(alpha: 0.18), spreadRadius: 3),
      ];
    } else if (_isOpen) {
      borderColor = cs.brand;
      boxShadow = [
        BoxShadow(color: cs.brand.withValues(alpha: 0.20), spreadRadius: 3),
      ];
    } else {
      borderColor = cs.border;
      boxShadow = [];
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typo.p3.copyWith(
              fontWeight: FontWeight.w500,
              color: cs.text,
            ),
          ),
          const SizedBox(height: 6),
        ],
        CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
            onTap: _toggle,
            child: MouseRegion(
              cursor:
                  widget.disabled
                      ? SystemMouseCursors.forbidden
                      : SystemMouseCursors.click,
              child: AnimatedOpacity(
                duration: motion.standard.duration,
                curve: motion.standard.curve,
                opacity: widget.disabled ? 0.5 : 1,
                child: AnimatedContainer(
                  duration: motion.standard.duration,
                  curve: motion.standard.curve,
                  height: _triggerHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: widget.disabled ? cs.muted : cs.surface,
                    borderRadius: Radii.lgAll,
                    border: Border.all(color: borderColor),
                    boxShadow: boxShadow,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selected?.label ?? widget.placeholder ?? '',
                          style: typo.body.copyWith(
                            color: selected != null ? cs.text : cs.textSubtle,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _isOpen ? 0.5 : 0,
                        duration: motion.micro.duration,
                        curve: motion.micro.curve,
                        child: Icon(
                          LucideIcons.chevronDown,
                          size: 18,
                          color: cs.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.helper != null || hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.error ?? widget.helper!,
            style: typo.caption.copyWith(
              color: hasError ? cs.danger : cs.textMuted,
            ),
          ),
        ],
      ],
    );
  }
}

class _SelectDropdown<T> extends StatelessWidget {
  const _SelectDropdown({
    required this.layerLink,
    required this.triggerWidth,
    required this.triggerHeight,
    required this.options,
    required this.value,
    required this.colorScheme,
    required this.typography,
    required this.shadows,
    required this.onSelect,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final double triggerWidth;
  final double triggerHeight;
  final List<SelectOption<T>> options;
  final T? value;
  final ColorScheme colorScheme;
  final Typography typography;
  final Shadows shadows;
  final ValueChanged<T> onSelect;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, triggerHeight + 4),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: triggerWidth,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 240),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: Radii.lgAll,
                  border: Border.all(color: colorScheme.border),
                  boxShadow: shadows.lg,
                ),
                child: ClipRRect(
                  borderRadius: Radii.lgAll,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final opt in options)
                          _SelectOptionRow<T>(
                            option: opt,
                            isSelected: opt.value == value,
                            onTap: () => onSelect(opt.value),
                            colorScheme: colorScheme,
                            typography: typography,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectOptionRow<T> extends StatefulWidget {
  const _SelectOptionRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.typography,
  });

  final SelectOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final Typography typography;

  @override
  State<_SelectOptionRow<T>> createState() => _SelectOptionRowState<T>();
}

class _SelectOptionRowState<T> extends State<_SelectOptionRow<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          color:
              (widget.isSelected || _hovered)
                  ? widget.colorScheme.subtle
                  : const Color(0x00000000),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.option.label,
                  style: widget.typography.p3.copyWith(
                    color: widget.colorScheme.text,
                  ),
                ),
              ),
              if (widget.isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  LucideIcons.check,
                  size: 16,
                  color: widget.colorScheme.brand,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
