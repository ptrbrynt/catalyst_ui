import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/color_scheme.dart';
import '../../theme/extensions.dart';
import '../../theme/shadows.dart';
import '../../theme/typography.dart';
import '../../tokens/radius.dart';

/// A sealed base class for items that can appear in a [MenuButton] dropdown.
///
/// Use [MenuOption] for actionable entries and [MenuDivider] to insert a
/// visual separator between groups of options.
sealed class MenuItem {
  /// Creates a menu item.
  const MenuItem();
}

/// A single actionable item in a [MenuButton] dropdown.
@immutable
class MenuOption extends MenuItem {
  /// Creates a menu option.
  const MenuOption({
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  /// The text label displayed in the dropdown row.
  final String label;

  /// Optional icon displayed to the left of the [label].
  final IconData? icon;

  /// Whether this option appears in a selected/checked state.
  ///
  /// When `true`, a check icon is shown on the trailing side of the row.
  final bool selected;

  /// Called when the user taps this option.
  ///
  /// The dropdown closes automatically before [onTap] is invoked.
  final VoidCallback? onTap;
}

/// A visual divider that can be placed between groups of items in a
/// [MenuButton] dropdown.
@immutable
class MenuDivider extends MenuItem {
  /// Creates a menu divider.
  const MenuDivider();
}

/// Controls which side of the trigger the [MenuButton] dropdown aligns to.
enum MenuButtonAlignment {
  /// The dropdown's leading edge aligns with the trigger's leading edge.
  start,

  /// The dropdown's trailing edge aligns with the trigger's trailing edge.
  ///
  /// Use this when the trigger sits near the right edge of the screen so the
  /// dropdown doesn't overflow off-screen.
  end,
}

/// A button that opens a contextual dropdown menu when tapped.
///
/// Instead of accepting a fixed child widget, [MenuButton] uses a [build]
/// callback that receives the current [BuildContext] and an `open` callback.
/// Wire `open` to the trigger's tap handler so the caller controls exactly
/// when the menu opens — this avoids gesture conflicts with interactive
/// widgets such as [Button].
///
/// By default the dropdown aligns its leading edge to the trigger's leading
/// edge. Set [alignment] to [MenuButtonAlignment.end] to align the trailing
/// edges instead (useful when the trigger is near the right side of the
/// screen).
///
/// ```dart
/// MenuButton(
///   items: [
///     MenuOption(
///       label: 'Edit',
///       icon: LucideIcons.pencil,
///       onTap: _onEdit,
///     ),
///     MenuOption(label: 'Duplicate', onTap: _onDuplicate),
///     const MenuDivider(),
///     MenuOption(
///       label: 'Delete',
///       icon: LucideIcons.trash2,
///       onTap: _onDelete,
///     ),
///   ],
///   build: (context, open) => Button(
///     label: 'Options',
///     onTap: open,
///   ),
/// )
/// ```
class MenuButton extends StatefulWidget {
  /// Creates a menu button.
  const MenuButton({
    required this.build,
    required this.items,
    super.key,
    this.alignment = MenuButtonAlignment.start,
  });

  /// Builds the trigger widget.
  ///
  /// The `open` callback opens (or closes) the dropdown; wire it to the
  /// trigger's tap handler.
  final Widget Function(BuildContext context, VoidCallback open) build;

  /// The list of items shown in the dropdown.
  ///
  /// May contain [MenuOption] entries and [MenuDivider] entries.
  final List<MenuItem> items;

  /// Which side of the trigger the dropdown aligns to.
  ///
  /// Defaults to [MenuButtonAlignment.start].
  final MenuButtonAlignment alignment;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  OverlayEntry? _overlay;
  final _link = LayerLink();

  bool get _isOpen => _overlay != null;

  void _open() {
    final cs = context.colorScheme;
    final typo = context.typography;
    final sh = context.shadows;
    final checkIcon = context.iconography.checkIcon;

    final renderBox = context.findRenderObject()! as RenderBox;
    final triggerGlobal = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    const dropdownMaxHeight = 240.0;
    final spaceBelow =
        screenHeight - triggerGlobal.dy - renderBox.size.height - 4;
    final showAbove = spaceBelow < dropdownMaxHeight;
    final dropdownWidth = math.max<double>(renderBox.size.width, 160);

    _overlay = OverlayEntry(
      builder: (_) => _MenuButtonDropdown(
        layerLink: _link,
        dropdownWidth: dropdownWidth,
        items: widget.items,
        colorScheme: cs,
        typography: typo,
        shadows: sh,
        showAbove: showAbove,
        alignment: widget.alignment,
        checkIcon: checkIcon,
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

  void _toggle() => _isOpen ? _close() : _open();

  @override
  void dispose() {
    _overlay?.remove();
    _overlay = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: widget.build(context, _toggle),
    );
  }
}

class _MenuButtonDropdown extends StatelessWidget {
  const _MenuButtonDropdown({
    required this.layerLink,
    required this.dropdownWidth,
    required this.items,
    required this.colorScheme,
    required this.typography,
    required this.shadows,
    required this.showAbove,
    required this.alignment,
    required this.checkIcon,
    required this.onDismiss,
  });

  final LayerLink layerLink;
  final double dropdownWidth;
  final List<MenuItem> items;
  final ColorScheme colorScheme;
  final Typography typography;
  final Shadows shadows;

  /// Whether the dropdown should open above the trigger.
  final bool showAbove;

  final MenuButtonAlignment alignment;
  final IconData checkIcon;
  final VoidCallback onDismiss;

  Alignment get _targetAnchor {
    final isEnd = alignment == MenuButtonAlignment.end;
    if (showAbove) {
      return isEnd ? Alignment.topRight : Alignment.topLeft;
    }
    return isEnd ? Alignment.bottomRight : Alignment.bottomLeft;
  }

  Alignment get _followerAnchor {
    final isEnd = alignment == MenuButtonAlignment.end;
    if (showAbove) {
      return isEnd ? Alignment.bottomRight : Alignment.bottomLeft;
    }
    return isEnd ? Alignment.topRight : Alignment.topLeft;
  }

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
            targetAnchor: _targetAnchor,
            followerAnchor: _followerAnchor,
            offset: Offset(0, showAbove ? -4 : 4),
            child: SizedBox(
              width: dropdownWidth,
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
                        for (final item in items)
                          switch (item) {
                            MenuOption() => _MenuOptionRow(
                              option: item,
                              colorScheme: colorScheme,
                              typography: typography,
                              checkIcon: checkIcon,
                              onTap: () {
                                onDismiss();
                                item.onTap?.call();
                              },
                            ),
                            MenuDivider() => _MenuItemDivider(
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

class _MenuItemDivider extends StatelessWidget {
  const _MenuItemDivider({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: colorScheme.border,
    );
  }
}

class _MenuOptionRow extends StatefulWidget {
  const _MenuOptionRow({
    required this.option,
    required this.colorScheme,
    required this.typography,
    required this.checkIcon,
    required this.onTap,
  });

  final MenuOption option;
  final ColorScheme colorScheme;
  final Typography typography;
  final IconData checkIcon;
  final VoidCallback onTap;

  @override
  State<_MenuOptionRow> createState() => _MenuOptionRowState();
}

class _MenuOptionRowState extends State<_MenuOptionRow> {
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
          color: (widget.option.selected || _hovered)
              ? widget.colorScheme.subtle
              : null,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Row(
            children: [
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
              if (widget.option.selected) ...[
                const SizedBox(width: 8),
                Icon(
                  widget.checkIcon,
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
