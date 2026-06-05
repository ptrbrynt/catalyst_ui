import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../tokens/radius.dart';

// ── Variant system ───────────────────────────────────────────────────────────

/// The resolved visual properties for a single [ChipVariant].
@immutable
class ChipVariantStyle {
  /// Creates a chip variant style.
  const ChipVariantStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });

  /// The chip background colour.
  final Color backgroundColor;

  /// The text and icon colour.
  final Color foregroundColor;

  /// The chip border colour.
  final Color borderColor;
}

/// Defines the visual appearance of a [Chip] in resting and selected states.
///
/// Extend this class to create your own chip styles:
///
/// ```dart
/// class CategoryChipVariant extends ChipVariant {
///   const CategoryChipVariant();
///
///   @override
///   ChipVariantStyle resolve(
///       ColorScheme cs, {required bool isSelected}) {
///     return ChipVariantStyle(
///       backgroundColor: isSelected ? cs.brand : cs.brandSoft,
///       foregroundColor: isSelected ? cs.onBrand : cs.brand,
///       borderColor: cs.brand,
///     );
///   }
/// }
/// ```
///
/// The built-in default is available via [ChipVariant.standard].
@immutable
abstract class ChipVariant {
  /// Const constructor for subclasses.
  const ChipVariant();

  /// The default chip variant: surface background when unselected,
  /// brand fill when selected.
  static const ChipVariant standard = _StandardChipVariant();

  /// Resolves the visual style given [colorScheme] and the [isSelected] state.
  ChipVariantStyle resolve(
    ColorScheme colorScheme, {
    required bool isSelected,
  });
}

class _StandardChipVariant extends ChipVariant {
  const _StandardChipVariant();

  @override
  ChipVariantStyle resolve(
    ColorScheme cs, {
    required bool isSelected,
  }) {
    final bg = isSelected ? cs.brand : cs.surface;
    return ChipVariantStyle(
      backgroundColor: bg,
      foregroundColor: isSelected ? cs.onBrand : cs.text,
      borderColor: isSelected ? cs.brand : cs.border,
    );
  }
}

// ── Widget ───────────────────────────────────────────────────────────────────

/// A compact, pill-shaped selection or filtering control.
///
/// Use the default constructor for a toggleable chip. Use [Chip.removable]
/// for a chip that always shows a close/remove icon.
///
/// Supply a custom [variant] to fully control colours in both selected and
/// unselected states.
class Chip extends StatefulWidget {
  /// Creates a toggleable chip.
  const Chip({
    required this.isSelected,
    required this.child,
    this.checkIcon,
    this.onTap,
    this.variant = ChipVariant.standard,
    super.key,
  }) : isRemovable = false,
       removeIcon = null;

  /// Creates a removable chip that shows a close (×) icon.
  const Chip.removable({
    required this.child,
    this.removeIcon,
    this.onTap,
    this.variant = ChipVariant.standard,
    super.key,
  }) : isRemovable = true,
       isSelected = false,
       checkIcon = null;

  /// Called when the chip is tapped. Pass `null` to disable.
  final VoidCallback? onTap;

  /// Whether the chip is in its selected/active state.
  final bool isSelected;

  /// Whether to always render the chip with a remove (×) icon.
  final bool isRemovable;

  /// The visual variant. Defaults to [ChipVariant.standard].
  final ChipVariant variant;

  /// The icon to display when checked.
  final IconData? checkIcon;

  /// The icon to display when removable.
  final IconData? removeIcon;

  /// The label content, typically a [Text] widget.
  final Widget child;

  @override
  State<Chip> createState() => _ChipState();
}

class _ChipState extends State<Chip> {
  late final WidgetStatesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WidgetStatesController({
      if (widget.onTap == null) WidgetState.disabled,
      if (widget.isSelected || widget.isRemovable) WidgetState.selected,
    })..addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(Chip oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller
      ..update(WidgetState.disabled, widget.onTap == null)
      ..update(
        WidgetState.selected,
        widget.isSelected || widget.isRemovable,
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final states = _controller.value;
    final isSelected =
        states.contains(WidgetState.selected) || widget.isRemovable;
    final style = widget.variant.resolve(
      context.colorScheme,
      isSelected: isSelected,
    );
    final motion = context.motion;

    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: context.typography.fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: style.foregroundColor,
      ),
      child: IconTheme(
        data: IconThemeData(color: style.foregroundColor, size: 16),
        child: GestureDetector(
          onTapDown: (_) => _controller.update(WidgetState.pressed, true),
          onTapUp: (_) => _controller.update(WidgetState.pressed, false),
          onTapCancel: () => _controller.update(WidgetState.pressed, false),
          onTap: widget.onTap,
          child: MouseRegion(
            onEnter: (_) => _controller.update(WidgetState.hovered, true),
            onExit: (_) => _controller.update(WidgetState.hovered, false),
            cursor: states.contains(WidgetState.disabled)
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            child: Focus(
              onFocusChange: (f) => _controller.update(WidgetState.focused, f),
              child: AnimatedOpacity(
                opacity: states.contains(WidgetState.disabled) ? 0.5 : 1,
                duration: motion.micro.duration,
                curve: motion.micro.curve,
                child:
                    AnimatedContainer(
                      duration: motion.micro.duration,
                      curve: motion.micro.curve,
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: Radii.pillAll,
                        border: Border.all(color: style.borderColor),
                        color: style.backgroundColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isSelected) ...[
                            Icon(
                              widget.checkIcon ?? context.iconography.checkIcon,
                            ),
                            const SizedBox(width: 6),
                          ] else
                            const SizedBox(width: 4),
                          widget.child,
                          if (widget.isRemovable) ...[
                            const SizedBox(width: 6),
                            Icon(
                              widget.removeIcon ??
                                  context.iconography.removeIcon,
                            ),
                          ] else
                            const SizedBox(width: 4),
                        ],
                      ),
                    ).withBrightness(
                      states.contains(WidgetState.pressed) &&
                              !states.contains(WidgetState.disabled)
                          ? 0.92
                          : 1,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
