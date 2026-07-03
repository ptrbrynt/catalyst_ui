import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../theme/shadows.dart';
import '../../theme/typography.dart';
import '../../tokens/radius.dart';
import '../atoms/checkbox.dart';
import 'select.dart';

/// A dropdown field for selecting multiple values from a list of options.
///
/// The [options] list accepts [SelectOption] entries and [SelectDivider]
/// entries, which render as a thin horizontal separator between groups.
/// [SelectOption] entries may include an optional icon displayed to the left
/// of the label in the dropdown rows, and in the trigger when exactly one
/// option is selected.
///
/// Unlike [Select], the dropdown stays open after a selection so users can
/// toggle several options in one session — it closes only when the user
/// taps outside it or taps the trigger again.
///
/// ```dart
/// MultiSelect<String>(
///   label: 'Countries',
///   placeholder: 'Pick countries…',
///   value: _countries,
///   options: const [
///     SelectOption(
///       value: 'gb',
///       label: 'United Kingdom',
///       icon: MyIcons.flagGb,
///     ),
///     SelectOption(value: 'us', label: 'United States'),
///     SelectDivider(),
///     SelectOption(value: 'ca', label: 'Canada'),
///   ],
///   onChanged: (v) => setState(() => _countries = v),
/// )
/// ```
class MultiSelect<T> extends StatefulWidget {
  /// Creates a multi-select field.
  const MultiSelect({
    this.trailingIcon,
    this.checkIcon,
    super.key,
    this.label,
    this.value = const [],
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

  /// The currently selected values.
  final List<T> value;

  /// Called with the full updated selection when the user toggles an option.
  final ValueChanged<List<T>>? onChanged;

  /// The list of items shown in the dropdown.
  ///
  /// May contain [SelectOption] entries and [SelectDivider] entries.
  final List<SelectItem<T>> options;

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

  /// Icon to display at the end of this [MultiSelect]. Defaults to
  /// `Iconography.expandIcon`.
  final IconData? trailingIcon;

  /// Icon to display on selected options' checkboxes. Defaults to
  /// `Iconography.checkIcon`.
  final IconData? checkIcon;

  @override
  State<MultiSelect<T>> createState() => _MultiSelectState<T>();
}

class _MultiSelectState<T> extends State<MultiSelect<T>> {
  OverlayEntry? _overlay;
  final _link = LayerLink();

  bool get _isOpen => _overlay != null;

  double get _triggerHeight => switch (widget.size) {
    SelectSize.small => 44,
    SelectSize.medium => 48,
    SelectSize.large => 52.0,
  };

  void _toggleValue(T value) {
    final next = List<T>.of(widget.value);
    if (!next.remove(value)) {
      next.add(value);
    }
    widget.onChanged?.call(next);
  }

  void _open() {
    final cs = context.colorScheme;
    final typo = context.typography;
    final sh = context.shadows;

    final renderBox = context.findRenderObject()! as RenderBox;
    final triggerGlobal = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    const dropdownMaxHeight = 240.0;
    final spaceBelow = screenHeight - triggerGlobal.dy - _triggerHeight - 4;
    final showAbove = spaceBelow < dropdownMaxHeight;

    _overlay = OverlayEntry(
      builder: (_) => _MultiSelectDropdown<T>(
        layerLink: _link,
        triggerWidth: renderBox.size.width,
        options: widget.options,
        value: widget.value,
        colorScheme: cs,
        typography: typo,
        shadows: sh,
        showAbove: showAbove,
        onToggle: _toggleValue,
        checkIcon: widget.checkIcon ?? context.iconography.checkIcon,
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
  void didUpdateWidget(MultiSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_overlay != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _overlay?.markNeedsBuild(),
      );
    }
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

    final selectedOptions = widget.options
        .whereType<SelectOption<T>>()
        .where((o) => widget.value.contains(o.value))
        .toList();

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
              cursor: widget.disabled
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
                      if (selectedOptions.length == 1 &&
                          selectedOptions.first.icon != null) ...[
                        Icon(
                          selectedOptions.first.icon,
                          size: 18,
                          color: cs.text,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          selectedOptions.isNotEmpty
                              ? selectedOptions.map((o) => o.label).join(', ')
                              : widget.placeholder ?? '',
                          style: typo.body.copyWith(
                            color: selectedOptions.isNotEmpty
                                ? cs.text
                                : cs.textSubtle,
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
                          widget.trailingIcon ?? context.iconography.expandIcon,
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

class _MultiSelectDropdown<T> extends StatelessWidget {
  const _MultiSelectDropdown({
    required this.layerLink,
    required this.triggerWidth,
    required this.options,
    required this.value,
    required this.colorScheme,
    required this.typography,
    required this.shadows,
    required this.showAbove,
    required this.onToggle,
    required this.onDismiss,
    required this.checkIcon,
  });

  final LayerLink layerLink;
  final double triggerWidth;
  final List<SelectItem<T>> options;
  final List<T> value;
  final ColorScheme colorScheme;
  final Typography typography;
  final Shadows shadows;

  /// Whether the dropdown should open above the trigger.
  final bool showAbove;

  final ValueChanged<T> onToggle;
  final VoidCallback onDismiss;

  final IconData checkIcon;

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
        Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
            followerAnchor: showAbove
                ? Alignment.bottomLeft
                : Alignment.topLeft,
            offset: Offset(0, showAbove ? -4 : 4),
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
                        for (final item in options)
                          switch (item) {
                            SelectOption<T>() => _MultiSelectOptionRow<T>(
                              option: item,
                              isSelected: value.contains(item.value),
                              onTap: () => onToggle(item.value),
                              colorScheme: colorScheme,
                              typography: typography,
                              checkIcon: checkIcon,
                            ),
                            SelectDivider<T>() => _MultiSelectItemDivider(
                              colorScheme: colorScheme,
                            ),
                          },
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

class _MultiSelectItemDivider extends StatelessWidget {
  const _MultiSelectItemDivider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: colorScheme.border);
  }
}

class _MultiSelectOptionRow<T> extends StatefulWidget {
  const _MultiSelectOptionRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.typography,
    required this.checkIcon,
  });

  final SelectOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final Typography typography;
  final IconData checkIcon;

  @override
  State<_MultiSelectOptionRow<T>> createState() =>
      _MultiSelectOptionRowState<T>();
}

class _MultiSelectOptionRowState<T> extends State<_MultiSelectOptionRow<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: GestureDetector(
        onTap: widget.onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            color: (widget.isSelected || _hovered)
                ? widget.colorScheme.subtle
                : null,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              children: [
                Checkbox(
                  value: widget.isSelected,
                  onChanged: (_) => widget.onTap(),
                  checkIcon: widget.checkIcon,
                  size: CheckboxSize.small,
                ),
                const SizedBox(width: 8),
                if (widget.option.icon != null) ...[
                  Icon(
                    widget.option.icon,
                    size: 16,
                    color: widget.colorScheme.textMuted,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.option.label,
                    style: widget.typography.p3.copyWith(
                      color: widget.colorScheme.text,
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
